# Devpi Docker Build and Management Makefile

# Variables
IMAGE_NAME = devpi/server
IMAGE_TAG = latest
REGISTRY = localhost:5000
CONTAINER_NAME = devpi-server
DATA_DIR = ./devpi_data
LOGS_DIR = ./logs

.PHONY: help prepare setup build push clean server-up server-down server-logs server-enter

help:
	@echo "Available commands:"
	@echo "  prepare     - Clone devpi repository and prepare environment"
	@echo "  setup       - Setup directories and permissions"
	@echo "  build       - Build Docker image"
	@echo "  push        - Push image to registry"
	@echo "  clean       - Clean up cloned repository and Docker resources"
	@echo "  server-up   - Start devpi server"
	@echo "  server-down - Stop devpi server"
	@echo "  server-logs - View server logs"
	@echo "  server-enter- Enter running container"

prepare:
	@echo "Preparing devpi environment..."
	rm -rf devpi
	git clone https://github.com/devpi/devpi.git --depth 1
	git clone https://github.com/devpi/devpi-constrained.git --depth 1
	git clone https://github.com/devpi/devpi-findlinks.git --depth 1
	git clone https://github.com/devpi/devpi-jenkins.git --depth 1
	git clone https://github.com/devpi/devpi-lockdown.git --depth 1
	@echo "devpi repository cloned successfully"

setup:
	@echo "Setting up directories..."
	mkdir -p $(DATA_DIR) $(LOGS_DIR)
	@echo "Directories created"

build: setup
	@echo "Building devpi Docker image..."
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
	@echo "Docker image built successfully"

build-no-cache: setup
	@echo "Building devpi Docker image without cache..."
	docker build --no-cache -t $(IMAGE_NAME):$(IMAGE_TAG) .
	@echo "Docker image built successfully"

push:
	@echo "Pushing image to registry..."
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Image pushed to registry"

clean:
	@echo "Cleaning up..."
	rm -rf devpi
	docker rmi -f $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) 2>/dev/null || true
	@echo "Cleanup completed"

server-up:
	@echo "Starting devpi server..."
	docker run -d \
		--name $(CONTAINER_NAME) \
		-p 3141:3141 \
		-v $(PWD)/$(DATA_DIR):/app/data \
		-v $(PWD)/$(LOGS_DIR):/app/logs \
		--restart unless-stopped \
		$(IMAGE_NAME):$(IMAGE_TAG)
	@echo "devpi server started on http://localhost:3141"

server-down:
	@echo "Stopping devpi server..."
	docker stop $(CONTAINER_NAME) 2>/dev/null || true
	docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@echo "devpi server stopped"

server-logs:
	@echo "Viewing devpi server logs..."
	docker logs -f $(CONTAINER_NAME)

server-enter:
	@echo "Entering devpi container..."
	docker exec -it $(CONTAINER_NAME) bash

server-restart: server-down server-up

# Development helpers
dev-build: prepare build

dev-run: dev-build server-up

dev-clean: server-down clean 