package classification

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"mime/multipart"
	"net/http"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/config"

	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

func ClassifyImage(image []byte) (types.Classification, error) {
	classification := new(types.Classification)

	log.Printf("Image byte size before sending: %d", len(image))

	bodyBuf := &bytes.Buffer{}
	writer := multipart.NewWriter(bodyBuf)
	fileWriter, err := writer.CreateFormFile("image", "uploaded_image.jpg")
	if err != nil {
		return *classification, fmt.Errorf("error creating form file: %v", err)
	}

	_, err = io.Copy(fileWriter, bytes.NewReader(image))
	if err != nil {
		return *classification, fmt.Errorf("error copying image data: %v", err)
	}

	writer.Close()

	req, err := http.NewRequest("POST", config.Envs.InferenceUrl, bodyBuf)
	if err != nil {
		return *classification, fmt.Errorf("error creating request: %v", err)
	}
	req.Header.Set("Content-Type", writer.FormDataContentType())

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return *classification, fmt.Errorf("error sending request: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return *classification, fmt.Errorf("error inferencing: %v", err)
	}

	decoder := json.NewDecoder(resp.Body)
	err = decoder.Decode(&classification)
	if err != nil {
		return *classification, fmt.Errorf("error decoding response: %v", err)
	}

	log.Printf("Classification Result: %+v", classification)

	return *classification, nil
}
