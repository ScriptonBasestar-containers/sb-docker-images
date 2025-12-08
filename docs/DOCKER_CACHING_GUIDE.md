# Docker Layer Caching Optimization Guide

**Last Updated**: 2025-12-08
**Status**: Best Practices
**Target**: 20-30% build time reduction

---

## 🎯 Overview

Docker layer caching can significantly reduce build times by reusing previously built layers. This guide provides practical strategies for optimizing Dockerfile layer caching in the sb-docker-images project.

### Benefits

- ⚡ **20-30% faster builds** in development
- 💰 **Lower CI/CD costs** (less compute time)
- 🚀 **Faster iteration cycles** for developers
- 📉 **Reduced bandwidth usage** (smaller layer downloads)

---

## 📋 Quick Reference

### Caching Best Practices Checklist

- ✅ Order layers from least to most frequently changing
- ✅ Use multi-stage builds to separate build dependencies
- ✅ Leverage BuildKit cache mounts for package managers
- ✅ Combine related RUN commands to reduce layers
- ✅ Copy only necessary files before expensive operations
- ✅ Use `.dockerignore` to exclude unnecessary files
- ✅ Pin base image versions for consistent caching

---

## 🏗️ Layer Ordering Strategy

### The Golden Rule

**Order Dockerfile instructions from least frequently changing to most frequently changing.**

### Bad Example (Cache Frequently Invalidated)

```dockerfile
FROM node:22-alpine

# ❌ Copying everything first invalidates cache on any file change
COPY . /app
WORKDIR /app

# ❌ This runs every time, even if package.json didn't change
RUN npm install

CMD ["node", "index.js"]
```

**Problem**: Any code change invalidates all subsequent layers, including `npm install`.

### Good Example (Optimized Caching)

```dockerfile
FROM node:22-alpine

WORKDIR /app

# ✅ Copy dependency files first (changes infrequently)
COPY package.json package-lock.json ./

# ✅ Install dependencies (cached unless package files change)
RUN npm install

# ✅ Copy application code last (changes frequently)
COPY . .

CMD ["node", "index.js"]
```

**Benefit**: `npm install` layer is cached unless `package.json` changes.

---

## 🚀 BuildKit Cache Mounts

### What Are Cache Mounts?

BuildKit cache mounts allow you to mount a persistent cache directory during build, speeding up package manager operations.

### Enabling BuildKit

```bash
# Enable BuildKit globally
export DOCKER_BUILDKIT=1

# Or per-command
DOCKER_BUILDKIT=1 docker build -t myimage .
```

### Node.js / pnpm Example

**Before** (No Cache Mount):

```dockerfile
FROM node:22-alpine

WORKDIR /app
COPY package.json pnpm-lock.yaml ./

# ❌ Downloads packages every time
RUN corepack enable && pnpm install --frozen-lockfile

COPY . .
CMD ["node", "index.js"]
```

**After** (With Cache Mount):

```dockerfile
FROM node:22-alpine

WORKDIR /app
COPY package.json pnpm-lock.yaml ./

# ✅ Reuses downloaded packages from cache
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    corepack enable && pnpm install --frozen-lockfile

COPY . .
CMD ["node", "index.js"]
```

**Impact**: 50-70% faster `pnpm install` on cache hit

### npm Example

```dockerfile
RUN --mount=type=cache,target=/root/.npm \
    npm ci --prefer-offline
```

### Python / pip Example

```dockerfile
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt
```

### Go Modules Example

```dockerfile
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    go mod download
```

### Rust / Cargo Example

```dockerfile
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/usr/local/cargo/git \
    --mount=type=cache,target=/app/target \
    cargo build --release
```

### apt / apk Example

```dockerfile
# For apt (Debian/Ubuntu)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y package-name

# For apk (Alpine)
RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    apk add --no-cache package-name
```

---

## 🎓 Multi-Stage Build Optimization

### Separate Build and Runtime Dependencies

**Before** (Single Stage):

```dockerfile
FROM node:22-alpine

RUN apk add --no-cache python3 make g++  # Build deps
COPY package.json ./
RUN npm install  # Includes devDependencies

COPY . .
RUN npm run build

# ❌ Final image includes build tools and devDependencies
CMD ["node", "dist/index.js"]
```

**After** (Multi-Stage):

```dockerfile
# Stage 1: Build
FROM node:22-alpine AS builder

RUN apk add --no-cache python3 make g++
WORKDIR /app

COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci

COPY . .
RUN npm run build

# Stage 2: Runtime
FROM node:22-alpine

WORKDIR /app

# ✅ Only copy production dependencies
COPY package.json package-lock.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

# ✅ Copy only built artifacts
COPY --from=builder /app/dist ./dist

# ✅ Final image is much smaller and more secure
CMD ["node", "dist/index.js"]
```

**Benefits**:
- 40-60% smaller final image
- No build tools in production
- Faster deployment pulls

---

## 📦 Language-Specific Optimizations

### Node.js / pnpm (Our Standard)

```dockerfile
FROM node:22-alpine

WORKDIR /app

# 1. Copy only lockfile and package.json
COPY package.json pnpm-lock.yaml ./

# 2. Use cache mount for pnpm store
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    corepack enable && \
    pnpm install --frozen-lockfile --prefer-offline

# 3. Copy application code
COPY . .

# 4. Build (if needed)
RUN pnpm run build

CMD ["node", "dist/index.js"]
```

### Python / pip

```dockerfile
FROM python:3.12-slim

WORKDIR /app

# 1. Copy only requirements
COPY requirements.txt ./

# 2. Use cache mount for pip
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --no-cache-dir -r requirements.txt

# 3. Copy application code
COPY . .

CMD ["python", "app.py"]
```

### Go

```dockerfile
FROM golang:1.21-alpine AS builder

WORKDIR /app

# 1. Copy go.mod and go.sum first
COPY go.mod go.sum ./

# 2. Download dependencies with cache
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download

# 3. Copy source code
COPY . .

# 4. Build with cache
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 go build -o /app/server .

# Runtime stage
FROM alpine:3.19
COPY --from=builder /app/server /server
CMD ["/server"]
```

### PHP / Composer

```dockerfile
FROM php:8.2-fpm-alpine

WORKDIR /app

# 1. Copy composer files
COPY composer.json composer.lock ./

# 2. Install dependencies with cache
RUN --mount=type=cache,target=/tmp/composer \
    composer install --no-dev --optimize-autoloader

# 3. Copy application code
COPY . .

CMD ["php-fpm"]
```

---

## 🔧 Advanced Techniques

### 1. Using .dockerignore

Prevent unnecessary files from invalidating cache:

```
# .dockerignore
.git/
.github/
node_modules/
npm-debug.log
.DS_Store
*.md
!README.md
tmp/
.env
coverage/
.vscode/
```

### 2. ARG Before FROM for Multi-Arch

```dockerfile
# ✅ ARG before FROM for multi-arch builds
ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-alpine

# ✅ ARG after FROM for build-time variables
ARG PNPM_VERSION=9
RUN corepack prepare pnpm@${PNPM_VERSION} --activate
```

### 3. Combining Related Commands

**Bad** (Multiple Layers):

```dockerfile
RUN apk add --no-cache git
RUN apk add --no-cache curl
RUN apk add --no-cache ca-certificates
```

**Good** (Single Layer):

```dockerfile
RUN apk add --no-cache \
    git \
    curl \
    ca-certificates
```

### 4. Cleaning Up in Same Layer

```dockerfile
# ✅ Install and cleanup in same layer
RUN apk add --no-cache --virtual .build-deps \
        python3 \
        make \
        g++ \
    && npm install \
    && apk del .build-deps
```

### 5. Cache-Friendly Base Images

```dockerfile
# ❌ Bad: Floating tag (cache unreliable)
FROM node:latest

# ✅ Good: Pinned version (cache reliable)
FROM node:22-alpine3.19

# ✅ Better: Digest for immutability
FROM node:22-alpine@sha256:abc123...
```

---

## 📊 Optimization Examples from Our Project

### node-pnpm Optimization

**Current** (Good baseline):

```dockerfile
FROM node:22-alpine
RUN apk add --no-cache git tini
RUN corepack enable && corepack prepare pnpm@9 --activate
```

**Optimized** (With cache mount):

```dockerfile
FROM node:22-alpine

# Install system deps (rarely changes)
RUN apk add --no-cache git tini

# Enable pnpm (rarely changes)
RUN corepack enable && corepack prepare pnpm@9 --activate

# When used as base for applications:
# COPY package.json pnpm-lock.yaml ./
# RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
#     pnpm install --frozen-lockfile
```

### rhymix Optimization

**Current**:

```dockerfile
FROM php:8.2-fpm-alpine

RUN apk add --no-cache nginx supervisor curl git ...
RUN docker-php-ext-install ...
RUN pecl install imagick
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
RUN curl -fsSL https://github.com/rhymix/rhymix/archive/...
```

**Optimized** (Reordered for better caching):

```dockerfile
FROM php:8.2-fpm-alpine

# 1. System dependencies (changes rarely)
RUN apk add --no-cache nginx supervisor curl git ...

# 2. PHP extensions (changes rarely)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo ...

# 3. PECL extensions (changes rarely)
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apk del .build-deps

# 4. Composer (rarely changes)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 5. Download Rhymix (version may change)
ARG RHYMIX_BRANCH=master
RUN curl -fsSL "https://github.com/rhymix/rhymix/archive/refs/heads/${RHYMIX_BRANCH}.tar.gz" ...

# 6. Configuration files (may change during development)
COPY php.ini nginx.conf supervisord.conf ...
```

---

## 🧪 Testing Cache Effectiveness

### Build Time Measurement

```bash
# First build (no cache)
time DOCKER_BUILDKIT=1 docker build --no-cache -t test:v1 .

# Second build (with cache)
time DOCKER_BUILDKIT=1 docker build -t test:v2 .

# Calculate improvement
# Should see 20-50% reduction in build time
```

### Cache Hit Analysis

```bash
# Use BuildKit progress output to see cache hits
DOCKER_BUILDKIT=1 docker build --progress=plain -t test:v1 . 2>&1 | grep CACHED

# Count cached vs uncached layers
DOCKER_BUILDKIT=1 docker build --progress=plain -t test:v1 . 2>&1 | \
    grep -c "CACHED" && echo "cached layers"
```

---

## 💡 CI/CD Integration

### GitHub Actions with Cache

```yaml
name: Build with Cache

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build with cache
        uses: docker/build-push-action@v5
        with:
          context: .
          cache-from: type=gha
          cache-to: type=gha,mode=max
          push: false
          tags: myimage:latest
```

### Local Development Cache

```bash
# Use BuildKit with local cache
DOCKER_BUILDKIT=1 docker build \
  --cache-from myimage:latest \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  -t myimage:latest .
```

---

## 📈 Expected Improvements

### Build Time Reduction

| Project Type | Before | After | Improvement |
|-------------|--------|-------|-------------|
| Node.js (pnpm) | 4m 30s | 1m 20s | 70% faster |
| PHP (composer) | 3m 45s | 1m 45s | 53% faster |
| Python (pip) | 2m 10s | 50s | 62% faster |
| Go (modules) | 5m 20s | 2m 10s | 59% faster |

### Layer Cache Hit Rate

- **Without optimization**: 30-40% cache hit rate
- **With optimization**: 70-85% cache hit rate
- **Best case** (code-only changes): 95%+ cache hit rate

---

## 🚫 Common Pitfalls

### Pitfall 1: COPY Before Dependencies

```dockerfile
# ❌ Bad: Invalidates cache on any code change
COPY . .
RUN npm install

# ✅ Good: Cache preserved if package.json unchanged
COPY package.json package-lock.json ./
RUN npm install
COPY . .
```

### Pitfall 2: Not Using BuildKit

```bash
# ❌ Old builder (no cache mounts)
docker build -t myimage .

# ✅ BuildKit (supports cache mounts)
DOCKER_BUILDKIT=1 docker build -t myimage .
```

### Pitfall 3: Clearing Package Manager Caches

```dockerfile
# ❌ Defeats the purpose of cache mounts
RUN npm install && npm cache clean --force

# ✅ Let BuildKit manage the cache
RUN --mount=type=cache,target=/root/.npm \
    npm install
```

### Pitfall 4: Using latest Tag

```dockerfile
# ❌ Cache unreliable (latest changes)
FROM node:latest

# ✅ Pin version for consistent cache
FROM node:22-alpine3.19
```

---

## 📚 Additional Resources

### Documentation
- [Docker BuildKit](https://docs.docker.com/build/buildkit/)
- [Docker Layer Caching](https://docs.docker.com/build/cache/)
- [Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)

### Project-Specific
- [Multi-Arch Guide](./MULTI_ARCH_GUIDE.md)
- [Dockerfile Examples](../images/)

---

## 🎯 Action Items

### Immediate (Already Optimized)
- ✅ node-pnpm Dockerfiles (good baseline)
- ✅ Layer ordering in most projects

### Recommended Next Steps
1. Add cache mounts to frequently built projects
2. Update CI/CD workflows with cache configuration
3. Add .dockerignore files where missing
4. Measure build time improvements

### Future Enhancements
- Implement registry cache backend
- Add cache warming in CI/CD
- Create reusable builder images

---

**Document Version**: 1.0
**Maintained by**: Infrastructure Team
**License**: MIT
