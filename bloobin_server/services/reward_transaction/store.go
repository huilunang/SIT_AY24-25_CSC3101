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
	WHERE VOUCHER_SERIAL = $2 AND USER_ID = $3
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

func (s *Store) GetRewardTransactions(userId int) ([]types.RewardTransaction, error) {
	query := `
	SELECT ID, VOUCHER_NAME, VOUCHER_SERIAL, VALID_DATE, USER_ID
	FROM T_REWARD_TRANSACTION
	WHERE CLAIMED = FALSE AND CURRENT_DATE <= VALID_DATE AND USER_ID = $1
	`
	stmt, err := s.prepareStmt(query)

	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	rows, err := stmt.Query(userId)
	if err != nil {
		return nil, err
	}

	rewardtransactions := make([]types.RewardTransaction, 0)
	for rows.Next() {
		rewardtransaction := new(types.RewardTransaction)

		err = rows.Scan(
			&rewardtransaction.ID,
			&rewardtransaction.VoucherName,
			&rewardtransaction.VoucherSerial,
			&rewardtransaction.ValidDate,
			&rewardtransaction.UserId,
		)
		if err != nil {
			return nil, err
		}

		rewardtransactions = append(rewardtransactions, *rewardtransaction)
	}

	return rewardtransactions, nil
}

func (s *Store) prepareStmt(q string) (*sql.Stmt, error) {
	stmt, err := s.Db.Prepare(q)

	if err != nil {
		return nil, err
	}

	return stmt, nil
}
