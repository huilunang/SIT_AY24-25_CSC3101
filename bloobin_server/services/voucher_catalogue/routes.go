package vouchercatalogue

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
	store     types.VoucherCatalogueStore
	userStore types.UserStore
}

func NewHandler(store types.VoucherCatalogueStore, userStore types.UserStore) *Handler {
	return &Handler{store: store, userStore: userStore}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/voucher_catalogues", auth.WithJWTAuth(h.handleGetVoucherCatalogues, h.userStore)).Methods("GET")
}

func (h *Handler) handleGetVoucherCatalogues(w http.ResponseWriter, r *http.Request) {
	vc, err := h.store.GetVoucherCatalogues()
	if err != nil {
		log.Printf("error retrieving reward catalogue: %v", err)
		utils.WriteError(
			w,
			http.StatusInternalServerError,
			fmt.Errorf("%v", err),
		)
		return
	}

	utils.WriteAPIJSON(w, http.StatusOK, map[string]any{"data": vc})
}
