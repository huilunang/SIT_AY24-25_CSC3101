package rewardtransaction

import (
	"database/sql"
	"time"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

type Store struct {
	Db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{Db: db}
}

func (s *Store) CreateRewardTransaction(rewardTransaction types.RewardTransaction, immediateClaim bool, points int) error {
	tx, err := s.Db.Begin()
	if err != nil {
		return err
	}

	query := `
	INSERT INTO T_REWARD_TRANSACTION (VOUCHER_NAME, VOUCHER_SERIAL, DESCRIPTION, VALID_DATE, CLAIMED, USER_ID)
	VALUES ($1, $2, $3, $4, $5, $6)
	`
	_, err = tx.Exec(query,
		rewardTransaction.VoucherName,
		rewardTransaction.VoucherSerial,
		rewardTransaction.Description,
		rewardTransaction.ValidDate,
		immediateClaim,
		rewardTransaction.UserId,
	)
	if err != nil {
		tx.Rollback()
		return err
	}

	query = `
	UPDATE T_USER
	SET POINTS = POINTS - $1 WHERE ID = $2
	`
	_, err = tx.Exec(query, points, rewardTransaction.UserId)
	if err != nil {
		tx.Rollback()
		return err
	}

	err = tx.Commit()
	if err != nil {
		return err
	}

	return nil
}

func (s *Store) ClaimRewardVoucher(claimedDate time.Time, voucherSerial string, userId int) error {
	query := `
	UPDATE T_REWARD_TRANSACTION
	SET CLAIMED = TRUE, CLAIMED_DATE = $1
	WHERE VOUCHER_SERIAL = $2, USER_ID = $3
	`
	stmt, err := s.prepareStmt(query)

	if err != nil {
		return err
	}
	defer stmt.Close()

	_, err = stmt.Exec(claimedDate, voucherSerial, userId)
	if err != nil {
		return err
	}

	return nil
}

func (s *Store) prepareStmt(q string) (*sql.Stmt, error) {
	stmt, err := s.Db.Prepare(q)

	if err != nil {
		return nil, err
	}

	return stmt, nil
}
