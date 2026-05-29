# PostgreSQL Extensions for CloudNativePG
# Single unified Dockerfile (cnpg.dockerfile) built with extension toggles.
#   - Curated bundles (essential/full/postgis/vector) for pre-built registry images
#   - Generic `make build EXTS=pgvector,pg_cron` for on-demand custom combinations
#
# Multi-version: pick the PostgreSQL major with PG_VERSION (default 18). Extension
# pins live in versions/pg<major>.mk so PG-major-locked extensions (pgaudit) and
# version ranges stay correct per release.
#   make full-build PG_VERSION=17

# Variables
IMAGE_NAME := postgres-exts
REGISTRY   := docker.io/scriptonbasestar
DOCKERFILE := cnpg.dockerfile

# Resolve the per-version extension pin matrix
PG_VERSION   ?= 18
SUPPORTED_PG := $(sort $(patsubst versions/pg%.mk,%,$(wildcard versions/pg*.mk)))
VERSION_FILE := versions/pg$(PG_VERSION).mk
ifeq ($(wildcard $(VERSION_FILE)),)
$(error Unsupported PG_VERSION=$(PG_VERSION). Supported: $(SUPPORTED_PG))
endif
include $(VERSION_FILE)

# Curated bundle build-arg sets
ESSENTIAL_ARGS := --build-arg WITH_PGVECTOR=true
FULL_ARGS      := --build-arg WITH_PGVECTOR=true --build-arg WITH_POSTGIS=true \
                  --build-arg WITH_TIMESCALEDB=true --build-arg WITH_PG_CRON=true \
                  --build-arg WITH_PG_REPACK=true --build-arg WITH_PGAUDIT=true \
                  --build-arg WITH_PG_PARTMAN=true
VECTOR_ARGS    := --build-arg WITH_PGVECTOR=true
POSTGIS_ARGS   := --build-arg WITH_PGVECTOR=false --build-arg WITH_POSTGIS=true

# Common build args applied to every image (extension pins from versions/pg$(PG_VERSION).mk)
COMMON_ARGS := --build-arg PG_VERSION=$(PG_VERSION) \
               --build-arg PGVECTOR_VERSION=$(PGVECTOR_VERSION) \
               --build-arg POSTGIS_VERSION=$(POSTGIS_VERSION) \
               --build-arg TIMESCALEDB_VERSION=$(TIMESCALEDB_VERSION) \
               --build-arg PGCRON_VERSION=$(PGCRON_VERSION) \
               --build-arg PGREPACK_VERSION=$(PGREPACK_VERSION) \
               --build-arg PGAUDIT_VERSION=$(PGAUDIT_VERSION) \
               --build-arg PGPARTMAN_VERSION=$(PGPARTMAN_VERSION)

# Local image tags (version-qualified so different PG builds never clobber each other)
ESSENTIAL_LOCAL := $(IMAGE_NAME):$(PG_VERSION)-essential
FULL_LOCAL      := $(IMAGE_NAME):$(PG_VERSION)-full
VECTOR_LOCAL    := $(IMAGE_NAME):$(PG_VERSION)-vector
POSTGIS_LOCAL   := $(IMAGE_NAME):$(PG_VERSION)-postgis

# Registry tags
ESSENTIAL_TAG := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-essential
FULL_TAG      := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-full
VECTOR_TAG    := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-vector
POSTGIS_TAG   := $(REGISTRY)/$(IMAGE_NAME):$(PG_VERSION)-postgis

PLATFORMS := linux/amd64,linux/arm64

# Extra tags pushed alongside the canonical registry tag by the *-buildx targets
# (e.g. CD passes an immutable version tag like :18-full-1.2.3). Space-separated.
EXTRA_TAGS ?=

.PHONY: help
help:
	@echo "PostgreSQL Extensions — unified build (cnpg.dockerfile)"
	@echo ""
	@echo "Version selection:"
	@echo "  make <target> PG_VERSION=17        - target a PostgreSQL major (supported: $(SUPPORTED_PG))"
	@echo "  make versions                      - show resolved extension pins for PG_VERSION"
	@echo ""
	@echo "Generic (on-demand custom combination):"
	@echo "  make build EXTS=pgvector,pg_cron   - Build only the listed extensions"
	@echo "      Available: pgvector postgis timescaledb pg_cron pg_repack pgaudit pg_partman"
	@echo ""
	@echo "Curated bundles (pre-built registry images):"
	@echo "  make essential-build   - pgvector + built-ins (lightweight)"
	@echo "  make full-build        - all 7 extensions"
	@echo "  make vector-build      - pgvector only (legacy alias)"
	@echo "  make postgis-build     - PostGIS only (geospatial)"
	@echo "  make build-all         - build all curated bundles"
	@echo ""
	@echo "Test / push / multi-arch:"
	@echo "  make <bundle>-test     - run extension smoke tests"
	@echo "  make <bundle>-push     - tag & push to registry"
	@echo "  make <bundle>-buildx   - multi-arch build & push ($(PLATFORMS))"
	@echo "  make buildx-all        - multi-arch build & push all bundles"
	@echo ""
	@echo "Utility:"
	@echo "  make verify            - list extensions in built images"
	@echo "  make clean             - remove test containers"
	@echo ""
	@echo "Current: PG=$(PG_VERSION) pgvector=$(PGVECTOR_VERSION) postgis=$(POSTGIS_VERSION) pgaudit=$(PGAUDIT_VERSION)"

.PHONY: versions
versions:
	@echo "PG_VERSION=$(PG_VERSION)  (supported: $(SUPPORTED_PG))"
	@echo "  pgvector    = $(PGVECTOR_VERSION)"
	@echo "  postgis     = $(POSTGIS_VERSION)"
	@echo "  timescaledb = $(TIMESCALEDB_VERSION)"
	@echo "  pg_cron     = $(PGCRON_VERSION)"
	@echo "  pg_repack   = $(PGREPACK_VERSION)"
	@echo "  pgaudit     = $(PGAUDIT_VERSION)"
	@echo "  pg_partman  = $(PGPARTMAN_VERSION)"

# ============================================================================
# Generic on-demand build: pick exactly the extensions you need
# ============================================================================
EXTS ?= pgvector
CUSTOM_TAG ?= $(IMAGE_NAME):$(PG_VERSION)-custom

.PHONY: build
build:
	@args=""; \
	for e in $$(echo "$(EXTS)" | tr ',' ' '); do \
	    case "$$e" in \
	        pgvector)    args="$$args --build-arg WITH_PGVECTOR=true";; \
	        postgis)     args="$$args --build-arg WITH_POSTGIS=true";; \
	        timescaledb) args="$$args --build-arg WITH_TIMESCALEDB=true";; \
	        pg_cron)     args="$$args --build-arg WITH_PG_CRON=true";; \
	        pg_repack)   args="$$args --build-arg WITH_PG_REPACK=true";; \
	        pgaudit)     args="$$args --build-arg WITH_PGAUDIT=true";; \
	        pg_partman)  args="$$args --build-arg WITH_PG_PARTMAN=true";; \
	        *) echo "❌ Unknown extension: $$e"; exit 1;; \
	    esac; \
	done; \
	echo "Building $(CUSTOM_TAG) with: $(EXTS)"; \
	docker build --build-arg WITH_PGVECTOR=false $$args $(COMMON_ARGS) \
	    -t $(CUSTOM_TAG) -f $(DOCKERFILE) .
	@echo "✅ Custom image built: $(CUSTOM_TAG)"

# ============================================================================
# Curated bundle: Essential (lightweight)
# ============================================================================
.PHONY: essential-build
essential-build:
	docker build $(ESSENTIAL_ARGS) $(COMMON_ARGS) -t $(ESSENTIAL_LOCAL) -f $(DOCKERFILE) .
	@echo "✅ Essential image built: $(ESSENTIAL_LOCAL)"

.PHONY: essential-test
essential-test:
	@echo "=== Testing Essential Image (PG $(PG_VERSION)) ==="
	docker run --rm $(ESSENTIAL_LOCAL) postgres --version
	@set -e; \
	c=test-pg-essential-$(PG_VERSION); \
	trap "docker rm -f $$c >/dev/null 2>&1 || true" EXIT; \
	docker run -d --name $$c -e POSTGRES_PASSWORD=test123 $(ESSENTIAL_LOCAL); \
	sleep 5; \
	docker exec $$c psql -U postgres -c "CREATE EXTENSION vector; CREATE EXTENSION pg_stat_statements; CREATE EXTENSION pg_trgm; CREATE EXTENSION hstore; SELECT extname FROM pg_extension;"; \
	docker exec $$c psql -U postgres -c "CREATE TABLE items (id serial, embedding vector(3)); INSERT INTO items (embedding) VALUES ('[1,2,3]'),('[4,5,6]'); SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 1;"
	@echo "✅ Essential image tests passed!"

.PHONY: essential-push
essential-push:
	docker tag $(ESSENTIAL_LOCAL) $(ESSENTIAL_TAG)
	docker push $(ESSENTIAL_TAG)
	@echo "✅ Essential image pushed to $(ESSENTIAL_TAG)"

.PHONY: essential-buildx
essential-buildx:
	docker buildx build --platform $(PLATFORMS) $(ESSENTIAL_ARGS) $(COMMON_ARGS) \
	    -t $(ESSENTIAL_TAG) $(addprefix -t ,$(EXTRA_TAGS)) --push -f $(DOCKERFILE) .
	@echo "✅ Essential multi-arch build pushed"

# ============================================================================
# Curated bundle: Full (all extensions)
# ============================================================================
.PHONY: full-build
full-build:
	docker build $(FULL_ARGS) $(COMMON_ARGS) -t $(FULL_LOCAL) -f $(DOCKERFILE) .
	@echo "✅ Full image built: $(FULL_LOCAL)"

.PHONY: full-test
full-test:
	@echo "=== Testing Full Extensions Image (PG $(PG_VERSION)) ==="
	docker run --rm $(FULL_LOCAL) postgres --version
	@set -e; \
	c=test-pg-full-$(PG_VERSION); \
	trap "docker rm -f $$c >/dev/null 2>&1 || true" EXIT; \
	docker run -d --name $$c -e POSTGRES_PASSWORD=test123 $(FULL_LOCAL); \
	sleep 10; \
	docker exec $$c psql -U postgres -c "CREATE EXTENSION vector; CREATE EXTENSION postgis; CREATE EXTENSION timescaledb; CREATE EXTENSION pg_cron; CREATE EXTENSION pgaudit; CREATE EXTENSION pg_stat_statements; CREATE EXTENSION pg_partman; SELECT extname FROM pg_extension ORDER BY extname;"; \
	docker exec $$c psql -U postgres -c "SELECT PostGIS_Version();"; \
	docker exec $$c psql -U postgres -c "CREATE TABLE metrics (time TIMESTAMPTZ NOT NULL, value DOUBLE PRECISION); SELECT create_hypertable('metrics', 'time');"
	@echo "✅ Full image tests passed!"

.PHONY: full-push
full-push:
	docker tag $(FULL_LOCAL) $(FULL_TAG)
	docker push $(FULL_TAG)
	@echo "✅ Full image pushed to $(FULL_TAG)"

.PHONY: full-buildx
full-buildx:
	docker buildx build --platform $(PLATFORMS) $(FULL_ARGS) $(COMMON_ARGS) \
	    -t $(FULL_TAG) $(addprefix -t ,$(EXTRA_TAGS)) --push -f $(DOCKERFILE) .
	@echo "✅ Full multi-arch build pushed"

# ============================================================================
# Curated bundle: Vector-only (legacy alias)
# ============================================================================
.PHONY: vector-build
vector-build:
	docker build $(VECTOR_ARGS) $(COMMON_ARGS) -t $(VECTOR_LOCAL) -f $(DOCKERFILE) .
	@echo "✅ Vector-only image built: $(VECTOR_LOCAL)"

.PHONY: vector-test
vector-test:
	@echo "=== Testing Vector-Only Image (PG $(PG_VERSION)) ==="
	docker run --rm $(VECTOR_LOCAL) postgres --version
	@set -e; \
	c=test-pg-vector-$(PG_VERSION); \
	trap "docker rm -f $$c >/dev/null 2>&1 || true" EXIT; \
	docker run -d --name $$c -e POSTGRES_PASSWORD=test123 $(VECTOR_LOCAL); \
	sleep 5; \
	docker exec $$c psql -U postgres -c "CREATE EXTENSION vector; CREATE TABLE items (id serial, embedding vector(3)); INSERT INTO items (embedding) VALUES ('[1,2,3]'); SELECT * FROM items;"
	@echo "✅ Vector-only image tests passed!"

.PHONY: vector-push
vector-push:
	docker tag $(VECTOR_LOCAL) $(VECTOR_TAG)
	docker push $(VECTOR_TAG)
	@echo "✅ Vector-only image pushed to $(VECTOR_TAG)"

# ============================================================================
# Curated bundle: PostGIS-only (geospatial)
# ============================================================================
.PHONY: postgis-build
postgis-build:
	docker build $(POSTGIS_ARGS) $(COMMON_ARGS) -t $(POSTGIS_LOCAL) -f $(DOCKERFILE) .
	@echo "✅ PostGIS-only image built: $(POSTGIS_LOCAL)"

.PHONY: postgis-test
postgis-test:
	@echo "=== Testing PostGIS-Only Image (PG $(PG_VERSION)) ==="
	docker run --rm $(POSTGIS_LOCAL) postgres --version
	@set -e; \
	c=test-pg-postgis-$(PG_VERSION); \
	trap "docker rm -f $$c >/dev/null 2>&1 || true" EXIT; \
	docker run -d --name $$c -e POSTGRES_PASSWORD=test123 $(POSTGIS_LOCAL); \
	sleep 5; \
	docker exec $$c psql -U postgres -c "CREATE EXTENSION postgis; SELECT PostGIS_Version();"; \
	docker exec $$c psql -U postgres -c "CREATE EXTENSION postgis_topology; SELECT topology.CreateTopology('test_topo', 4326);"; \
	docker exec $$c psql -U postgres -c "CREATE TABLE locations (id serial, geom GEOMETRY(Point, 4326)); INSERT INTO locations (geom) VALUES (ST_SetSRID(ST_MakePoint(127.0, 37.5), 4326)); SELECT id, ST_AsText(geom) FROM locations;"
	@echo "✅ PostGIS-only image tests passed!"

.PHONY: postgis-push
postgis-push:
	docker tag $(POSTGIS_LOCAL) $(POSTGIS_TAG)
	docker push $(POSTGIS_TAG)
	@echo "✅ PostGIS-only image pushed to $(POSTGIS_TAG)"

.PHONY: postgis-buildx
postgis-buildx:
	docker buildx build --platform $(PLATFORMS) $(POSTGIS_ARGS) $(COMMON_ARGS) \
	    -t $(POSTGIS_TAG) $(addprefix -t ,$(EXTRA_TAGS)) --push -f $(DOCKERFILE) .
	@echo "✅ PostGIS-only multi-arch build pushed"

# ============================================================================
# Batch operations
# ============================================================================
.PHONY: build-all
build-all: essential-build full-build vector-build postgis-build
	@echo "✅ All curated bundles built"

.PHONY: test-all
test-all: essential-test full-test vector-test postgis-test
	@echo "✅ All tests passed"

.PHONY: push-all
push-all: essential-push full-push vector-push postgis-push
	@echo "✅ All images pushed"

.PHONY: buildx-all
buildx-all: essential-buildx full-buildx postgis-buildx
	@echo "✅ All multi-arch builds pushed"

# ============================================================================
# Utility targets
# ============================================================================
.PHONY: verify
verify:
	@for v in essential full postgis; do \
	    echo "=== $(PG_VERSION)-$$v image ==="; \
	    docker run --rm $(IMAGE_NAME):$(PG_VERSION)-$$v sh -c "ls /usr/share/postgresql/$(PG_VERSION)/extension/*.control | xargs -n1 basename | sed 's/\.control//'" 2>/dev/null || echo "Image not built"; \
	    echo ""; \
	done
	@echo "=== Image sizes ==="
	@docker images $(IMAGE_NAME) --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

.PHONY: clean
clean:
	-docker stop test-pg-essential-$(PG_VERSION) test-pg-full-$(PG_VERSION) test-pg-vector-$(PG_VERSION) test-pg-postgis-$(PG_VERSION) 2>/dev/null || true
	-docker rm test-pg-essential-$(PG_VERSION) test-pg-full-$(PG_VERSION) test-pg-vector-$(PG_VERSION) test-pg-postgis-$(PG_VERSION) 2>/dev/null || true
	@echo "✅ Cleaned up test containers"

.PHONY: clean-images
clean-images:
	-docker rmi $(ESSENTIAL_LOCAL) $(FULL_LOCAL) $(VECTOR_LOCAL) $(POSTGIS_LOCAL) $(CUSTOM_TAG) 2>/dev/null || true
	@echo "✅ Cleaned up local images"
