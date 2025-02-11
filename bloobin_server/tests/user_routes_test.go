package tests

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/user"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestUserServiceHandlers(t *testing.T) {
	userStore := &mockUserStore{}
	handler := user.NewHandler(userStore)

	t.Run("Test handleRegister with invalid payload", func(t *testing.T) {
		registerUserPayload := types.RegisterUserPayload{
			Email:           "test@gmail.com",
			Password:        "password",
			ConfirmPassword: "password1",
		}
		marshalled, _ := json.Marshal(registerUserPayload)

		req, err := http.NewRequest("POST", "/register", bytes.NewBuffer(marshalled))
		if err != nil {
			t.Fatal(err)
		}

		rr := httptest.NewRecorder()
		router := mux.NewRouter()
		handler.RegisterRoutes(router)
		router.ServeHTTP(rr, req)

		if rr.Code != http.StatusBadRequest {
			t.Errorf("Expected status code %d, got %d", http.StatusBadRequest, rr.Code)
		}
	})

	t.Run("Test handleRegister with successful registration", func(t *testing.T) {
		registerUserPayload := types.RegisterUserPayload{
			Email:           "test@gmail.com",
			Password:        "password",
			ConfirmPassword: "password",
		}
		marshalled, _ := json.Marshal(registerUserPayload)

		req, err := http.NewRequest("POST", "/register", bytes.NewBuffer(marshalled))
		if err != nil {
			t.Fatal(err)
		}

		rr := httptest.NewRecorder()
		router := mux.NewRouter()
		handler.RegisterRoutes(router)
		router.ServeHTTP(rr, req)

		if rr.Code != http.StatusCreated {
			t.Errorf("Expected status code %d, got %d", http.StatusCreated, rr.Code)
		}
	})
}

type mockUserStore struct{}

func (m *mockUserStore) CreateUser(user types.User) error {
	return nil
}

func (m *mockUserStore) GetUserByEmail(email string) (*types.User, error) {
	return nil, fmt.Errorf("user not found")
}
