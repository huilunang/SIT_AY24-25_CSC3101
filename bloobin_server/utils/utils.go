package utils

import (
	"encoding/json"
	"fmt"
	"net/http"
)

func WriteAPIJSON(w http.ResponseWriter, status int, v interface{}) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)

	return json.NewEncoder(w).Encode(v)
}

func DecodeAPIJSON(r *http.Request, v interface{}) error {
	if r.Body == nil {
		return fmt.Errorf("request body is missing")
	}

	return json.NewDecoder(r.Body).Decode(v)
}

func WriteError(w http.ResponseWriter, status int, err error) {
	WriteAPIJSON(w, status, map[string]string{"error": err.Error()})
}
