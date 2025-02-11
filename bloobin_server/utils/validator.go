package utils

import (
	"github.com/go-playground/validator/v10"
	"github.com/huilunang/SIT_AY24-25_CSC3101/bloobin_server/types"
)

var Validate = validator.New()

func init() {
	Validate.RegisterValidation("eqpwfield", passwordMatch)
}

func passwordMatch(fl validator.FieldLevel) bool {
	registerUser := fl.Parent().Interface().(types.RegisterUserPayload)

	return registerUser.Password == registerUser.ConfirmPassword
}
