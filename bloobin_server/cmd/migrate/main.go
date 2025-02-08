package main

import (
	"log"
	"os"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/postgres"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/db"
)

func main() {
	db, err := db.NewPostGreStore(os.Getenv("DB_CONN_STR"))
	if err != nil {
		log.Fatal(err)
	}

	driver, err := postgres.WithInstance(db.Db, &postgres.Config{})
	if err != nil {
		log.Fatal(err)
	}

	m, err := migrate.NewWithDatabaseInstance(
		"file://cmd/migrate/migrations",
		"postgres",
		driver,
	)
	if err != nil {
		log.Fatal(err)
	}

	cmd := os.Args[(len(os.Args) - 1)]
	switch cmd {
	case "up":
		log.Println("Starting migration up...")
		if err := m.Up(); err != nil && err != migrate.ErrNoChange {
			log.Fatal(err)
		}
	case "down":
		log.Println("Starting migration down...")
		if err := m.Down(); err != nil && err != migrate.ErrNoChange {
			log.Fatal(err)
		}
	}
}
