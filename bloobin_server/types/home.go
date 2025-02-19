package types

import "time"

type HomeStore interface {
	GetHomeData(userId int, interval string) (*Home, error)
}

type Home struct {
	Points    int      `json:"points"`
	Vouchers  int      `json:"vouchers"`
	Types     []string `json:"types"`
	ChartData []Chart  `json:"chart_data"`
}

type Chart struct {
	Date  time.Time `json:"date"`
	Type  string    `json:"type"`
	Count int       `json:"count"`
}

type GetHomePayload struct {
	UserId   int    `json:"user_id" validate:"required"`
	Interval string `json:"interval" validate:"required,interval"`
}
