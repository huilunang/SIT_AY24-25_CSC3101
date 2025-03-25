package tests

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	rewardtransaction "github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/reward_transaction"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestRewardTransactionHandlers(t *testing.T) {
	tests := []struct {
		name                        string
		endpoint                    string
		method                      string
		payload                     any
		mockCreateRewardTransaction func(RewardTransaction types.RewardTransaction, immediateClaim bool, points int) error
		mockClaimRewardVoucher      func(claimedDate time.Time, voucherSerial string, userId int) error
		mockGetRewardTransactions   func(userId int) ([]types.RewardTransaction, error)
		mockGetUserById             func(id int) (*types.User, error)
		expectedStatus              int
	}{
		{
			name:     "[Reward Transaction]: Successful creation",
			endpoint: "/reward_transaction",
			method:   "POST",
			payload: &types.CreateRewardTransactionPayload{
				VoucherName:    "testVoucher",
				Points:         100,
				ImmediateClaim: true,
			},
			mockCreateRewardTransaction: func(RewardTransaction types.RewardTransaction, immediateClaim bool, points int) error {
				return nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:     "[Reward Transaction]: Validation failure on create",
			endpoint: "/reward_transaction",
			method:   "POST",
			payload: &types.CreateRewardTransactionPayload{
				VoucherName:    "",
				ImmediateClaim: false,
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusBadRequest,
		},
		{
			name:     "[Reward Transaction]: Successful retrieval",
			endpoint: "/reward_transaction/retrieve",
			method:   "POST",
			payload:  nil,
			mockGetRewardTransactions: func(userId int) ([]types.RewardTransaction, error) {
				return []types.RewardTransaction{{VoucherName: "voucher1"}}, nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:     "[Reward Transaction]: Failure in retrieval",
			endpoint: "/reward_transaction/retrieve",
			method:   "POST",
			payload:  nil,
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
		{
			name:     "[Reward Transaction]: Successful claim",
			endpoint: "/reward_transaction/claim",
			method:   "POST",
			payload: &types.ClaimRewardVoucherPayload{
				VoucherSerial: "voucher123",
			},
			mockClaimRewardVoucher: func(claimedDate time.Time, voucherSerial string, userId int) error {
				return nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:     "[Reward Transaction]: Failure in claim",
			endpoint: "/reward_transaction/claim",
			method:   "POST",
			payload: &types.ClaimRewardVoucherPayload{
				VoucherSerial: "voucher123",
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockRewardTransactionStore := &mockRewardTransactionStore{
				createRewardTransaction: tt.mockCreateRewardTransaction,
				getRewardTransactions:   tt.mockGetRewardTransactions,
				claimRewardVoucher:      tt.mockClaimRewardVoucher,
			}
			mockUserStore := &mockUserStore{
				getUserById: tt.mockGetUserById,
			}
			handler := rewardtransaction.NewHandler(mockRewardTransactionStore, mockUserStore)

			secret := []byte(config.Envs.JWTSecret)
			token, err := auth.CreateJWT(secret, 1)
			if err != nil {
				t.Fatalf("Error generating JWT: %v", err)
			}

			marshalled, _ := json.Marshal(tt.payload)
			req, err := http.NewRequest(tt.method, tt.endpoint, bytes.NewBuffer(marshalled))
			if err != nil {
				t.Fatal(err)
			}
			req.Header.Set("Authorization", token)

			rr := httptest.NewRecorder()
			router := mux.NewRouter()
			handler.RegisterRoutes(router)
			router.ServeHTTP(rr, req)

			if rr.Code != tt.expectedStatus {
				t.Errorf("Expected status %d, got %d", tt.expectedStatus, rr.Code)
			}
		})
	}
}

type mockRewardTransactionStore struct {
	createRewardTransaction func(RewardTransaction types.RewardTransaction, immediateClaim bool, points int) error
	getRewardTransactions   func(userId int) ([]types.RewardTransaction, error)
	claimRewardVoucher      func(claimedDate time.Time, voucherSerial string, userId int) error
}

func (m *mockRewardTransactionStore) CreateRewardTransaction(rewardTransaction types.RewardTransaction, immediateClaim bool, points int) error {
	if m.createRewardTransaction != nil {
		return m.createRewardTransaction(rewardTransaction, immediateClaim, points)
	}

	return fmt.Errorf("error creating reward transaction")
}

func (m *mockRewardTransactionStore) GetRewardTransactions(userId int) ([]types.RewardTransaction, error) {
	if m.getRewardTransactions != nil {
		return m.getRewardTransactions(userId)
	}

	return nil, fmt.Errorf("error retrieving home data")
}

func (m *mockRewardTransactionStore) ClaimRewardVoucher(claimedDate time.Time, voucherSerial string, userId int) error {
	if m.claimRewardVoucher != nil {
		return m.claimRewardVoucher(claimedDate, voucherSerial, userId)
	}

	return fmt.Errorf("error claiming to use voucher")
}
