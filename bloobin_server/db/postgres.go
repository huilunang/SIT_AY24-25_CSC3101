package db

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
)

type PostgreStore struct {
	Db *sql.DB
}

func NewPostGreStore(connStr string) (*PostgreStore, error) {
	db, err := sql.Open("postgres", connStr)

	if err != nil {
		return nil, fmt.Errorf("error opening database: %v", err)
	}

	if err = db.Ping(); err != nil {
		return nil, fmt.Errorf("error pinging database: %v", err)
	}

	log.Println("Connected to database")

	return &PostgreStore{Db: db}, nil
}
