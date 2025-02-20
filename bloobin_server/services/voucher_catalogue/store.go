package vouchercatalogue

import (
	"database/sql"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

type Store struct {
	Db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{Db: db}
}

func (s *Store) GetVoucherCatalogues() ([]types.VoucherCatalogue, error) {
	query := `SELECT * FROM T_VOUCHER_CATALOGUE`
	stmt, err := s.prepareStmt(query)

	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	rows, err := stmt.Query()
	if err != nil {
		return nil, err
	}

	voucherCatalogues := make([]types.VoucherCatalogue, 0)
	for rows.Next() {
		voucherCatalogue := new(types.VoucherCatalogue)

		err = rows.Scan(
			&voucherCatalogue.ID,
			&voucherCatalogue.VoucherName,
			&voucherCatalogue.Cost,
			&voucherCatalogue.ImmediateClaim,
			&voucherCatalogue.CreatedAt,
		)
		if err != nil {
			return nil, err
		}

		voucherCatalogues = append(voucherCatalogues, *voucherCatalogue)
	}

	return voucherCatalogues, nil
}

func (s *Store) prepareStmt(q string) (*sql.Stmt, error) {
	stmt, err := s.Db.Prepare(q)

	if err != nil {
		return nil, err
	}

	return stmt, nil
}
