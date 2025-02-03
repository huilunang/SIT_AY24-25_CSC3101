package main

import (
	"log"
	"os"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/cmd/api"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/db"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()

	db, err := db.NewPostGreStore(os.Getenv("DB_CONN_STR"))

	if err != nil {
		log.Fatal(err)
	}

	server := api.NewAPIServer(":8080", db)

	if err := server.Run(); err != nil {
		log.Fatal(err)
	}
}
