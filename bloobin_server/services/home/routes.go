package home

import (
	"fmt"
	"log"
	"net/http"
	"strings"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store     types.HomeStore
	userStore types.UserStore
}

func NewHandler(store types.HomeStore, userStore types.UserStore) *Handler {
	return &Handler{store: store, userStore: userStore}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/home", auth.WithJWTAuth(h.handleGetHomeData, h.userStore)).Methods("POST")
}

func (h *Handler) handleGetHomeData(w http.ResponseWriter, r *http.Request) {
	userId := auth.GetUserIdFromContext(r.Context())
	getHomePayload := new(types.GetHomePayload)

	if err := utils.DecodeAPIJSON(r, &getHomePayload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
	}

	getHomePayload.Interval = strings.ToLower(getHomePayload.Interval)

	if err := utils.Validate.Struct(getHomePayload); err != nil {
		log.Printf("invalid payload: %s", utils.ExtractValidationErrors(err))
		utils.WriteError(
			w,
			http.StatusBadRequest,
			fmt.Errorf("%s", utils.ExtractValidationErrors(err)),
		)
		return
	}

	home, err := h.store.GetHomeData(userId, getHomePayload.Interval)
	if err != nil {
		log.Printf("error retrieving dashboard data for user_id %d: %v", userId, err)
		utils.WriteError(
			w,
			http.StatusInternalServerError,
			fmt.Errorf("%v", err),
		)
		return
	}

	utils.WriteAPIJSON(w, http.StatusOK, map[string]any{"data": home})
}
