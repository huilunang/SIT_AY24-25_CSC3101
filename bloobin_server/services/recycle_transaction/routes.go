package recycletransaction

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/classification"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store types.RecycleTransactionStore
}

func NewHandler(store types.RecycleTransactionStore) *Handler {
	return &Handler{store: store}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	// router.HandleFunc("/recycle_transactions", h.handleGetRecycleTransactions).Methods("GET")
	router.HandleFunc("/recycle_transactions", h.handleCreateRecycleTransaction).Methods("POST")
}

// func (h *Handler) handleGetRecycleTransactions(w http.ResponseWriter, r *http.Request) {
// 	getRecycleTransactionsPayload := new(types.GetRecycleTransactionsPayload)
// 	if err := utils.DecodeAPIJSON(r, &getRecycleTransactionsPayload); err != nil {
// 		utils.WriteError(w, http.StatusBadRequest, err)
// 	}

// 	if err := utils.Validate.Struct(getRecycleTransactionsPayload); err != nil {
// 		log.Printf("invalid payload: %s", utils.ExtractValidationErrors(err))
// 		utils.WriteError(
// 			w,
// 			http.StatusBadRequest,
// 			fmt.Errorf("%s", utils.ExtractValidationErrors(err)),
// 		)
// 		return
// 	}

// 	// TODO: Validate JWTToken

// 	rt, err := h.store.GetRecycleTransactions(getRecycleTransactionsPayload.ID)
// 	if err != nil {
// 		log.Printf("error retrieving recycle transaction with id %s: %v",
// 			getRecycleTransactionsPayload.ID, err)
// 		utils.WriteError(
// 			w, http.StatusInternalServerError,
// 			fmt.Errorf("error retrieving recycle transaction with id %s",
// 				getRecycleTransactionsPayload.ID),
// 		)
// 		return
// 	}

// 	utils.WriteAPIJSON(w, http.StatusOK, map[string]interface{}{"data": rt})
// }

func (h *Handler) handleCreateRecycleTransaction(w http.ResponseWriter, r *http.Request) {
	err := r.ParseMultipartForm(10 << 20) // 10MB max file size
	if err != nil {
		log.Printf("error parsing form: %v", err)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("%v", err))
		return
	}

	userId, err := utils.ConvertStrToInt(r.FormValue("user_id"))
	if err != nil {
		log.Printf("invalid user_id format: %v", err)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("invalid user_id format"))
		return
	}

	file, _, err := r.FormFile("image")
	if err != nil {
		log.Printf("error retrieving image: %v", err)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("error retrieving image"))
		return
	}
	defer file.Close()

	var imgBytes bytes.Buffer
	_, err = io.Copy(&imgBytes, file)
	if err != nil {
		log.Printf("error reading image file: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, fmt.Errorf("error reading image file"))
		return
	}

	createRecycleTransactionPayload := types.CreateRecycleTransactionPayload{
		Image:  imgBytes.Bytes(),
		UserId: userId,
	}

	if err := utils.Validate.Struct(createRecycleTransactionPayload); err != nil {
		log.Printf("invalid payload: %s", utils.ExtractValidationErrors(err))
		utils.WriteError(
			w,
			http.StatusBadRequest,
			fmt.Errorf("%s", utils.ExtractValidationErrors(err)),
		)
		return
	}

	classificationResult, err := classification.ClassifyImage(createRecycleTransactionPayload.Image)
	if err != nil {
		log.Printf("error classifying image: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, fmt.Errorf("error classifying image"))
		return
	}

	err = h.store.CreateRecycleTransaction(types.RecycleTransaction{
		Type:        classificationResult.Type,
		Subtype:     classificationResult.Subtype,
		Image:       createRecycleTransactionPayload.Image,
		Description: fmt.Sprintf("+ %d pts from recycling", classificationResult.Points),
		Date:        time.Now().Truncate(24 * time.Hour),
		UserId:      createRecycleTransactionPayload.UserId,
	}, classificationResult.Points)
	if err != nil {
		log.Printf("error saving recycling data %v", err)
		utils.WriteError(w, http.StatusInternalServerError, err)
	}

	utils.WriteAPIJSON(w, http.StatusCreated, map[string]interface{}{
		"material": classificationResult.Subtype,
		"points":   classificationResult.Points,
	})
}
