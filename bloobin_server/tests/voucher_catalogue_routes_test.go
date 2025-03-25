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
	vouchercatalogue "github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/voucher_catalogue"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestVoucherCatalogueHandlers(t *testing.T) {
	tests := []struct {
		name                     string
		endpoint                 string
		method                   string
		payload                  any
		mockGetVoucherCatalogues func() ([]types.VoucherCatalogue, error)
		expectedStatus           int
	}{
		{
			name:     "[Voucher Catalogue]: Successful retrieval",
			endpoint: "/voucher_catalogues",
			method:   "GET",
			payload:  nil,
			mockGetVoucherCatalogues: func() ([]types.VoucherCatalogue, error) {
				return []types.VoucherCatalogue{}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:           "[Voucher Catalogue]: Failure on retrieval - Database Error",
			endpoint:       "/voucher_catalogues",
			method:         "GET",
			payload:        nil,
			expectedStatus: http.StatusInternalServerError,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockVoucherCatalogueStore := &mockVoucherCatalogueStore{
				getVoucherCatalogues: tt.mockGetVoucherCatalogues,
			}
			mockUserStore := &mockUserStore{
				getUserById: func(id int) (*types.User, error) {
					return &types.User{}, nil
				},
			}
			handler := vouchercatalogue.NewHandler(mockVoucherCatalogueStore, mockUserStore)

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

type mockVoucherCatalogueStore struct {
	getVoucherCatalogues func() ([]types.VoucherCatalogue, error)
}

func (m *mockVoucherCatalogueStore) GetVoucherCatalogues() ([]types.VoucherCatalogue, error) {
	if m.getVoucherCatalogues != nil {
		return m.getVoucherCatalogues()
	}

	return nil, fmt.Errorf("error retrieving voucher catalogues")
}
