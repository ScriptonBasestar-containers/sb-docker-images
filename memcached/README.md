# Memcached Docker Setup

High-performance distributed memory object caching system.

## Features

- Official Docker image: `memcached:1.6-alpine`
- Memory limit: 64MB (configurable)
- Port: 11211

## Quick Start

```bash
# Start memcached
docker compose up -d

# View logs
docker compose logs -f

# Stop memcached
docker compose down
```

## Configuration

Edit the `command` in `compose.yml` to customize memcached settings:

```yaml
command: memcached -m 128  # Set memory to 128MB
```

Common options:
- `-m <num>`: Maximum memory in megabytes (default: 64)
- `-c <num>`: Max simultaneous connections (default: 1024)
- `-v`: Verbose output
- `-vv`: Very verbose output

## Testing Connection

```bash
# Using telnet
telnet localhost 11211

# Or using nc
echo "stats" | nc localhost 11211
```

## Official Documentation

- Docker Hub: https://hub.docker.com/_/memcached
- Memcached: https://memcached.org/
