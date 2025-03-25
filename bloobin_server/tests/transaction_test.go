package tests

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/transaction"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestTransactionHandlers(t *testing.T) {
	tests := []struct {
		name                        string
		endpoint                    string
		method                      string
		payload                     any
		mockGetTransactionHistories func(userId int) (*types.Transaction, error)
		mockGetUserById             func(id int) (*types.User, error)
		expectedStatus              int
	}{
		{
			name:     "[Transaction]: Successful retrieval",
			endpoint: "/transaction",
			method:   "POST",
			payload:  nil,
			mockGetTransactionHistories: func(userId int) (*types.Transaction, error) {
				return &types.Transaction{}, nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:     "[Transaction]: Failure on retrieval - Database Error",
			endpoint: "/transaction",
			method:   "POST",
			payload:  nil,
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
		{
			name:                        "Invalid User JWT Token",
			endpoint:                    "/transaction",
			method:                      "POST",
			payload:                     nil,
			mockGetTransactionHistories: nil,
			mockGetUserById:             nil,
			expectedStatus:              http.StatusForbidden,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockTransactionStore := &mockTransactionStore{
				getTransactionHistories: tt.mockGetTransactionHistories,
			}
			mockUserStore := &mockUserStore{
				getUserById: tt.mockGetUserById,
			}
			handler := transaction.NewHandler(mockTransactionStore, mockUserStore)

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

type mockTransactionStore struct {
	getTransactionHistories func(userId int) (*types.Transaction, error)
}

func (m *mockTransactionStore) GetTransactionHistories(userId int) (*types.Transaction, error) {
	if m.getTransactionHistories != nil {
		return m.getTransactionHistories(userId)
	}

	return nil, fmt.Errorf("error retrieving transactions")
}
