# PostgreSQL with Essential Extensions (Lightweight)
# Base: Official PostgreSQL 16
# Extensions: pgvector, pg_stat_statements, pg_trgm, hstore (built-in)
FROM postgres:16 AS base

# Build stage: Compile pgvector only
FROM base AS builder

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        git \
        ca-certificates \
        postgresql-server-dev-16 && \
    rm -rf /var/lib/apt/lists/*

# pgvector - AI/ML Vector Embeddings
ARG PGVECTOR_VERSION=v0.7.4
RUN cd /tmp && \
    git clone --branch ${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make clean && \
    make OPTFLAGS="" && \
    make install && \
    cd / && \
    rm -rf /tmp/pgvector

# Final stage: Clean runtime image
FROM base

# Copy compiled pgvector extension
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

# Verify extensions
RUN set -eux; \
    pg_config --version; \
    echo "=== Compiled Extensions ===" && \
    ls -lh /usr/lib/postgresql/16/lib/vector.so && \
    echo "=== Built-in Extensions ===" && \
    ls /usr/share/postgresql/16/extension/*.control | \
    grep -E "(pg_stat_statements|pg_trgm|hstore|btree_gin|btree_gist)" | \
    xargs -n1 basename | sed 's/\.control//' || true

# PostgreSQL configuration
RUN echo "# Essential extensions preloading" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "shared_preload_libraries = 'vector,pg_stat_statements'" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "# pg_stat_statements settings" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "pg_stat_statements.track = all" >> /usr/share/postgresql/postgresql.conf.sample && \
    echo "pg_stat_statements.max = 10000" >> /usr/share/postgresql/postgresql.conf.sample

# Labels
LABEL org.opencontainers.image.title="PostgreSQL with Essential Extensions" \
      org.opencontainers.image.description="PostgreSQL 16 with pgvector + built-in extensions (lightweight)" \
      org.opencontainers.image.version="16-essential" \
      org.opencontainers.image.vendor="ScriptonBaseStar" \
      extensions="pgvector,pg_stat_statements,pg_trgm,hstore"

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD pg_isready -U postgres || exit 1

USER postgres
