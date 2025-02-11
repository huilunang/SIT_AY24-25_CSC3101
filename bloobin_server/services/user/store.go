package user

import (
	"database/sql"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/errors"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

type Store struct {
	Db *sql.DB
}

func NewStore(db *sql.DB) *Store {
	return &Store{Db: db}
}

func (s *Store) CreateUser(user types.User) error {
	query := `
	INSERT INTO T_USER (EMAIL, PASSWORD)
	VALUES ($1, $2)
	`
	stmt, err := s.prepareStmt(query)

	if err != nil {
		return err
	}
	defer stmt.Close()

	_, err = stmt.Exec(user.Email, user.Password)
	if err != nil {
		return err
	}

	return nil
}

func (s *Store) GetUserByEmail(email string) (*types.User, error) {
	query := `SELECT * FROM T_USER WHERE EMAIL = $1`
	stmt, err := s.prepareStmt(query)

	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	rows, err := stmt.Query(email)
	if err != nil {
		return nil, err
	}

	user := new(types.User)
	for rows.Next() {
		err = rows.Scan(
			&user.ID,
			&user.Email,
			&user.Password,
			&user.Points,
			&user.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
	}

	if user.ID == 0 {
		return nil, errors.ErrUserNotFound
	}

	return user, nil
}

func (s *Store) prepareStmt(q string) (*sql.Stmt, error) {
	stmt, err := s.Db.Prepare(q)

	if err != nil {
		return nil, err
	}

	return stmt, nil
}
