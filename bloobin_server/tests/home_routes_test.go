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
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/home"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestHomeHandlers(t *testing.T) {
	tests := []struct {
		name            string
		endpoint        string
		method          string
		payload         any
		mockGetHomeData func(userId int, interval string) (*types.Home, error)
		mockGetUserById func(id int) (*types.User, error)
		expectedStatus  int
	}{
		{
			name:     "[Home]: Successful retrieval of home data",
			endpoint: "/home",
			method:   "POST",
			payload: types.GetHomePayload{
				Interval: "daily",
			},
			mockGetHomeData: func(userId int, interval string) (*types.Home, error) {
				return &types.Home{Points: 2}, nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:     "[Home]: Invalid payload",
			endpoint: "/home",
			method:   "POST",
			payload: struct {
				InvalidField string `json:"invalid_field"`
			}{
				InvalidField: "some value",
			},
			mockGetHomeData: func(userId int, interval string) (*types.Home, error) {
				return nil, nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusBadRequest,
		},
		{
			name:     "[Home]: Error retrieving home data from store",
			endpoint: "/home",
			method:   "POST",
			payload: types.GetHomePayload{
				Interval: "monthly",
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockHomeStore := &mockHomeStore{
				getHomeData: tt.mockGetHomeData,
			}
			mockUserStore := &mockUserStore{
				getUserById: tt.mockGetUserById,
			}
			handler := home.NewHandler(mockHomeStore, mockUserStore)

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

type mockHomeStore struct {
	getHomeData func(userId int, interval string) (*types.Home, error)
}

func (m *mockHomeStore) GetHomeData(userId int, interval string) (*types.Home, error) {
	if m.getHomeData != nil {
		return m.getHomeData(userId, interval)
	}

	return nil, fmt.Errorf("error retrieving home data")
}
