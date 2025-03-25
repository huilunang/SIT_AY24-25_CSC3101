package recycletransaction

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"net/http"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/utils"
)

type Handler struct {
	store      types.RecycleTransactionStore
	userStore  types.UserStore
	classifier types.Classifier
}

func NewHandler(store types.RecycleTransactionStore, userStore types.UserStore, classifier types.Classifier) *Handler {
	return &Handler{store: store, userStore: userStore, classifier: classifier}
}

func (h *Handler) RegisterRoutes(router *mux.Router) {
	// router.HandleFunc("/recycle_transactions", h.handleGetRecycleTransactions).Methods("GET")
	router.HandleFunc("/recycle_transactions", auth.WithJWTAuth(h.handleCreateRecycleTransaction, h.userStore)).Methods("POST")
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
	userId := auth.GetUserIdFromContext(r.Context())

	err := r.ParseMultipartForm(10 << 20) // 10MB max file size
	if err != nil {
		log.Printf("error parsing form: %v", err)
		utils.WriteError(w, http.StatusBadRequest, fmt.Errorf("%v", err))
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
		Image: imgBytes.Bytes(),
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

	classificationResult, err := h.classifier.ClassifyImage(createRecycleTransactionPayload.Image)
	if err != nil {
		log.Printf("error classifying image: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, fmt.Errorf("error classifying image"))
		return
	}

	availablePoints, pointsMessage, err := h.store.CheckAvailablePoints(userId, classificationResult.Points)
	if err != nil {
		log.Printf("error checking available points: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	imageID, err := h.store.SaveImage(createRecycleTransactionPayload.Image)
	if err != nil {
		log.Printf("error saving image: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	predictionID, err := uuid.NewV7()
	if err != nil {
		log.Printf("error generating UUID: %v", err)
		utils.WriteError(w, http.StatusInternalServerError, err)
		return
	}

	for i, cType := range classificationResult.Type {
		pointsToAdd := 0
		if availablePoints >= 1 && cType != "non-recyclable" {
			pointsToAdd = 1
			availablePoints--
		}

		err = h.store.CreateRecycleTransaction(types.RecycleTransaction{
			Type:         cType,
			Subtype:      classificationResult.Subtype[i],
			Confidence:   classificationResult.Confidence[i],
			ImageId:      imageID,
			Description:  fmt.Sprintf("+ %d pts from recycling", pointsToAdd),
			Date:         time.Now().Truncate(24 * time.Hour),
			PredictionId: predictionID.String(),
			UserId:       userId,
		}, pointsToAdd)
		if err != nil {
			log.Printf("error saving recycling data: %v", err)
			utils.WriteError(w, http.StatusInternalServerError, err)
			return
		}
	}

	responsePayload := map[string]any{
		"material":       strings.Join(utils.RemoveDuplicateStr(classificationResult.Subtype), ", "),
		"points_message": pointsMessage,
	}
	if len(classificationResult.NonRecyclable) > 0 {
		responsePayload["remark"] = fmt.Sprintf(
			"Ensure recyclables are clean. Detected non-recyclables or contaminants include: %v.",
			strings.Join(classificationResult.NonRecyclable, ", "),
		)
	}

	utils.WriteAPIJSON(w, http.StatusCreated, responsePayload)
}
