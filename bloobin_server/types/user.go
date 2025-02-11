package types

import (
	"time"
)

type UserStore interface {
	CreateUser(User) error
	GetUserByEmail(email string) (*User, error)
}

type User struct {
	ID        int       `json:"id"`
	Email     string    `json:"email"`
	Password  string    `json:"password"`
	Points    int       `json:"points"`
	CreatedAt time.Time `json:"created_at"`
}

type RegisterUserPayload struct {
	Email           string `json:"email" validate:"required,email"`
	Password        string `json:"password" validate:"required,min=8,max=32,eqpwfield=ConfirmPassword"`
	ConfirmPassword string `json:"confirm_password" validate:"required,min=8,max=32"`
}

type LoginUserPayload struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}
