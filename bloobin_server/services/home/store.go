package home

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

func (s *Store) GetHomeData(userId int, interval string) (*types.Home, error) {
	home := new(types.Home)

	query := `SELECT POINTS FROM T_USER WHERE ID = $1`
	err := s.Db.QueryRow(query, userId).Scan(&home.Points)
	if err != nil {
		return nil, err
	}

	query = `
	SELECT COUNT(*)
	FROM T_REWARD_TRANSACTION
	WHERE CLAIMED = FALSE AND USER_ID = $1
	`
	err = s.Db.QueryRow(query, userId).Scan(&home.Vouchers)
	if err != nil {
		return nil, err
	}

	query = `
	SELECT DISTINCT TYPE
	FROM T_RECYCLE_TRANSACTION
	WHERE USER_ID = $1
	`
	rows, err := s.Db.Query(query, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var typesList []string
	for rows.Next() {
		var t string

		if err := rows.Scan(&t); err != nil {
			return nil, err
		}

		typesList = append(typesList, t)
	}
	home.Types = typesList

	if interval == "daily" {
		query = `
		SELECT DATE, TYPE, COUNT(*)
		FROM T_RECYCLE_TRANSACTION
		WHERE USER_ID = $1
			AND DATE >= CURRENT_DATE - INTERVAL '7 days'
			AND DATE <= CURRENT_DATE
		GROUP BY DATE, TYPE
		ORDER BY DATE ASC;
		`
	} else {
		query = `
		SELECT DATE_TRUNC('month', DATE) AS month, TYPE, COUNT(*)
		FROM T_RECYCLE_TRANSACTION
		WHERE USER_ID = $1
			AND DATE >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12 months'
			AND DATE < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
		GROUP BY month, TYPE
		ORDER BY month ASC;
		`
	}

	rows, err = s.Db.Query(query, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		chart := new(types.Chart)

		err := rows.Scan(&chart.Date, &chart.Type, &chart.Count)
		if err != nil {
			return nil, err
		}

		home.ChartData = append(home.ChartData, *chart)
	}

	return home, nil
}
