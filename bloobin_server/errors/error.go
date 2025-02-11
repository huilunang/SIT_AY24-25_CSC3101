package errors

import (
	"fmt"
	"net/http"
)

type CustomError struct {
	Code    int
	Message string
}

// Implement the error interface
func (e *CustomError) Error() string {
	return fmt.Sprintf("Error %d: %s", e.Code, e.Message)
}

// Helper function to create new custom errors
func New(code int, message string) *CustomError {
	return &CustomError{
		Code:    code,
		Message: message,
	}
}

var (
	ErrUserNotFound   = New(http.StatusNotFound, "user not found")
	ErrInvalidRequest = New(http.StatusBadRequest, "invalid request")
	ErrInternalServer = New(http.StatusInternalServerError, "internal server error")
)
