package types

import "time"

type VoucherCatalogueStore interface {
	GetVoucherCatalogues() ([]VoucherCatalogue, error)
}

type VoucherCatalogue struct {
	ID             int       `json:"id"`
	VoucherName    string    `json:"voucher_name"`
	Cost           int       `json:"cost"`
	ImmediateClaim bool      `json:"immediate_claim"`
	CreatedAt      time.Time `json:"created_at"`
}
