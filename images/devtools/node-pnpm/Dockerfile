# Node.js with pnpm - Debian variant
# Multi-arch: amd64, arm64
ARG NODE_VERSION=22

FROM node:${NODE_VERSION}-bookworm-slim
LABEL maintainer="archmagece@gmail.com"
LABEL org.opencontainers.image.title="node-pnpm"
LABEL org.opencontainers.image.description="Node.js with pnpm package manager"
LABEL org.opencontainers.image.source="https://github.com/scriptonbasestar/sb-docker-images"

ARG PNPM_VERSION=9
ARG TINI_VERSION=v0.19.0

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install tini for proper signal handling
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Install pnpm globally via corepack
RUN corepack enable && corepack prepare pnpm@${PNPM_VERSION} --activate

# Verify installations
RUN node --version && pnpm --version

# Set pnpm store directory
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN mkdir -p /pnpm

# Create workspace directory
WORKDIR /app

ENTRYPOINT ["/tini", "--"]
CMD ["node"]
