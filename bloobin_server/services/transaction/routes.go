package transaction

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store     types.TransactionStore
	userStore types.UserStore
}

func NewHandler(store types.TransactionStore, userStore types.UserStore) *Handler {
	return &Handler{store: store, userStore: userStore}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/transaction", auth.WithJWTAuth(h.handleGetTransactionHistories, h.userStore)).Methods("POST")
}

func (h *Handler) handleGetTransactionHistories(w http.ResponseWriter, r *http.Request) {
	userId := auth.GetUserIdFromContext(r.Context())

	t, err := h.store.GetTransactionHistories(userId)
	if err != nil {
		log.Printf("error retrieving transactions for user_id %d: %v", userId, err)
		utils.WriteError(
			w,
			http.StatusInternalServerError,
			fmt.Errorf("%v", err),
		)
		return
	}

	utils.WriteAPIJSON(w, http.StatusOK, map[string]any{"data": t})
}
