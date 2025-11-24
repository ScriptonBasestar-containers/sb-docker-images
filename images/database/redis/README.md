# Redis

Redis is an open-source, in-memory data structure store used as a database, cache, message broker, and streaming engine.

## Overview

This directory provides a standalone Redis instance for development and testing purposes.

**Key Features:**
- ✅ Redis 7 Alpine (lightweight image)
- ✅ AOF (Append-Only File) persistence enabled
- ✅ Password authentication
- ✅ Health check configured
- ✅ Data persistence via Docker volumes
- ✅ Isolated network

---

## Quick Start

```bash
cd redis

# Start Redis
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop Redis
docker compose down
```

---

## Configuration

### Default Settings

| Setting | Value | Description |
|---------|-------|-------------|
| **Port** | 6379 | Standard Redis port |
| **Password** | passw0rd | ⚠️ **Change in production!** |
| **Container** | redis | Container name |
| **Image** | redis:7-alpine | Lightweight Redis 7 |
| **Persistence** | AOF enabled | Append-Only File mode |

### Environment Variables

Copy `.env.example` to `.env` to customize:

```bash
cp .env.example .env
```

**.env variables:**
```bash
REDIS_PORT=6379                    # Redis port
REDIS_PASSWORD=passw0rd            # Authentication password
REDIS_CONTAINER_NAME=redis         # Container name
REDIS_DATA_VOLUME=redis-data       # Data volume name
```

---

## Connecting to Redis

### From Docker Containers (Same Network)

```yaml
services:
  your-app:
    environment:
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: passw0rd
    networks:
      - cache-network

networks:
  cache-network:
    external: true
    name: redis_cache-network
```

### From Host Machine

**Using redis-cli (Docker exec):**
```bash
# Interactive shell
docker compose exec redis redis-cli -a passw0rd

# Single command
docker compose exec redis redis-cli -a passw0rd PING
# Output: PONG
```

**Using redis-cli (installed locally):**
```bash
redis-cli -h localhost -p 6379 -a passw0rd
```

**Connection URL format:**
```
redis://:passw0rd@localhost:6379/0
```

### From Application Code

**Python (redis-py):**
```python
import redis

r = redis.Redis(
    host='localhost',  # or 'redis' if in same network
    port=6379,
    password='passw0rd',
    decode_responses=True
)

r.set('key', 'value')
print(r.get('key'))  # Output: value
```

**Node.js (ioredis):**
```javascript
const Redis = require('ioredis');

const redis = new Redis({
  host: 'localhost',  // or 'redis' if in same network
  port: 6379,
  password: 'passw0rd'
});

await redis.set('key', 'value');
const value = await redis.get('key');
console.log(value);  // Output: value
```

**Go (go-redis):**
```go
import (
    "github.com/redis/go-redis/v9"
    "context"
)

rdb := redis.NewClient(&redis.Options{
    Addr:     "localhost:6379",  // or "redis:6379"
    Password: "passw0rd",
    DB:       0,
})

ctx := context.Background()
err := rdb.Set(ctx, "key", "value", 0).Err()
val, err := rdb.Get(ctx, "key").Result()
```

---

## Common Operations

### Basic Key-Value Operations

```bash
# Set a key
docker compose exec redis redis-cli -a passw0rd SET mykey "Hello Redis"

# Get a key
docker compose exec redis redis-cli -a passw0rd GET mykey

# Delete a key
docker compose exec redis redis-cli -a passw0rd DEL mykey

# Check if key exists
docker compose exec redis redis-cli -a passw0rd EXISTS mykey

# Set with expiration (10 seconds)
docker compose exec redis redis-cli -a passw0rd SETEX tempkey 10 "temporary value"
```

### Lists

```bash
# Push to list
docker compose exec redis redis-cli -a passw0rd LPUSH mylist "item1"
docker compose exec redis redis-cli -a passw0rd LPUSH mylist "item2"

# Get list items
docker compose exec redis redis-cli -a passw0rd LRANGE mylist 0 -1
```

### Sets

```bash
# Add to set
docker compose exec redis redis-cli -a passw0rd SADD myset "member1"
docker compose exec redis redis-cli -a passw0rd SADD myset "member2"

# Get all set members
docker compose exec redis redis-cli -a passw0rd SMEMBERS myset
```

### Hashes

```bash
# Set hash fields
docker compose exec redis redis-cli -a passw0rd HSET user:1 name "John"
docker compose exec redis redis-cli -a passw0rd HSET user:1 email "john@example.com"

# Get all hash fields
docker compose exec redis redis-cli -a passw0rd HGETALL user:1
```

---

## Monitoring and Maintenance

### Server Information

```bash
# Server stats
docker compose exec redis redis-cli -a passw0rd INFO

# Memory usage
docker compose exec redis redis-cli -a passw0rd INFO memory

# Connected clients
docker compose exec redis redis-cli -a passw0rd CLIENT LIST

# Current database size
docker compose exec redis redis-cli -a passw0rd DBSIZE
```

### Performance Monitoring

```bash
# Monitor all commands in real-time
docker compose exec redis redis-cli -a passw0rd MONITOR

# Measure latency
docker compose exec redis redis-cli -a passw0rd --latency

# Continuous latency histogram
docker compose exec redis redis-cli -a passw0rd --latency-history
```

### Data Persistence

**Current configuration:**
- AOF (Append-Only File) enabled
- Data saved to `/data` (persisted in Docker volume)

**Trigger manual save:**
```bash
# Background save (BGSAVE)
docker compose exec redis redis-cli -a passw0rd BGSAVE

# Blocking save (SAVE)
docker compose exec redis redis-cli -a passw0rd SAVE

# Check last save time
docker compose exec redis redis-cli -a passw0rd LASTSAVE
```

---

## Data Management

### Backup

```bash
# Backup AOF file
docker compose exec redis redis-cli -a passw0rd BGREWRITEAOF
docker cp redis:/data/appendonly.aof ./backup-$(date +%Y%m%d).aof

# Backup RDB file (if using RDB persistence)
docker cp redis:/data/dump.rdb ./backup-$(date +%Y%m%d).rdb
```

### Restore

```bash
# Stop Redis
docker compose down

# Copy backup to volume
docker run --rm -v redis_redis-data:/data -v $(pwd):/backup alpine \
  cp /backup/appendonly.aof /data/appendonly.aof

# Start Redis
docker compose up -d
```

### Clear All Data

```bash
# Flush current database (DB 0)
docker compose exec redis redis-cli -a passw0rd FLUSHDB

# Flush all databases
docker compose exec redis redis-cli -a passw0rd FLUSHALL
```

---

## Security Best Practices

### Production Deployment Checklist

- [ ] **Change default password**: Use strong random password (32+ characters)
  ```bash
  openssl rand -base64 32
  ```

- [ ] **Disable external port access**: Remove ports mapping if Redis is only used internally
  ```yaml
  # Comment out or remove:
  # ports:
  #   - "6379:6379"
  ```

- [ ] **Enable TLS/SSL**: Configure encrypted connections for production

- [ ] **Set maxmemory policy**: Prevent unbounded memory growth
  ```bash
  command: redis-server --maxmemory 256mb --maxmemory-policy allkeys-lru
  ```

- [ ] **Rename dangerous commands**: Protect against accidental data loss
  ```bash
  command: redis-server --rename-command FLUSHALL "" --rename-command FLUSHDB ""
  ```

- [ ] **Configure firewall**: Restrict network access to trusted sources only

- [ ] **Regular backups**: Automated backup schedule

---

## Health Check

The compose file includes automatic health monitoring:

```yaml
healthcheck:
  test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
  interval: 10s
  timeout: 3s
  retries: 5
```

**Check health status:**
```bash
docker compose ps
# Look for "healthy" status
```

---

## Troubleshooting

### Connection Refused

**Symptom:** `Could not connect to Redis at localhost:6379: Connection refused`

**Solutions:**
1. Check if Redis is running:
   ```bash
   docker compose ps
   ```

2. Verify port mapping:
   ```bash
   docker compose port redis 6379
   ```

3. Check logs for errors:
   ```bash
   docker compose logs redis
   ```

### Authentication Failed

**Symptom:** `NOAUTH Authentication required`

**Solution:** Include password in all commands:
```bash
docker compose exec redis redis-cli -a passw0rd PING
```

### Out of Memory

**Symptom:** `OOM command not allowed when used memory > 'maxmemory'`

**Solutions:**
1. Set maxmemory policy:
   ```yaml
   command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
   ```

2. Clear unused keys:
   ```bash
   docker compose exec redis redis-cli -a passw0rd --scan --pattern "temp:*" | xargs docker compose exec redis redis-cli -a passw0rd DEL
   ```

### Data Not Persisting

**Symptom:** Data lost after container restart

**Solutions:**
1. Verify AOF is enabled:
   ```bash
   docker compose exec redis redis-cli -a passw0rd CONFIG GET appendonly
   # Should return: 1) "appendonly" 2) "yes"
   ```

2. Check volume exists:
   ```bash
   docker volume ls | grep redis-data
   ```

---

## Use Cases

### 1. Session Store

Store user sessions for web applications with automatic expiration:
```python
redis.setex(f'session:{session_id}', 3600, session_data)
```

### 2. Cache Layer

Cache database queries or API responses:
```python
cache_key = f'user:{user_id}'
cached = redis.get(cache_key)
if not cached:
    user = db.query(user_id)
    redis.setex(cache_key, 300, json.dumps(user))
```

### 3. Message Queue

Simple pub/sub messaging:
```python
# Publisher
redis.publish('notifications', 'New message')

# Subscriber
pubsub = redis.pubsub()
pubsub.subscribe('notifications')
for message in pubsub.listen():
    print(message)
```

### 4. Rate Limiting

Implement API rate limiting:
```python
key = f'rate_limit:{user_id}'
requests = redis.incr(key)
if requests == 1:
    redis.expire(key, 60)  # 60 seconds window
if requests > 100:
    raise RateLimitExceeded()
```

---

## Integration with Buildbox

**[Buildbox](../buildbox/)** provides pre-configured Redis templates for quick development environment setup.

### Using Redis with Buildbox

**Start Redis standalone:**
```bash
cd ../buildbox
make redis
# Redis available at localhost:6379
```

**Start complete development stack:**
```bash
# Django stack (PostgreSQL + Redis + MailSlurper)
make django-stack

# Rails stack (PostgreSQL + Redis)
make rails-stack

# PHP stack (MariaDB + Redis)
make php-stack
```

### Connect Your Application

Reference Buildbox's Redis service in your `docker-compose.yml`:

```yaml
services:
  your-app:
    environment:
      REDIS_URL: redis://:passw0rd@redis_dev:6379/0
    networks:
      - buildbox_data-network
    depends_on:
      - redis

networks:
  buildbox_data-network:
    external: true
```

**See also:** [Buildbox README](../buildbox/README.md) for complete usage patterns.

---

## References

### Official Documentation
- [Redis Documentation](https://redis.io/docs/)
- [Redis Commands Reference](https://redis.io/commands/)
- [Redis Docker Hub](https://hub.docker.com/_/redis)
- [Redis Security](https://redis.io/topics/security)
- [Redis Persistence](https://redis.io/topics/persistence)

### Client Libraries
- Python: [redis-py](https://github.com/redis/redis-py)
- Node.js: [ioredis](https://github.com/luin/ioredis)
- Go: [go-redis](https://github.com/redis/go-redis)
- Java: [Jedis](https://github.com/redis/jedis)
- PHP: [Predis](https://github.com/predis/predis)

---

## License

This Docker Compose configuration is provided for development and testing purposes.
For production use, ensure compliance with [Redis license terms](https://redis.io/topics/license).
