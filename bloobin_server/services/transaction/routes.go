package transaction

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store types.TransactionStore
}

func NewHandler(store types.TransactionStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/transaction", h.handleGetTransactionHistories).Methods("POST")
}

func (h *Handler) handleGetTransactionHistories(w http.ResponseWriter, r *http.Request) {
	getTransactionHistoriesPayload := new(types.GetTransactionHistoriesPayload)
	if err := utils.DecodeAPIJSON(r, &getTransactionHistoriesPayload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
	}

	if err := utils.Validate.Struct(getTransactionHistoriesPayload); err != nil {
		log.Printf("invalid payload: %s", utils.ExtractValidationErrors(err))
		utils.WriteError(
			w,
			http.StatusBadRequest,
			fmt.Errorf("%s", utils.ExtractValidationErrors(err)),
		)
		return
	}

	t, err := h.store.GetTransactionHistories(getTransactionHistoriesPayload.UserId)
	if err != nil {
		log.Printf("error retrieving transactions for user_id %d: %v",
			getTransactionHistoriesPayload.UserId, err)
		utils.WriteError(
			w,
			http.StatusInternalServerError,
			fmt.Errorf("%v", err),
		)
		return
	}

	utils.WriteAPIJSON(w, http.StatusOK, map[string]interface{}{"data": t})
}
