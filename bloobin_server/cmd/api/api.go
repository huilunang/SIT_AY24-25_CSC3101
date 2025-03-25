package api

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/db"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/classification"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/home"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/recycle_transaction"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/reward_transaction"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/transaction"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/user"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/voucher_catalogue"
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

	userStore := user.NewStore(s.db.Db)
	userHandler := user.NewHandler(userStore)
	userHandler.RegisterRoutes(subRouter)

	homeStore := home.NewStore(s.db.Db)
	homeHandler := home.NewHandler(homeStore, userStore)
	homeHandler.RegisterRoutes(subRouter)

	transactionStore := transaction.NewStore(s.db.Db)
	transactionHandler := transaction.NewHandler(transactionStore, userStore)
	transactionHandler.RegisterRoutes(subRouter)

	voucherCatalogueStore := vouchercatalogue.NewStore(s.db.Db)
	voucherCatalogueHandler := vouchercatalogue.NewHandler(voucherCatalogueStore, userStore)
	voucherCatalogueHandler.RegisterRoutes(subRouter)

	rewardTransactionStore := rewardtransaction.NewStore(s.db.Db)
	rewardTransactionHandler := rewardtransaction.NewHandler(rewardTransactionStore, userStore)
	rewardTransactionHandler.RegisterRoutes(subRouter)

	recycleTransactionStore := recycletransaction.NewStore(s.db.Db)
	classifier := classification.NewClassifier()
	recycleTransactionHandler := recycletransaction.NewHandler(recycleTransactionStore, userStore, classifier)
	recycleTransactionHandler.RegisterRoutes(subRouter)

	log.Println("Bloobin server running on port:", s.listenAddr)

	return http.ListenAndServe(s.listenAddr, router)
}
