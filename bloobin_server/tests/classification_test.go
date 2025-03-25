package tests

import (
	"fmt"
	"testing"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func TestClassifier(t *testing.T) {
	t.Run("[Classifier]: Successful classification", func(t *testing.T) {
		mockClassifier := &mockClassifier{
			classifyImage: func(image []byte) (*types.Classification, error) {
				return &types.Classification{
					Type:       []string{"plastic"},
					Confidence: []string{"0.98"},
					Subtype:    []string{"plastic_bottle"},
				}, nil
			},
		}

		image := []byte("image_data")

		result, err := mockClassifier.ClassifyImage(image)
		if err != nil {
			t.Errorf("unexpected error: %v", err)
		}

		if result.Type[0] != "plastic" || result.Confidence[0] != "0.98" || result.Subtype[0] != "plastic_bottle" {
			t.Errorf("unexpected classification result: %+v", result)
		}
	})
}

type mockClassifier struct {
	classifyImage func(image []byte) (*types.Classification, error)
}

func (m *mockClassifier) ClassifyImage(image []byte) (*types.Classification, error) {
	if m.classifyImage != nil {
		return m.classifyImage(image)
	}

	return nil, fmt.Errorf("error inferencing image")
}
