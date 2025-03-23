package types

import "time"

type RecycleTransactionStore interface {
	// GetRecycleTransactions(userId string) ([]RecycleTransaction, error)
	CheckAvailablePoints(userId int, points int) (int, string, error)
	SaveImage(image []byte) (int, error)
	CreateRecycleTransaction(recycleTransaction RecycleTransaction, points int) error
}

type RecycleTransaction struct {
	ID           int       `json:"id"`
	Type         string    `json:"type"`
	Subtype      string    `json:"subtype"`
	Confidence   string    `json:"confidence"`
	Image        []byte    `json:"image"`
	Description  string    `json:"description"`
	Date         time.Time `json:"date"`
	CreatedAt    time.Time `json:"created_at"`
	PredictionId string    `json:"prediction_id"`
	ImageId      int       `json:"image_id"`
	UserId       int       `json:"user_id"`
}

type GetRecycleTransactionsPayload struct {
	ID string `json:"id" validate:"required"`
}

type CreateRecycleTransactionPayload struct {
	Image []byte `json:"image" validate:"required"`
}
