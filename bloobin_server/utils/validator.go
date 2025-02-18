package utils

import (
	"fmt"
	"strings"

	"github.com/go-playground/validator/v10"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

var Validate = validator.New()

func init() {
	Validate.RegisterValidation("eqpwfield", passwordMatch)
	Validate.RegisterValidation("interval", validateInterval)
}

func ExtractValidationErrors(err error) string {
	if validationErrors, ok := err.(validator.ValidationErrors); ok {
		var errorMessages []string

		for _, fieldErr := range validationErrors {
			switch fieldErr.Tag() {
			case "required":
				errorMessages = append(errorMessages, fmt.Sprintf("%s is required", fieldErr.Field()))
			case "email":
				errorMessages = append(errorMessages, fmt.Sprintf("%s must be a valid email", fieldErr.Field()))
			case "eqpwfield":
				errorMessages = append(errorMessages, "password entered must be the same")
			case "interval":
				errorMessages = append(errorMessages, "frequency can be only daily or monthly")
			default:
				errorMessages = append(errorMessages, fmt.Sprintf("%s is invalid", fieldErr.Field()))
			}
		}

		return strings.Join(errorMessages, ", ")
	}

	return "Invalid request payload"
}

func passwordMatch(fl validator.FieldLevel) bool {
	registerUser := fl.Parent().Interface().(types.RegisterUserPayload)

	return registerUser.Password == registerUser.ConfirmPassword
}

func validateInterval(fl validator.FieldLevel) bool {
	home := fl.Parent().Interface().(types.GetHomePayload)

	return home.Interval == "daily" || home.Interval == "monthly"
}
