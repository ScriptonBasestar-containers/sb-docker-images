# PostgreSQL with pgvector for CloudNativePG
# Build multi-architecture images for production use

# Variables
IMAGE_NAME := postgres-vector
REGISTRY := docker.io/scriptonbasestar
PG_VERSION := 16
PGVECTOR_VERSION := 0.7.4
FULL_TAG := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)
VERSIONED_TAG := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-pgvector-$(PGVECTOR_VERSION)
DOCKERFILE := cnpg-vector.dockerfile

# Default target
.PHONY: help
help:
	@echo "PostgreSQL with pgvector build targets:"
	@echo "  make build       - Build single-arch image (current platform)"
	@echo "  make test        - Run tests on built image"
	@echo "  make tag         - Tag image for registry"
	@echo "  make push        - Push tagged images to registry"
	@echo "  make buildx      - Build and push multi-arch (amd64, arm64)"
	@echo "  make clean       - Remove local test containers"
	@echo "  make verify      - Verify image contents"
	@echo ""
	@echo "Current settings:"
	@echo "  Image: $(FULL_TAG)"
	@echo "  Version Tag: $(VERSIONED_TAG)"
	@echo "  PostgreSQL: $(PG_VERSION)"
	@echo "  pgvector: $(PGVECTOR_VERSION)"

# Build single-arch image
.PHONY: build
build:
	docker build \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(IMAGE_NAME):$(PG_VERSION) \
		-f $(DOCKERFILE) .

# Run tests on built image
.PHONY: test
test:
	@echo "Testing PostgreSQL version..."
	docker run --rm $(IMAGE_NAME):$(PG_VERSION) postgres --version
	@echo ""
	@echo "Testing pgvector extension files..."
	docker run --rm $(IMAGE_NAME):$(PG_VERSION) ls -lh /usr/lib/postgresql/16/lib/vector.so
	@echo ""
	@echo "Starting PostgreSQL and testing vector extension..."
	docker run -d --name test-pg-vector -e POSTGRES_PASSWORD=test123 $(IMAGE_NAME):$(PG_VERSION)
	@sleep 5
	docker exec test-pg-vector psql -U postgres -c "CREATE EXTENSION IF NOT EXISTS vector; SELECT * FROM pg_available_extensions WHERE name = 'vector';"
	docker exec test-pg-vector psql -U postgres -c "CREATE TABLE test_vectors (id serial PRIMARY KEY, embedding vector(3)); INSERT INTO test_vectors (embedding) VALUES ('[1,2,3]'), ('[4,5,6]'); SELECT * FROM test_vectors ORDER BY embedding <-> '[3,1,2]' LIMIT 1;"
	docker stop test-pg-vector
	docker rm test-pg-vector
	@echo ""
	@echo "✅ All tests passed!"

# Tag image for registry
.PHONY: tag
tag:
	docker tag $(IMAGE_NAME):$(PG_VERSION) $(FULL_TAG)
	docker tag $(IMAGE_NAME):$(PG_VERSION) $(VERSIONED_TAG)
	@echo "Tagged:"
	@echo "  $(FULL_TAG)"
	@echo "  $(VERSIONED_TAG)"

# Push to registry
.PHONY: push
push: tag
	docker push $(FULL_TAG)
	docker push $(VERSIONED_TAG)
	@echo "✅ Pushed to registry"

# Build and push multi-arch (production)
.PHONY: buildx
buildx:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(FULL_TAG) \
		-t $(VERSIONED_TAG) \
		--push \
		-f $(DOCKERFILE) .
	@echo "✅ Multi-arch build pushed to registry"

# Verify image contents
.PHONY: verify
verify:
	@echo "=== PostgreSQL Version ==="
	docker run --rm $(IMAGE_NAME):$(PG_VERSION) postgres --version
	@echo ""
	@echo "=== pgvector Extension ==="
	docker run --rm $(IMAGE_NAME):$(PG_VERSION) sh -c "ls -lh /usr/lib/postgresql/16/lib/vector.so && cat /usr/share/postgresql/16/extension/vector.control"
	@echo ""
	@echo "=== CloudNativePG Tools ==="
	docker run --rm $(IMAGE_NAME):$(PG_VERSION) dpkg -l | grep -E "(barman|pgbackrest)"
	@echo ""
	@echo "=== Image Size ==="
	docker images $(IMAGE_NAME):$(PG_VERSION) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Clean up test containers
.PHONY: clean
clean:
	-docker stop test-pg-vector 2>/dev/null || true
	-docker rm test-pg-vector 2>/dev/null || true
	@echo "✅ Cleaned up test containers"

# Full pipeline: build -> test -> tag
.PHONY: all
all: build test tag
	@echo "✅ Build, test, and tag complete"

# Build with different pgvector version
.PHONY: build-version
build-version:
	@if [ -z "$(VERSION)" ]; then \
		echo "Error: VERSION not set. Usage: make build-version VERSION=0.8.0"; \
		exit 1; \
	fi
	docker build \
		--build-arg PGVECTOR_VERSION=v$(VERSION) \
		-t $(IMAGE_NAME):$(PG_VERSION)-pgvector-$(VERSION) \
		-f $(DOCKERFILE) .
