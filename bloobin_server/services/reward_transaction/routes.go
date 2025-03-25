package rewardtransaction

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store     types.RewardTransactionStore
	userStore types.UserStore
}

func NewHandler(store types.RewardTransactionStore, userStore types.UserStore) *Handler {
	return &Handler{store: store, userStore: userStore}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	router.HandleFunc("/reward_transaction", auth.WithJWTAuth(h.handleCreateRewardTransaction, h.userStore)).Methods("POST")
	router.HandleFunc("/reward_transaction/retrieve", auth.WithJWTAuth(h.handleGetRewardTransactionsPayload, h.userStore)).Methods("POST")
	router.HandleFunc("/reward_transaction/claim", auth.WithJWTAuth(h.handleClaimRewardVoucher, h.userStore)).Methods("POST")
}

func (h *Handler) handleCreateRewardTransaction(w http.ResponseWriter, r *http.Request) {
	userId := auth.GetUserIdFromContext(r.Context())

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
		UserId:        userId,
	}, createRewardTransactionPayload.ImmediateClaim, createRewardTransactionPayload.Points)
	if err != nil {
		log.Printf("error creating reward transaction for user_id %d: %v", userId, err)
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusOK, nil)
}

func (h *Handler) handleGetRewardTransactionsPayload(w http.ResponseWriter, r *http.Request) {
	userId := auth.GetUserIdFromContext(r.Context())

	rt, err := h.store.GetRewardTransactions(userId)
	if err != nil {
		log.Printf("error retrieving claimable vouchers for user_id %d: %v",
			userId, err)
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusOK, map[string]any{"data": rt})
}

func (h *Handler) handleClaimRewardVoucher(w http.ResponseWriter, r *http.Request) {
	userId := auth.GetUserIdFromContext(r.Context())

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
		userId,
	)
	if err != nil {
		log.Printf("error claiming to use voucher for user_id %d: %v", userId, err)
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusOK, nil)
}
