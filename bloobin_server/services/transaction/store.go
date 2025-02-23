package transaction

import (
	"database/sql"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/lib/pq"
)

type Store struct {
	Db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{Db: db}
}

func (s *Store) GetTransactionHistories(userId int) (*types.Transaction, error) {
	transaction := new(types.Transaction)

	query := `SELECT POINTS FROM T_USER WHERE ID = $1`
	err := s.Db.QueryRow(query, userId).Scan(&transaction.Points)
	if err != nil {
		return nil, err
	}

	query = `
	SELECT DATE, ARRAY_AGG(DESCRIPTION) AS DESCRIPTIONS
	FROM (
		SELECT DATE, DESCRIPTION
		FROM T_RECYCLE_TRANSACTION
		WHERE USER_ID = $1
		AND DATE >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
		UNION ALL
		SELECT VALID_DATE - INTERVAL '3 months' AS DATE, DESCRIPTION
    	FROM T_REWARD_TRANSACTION
    	WHERE USER_ID = $1
    	AND VALID_DATE - INTERVAL '3 months' >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
	) AS combined_transactions
	GROUP BY DATE
	ORDER BY DATE DESC;
	`

	rows, err := s.Db.Query(query, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	records := make([]types.Record, 0)
	for rows.Next() {
		record := new(types.Record)

		err := rows.Scan(
			&record.Date,
			pq.Array(&record.Description),
		)
		if err != nil {
			return nil, err
		}

		records = append(records, *record)
	}

	transaction.Records = records

	return transaction, nil
}
