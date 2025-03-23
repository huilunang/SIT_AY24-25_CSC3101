package config

import (
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

type Config struct {
	DBConnStr           string
	JWTExpiredInSeconds int64
	JWTSecret           string
	InferenceUrl        string
}

var Envs = initConfig()

func initConfig() *Config {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	return &Config{
		DBConnStr:           getEnv("DB_CONN_STR", "postgres://user:password@localhost:5432/dbname?sslmode=disable"),
		JWTExpiredInSeconds: getEnvAsInt("JWTEXPSEC", 3600*24*7),
		JWTSecret:           getEnv("JWT_SECRET", "jwt-shh-secret"),
		InferenceUrl:        getEnv("INFERENCE_URL", "http://localhost:5000/inference"),
	}
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func getEnvAsInt(key string, fallback int64) int64 {
	if value, ok := os.LookupEnv(key); ok {
		i, err := strconv.ParseInt(value, 10, 64)
		if err != nil {
			log.Printf("Warning: Invalid value for %s. Using default: %d", key, fallback)
			return fallback
		}
		return i
	}
	return fallback
}
