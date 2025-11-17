# Redis Docker Setup

The world's fastest data platform for caching, vector search, and NoSQL databases.

## Features

- Official Docker image: `redis:7-alpine`
- Persistence enabled (AOF)
- Password protection: `passw0rd` (change in production)
- Port: 6379
- Health check enabled

## Quick Start

```bash
# Start Redis
docker compose up -d

# View logs
docker compose logs -f

# Access Redis CLI
make cli
# or
docker compose exec redis redis-cli -a passw0rd

# Stop Redis
docker compose down
```

## Configuration

The Redis server is configured with:
- `--appendonly yes`: Enable AOF persistence
- `--requirepass passw0rd`: Password authentication

### Change Password

Edit the `command` in `compose.yml`:

```yaml
command: redis-server --appendonly yes --requirepass YOUR_NEW_PASSWORD
```

### Additional Configuration

Create a `redis.conf` file and mount it:

```yaml
volumes:
  - redis-data:/data
  - ./redis.conf:/usr/local/etc/redis/redis.conf
command: redis-server /usr/local/etc/redis/redis.conf
```

## Testing Connection

```bash
# Test connection
make test

# Or manually
docker compose exec redis redis-cli -a passw0rd ping
# Should return: PONG

# Set and get a value
docker compose exec redis redis-cli -a passw0rd set mykey "Hello"
docker compose exec redis redis-cli -a passw0rd get mykey
# Should return: "Hello"
```

## Persistence

Data is persisted in the `redis-data` volume. To backup:

```bash
# Backup
docker compose exec redis redis-cli -a passw0rd BGSAVE

# Copy AOF file
docker cp redis:/data/appendonly.aof ./backup/
```

## Official Documentation

- Docker Hub: https://hub.docker.com/_/redis
- Redis Documentation: https://redis.io/docs/
- Docker Official Image Guide: https://www.docker.com/blog/how-to-use-the-redis-docker-official-image/
