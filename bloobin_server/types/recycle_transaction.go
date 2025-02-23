package types

import "time"

type RecycleTransactionStore interface {
	// GetRecycleTransactions(userId string) ([]RecycleTransaction, error)
	CreateRecycleTransaction(recycleTransaction RecycleTransaction, points int) error
}

type RecycleTransaction struct {
	ID          int       `json:"id"`
	Type        string    `json:"type"`
	Subtype     string    `json:"subtype"`
	Image       []byte    `json:"image"`
	Description string    `json:"description"`
	Date        time.Time `json:"date"`
	CreatedAt   time.Time `json:"created_at"`
	UserId      int       `json:"user_id"`
}

type GetRecycleTransactionsPayload struct {
	ID string `json:"id" validate:"required"`
	// JWTToken string `json:"jwt_token" validate:"required"`
}

type CreateRecycleTransactionPayload struct {
	Image  []byte `json:"image" validate:"required"`
	UserId int    `json:"user_id" validate:"required"`
}
