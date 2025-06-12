# Build stage
FROM python:3.12-slim as builder

# Install system dependencies for building
RUN apt-get update && apt-get install -y \
    gcc \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone devpi repository
COPY devpi /build/devpi

# Install devpi packages
WORKDIR /build/devpi
RUN pip install --no-cache-dir \
    ./common \
    ./server \
    ./web \
    ./client

# Install additional devpi plugins
RUN pip install --no-cache-dir \
    devpi-web

# Production stage
FROM python:3.12-slim as monolith

ARG PORT=3141

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -r devpi && useradd -r -g devpi devpi

# Create directories
RUN mkdir -p /app/data /app/logs && \
    chown -R devpi:devpi /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/devpi* /usr/local/bin/

# Set working directory
WORKDIR /app

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Switch to non-root user
USER devpi

# Expose port
EXPOSE ${PORT}

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/ || exit 1

# Volume for data persistence
VOLUME ["/app/data"]

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]

# Default command with web interface
CMD ["devpi-server", "--host=0.0.0.0", "--port=3141", "--serverdir=/app/data", "--theme=semantic-ui"] 
