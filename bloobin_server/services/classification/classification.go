package classification

import (
	"math/rand"
	"time"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func ClassifyImage(image []byte) (types.Classification, error) {
	typesList := []string{"Metal", "Plastic", "Cardboard", "Glass", "Paper"}

	randomType := typesList[rand.Intn(len(typesList))]

	mockResult := types.Classification{
		Type:    randomType,
		Subtype: randomType,
		Points:  rand.Intn(2),
	}

	time.Sleep(2 * time.Second)

	return mockResult, nil
}
