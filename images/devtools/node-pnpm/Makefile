.PHONY: help build build-alpine build-builder build-all up down logs ps shell clean test

NODE_VERSION ?= 22
PNPM_VERSION ?= 9
DOCKER_REPONAME ?= scriptonbasestar
IMAGE_NAME = $(DOCKER_REPONAME)/node-pnpm

help:
	@echo "Node.js with pnpm Development Environment"
	@echo ""
	@echo "Build commands:"
	@echo "  make build          - Build default (Debian slim) image"
	@echo "  make build-alpine   - Build Alpine variant"
	@echo "  make build-builder  - Build builder variant"
	@echo "  make build-all      - Build all variants"
	@echo ""
	@echo "Runtime commands:"
	@echo "  make up             - Start container"
	@echo "  make down           - Stop container"
	@echo "  make logs           - View logs"
	@echo "  make ps             - Show running containers"
	@echo "  make shell          - Access container shell"
	@echo "  make clean          - Stop and remove all data"
	@echo ""
	@echo "Test commands:"
	@echo "  make test           - Run image tests"
	@echo ""
	@echo "Variables:"
	@echo "  NODE_VERSION=$(NODE_VERSION)"
	@echo "  PNPM_VERSION=$(PNPM_VERSION)"

build:
	docker build \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg PNPM_VERSION=$(PNPM_VERSION) \
		-t $(IMAGE_NAME):$(NODE_VERSION) \
		-f Dockerfile .
	@echo ""
	@echo "Built: $(IMAGE_NAME):$(NODE_VERSION)"

build-alpine:
	docker build \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg PNPM_VERSION=$(PNPM_VERSION) \
		-t $(IMAGE_NAME):$(NODE_VERSION)-alpine \
		-f Dockerfile.alpine .
	@echo ""
	@echo "Built: $(IMAGE_NAME):$(NODE_VERSION)-alpine"

build-builder:
	docker build \
		--build-arg NODE_VERSION=$(NODE_VERSION) \
		--build-arg PNPM_VERSION=$(PNPM_VERSION) \
		-t $(IMAGE_NAME):$(NODE_VERSION)-builder \
		-f Dockerfile.builder .
	@echo ""
	@echo "Built: $(IMAGE_NAME):$(NODE_VERSION)-builder"

build-all: build build-alpine build-builder
	@echo ""
	@echo "All variants built successfully!"

up:
	docker compose up -d
	@echo ""
	@echo "Node.js with pnpm container is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

shell:
	docker run -it --rm \
		-v $(PWD)/app:/app \
		-v node-pnpm-store:/pnpm \
		$(IMAGE_NAME):$(NODE_VERSION) \
		/bin/bash

clean:
	@echo "This will remove all node-pnpm data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All data removed"; \
	fi

test:
	@echo "Testing node-pnpm images..."
	@echo ""
	@echo "=== Testing Debian image ==="
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION) node --version
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION) pnpm --version
	@echo ""
	@echo "=== Testing Alpine image ==="
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION)-alpine node --version
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION)-alpine pnpm --version
	@echo ""
	@echo "=== Testing Builder image ==="
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION)-builder node --version
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION)-builder pnpm --version
	docker run --rm $(IMAGE_NAME):$(NODE_VERSION)-builder python3 --version
	@echo ""
	@echo "All tests passed!"
