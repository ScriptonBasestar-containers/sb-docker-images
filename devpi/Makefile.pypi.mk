# Variables
IMAGE_NAME ?= devpi/pypi
IMAGE_TAG ?= latest
PORT ?= 3141

REGISTRY = ghcr.io
NAMESPACE = scriptonbasestar-containers

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

.PHONY: build push setup teardown clean


build: 
	@echo "Building Docker image..."
	docker build $(BUILD_ARGS) -t $(REGISTRY)/$(NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG) -f pypi/Dockerfile .
	@echo "Docker image built successfully"

push:
	@echo "Pushing Docker image..."
	# docker push $(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(REGISTRY)/$(NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG)

setup:
	@echo "Setting up devpi server..."
	mkdir -p $(DATA_DIR) $(LOGS_DIR)
	chmod 777 $(DATA_DIR) $(LOGS_DIR)

run:
	@echo "Setting up devpi server..."
	docker run -d \
		--name devpi-server \
		-p $(PORT):$(PORT) \
		-v $(DATA_DIR):/app/data \
		-v $(LOGS_DIR):/app/logs \
		$(REGISTRY)/$(NAMESPACE)/$(IMAGE_NAME):$(IMAGE_TAG)

enter:
	@echo "Running devpi server..."
	docker exec -it devpi-server /bin/bash

teardown:
	@echo "Tearing down devpi server..."
	-docker stop devpi-server
	-docker rm devpi-server
	-rm -rf $(DATA_DIR) $(LOGS_DIR)
	# rm -rf data/*
	# rm -rf logs/*
