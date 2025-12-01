# PostgreSQL with Essential Extensions for CloudNativePG
# Base: Official PostgreSQL 16
# Extensions: pgvector, PostGIS, TimescaleDB, pg_cron, pg_repack, pgAudit
FROM postgres:16 AS base

# Enable multi-architecture support
ARG TARGETARCH

# Build stage: Compile extensions
FROM base AS builder

# Re-declare TARGETARCH for this stage
ARG TARGETARCH

# Log build architecture
RUN echo "Building PostgreSQL extensions for architecture: ${TARGETARCH:-unknown}"

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        ca-certificates \
        wget \
        libssl-dev \
        libkrb5-dev \
        postgresql-server-dev-16 \
        # PostGIS dependencies
        libgeos-dev \
        libproj-dev \
        libgdal-dev \
        libjson-c-dev \
        libxml2-dev \
        libprotobuf-c-dev \
        protobuf-c-compiler && \
    rm -rf /var/lib/apt/lists/*

# 1. pgvector - AI/ML Vector Embeddings ⭐
ARG PGVECTOR_VERSION=v0.7.4
RUN cd /tmp && \
    git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make clean && \
    make OPTFLAGS="" && \
    make install && \
    cd / && \
    rm -rf /tmp/pgvector

# 2. PostGIS - Geospatial Data 🗺️
ARG POSTGIS_VERSION=3.5.1
RUN cd /tmp && \
    wget https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz && \
    tar xzf postgis-${POSTGIS_VERSION}.tar.gz && \
    cd postgis-${POSTGIS_VERSION} && \
    ./configure --with-pgconfig=/usr/lib/postgresql/16/bin/pg_config && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/postgis-${POSTGIS_VERSION}*

# 3. TimescaleDB - Time-Series Data 📈
ARG TIMESCALEDB_VERSION=2.17.2
RUN cd /tmp && \
    git clone --branch ${TIMESCALEDB_VERSION} https://github.com/timescale/timescaledb.git && \
    cd timescaledb && \
    ./bootstrap -DREGRESS_CHECKS=OFF && \
    cd build && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/timescaledb

# 4. pg_cron - Database Scheduler ⏰
ARG PGCRON_VERSION=v1.6.4
RUN cd /tmp && \
    git clone --branch ${PGCRON_VERSION} https://github.com/citusdata/pg_cron.git && \
    cd pg_cron && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pg_cron

# 5. pg_repack - Online Table Reorganization ⚡
ARG PGREPACK_VERSION=1.5.1
RUN cd /tmp && \
    git clone --branch ver_${PGREPACK_VERSION} https://github.com/reorg/pg_repack.git && \
    cd pg_repack && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pg_repack

# 6. pgAudit - Security Audit Logging 🔒
ARG PGAUDIT_VERSION=16.0
RUN cd /tmp && \
    git clone --branch ${PGAUDIT_VERSION} https://github.com/pgaudit/pgaudit.git && \
    cd pgaudit && \
    make USE_PGXS=1 && \
    make USE_PGXS=1 install && \
    cd / && \
    rm -rf /tmp/pgaudit

# 7. pg_partman - Automatic Partition Management 📊
ARG PGPARTMAN_VERSION=v5.2.1
RUN cd /tmp && \
    git clone --branch ${PGPARTMAN_VERSION} https://github.com/pgpartman/pg_partman.git && \
    cd pg_partman && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pg_partman

# Final stage: Clean runtime image
FROM base

# Copy compiled extensions from builder
COPY --from=builder /usr/lib/postgresql/16/lib/*.so /usr/lib/postgresql/16/lib/
COPY --from=builder /usr/share/postgresql/16/extension/* /usr/share/postgresql/16/extension/
COPY --from=builder /usr/lib/postgresql/16/bin/pg_repack /usr/lib/postgresql/16/bin/

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # CloudNativePG requirements
        barman-cli \
        pgbackrest \
        postgresql-client \
        curl \
        ca-certificates \
        # PostGIS runtime (wildcard patterns for multi-arch compatibility)
        libgeos-c1* \
        libproj2* \
        libgdal3* \
        libjson-c* \
        libxml2 \
        libprotobuf-c1 && \
    rm -rf /var/lib/apt/lists/*

# Verify extensions are available
RUN set -eux; \
    pg_config --version; \
    echo "=== Installed Extensions ===" && \
    ls -lh /usr/lib/postgresql/16/lib/*.so | grep -E "(vector|postgis|timescale|cron|repack|audit|partman)" || true && \
    echo "=== Extension Control Files ===" && \
    ls /usr/share/postgresql/16/extension/*.control | xargs -n1 basename | sed 's/\.control//'

# PostgreSQL configuration for extensions
RUN echo "# Extension preloading" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "shared_preload_libraries = 'vector,timescaledb,pg_cron,pg_stat_statements,pgaudit'" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "# pg_cron settings" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "cron.database_name = 'postgres'" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "# TimescaleDB settings" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "timescaledb.max_background_workers = 8" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "# pgAudit settings" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "pgaudit.log = 'write, ddl'" >> /usr/share/postgresql/postgresql.conf.sample

# Labels for tracking
LABEL org.opencontainers.image.title="PostgreSQL with Essential Extensions for CloudNativePG" \
      org.opencontainers.image.description="PostgreSQL 16 with pgvector, PostGIS, TimescaleDB, pg_cron, pg_repack, pgAudit, pg_partman" \
      org.opencontainers.image.version="16-multi-ext" \
      org.opencontainers.image.vendor="ScriptonBaseStar" \
      extensions="pgvector,postgis,timescaledb,pg_cron,pg_repack,pgaudit,pg_partman"

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD pg_isready -U postgres || exit 1

USER postgres
