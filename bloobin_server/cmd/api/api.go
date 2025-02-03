package api

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/db"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/user"
)

type APIServer struct {
	listenAddr string
	db         *db.PostgreStore
}

func NewAPIServer(addr string, db *db.PostgreStore) *APIServer {
	return &APIServer{listenAddr: addr, db: db}
}

func (s *APIServer) Run() error {
	router := mux.NewRouter()
	subRouter := router.PathPrefix("/api/v1").Subrouter()

	userHandler := user.NewHandler()
	userHandler.RegisterRoutes(subRouter)

	log.Println("Bloobin server running on port: ", s.listenAddr)

	return http.ListenAndServe(s.listenAddr, router)
}
