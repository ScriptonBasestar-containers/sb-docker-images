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
	@echo "  prepare      - Clone devpi repository and plugins"
	@echo "  setup        - Setup directories and permissions"
	@echo "  build        - Build Docker image (with web interface)"
	@echo "  build-full   - Build image with all plugins enabled"
	@echo "  build-minimal- Build minimal image (no web interface)"
	@echo "  build-custom - Build custom image with specific plugins"
	@echo "               Usage: make build-custom web=true constrained=true"
	@echo "  push         - Push image to registry"
	@echo "  clean        - Clean up cloned repositories and Docker resources"
	@echo "  server-up    - Start devpi server"
	@echo "  server-down  - Stop devpi server"
	@echo "  server-logs  - View server logs"
	@echo "  server-enter - Enter running container"

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
	@echo "Building devpi Docker image (with web interface)..."
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
	@echo "Docker image built successfully"

build-no-cache: setup
	@echo "Building devpi Docker image without cache..."
	docker build --no-cache -t $(IMAGE_NAME):$(IMAGE_TAG) .
	@echo "Docker image built successfully"

build-full: setup
	@echo "Building devpi Docker image with all plugins..."
	docker build \
		--build-arg INSTALL_WEB=true \
		--build-arg INSTALL_CONSTRAINED=true \
		--build-arg INSTALL_FINDLINKS=true \
		--build-arg INSTALL_JENKINS=true \
		--build-arg INSTALL_LOCKDOWN=true \
		-t $(IMAGE_NAME):full .
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