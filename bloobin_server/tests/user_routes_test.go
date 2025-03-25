package tests

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/mux"
	customErrors "github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/errors"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/user"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

// func TestUserServiceHandlers(t *testing.T) {
// 	userStore := &mockUserStore{}
// 	handler := user.NewHandler(userStore)

// 	t.Run("Test handleRegister with invalid payload", func(t *testing.T) {
// 		registerUserPayload := types.RegisterUserPayload{
// 			Email:           "test@gmail.com",
// 			Password:        "password",
// 			ConfirmPassword: "password1",
// 		}
// 		marshalled, _ := json.Marshal(registerUserPayload)

// 		req, err := http.NewRequest("POST", "/register", bytes.NewBuffer(marshalled))
// 		if err != nil {
// 			t.Fatal(err)
// 		}

// 		rr := httptest.NewRecorder()
// 		router := mux.NewRouter()
// 		handler.RegisterRoutes(router)
// 		router.ServeHTTP(rr, req)

// 		if rr.Code != http.StatusBadRequest {
// 			t.Errorf("Expected status code %d, got %d", http.StatusBadRequest, rr.Code)
// 		}
// 	})

// 	t.Run("Test handleRegister with successful registration", func(t *testing.T) {
// 		registerUserPayload := types.RegisterUserPayload{
// 			Email:           "test@gmail.com",
// 			Password:        "password",
// 			ConfirmPassword: "password",
// 		}
// 		marshalled, _ := json.Marshal(registerUserPayload)

// 		req, err := http.NewRequest("POST", "/register", bytes.NewBuffer(marshalled))
// 		if err != nil {
// 			t.Fatal(err)
// 		}

// 		rr := httptest.NewRecorder()
// 		router := mux.NewRouter()
// 		handler.RegisterRoutes(router)
// 		router.ServeHTTP(rr, req)

// 		if rr.Code != http.StatusCreated {
// 			t.Errorf("Expected status code %d, got %d", http.StatusCreated, rr.Code)
// 		}
// 	})
// }

// type mockUserStore struct{}

// func (m *mockUserStore) CreateUser(user types.User) error {
// 	return nil
// }

// func (m *mockUserStore) GetUserById(id int) (*types.User, error) {
// 	return nil, customErrors.ErrUserNotFound
// }

// func (m *mockUserStore) GetUserByEmail(email string) (*types.User, error) {
// 	return nil, customErrors.ErrUserNotFound
// }

func TestUserHandlers(t *testing.T) {
	tests := []struct {
		name               string
		endpoint           string
		method             string
		payload            any
		mockCreateUser     func(user types.User) error
		mockGetUserById    func(id int) (*types.User, error)
		mockGetUserByEmail func(email string) (*types.User, error)
		expectedStatus     int
	}{
		{
			name:     "[Register]: Successful registration",
			endpoint: "/register",
			method:   "POST",
			payload: types.RegisterUserPayload{
				Email:           "test@gmail.com",
				Password:        "password",
				ConfirmPassword: "password",
			},
			expectedStatus: http.StatusCreated,
		},
		{
			name:     "[Register]: User already exists",
			endpoint: "/register",
			method:   "POST",
			payload: types.RegisterUserPayload{
				Email:           "test@gmail.com",
				Password:        "password",
				ConfirmPassword: "password",
			},
			mockGetUserByEmail: func(email string) (*types.User, error) {
				return &types.User{Email: email}, nil
			},
			expectedStatus: http.StatusBadRequest,
		},
		{
			name:     "[Register]: Invalid payload",
			endpoint: "/register",
			method:   "POST",
			payload: types.RegisterUserPayload{
				Email:           "test@gmail.com",
				Password:        "password",
				ConfirmPassword: "password1",
			},
			expectedStatus: http.StatusBadRequest,
		},
		{
			name:     "[Login]: Successful login",
			endpoint: "/login",
			method:   "POST",
			payload: types.LoginUserPayload{
				Email:    "test@gmail.com",
				Password: "password",
			},
			mockGetUserByEmail: func(email string) (*types.User, error) {
				hashedPassword, _ := auth.HashPassword("password")

				return &types.User{Email: email, Password: hashedPassword}, nil
			},
			expectedStatus: http.StatusOK,
		},
		{
			name:     "[Login]: User not found",
			endpoint: "/login",
			method:   "POST",
			payload: types.LoginUserPayload{
				Email:    "notfound@gmail.com",
				Password: "password",
			},
			mockGetUserByEmail: func(email string) (*types.User, error) {
				return nil, customErrors.ErrUserNotFound
			},
			expectedStatus: http.StatusNotFound,
		},
		{
			name:     "[Login]: Invalid password",
			endpoint: "/login",
			method:   "POST",
			payload: types.LoginUserPayload{
				Email:    "test@gmail.com",
				Password: "password1",
			},
			mockGetUserByEmail: func(email string) (*types.User, error) {
				return &types.User{Email: email, Password: "password"}, nil
			},
			expectedStatus: http.StatusBadRequest,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockStore := &mockUserStore{
				createUser:     tt.mockCreateUser,
				getUserById:    tt.mockGetUserById,
				getUserByEmail: tt.mockGetUserByEmail,
			}
			handler := user.NewHandler(mockStore)

			marshalled, _ := json.Marshal(tt.payload)
			req, err := http.NewRequest(tt.method, tt.endpoint, bytes.NewBuffer(marshalled))
			if err != nil {
				t.Fatal(err)
			}

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

// Mock struct with optional overrides
type mockUserStore struct {
	createUser     func(user types.User) error
	getUserById    func(id int) (*types.User, error)
	getUserByEmail func(email string) (*types.User, error)
}

// if no override of returning result, return defined else default
func (m *mockUserStore) CreateUser(user types.User) error {
	if m.createUser != nil {
		return m.createUser(user)
	}

	return nil
}

func (m *mockUserStore) GetUserById(id int) (*types.User, error) {
	if m.getUserById != nil {
		return m.getUserById(id)
	}

	return nil, customErrors.ErrUserNotFound
}

func (m *mockUserStore) GetUserByEmail(email string) (*types.User, error) {
	if m.getUserByEmail != nil {
		return m.getUserByEmail(email)
	}

	return nil, customErrors.ErrUserNotFound
}
