# Variables
IMAGE_NAME ?= devpi/source
IMAGE_TAG ?= latest
PORT ?= 3141

REGISTRY = ghcr.io
NAMESPACE = ScriptonBasestar-containers

CONTAINER_NAME = devpi-server
DATA_DIR = ./devpi_data
LOGS_DIR = ./logs

# Build arguments
BUILD_ARGS = \
	--build-arg PORT=$(PORT) \
	--build-arg INSTALL_WEB=true \
	--build-arg INSTALL_CONSTRAINED=false \
	--build-arg INSTALL_FINDLINKS=false \
	--build-arg INSTALL_JENKINS=false \
	--build-arg INSTALL_LOCKDOWN=false

.PHONY: setup build push clean server-up server-down server-logs server-enter

build:
	@echo "Building Docker image..."
	@echo "devpi Docker image (with web interface)..."
	# docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
	# docker build --progress=plain --no-cache .
	docker build $(BUILD_ARGS) -t $(IMAGE_NAME):$(IMAGE_TAG) -f source/Dockerfile .
	@echo "Docker image built successfully"

build-no-cache: setup
	@echo "Building devpi Docker image without cache..."
	docker build --no-cache -t $(IMAGE_NAME):$(IMAGE_TAG) .
	@echo "Docker image built successfully"

build-full: setup
	@echo "Building devpi Docker image with all plugins..."
	docker build $(BUILD_ARGS) -t $(IMAGE_NAME):full .
	@echo "Full Docker image built successfully"

build-minimal: setup
	@echo "Building minimal devpi Docker image (no web interface)..."
	docker build \
		--build-arg INSTALL_WEB=false \
		-t $(IMAGE_NAME):minimal .
	@echo "Minimal Docker image built successfully"

build-custom: setup
	@echo "Building custom devpi Docker image..."
	@echo "Usage: make build-custom PLUGINS='web=true constrained=true jenkins=false'"
	docker build \
		--build-arg INSTALL_WEB=$(or $(web),false) \
		--build-arg INSTALL_CONSTRAINED=$(or $(constrained),false) \
		--build-arg INSTALL_FINDLINKS=$(or $(findlinks),false) \
		--build-arg INSTALL_JENKINS=$(or $(jenkins),false) \
		--build-arg INSTALL_LOCKDOWN=$(or $(lockdown),false) \
		-t $(IMAGE_NAME):custom .
	@echo "Custom Docker image built successfully"

push:
	@echo "Pushing image to registry..."
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Image pushed to registry"

clean:
	@echo "Cleaning up..."
	rm -rf devpi devpi-constrained devpi-findlinks devpi-jenkins devpi-lockdown
	docker rmi -f $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):full $(IMAGE_NAME):minimal $(IMAGE_NAME):custom 2>/dev/null || true
	docker rmi -f $(REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG) 2>/dev/null || true
	@echo "Cleanup completed"

setup:
	@echo "Setting up directories..."
	mkdir -p $(DATA_DIR) $(LOGS_DIR)
	@echo "Directories created"

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