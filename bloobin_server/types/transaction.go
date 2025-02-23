package types

import "time"

type TransactionStore interface {
	GetTransactionHistories(userId int) (*Transaction, error)
}

type Transaction struct {
	Points  int      `json:"points"`
	Records []Record `json:"records"`
}

type Record struct {
	Date        time.Time `json:"date"`
	Description []string  `json:"descriptions"`
}

type GetTransactionHistoriesPayload struct {
	UserId int `json:"user_id" validate:"required"`
}
