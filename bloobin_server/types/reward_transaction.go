package types

import (
	"time"
)

type RewardTransactionStore interface {
	CreateRewardTransaction(rewardTransaction RewardTransaction, immediateClaim bool, points int) error
	GetRewardTransactions(userId int) ([]RewardTransaction, error)
	ClaimRewardVoucher(claimedDate time.Time, voucherSerial string, userId int) error
}

type RewardTransaction struct {
	ID            int       `json:"id"`
	VoucherName   string    `json:"voucher_name"`
	VoucherSerial string    `json:"voucher_serial"`
	Description   string    `json:"description"`
	ValidDate     time.Time `json:"valid_date"`
	Claimed       bool      `json:"claimed"`
	ClaimedDate   time.Time `json:"claimed_date"`
	CreatedAt     time.Time `json:"created_at"`
	UserId        int       `json:"user_id"`
}

type CreateRewardTransactionPayload struct {
	VoucherName    string `json:"voucher_name" validate:"required"`
	Points         int    `json:"points" validate:"required"`
	ImmediateClaim bool   `json:"immediate_claim"`
}

type ClaimRewardVoucherPayload struct {
	VoucherSerial string `json:"voucher_serial" validate:"required"`
}
