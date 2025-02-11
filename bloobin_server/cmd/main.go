package main

import (
	"log"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/cmd/api"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/db"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()

	db, err := db.NewPostGreStore(config.Envs.DBConnStr)

	if err != nil {
		log.Fatal(err)
	}

	server := api.NewAPIServer(":8080", db)

	if err := server.Run(); err != nil {
		log.Fatal(err)
	}
}
