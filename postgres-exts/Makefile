# PostgreSQL Extensions for CloudNativePG
# Build multi-architecture images with various extension combinations

# Variables
IMAGE_NAME := postgres-exts
REGISTRY := docker.io/scriptonbasestar
PG_VERSION := 16
PGVECTOR_VERSION := 0.7.4

# Image variants
ESSENTIAL_TAG := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-essential
FULL_TAG := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-full
VECTOR_TAG := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-vector

# Default target
.PHONY: help
help:
	@echo "PostgreSQL Extensions build targets:"
	@echo ""
	@echo "Build targets:"
	@echo "  make essential-build  - Build Essential image (pgvector + built-ins)"
	@echo "  make full-build       - Build Full image (all extensions)"
	@echo "  make vector-build     - Build Vector-only image (legacy)"
	@echo "  make build-all        - Build all variants"
	@echo ""
	@echo "Test targets:"
	@echo "  make essential-test   - Test Essential image"
	@echo "  make full-test        - Test Full image"
	@echo "  make vector-test      - Test Vector-only image"
	@echo ""
	@echo "Registry targets:"
	@echo "  make essential-push   - Push Essential to registry"
	@echo "  make full-push        - Push Full to registry"
	@echo "  make push-all         - Push all variants"
	@echo ""
	@echo "Multi-arch targets:"
	@echo "  make essential-buildx - Build & push Essential (amd64, arm64)"
	@echo "  make full-buildx      - Build & push Full (amd64, arm64)"
	@echo "  make buildx-all       - Build & push all (amd64, arm64)"
	@echo ""
	@echo "Utility targets:"
	@echo "  make verify           - Verify image contents"
	@echo "  make clean            - Remove test containers"
	@echo ""
	@echo "Current settings:"
	@echo "  Registry: $(REGISTRY)"
	@echo "  Essential: $(ESSENTIAL_TAG)"
	@echo "  Full: $(FULL_TAG)"
	@echo "  Vector: $(VECTOR_TAG)"

# ============================================================================
# Essential Image (Lightweight)
# ============================================================================

.PHONY: essential-build
essential-build:
	docker build \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(IMAGE_NAME):essential \
		-f cnpg-essential.dockerfile .
	@echo "✅ Essential image built: $(IMAGE_NAME):essential"

.PHONY: essential-test
essential-test:
	@echo "=== Testing Essential Image ==="
	@echo "Testing PostgreSQL version..."
	docker run --rm $(IMAGE_NAME):essential postgres --version
	@echo ""
	@echo "Starting PostgreSQL..."
	docker run -d --name test-pg-essential -e POSTGRES_PASSWORD=test123 $(IMAGE_NAME):essential
	@sleep 5
	@echo ""
	@echo "Testing pgvector..."
	docker exec test-pg-essential psql -U postgres -c "CREATE EXTENSION vector; SELECT * FROM pg_available_extensions WHERE name = 'vector';"
	@echo ""
	@echo "Testing built-in extensions..."
	docker exec test-pg-essential psql -U postgres -c "CREATE EXTENSION pg_stat_statements; CREATE EXTENSION pg_trgm; CREATE EXTENSION hstore; SELECT extname FROM pg_extension;"
	@echo ""
	@echo "Testing vector operations..."
	docker exec test-pg-essential psql -U postgres -c "CREATE TABLE items (id serial, embedding vector(3)); INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]'); SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 1;"
	docker stop test-pg-essential
	docker rm test-pg-essential
	@echo "✅ Essential image tests passed!"

.PHONY: essential-push
essential-push:
	docker tag $(IMAGE_NAME):essential $(ESSENTIAL_TAG)
	docker push $(ESSENTIAL_TAG)
	@echo "✅ Essential image pushed to $(ESSENTIAL_TAG)"

.PHONY: essential-buildx
essential-buildx:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(ESSENTIAL_TAG) \
		--push \
		-f cnpg-essential.dockerfile .
	@echo "✅ Essential multi-arch build pushed"

# ============================================================================
# Full Extensions Image
# ============================================================================

.PHONY: full-build
full-build:
	docker build \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(IMAGE_NAME):full \
		-f cnpg-extensions.dockerfile .
	@echo "✅ Full image built: $(IMAGE_NAME):full"

.PHONY: full-test
full-test:
	@echo "=== Testing Full Extensions Image ==="
	@echo "Testing PostgreSQL version..."
	docker run --rm $(IMAGE_NAME):full postgres --version
	@echo ""
	@echo "Starting PostgreSQL..."
	docker run -d --name test-pg-full -e POSTGRES_PASSWORD=test123 $(IMAGE_NAME):full
	@sleep 10
	@echo ""
	@echo "Testing all extensions..."
	docker exec test-pg-full psql -U postgres -c " \
		CREATE EXTENSION vector; \
		CREATE EXTENSION postgis; \
		CREATE EXTENSION timescaledb; \
		CREATE EXTENSION pg_cron; \
		CREATE EXTENSION pgaudit; \
		CREATE EXTENSION pg_stat_statements; \
		CREATE EXTENSION pg_partman; \
		SELECT extname FROM pg_extension ORDER BY extname; \
	"
	@echo ""
	@echo "Testing vector operations..."
	docker exec test-pg-full psql -U postgres -c "CREATE TABLE items (id serial, embedding vector(3)); INSERT INTO items (embedding) VALUES ('[1,2,3]'); SELECT * FROM items;"
	@echo ""
	@echo "Testing PostGIS..."
	docker exec test-pg-full psql -U postgres -c "SELECT PostGIS_Version();"
	@echo ""
	@echo "Testing TimescaleDB..."
	docker exec test-pg-full psql -U postgres -c "CREATE TABLE metrics (time TIMESTAMPTZ NOT NULL, value DOUBLE PRECISION); SELECT create_hypertable('metrics', 'time');"
	docker stop test-pg-full
	docker rm test-pg-full
	@echo "✅ Full image tests passed!"

.PHONY: full-push
full-push:
	docker tag $(IMAGE_NAME):full $(FULL_TAG)
	docker push $(FULL_TAG)
	@echo "✅ Full image pushed to $(FULL_TAG)"

.PHONY: full-buildx
full-buildx:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(FULL_TAG) \
		--push \
		-f cnpg-extensions.dockerfile .
	@echo "✅ Full multi-arch build pushed"

# ============================================================================
# Vector-Only Image (Legacy)
# ============================================================================

.PHONY: vector-build
vector-build:
	docker build \
		--build-arg PGVECTOR_VERSION=v$(PGVECTOR_VERSION) \
		-t $(IMAGE_NAME):vector \
		-f cnpg-vector.dockerfile .
	@echo "✅ Vector-only image built: $(IMAGE_NAME):vector"

.PHONY: vector-test
vector-test:
	@echo "=== Testing Vector-Only Image ==="
	docker run --rm $(IMAGE_NAME):vector postgres --version
	docker run -d --name test-pg-vector -e POSTGRES_PASSWORD=test123 $(IMAGE_NAME):vector
	@sleep 5
	docker exec test-pg-vector psql -U postgres -c "CREATE EXTENSION vector; CREATE TABLE items (id serial, embedding vector(3)); INSERT INTO items (embedding) VALUES ('[1,2,3]'); SELECT * FROM items;"
	docker stop test-pg-vector
	docker rm test-pg-vector
	@echo "✅ Vector-only image tests passed!"

.PHONY: vector-push
vector-push:
	docker tag $(IMAGE_NAME):vector $(VECTOR_TAG)
	docker push $(VECTOR_TAG)
	@echo "✅ Vector-only image pushed to $(VECTOR_TAG)"

# ============================================================================
# Batch Operations
# ============================================================================

.PHONY: build-all
build-all: essential-build full-build vector-build
	@echo "✅ All images built"

.PHONY: test-all
test-all: essential-test full-test vector-test
	@echo "✅ All tests passed"

.PHONY: push-all
push-all: essential-push full-push vector-push
	@echo "✅ All images pushed"

.PHONY: buildx-all
buildx-all: essential-buildx full-buildx
	@echo "✅ All multi-arch builds pushed"

# ============================================================================
# Utility Targets
# ============================================================================

.PHONY: verify
verify:
	@echo "=== Essential Image ==="
	@docker run --rm $(IMAGE_NAME):essential sh -c "ls /usr/share/postgresql/16/extension/*.control | xargs -n1 basename | sed 's/\.control//'" 2>/dev/null || echo "Image not built"
	@echo ""
	@echo "=== Full Image ==="
	@docker run --rm $(IMAGE_NAME):full sh -c "ls /usr/share/postgresql/16/extension/*.control | xargs -n1 basename | sed 's/\.control//'" 2>/dev/null || echo "Image not built"
	@echo ""
	@echo "=== Image Sizes ==="
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

.PHONY: clean
clean:
	-docker stop test-pg-essential test-pg-full test-pg-vector 2>/dev/null || true
	-docker rm test-pg-essential test-pg-full test-pg-vector 2>/dev/null || true
	@echo "✅ Cleaned up test containers"

.PHONY: clean-images
clean-images:
	-docker rmi $(IMAGE_NAME):essential $(IMAGE_NAME):full $(IMAGE_NAME):vector 2>/dev/null || true
	@echo "✅ Cleaned up local images"
