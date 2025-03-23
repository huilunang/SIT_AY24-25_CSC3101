package utils

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
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

func ConvertStrToInt(data string) (int, error) {
	convertedData, err := strconv.Atoi(data)
	if err != nil {
		return 0, err
	}

	return convertedData, nil
}

func RemoveDuplicateStr(s []string) []string {
	keys := make(map[string]bool)
	list := []string{}

	for _, item := range s {
		if _, value := keys[item]; !value {
			keys[item] = true
			list = append(list, item)
		}
	}

	return list
}

func Pluralize(points int) string {
    if points == 1 {
        return ""
    }
    return "s"
}
