package rewardtransaction

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store types.RewardTransactionStore
}

func NewHandler(store types.RewardTransactionStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/reward_transaction", h.handleCreateRewardTransaction).Methods("POST")
	router.HandleFunc("/reward_transaction/claim", h.handleClaimRewardVoucher).Methods("POST")
}

func (h *Handler) handleCreateRewardTransaction(w http.ResponseWriter, r *http.Request) {
	createRewardTransactionPayload := new(types.CreateRewardTransactionPayload)
	if err := utils.DecodeAPIJSON(r, &createRewardTransactionPayload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
	}

	if err := utils.Validate.Struct(createRewardTransactionPayload); err != nil {
		log.Printf("invalid payload: %s", utils.ExtractValidationErrors(err))
		utils.WriteError(
			w,
			http.StatusBadRequest,
			fmt.Errorf("%s", utils.ExtractValidationErrors(err)),
		)
		return
	}

	err := h.store.CreateRewardTransaction(types.RewardTransaction{
		VoucherName:   createRewardTransactionPayload.VoucherName,
		VoucherSerial: uuid.New().String(),
		Description:   fmt.Sprintf("- %d pts to redeem voucher", createRewardTransactionPayload.Points),
		ValidDate:     time.Now().AddDate(0, 3, 0).Truncate(24 * time.Hour),
		UserId:        createRewardTransactionPayload.UserId,
	}, createRewardTransactionPayload.ImmediateClaim, createRewardTransactionPayload.Points)
	if err != nil {
		log.Printf("error redeeming points for user_id %d: %v",
			createRewardTransactionPayload.UserId, err)
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusOK, nil)
}

func (h *Handler) handleClaimRewardVoucher(w http.ResponseWriter, r *http.Request) {
	claimRewardVoucherPayload := new(types.ClaimRewardVoucherPayload)
	if err := utils.DecodeAPIJSON(r, &claimRewardVoucherPayload); err != nil {
		utils.WriteError(w, http.StatusBadRequest, err)
	}

	if err := utils.Validate.Struct(claimRewardVoucherPayload); err != nil {
		log.Printf("invalid payload: %s", utils.ExtractValidationErrors(err))
		utils.WriteError(
			w,
			http.StatusBadRequest,
			fmt.Errorf("%s", utils.ExtractValidationErrors(err)),
		)
		return
	}

	err := h.store.ClaimRewardVoucher(
		time.Now().AddDate(0, 3, 0).Truncate(24*time.Hour),
		claimRewardVoucherPayload.VoucherSerial,
		claimRewardVoucherPayload.UserId,
	)
	if err != nil {
		log.Printf("error claiming to use voucher for user_id %d: %v",
			claimRewardVoucherPayload.UserId, err)
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusOK, nil)
}
