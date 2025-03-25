package tests

import (
	"bytes"
	"fmt"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gorilla/mux"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/auth"
	recycletransaction "github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/services/recycle_transaction"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestRecycleTransactionHandlers(t *testing.T) {
	tests := []struct {
		name                         string
		endpoint                     string
		method                       string
		mockCheckAvailablePoints     func(userId int, points int) (int, string, error)
		mockSaveImage                func(image []byte) (int, error)
		mockCreateRecycleTransaction func(recycleTransaction types.RecycleTransaction, points int) error
		mockGetUserById              func(id int) (*types.User, error)
		mockClassifyImage            func(image []byte) (*types.Classification, error)
		expectedStatus               int
	}{
		{
			name:     "[Recycle Transaction]: Successful creation",
			endpoint: "/recycle_transactions",
			method:   "POST",
			mockCheckAvailablePoints: func(userId int, points int) (int, string, error) {
				return 10, "points availability message", nil
			},
			mockSaveImage: func(image []byte) (int, error) {
				return 1, nil
			},
			mockCreateRecycleTransaction: func(recycleTransaction types.RecycleTransaction, points int) error {
				return nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: id}, nil
			},
			mockClassifyImage: func(image []byte) (*types.Classification, error) {
				return &types.Classification{}, nil
			},
			expectedStatus: http.StatusCreated,
		},
		{
			name:     "[Recycle Transaction]: Error in image classification",
			endpoint: "/recycle_transactions",
			method:   "POST",
			mockCheckAvailablePoints: func(userId int, points int) (int, string, error) {
				return 10, "Points available", nil
			},
			mockSaveImage: func(image []byte) (int, error) {
				return 1, nil
			},
			mockCreateRecycleTransaction: func(recycleTransaction types.RecycleTransaction, points int) error {
				return nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
		{
			name:     "[Recycle Transaction]: Error checking available points",
			endpoint: "/recycle_transactions",
			method:   "POST",
			mockCheckAvailablePoints: func(userId int, points int) (int, string, error) {
				return 0, "", fmt.Errorf("error checking available points")
			},
			mockSaveImage: func(image []byte) (int, error) {
				return 1, nil
			},
			mockCreateRecycleTransaction: func(recycleTransaction types.RecycleTransaction, points int) error {
				return nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
		{
			name:     "[Recycle Transaction]: Error saving image",
			endpoint: "/recycle_transactions",
			method:   "POST",
			mockCheckAvailablePoints: func(userId int, points int) (int, string, error) {
				return 10, "Points available", nil
			},
			mockSaveImage: func(image []byte) (int, error) {
				return 0, fmt.Errorf("error saving image")
			},
			mockCreateRecycleTransaction: func(recycleTransaction types.RecycleTransaction, points int) error {
				return nil
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
		{
			name:     "[Recycle Transaction]: Error creating recycle transaction",
			endpoint: "/recycle_transactions",
			method:   "POST",
			mockCheckAvailablePoints: func(userId int, points int) (int, string, error) {
				return 10, "Points available", nil
			},
			mockSaveImage: func(image []byte) (int, error) {
				return 1, nil
			},
			mockCreateRecycleTransaction: func(recycleTransaction types.RecycleTransaction, points int) error {
				return fmt.Errorf("error creating recycle transaction")
			},
			mockGetUserById: func(id int) (*types.User, error) {
				return &types.User{ID: 1}, nil
			},
			expectedStatus: http.StatusInternalServerError,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockRecycleTransactionStore := &mockRecycleTransactionStore{
				checkAvailablePoints:     tt.mockCheckAvailablePoints,
				saveImage:                tt.mockSaveImage,
				createRecycleTransaction: tt.mockCreateRecycleTransaction,
			}
			mockUserStore := &mockUserStore{
				getUserById: tt.mockGetUserById,
			}
			mockClassifier := &mockClassifier{
				classifyImage: tt.mockClassifyImage,
			}
			handler := recycletransaction.NewHandler(mockRecycleTransactionStore, mockUserStore, mockClassifier)

			body := &bytes.Buffer{}
			writer := multipart.NewWriter(body)
			part, err := writer.CreateFormFile("image", "mockimage.jpg")
			if err != nil {
				t.Fatal("Error creating form file:", err)
			}
			_, err = part.Write([]byte("mock image content"))
			if err != nil {
				t.Fatal("Error writing mock image:", err)
			}
			err = writer.Close()
			if err != nil {
				t.Fatal("Error closing multipart writer:", err)
			}

			secret := []byte(config.Envs.JWTSecret)
			token, err := auth.CreateJWT(secret, 1)
			if err != nil {
				t.Fatalf("Error generating JWT: %v", err)
			}

			req, err := http.NewRequest(tt.method, tt.endpoint, body)
			if err != nil {
				t.Fatal(err)
			}
			req.Header.Set("Authorization", token)
			req.Header.Set("Content-Type", writer.FormDataContentType())

			rr := httptest.NewRecorder()
			router := mux.NewRouter()
			handler.RegisterRoutes(router)
			router.ServeHTTP(rr, req)

			if rr.Code != tt.expectedStatus {
				t.Errorf("Expected status %d, got %d", tt.expectedStatus, rr.Code)
			}
		})
	}
}

type mockRecycleTransactionStore struct {
	checkAvailablePoints     func(userId int, points int) (int, string, error)
	saveImage                func(image []byte) (int, error)
	createRecycleTransaction func(recycleTransaction types.RecycleTransaction, points int) error
}

func (m *mockRecycleTransactionStore) CheckAvailablePoints(userId int, points int) (int, string, error) {
	if m.checkAvailablePoints != nil {
		return m.checkAvailablePoints(userId, points)
	}

	return 0, "", fmt.Errorf("error checking available points")
}

func (m *mockRecycleTransactionStore) SaveImage(image []byte) (int, error) {
	if m.saveImage != nil {
		return m.saveImage(image)
	}

	return 0, fmt.Errorf("error saving image")
}

func (m *mockRecycleTransactionStore) CreateRecycleTransaction(recycleTransaction types.RecycleTransaction, points int) error {
	if m.createRecycleTransaction != nil {
		return m.createRecycleTransaction(recycleTransaction, points)
	}

	return fmt.Errorf("error saving recycling data")
}
