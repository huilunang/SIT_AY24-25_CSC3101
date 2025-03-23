include .env

# Docker Compose Configuration
COMPOSE_FILE_ARG := -f docker/compose.yaml
ENV_FILE_ARG := --env-file .env

# Migration Paths
MIGRATION_EXE_PATH := bloobin_server/cmd/migrate/main.go
MIGRATION_OUT_PATH := bloobin_server/cmd/migrate/migrations

.PHONY: inference db build run clean test migration migrate-up migrate-down wait-db

inference:
	@echo "Running inference server..."
	@docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} up -d inference

db:
	@echo "Running database..."
	@docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} up -d db

build:
	@cd bloobin_server && go build -o bin/bloobin_server cmd/main.go

run: db inference build
	@echo "Running Bloobin Server..."
	@./bloobin_server/bin/bloobin_server

clean:
	@echo "Cleaning Bloobin Server..."
	@docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} down --remove-orphans
	@rm -rf bin

test:
	@echo "Testing..."
	@go test -v ./tests

migration: wait-db
	@echo "Creating migration file..."
	@docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} run --rm migrate \
		migrate create -ext sql -dir ${MIGRATION_OUT_PATH} $(filter-out $@,$(MAKECMDGOALS))

migrate-up: wait-db
	@echo "Applying migrations (up)..."
	@docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} run --rm migrate \
		migrate -path ${MIGRATION_OUT_PATH} -database ${DB_CONN_STR} up

migrate-down: wait-db
	@echo "Rolling back migrations (down)..."
	@docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} run --rm migrate \
		migrate -path ${MIGRATION_OUT_PATH} -database ${DB_CONN_STR} down

wait-db:
	@echo "Waiting for DB to be ready..."
	@until docker compose ${COMPOSE_FILE_ARG} ${ENV_FILE_ARG} exec -T db pg_isready \
		-U ${POSTGRES_USER} -d ${POSTGRES_PROD_DB}; do \
		echo "Waiting for DB to be ready..."; \
		sleep 2; \
	done
