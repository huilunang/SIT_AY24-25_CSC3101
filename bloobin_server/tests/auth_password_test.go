package tests

import (
	"testing"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
)

func TestHashPassword(t *testing.T) {
	hash, err := auth.HashPassword("password")
	if err != nil {
		t.Errorf("Error hashing password: %v", err)
	}

	if hash == "" {
		t.Error("Expected hash to be not empty")
	}

	if hash == "password" {
		t.Error("Expected hash to be different from password")
	}
}

func TestComparePasswords(t *testing.T) {
	hash, err := auth.HashPassword("password")
	if err != nil {
		t.Errorf("Error hashing password: %v", err)
	}

	if !auth.ComparePasswords(hash, []byte("password")) {
		t.Errorf("Expected password to match hash")
	}
	if auth.ComparePasswords(hash, []byte("notpassword")) {
		t.Errorf("Expected password to not match hash")
	}
}
