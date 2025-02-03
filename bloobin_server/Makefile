build:
	@go build -o bin/bloobin_server

run: build
	@echo "Running Bloobin Server..."
	@docker compose -f ./docker/compose.yaml --env-file .env up -d
	@./bin/bloobin_server

clean:
	@echo "Cleaning Bloobin Server..."
	@docker compose -f ./docker/compose.yaml --env-file .env down
	@rm -rf bin

test:
	@echo "Testing..."
	@go test -v ./tests
