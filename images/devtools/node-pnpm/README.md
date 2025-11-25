# node-pnpm

Node.js with pnpm package manager - Docker images for development and CI/CD.

## Why This Image?

[pnpm does not provide official Docker images](https://github.com/orgs/pnpm/discussions/4944). This project fills that gap with:

- **Multi-arch support**: amd64, arm64
- **Multiple variants**: debian-slim, alpine, builder
- **Corepack integration**: Uses Node.js built-in corepack for pnpm management
- **Proper signal handling**: Includes tini as init process

## Image Variants

| Variant | Base | Size | Use Case |
|---------|------|------|----------|
| `node-pnpm:22` | Debian bookworm-slim | ~200MB | General development |
| `node-pnpm:22-alpine` | Alpine | ~100MB | Production, size-sensitive |
| `node-pnpm:22-builder` | Debian bookworm | ~400MB | CI/CD, native modules |

## Quick Start

### Interactive Shell

```bash
docker run -it --rm -v $(pwd):/app scriptonbasestar/node-pnpm:22 bash
```

### Create New Project

```bash
docker run -it --rm -v $(pwd):/app scriptonbasestar/node-pnpm:22 pnpm init
```

### Install Dependencies

```bash
docker run -it --rm -v $(pwd):/app scriptonbasestar/node-pnpm:22 pnpm install
```

### Run Scripts

```bash
docker run -it --rm -v $(pwd):/app scriptonbasestar/node-pnpm:22 pnpm run build
```

## Usage in Dockerfile

### Production Build

```dockerfile
FROM scriptonbasestar/node-pnpm:22-alpine AS builder
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM node:22-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

### CI/CD Pipeline

```dockerfile
FROM scriptonbasestar/node-pnpm:22-builder
WORKDIR /app
COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm test
RUN pnpm build
```

## Build Locally

```bash
# Build default image
make build

# Build Alpine variant
make build-alpine

# Build builder variant (with build tools)
make build-builder

# Build all variants
make build-all

# Run tests
make test
```

## Configuration

Copy `.env.example` to `.env` and customize:

```bash
cp .env.example .env
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NODE_VERSION` | 22 | Node.js major version |
| `PNPM_VERSION` | 9 | pnpm major version |
| `NODE_ENV` | development | Node environment |
| `DOCKER_REPONAME` | scriptonbasestar | Docker registry |

## pnpm Store Caching

For faster builds, mount a persistent pnpm store:

```bash
docker run -it --rm \
  -v $(pwd):/app \
  -v pnpm-store:/pnpm \
  scriptonbasestar/node-pnpm:22 pnpm install
```

Or in compose.yml:

```yaml
services:
  app:
    image: scriptonbasestar/node-pnpm:22
    volumes:
      - ./:/app
      - pnpm-store:/pnpm

volumes:
  pnpm-store:
```

## Supported Node.js Versions

| Node.js | Status | Image Tags |
|---------|--------|------------|
| 22 | LTS (Active) | `22`, `22-alpine`, `22-builder` |
| 20 | LTS (Maintenance) | `20`, `20-alpine`, `20-builder` |
| 18 | LTS (Maintenance) | `18`, `18-alpine`, `18-builder` |

## References

- [pnpm Official](https://pnpm.io/)
- [Node.js Corepack](https://nodejs.org/api/corepack.html)
- [GitHub Discussion: Why no official pnpm Docker image?](https://github.com/orgs/pnpm/discussions/4944)
