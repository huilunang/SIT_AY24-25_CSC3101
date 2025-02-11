package user

import (
	"errors"
	"fmt"
	"log"
	"net/http"

	"github.com/go-playground/validator/v10"
	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"
	customErrors "github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/errors"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store types.UserStore
}

func NewHandler(store types.UserStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/login", h.handleLogin).Methods("POST")
	router.HandleFunc("/register", h.handleRegister).Methods("POST")
}

func (h *Handler) handleLogin(w http.ResponseWriter, r *http.Request) {
	loginUserPayload := new(types.LoginUserPayload)
	if err := utils.DecodeAPIJSON(r, &loginUserPayload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
	}

	if err := utils.Validate.Struct(loginUserPayload); err != nil {
		error := err.(validator.ValidationErrors)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("invalid payload: %v", error))
		return
	}

	u, err := h.store.GetUserByEmail(loginUserPayload.Email)
	if err != nil {
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("user not found"))
		return
	}

	if !auth.ComparePasswords(u.Password, []byte(loginUserPayload.Password)) {
		utils.WriteError(w, http.StatusInternalServerError, fmt.Errorf("invalid password"))
		return
	}

	secret := []byte(config.Envs.JWTSecret)
	token, err := auth.CreateJWT(secret, u.ID)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, fmt.Errorf("jwt token not generated: %w", err))
		return
	}

	utils.WriteAPIJSON(w, http.StatusOK, map[string]string{"token": token})
}

func (h *Handler) handleRegister(w http.ResponseWriter, r *http.Request) {
	registerUserPayload := new(types.RegisterUserPayload)
	if err := utils.DecodeAPIJSON(r, &registerUserPayload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
	}

	user, err := h.store.GetUserByEmail(registerUserPayload.Email)
	if err != nil {
		if errors.Is(err, customErrors.ErrUserNotFound) {
			log.Printf("User with email %s not found, proceeding with registration", registerUserPayload.Email)
		} else {
			log.Printf("Error checking user email %s: %v", registerUserPayload.Email, err)
			utils.WriteError(w, http.StatusInternalServerError, fmt.Errorf("internal server error"))
			return
		}
	}

	if user != nil {
		log.Printf("User with email %s already exists", registerUserPayload.Email)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("user with email %s already exists", registerUserPayload.Email))
		return
	}

	if err := utils.Validate.Struct(registerUserPayload); err != nil {
		error := err.(validator.ValidationErrors)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("invalid payload: %v", error))
		return
	}

	hashedPassword, err := auth.HashPassword(registerUserPayload.Password)
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	err = h.store.CreateUser(types.User{
		Email:    registerUserPayload.Email,
		Password: hashedPassword,
	})
	if err != nil {
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusCreated, nil)
}
