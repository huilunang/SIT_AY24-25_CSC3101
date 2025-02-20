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

func (s *Store) GetTransactionHistories(userId int) ([]types.Transaction, error) {
	query := `
	SELECT DATE, ARRAY_AGG(DESCRIPTION) AS DESCRIPTIONS
	FROM (
		SELECT DATE, DESCRIPTION
		FROM T_RECYCLE_TRANSACTION
		WHERE USER_ID = $1
		AND DATE >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
		UNION ALL
		SELECT VALID_DATE AS DATE, DESCRIPTION
		FROM T_REWARD_TRANSACTION
		WHERE USER_ID = $1
		AND VALID_DATE >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3 months'
	) AS combined_transactions
	GROUP BY DATE
	ORDER BY DATE DESC;
	`

	rows, err := s.Db.Query(query, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	transactions := make([]types.Transaction, 0)
	for rows.Next() {
		transaction := new(types.Transaction)

		err := rows.Scan(
			&transaction.Date,
			pq.Array(&transaction.Description),
		)
		if err != nil {
			return nil, err
		}

		transactions = append(transactions, *transaction)
	}

	return transactions, nil
}
