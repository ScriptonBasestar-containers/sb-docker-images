# CloudNativePG-compatible PostgreSQL with pgvector and extensible architecture
# Base: Official PostgreSQL 16
FROM postgres:16 AS base

# Build stage: Compile extensions
FROM base AS builder

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        ca-certificates \
        postgresql-server-dev-16 && \
    rm -rf /var/lib/apt/lists/*

# Build pgvector
ARG PGVECTOR_VERSION=v0.7.4
RUN cd /tmp && \
    git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make clean && \
    make OPTFLAGS="" && \
    make install && \
    cd / && \
    rm -rf /tmp/pgvector

# Build pg_cron (optional, uncomment if needed)
# ARG PGCRON_VERSION=v1.6.2
# RUN cd /tmp && \
#     git clone --branch ${PGCRON_VERSION} https://github.com/citusdata/pg_cron.git && \
#     cd pg_cron && \
#     make && \
#     make install && \
#     cd / && \
#     rm -rf /tmp/pg_cron

# Build timescaledb (optional, uncomment if needed)
# ARG TIMESCALEDB_VERSION=2.14.2
# RUN cd /tmp && \
#     git clone --branch ${TIMESCALEDB_VERSION} https://github.com/timescale/timescaledb.git && \
#     cd timescaledb && \
#     ./bootstrap && \
#     cd build && make && make install && \
#     cd / && \
#     rm -rf /tmp/timescaledb

# Final stage: Clean runtime image
FROM base

# Copy compiled extensions from builder
COPY --from=builder /usr/lib/postgresql/16/lib/*.so /usr/lib/postgresql/16/lib/
COPY --from=builder /usr/share/postgresql/16/extension/* /usr/share/postgresql/16/extension/

# CloudNativePG requires these utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        barman-cli \
        pgbackrest \
        postgresql-client \
        curl \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Verify extensions are available
RUN set -eux; \
    pg_config --version; \
    ls -lh /usr/lib/postgresql/16/lib/vector.so; \
    ls -lh /usr/share/postgresql/16/extension/vector*

# Set recommended PostgreSQL settings for vector operations
RUN echo "shared_preload_libraries = 'vector'" >> /usr/share/postgresql/postgresql.conf.sample

# Labels for tracking
LABEL org.opencontainers.image.title="PostgreSQL with pgvector for CloudNativePG" \
      org.opencontainers.image.description="PostgreSQL 16 with pgvector extension, compatible with CloudNativePG operator" \
      org.opencontainers.image.version="16-pgvector-${PGVECTOR_VERSION}" \
      org.opencontainers.image.vendor="ScriptonBaseStar" \
      pgvector.version="${PGVECTOR_VERSION}"

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD pg_isready -U postgres || exit 1

USER postgres
