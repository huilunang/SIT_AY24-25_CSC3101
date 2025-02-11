package tests

import (
	"testing"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
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
