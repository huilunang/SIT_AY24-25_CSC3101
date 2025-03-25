package tests

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestCreateJWT(t *testing.T) {
	secret := []byte("secret")

	token, err := auth.CreateJWT(secret, 1)
	if err != nil {
		t.Errorf("Error creating JWT: %v", err)
	}

	if token == "" {
		t.Error("Expected token to be not empty")
	}
}

func TestWithJWTAuth_PermissionDenied_NoToken(t *testing.T) {
	mockStore := &mockUserStore{}
	protectedHandler := auth.WithJWTAuth(dummyHandler, mockStore)

	req, _ := http.NewRequest("GET", "/protected", nil)
	rr := httptest.NewRecorder()

	protectedHandler.ServeHTTP(rr, req)

	if rr.Code != http.StatusForbidden {
		t.Errorf("Expected status %d, got %d", http.StatusForbidden, rr.Code)
	}
}

func TestWithJWTAuth_Success(t *testing.T) {
	mockStore := &mockUserStore{
		getUserByEmail: func(email string) (*types.User, error) {
			return &types.User{ID: 1}, nil
		},
		getUserById: func(id int) (*types.User, error) {
			return &types.User{ID: 1}, nil
		},
	}

	secret := []byte(config.Envs.JWTSecret)
	token, err := auth.CreateJWT(secret, 1)
	if err != nil {
		t.Fatalf("Error creating JWT: %v", err)
	}

	protectedHandler := auth.WithJWTAuth(dummyHandler, mockStore)
	req, _ := http.NewRequest("GET", "/protected", nil)
	req.Header.Set("Authorization", token)
	rr := httptest.NewRecorder()

	protectedHandler.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Errorf("Expected status %d, got %d", http.StatusOK, rr.Code)
	}
}

func TestGetUserIdFromContext(t *testing.T) {
	ctx := context.WithValue(context.Background(), auth.UserKey, 42)
	userId := auth.GetUserIdFromContext(ctx)

	if userId != 42 {
		t.Errorf("Expected userId to be 42, got %d", userId)
	}
}

func dummyHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}
