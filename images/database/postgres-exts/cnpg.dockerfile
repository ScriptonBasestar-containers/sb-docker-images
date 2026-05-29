# Unified PostgreSQL Extensions image for CloudNativePG
#
# Single Dockerfile that builds ANY combination of extensions via build args.
# Enable only what you need with --build-arg WITH_<ext>=true.
#
# Example:
#   docker build --build-arg WITH_PGVECTOR=true --build-arg WITH_PG_CRON=true \
#                -f cnpg.dockerfile -t postgres-exts:custom .
#
# The Makefile wraps this with curated bundles (essential/full/postgis/vector)
# and a generic `make build EXTS=pgvector,pg_cron` target.

ARG PG_VERSION=18
FROM postgres:${PG_VERSION} AS base
ARG TARGETARCH

# ============================================================================
# Builder stage: compile only the enabled extensions
# ============================================================================
FROM base AS builder
ARG PG_VERSION=18
ARG TARGETARCH

# Extension toggles (default: pgvector only — the most common case)
ARG WITH_PGVECTOR=true
ARG WITH_POSTGIS=false
ARG WITH_TIMESCALEDB=false
ARG WITH_PG_CRON=false
ARG WITH_PG_REPACK=false
ARG WITH_PGAUDIT=false
ARG WITH_PG_PARTMAN=false

# Pinned extension versions (defaults track the default PG_VERSION=18; the Makefile
# overrides these per-major from versions/pg<major>.mk)
ARG PGVECTOR_VERSION=v0.8.2
ARG POSTGIS_VERSION=3.6.1
ARG TIMESCALEDB_VERSION=2.27.1
ARG PGCRON_VERSION=v1.6.7
ARG PGREPACK_VERSION=1.5.3
ARG PGAUDIT_VERSION=18.0
ARG PGPARTMAN_VERSION=v5.4.3

RUN echo "Building PostgreSQL ${PG_VERSION} extensions for arch: ${TARGETARCH:-unknown}"

# Common build dependencies (shared by every extension)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        ca-certificates \
        wget \
        libssl-dev \
        libkrb5-dev \
        postgresql-server-dev-${PG_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# Staging dir for optional binaries (e.g. pg_repack) so the final COPY is uniform
RUN mkdir -p /extensions-bin

# 1. pgvector — AI/ML vector embeddings
RUN if [ "$WITH_PGVECTOR" = "true" ]; then \
        cd /tmp && \
        git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git && \
        cd pgvector && make clean && make OPTFLAGS="" && make install && \
        cd / && rm -rf /tmp/pgvector; \
    fi

# 2. PostGIS — geospatial (built from source for native amd64/arm64)
RUN if [ "$WITH_POSTGIS" = "true" ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
            autoconf automake libtool \
            libgeos-dev libproj-dev libgdal-dev \
            libjson-c-dev libxml2-dev libprotobuf-c-dev protobuf-c-compiler && \
        cd /tmp && \
        git clone --depth 1 --branch ${POSTGIS_VERSION} https://github.com/postgis/postgis.git && \
        cd postgis && ./autogen.sh && \
        cp /usr/share/automake-*/config.guess /usr/share/automake-*/config.sub /usr/share/automake-*/install-sh build-aux/ && \
        ./configure --with-pgconfig=/usr/lib/postgresql/${PG_VERSION}/bin/pg_config && \
        make && make install && \
        cd / && rm -rf /tmp/postgis /var/lib/apt/lists/*; \
    fi

# 3. TimescaleDB — time-series
RUN if [ "$WITH_TIMESCALEDB" = "true" ]; then \
        cd /tmp && \
        git clone --branch ${TIMESCALEDB_VERSION} https://github.com/timescale/timescaledb.git && \
        cd timescaledb && ./bootstrap -DREGRESS_CHECKS=OFF && \
        cd build && make && make install && \
        cd / && rm -rf /tmp/timescaledb; \
    fi

# 4. pg_cron — database job scheduler
RUN if [ "$WITH_PG_CRON" = "true" ]; then \
        cd /tmp && \
        git clone --branch ${PGCRON_VERSION} https://github.com/citusdata/pg_cron.git && \
        cd pg_cron && make && make install && \
        cd / && rm -rf /tmp/pg_cron; \
    fi

# 5. pg_repack — online table reorganization (ships a client binary)
#    PG18+ pg_config exports -lcurl/-lnuma (PGDG builds with --with-libcurl/--with-libnuma),
#    so the client link needs libcurl/libnuma dev headers in addition to readline/zlib.
RUN if [ "$WITH_PG_REPACK" = "true" ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
            libreadline-dev zlib1g-dev libcurl4-openssl-dev libnuma-dev && \
        cd /tmp && \
        git clone --branch ver_${PGREPACK_VERSION} https://github.com/reorg/pg_repack.git && \
        cd pg_repack && make && make install && \
        cp /usr/lib/postgresql/${PG_VERSION}/bin/pg_repack /extensions-bin/ && \
        cd / && rm -rf /tmp/pg_repack /var/lib/apt/lists/*; \
    fi

# 6. pgAudit — security audit logging
RUN if [ "$WITH_PGAUDIT" = "true" ]; then \
        cd /tmp && \
        git clone --branch ${PGAUDIT_VERSION} https://github.com/pgaudit/pgaudit.git && \
        cd pgaudit && make USE_PGXS=1 && make USE_PGXS=1 install && \
        cd / && rm -rf /tmp/pgaudit; \
    fi

# 7. pg_partman — automatic partition management
RUN if [ "$WITH_PG_PARTMAN" = "true" ]; then \
        cd /tmp && \
        git clone --branch ${PGPARTMAN_VERSION} https://github.com/pgpartman/pg_partman.git && \
        cd pg_partman && make && make install && \
        cd / && rm -rf /tmp/pg_partman; \
    fi

# ============================================================================
# Final stage: clean runtime image
# ============================================================================
FROM base
ARG PG_VERSION=18
ARG WITH_PGVECTOR=true
ARG WITH_POSTGIS=false
ARG WITH_TIMESCALEDB=false
ARG WITH_PG_CRON=false
ARG WITH_PGAUDIT=false

# Copy compiled extensions and optional binaries from builder
COPY --from=builder /usr/lib/postgresql/${PG_VERSION}/lib/*.so /usr/lib/postgresql/${PG_VERSION}/lib/
COPY --from=builder /usr/share/postgresql/${PG_VERSION}/extension/ /usr/share/postgresql/${PG_VERSION}/extension/
COPY --from=builder /extensions-bin/ /usr/lib/postgresql/${PG_VERSION}/bin/

# CloudNativePG runtime utilities (always required by the operator)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        barman-cli \
        pgbackrest \
        postgresql-client \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# PostGIS runtime libraries (only when PostGIS is enabled)
RUN if [ "$WITH_POSTGIS" = "true" ]; then \
        apt-get update && \
        apt-get install -y --no-install-recommends \
            libgeos-c1* libproj2* libgdal3* libjson-c* libxml2 libprotobuf-c1 && \
        rm -rf /var/lib/apt/lists/*; \
    fi

# Build shared_preload_libraries from the enabled extensions
RUN PRELOAD="pg_stat_statements"; \
    if [ "$WITH_PGVECTOR" = "true" ]; then PRELOAD="vector,$PRELOAD"; fi; \
    if [ "$WITH_TIMESCALEDB" = "true" ]; then PRELOAD="$PRELOAD,timescaledb"; fi; \
    if [ "$WITH_PG_CRON" = "true" ]; then PRELOAD="$PRELOAD,pg_cron"; fi; \
    if [ "$WITH_PGAUDIT" = "true" ]; then PRELOAD="$PRELOAD,pgaudit"; fi; \
    { \
        echo ""; \
        echo "# Extension preloading (generated at build time)"; \
        echo "shared_preload_libraries = '$PRELOAD'"; \
        echo "pg_stat_statements.track = all"; \
        if [ "$WITH_PG_CRON" = "true" ]; then echo "cron.database_name = 'postgres'"; fi; \
        if [ "$WITH_TIMESCALEDB" = "true" ]; then echo "timescaledb.max_background_workers = 8"; fi; \
        if [ "$WITH_PGAUDIT" = "true" ]; then echo "pgaudit.log = 'write, ddl'"; fi; \
    } >> /usr/share/postgresql/postgresql.conf.sample

# Verify the enabled extensions are present
RUN set -eux; \
    pg_config --version; \
    echo "=== Installed extension control files ==="; \
    ls /usr/share/postgresql/${PG_VERSION}/extension/*.control | xargs -n1 basename | sed 's/\.control//'

LABEL org.opencontainers.image.title="PostgreSQL with Extensions for CloudNativePG" \
      org.opencontainers.image.description="PostgreSQL with a build-arg-selectable set of extensions, compatible with CloudNativePG" \
      org.opencontainers.image.vendor="ScriptonBaseStar"

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD pg_isready -U postgres || exit 1

USER postgres
