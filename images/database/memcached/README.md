# Memcached

Memcached is a high-performance, distributed memory object caching system, generic in nature, but intended
for use in speeding up dynamic web applications by alleviating database load.

## Overview

This directory provides a standalone Memcached instance for development and testing purposes.

**Key Features:**
- ✅ Memcached 1.6 Alpine (lightweight image)
- ✅ Configurable memory limit (64MB default)
- ✅ Isolated network
- ✅ Simple and fast key-value storage
- ✅ LRU (Least Recently Used) eviction

---

## Quick Start

```bash
cd memcached

# Start Memcached
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop Memcached
docker compose down
```

---

## Configuration

### Default Settings

| Setting | Value | Description |
|---------|-------|-------------|
| **Port** | 11211 | Standard Memcached port |
| **Memory** | 64 MB | Maximum memory allocation |
| **Container** | memcached | Container name |
| **Image** | memcached:1.6-alpine | Lightweight Memcached 1.6 |
| **Eviction** | LRU | Least Recently Used policy |

### Environment Variables

Copy `.env.example` to `.env` to customize:

```bash
cp .env.example .env
```

**.env variables:**
```bash
MEMCACHED_PORT=11211                  # Memcached port
MEMCACHED_MEMORY=64                   # Memory limit in MB
MEMCACHED_CONTAINER_NAME=memcached    # Container name
```

### Memory Sizing

Choose memory based on your use case:

| Use Case | Recommended Memory |
|----------|-------------------|
| **Development** | 64-128 MB |
| **Small production** | 256-512 MB |
| **Medium production** | 1-2 GB |
| **Large production** | 4-8+ GB |

Update `command` in `compose.yml`:
```yaml
command: memcached -m 256  # 256 MB
```

---

## Connecting to Memcached

### From Docker Containers (Same Network)

```yaml
services:
  your-app:
    environment:
      MEMCACHED_HOST: memcached
      MEMCACHED_PORT: 11211
    networks:
      - cache-network

networks:
  cache-network:
    external: true
    name: memcached_cache-network
```

### From Host Machine

**Connection format:**
```
memcached://localhost:11211
```

### From Application Code

**Python (pymemcache):**
```python
from pymemcache.client import base

client = base.Client(('localhost', 11211))  # or 'memcached' if in same network

# Set a value
client.set('key', 'value')

# Get a value
value = client.get('key')
print(value)  # Output: b'value'

# Set with expiration (60 seconds)
client.set('tempkey', 'tempvalue', expire=60)

# Delete a key
client.delete('key')
```

**Node.js (memjs):**
```javascript
const memjs = require('memjs');

const client = memjs.Client.create('localhost:11211');  // or 'memcached:11211'

// Set a value
await client.set('key', 'value');

// Get a value
const { value } = await client.get('key');
console.log(value.toString());  // Output: value

// Set with expiration (60 seconds)
await client.set('tempkey', 'tempvalue', { expires: 60 });

// Delete a key
await client.delete('key');
```

**PHP (Memcached extension):**
```php
<?php
$memcached = new Memcached();
$memcached->addServer('localhost', 11211);  // or 'memcached' if in same network

// Set a value
$memcached->set('key', 'value');

// Get a value
$value = $memcached->get('key');
echo $value;  // Output: value

// Set with expiration (60 seconds)
$memcached->set('tempkey', 'tempvalue', 60);

// Delete a key
$memcached->delete('key');
?>
```

**Go (gomemcache):**
```go
import (
    "github.com/bradfitz/gomemcache/memcache"
)

mc := memcache.New("localhost:11211")  // or "memcached:11211"

// Set a value
mc.Set(&memcache.Item{Key: "key", Value: []byte("value")})

// Get a value
item, err := mc.Get("key")
if err == nil {
    fmt.Println(string(item.Value))  // Output: value
}

// Set with expiration (60 seconds)
mc.Set(&memcache.Item{
    Key:        "tempkey",
    Value:      []byte("tempvalue"),
    Expiration: 60,
})

// Delete a key
mc.Delete("key")
```

---

## Common Operations

### Basic Key-Value Operations

**Using telnet (for testing):**
```bash
# Connect via telnet
telnet localhost 11211

# Set a key (syntax: set <key> <flags> <exptime> <bytes>)
set mykey 0 0 5
Hello
STORED

# Get a key
get mykey
VALUE mykey 0 5
Hello
END

# Delete a key
delete mykey
DELETED

# Quit
quit
```

**Using Docker exec (stats and commands):**
```bash
# Check statistics
echo "stats" | docker compose exec -T memcached nc localhost 11211

# Get specific stat
echo "stats items" | docker compose exec -T memcached nc localhost 11211

# Flush all data
echo "flush_all" | docker compose exec -T memcached nc localhost 11211
```

---

## Monitoring and Maintenance

### Server Statistics

**Get all statistics:**
```bash
echo "stats" | docker compose exec -T memcached nc localhost 11211
```

**Key statistics to monitor:**

| Statistic | Description |
|-----------|-------------|
| `curr_items` | Current number of items stored |
| `total_items` | Total items stored since startup |
| `bytes` | Current bytes used to store items |
| `limit_maxbytes` | Max memory allowed (in bytes) |
| `curr_connections` | Current open connections |
| `total_connections` | Total connections since startup |
| `cmd_get` | Total GET commands |
| `cmd_set` | Total SET commands |
| `get_hits` | Successful GET operations |
| `get_misses` | Failed GET operations |
| `evictions` | Items removed to free memory |
| `bytes_read` | Total bytes read |
| `bytes_written` | Total bytes written |

### Hit Rate Calculation

```bash
# Get hits and misses
echo "stats" | docker compose exec -T memcached nc localhost 11211 | grep -E "get_hits|get_misses"

# Hit rate = hits / (hits + misses) * 100
```

**Example:**
- Hits: 1000
- Misses: 100
- Hit Rate: 1000 / (1000 + 100) * 100 = 90.9%

**Healthy hit rate:** > 90%
**Poor hit rate:** < 80% (consider increasing memory or reviewing cache strategy)

### Memory Usage

```bash
# Check memory usage
echo "stats" | docker compose exec -T memcached nc localhost 11211 | grep -E "bytes|limit_maxbytes"

# Example output:
# STAT bytes 524288              (current usage: ~512 KB)
# STAT limit_maxbytes 67108864   (max limit: 64 MB)
```

**Memory utilization = bytes / limit_maxbytes * 100**

### Eviction Monitoring

```bash
# Check evictions
echo "stats" | docker compose exec -T memcached nc localhost 11211 | grep evictions

# If evictions > 0, consider:
# 1. Increasing memory limit
# 2. Reducing TTL values
# 3. Reviewing what's being cached
```

---

## Data Management

### Clear All Data

```bash
# Flush all keys (immediate)
echo "flush_all" | docker compose exec -T memcached nc localhost 11211

# Flush all keys (delayed - 10 seconds)
echo "flush_all 10" | docker compose exec -T memcached nc localhost 11211
```

### Inspect Keys

Memcached doesn't provide direct key listing, but you can:

**Get item count:**
```bash
echo "stats items" | docker compose exec -T memcached nc localhost 11211
```

**Use debugging tools:**
```bash
# Install memcached-tool (if available)
docker compose exec memcached memcached-tool localhost:11211
```

---

## Security Best Practices

### Production Deployment Checklist

- [ ] **Never expose to public internet**: Remove ports mapping or use internal network only
  ```yaml
  # DANGER - Public exposure:
  # ports:
  #   - "11211:11211"

  # SAFE - Internal network only (no ports mapping)
  networks:
    - cache-network
  ```

- [ ] **Use internal Docker network**: Connect only via Docker network

- [ ] **Consider SASL authentication**: Enable authentication for production
  ```bash
  command: memcached -m 256 -S
  ```

- [ ] **Set memory limits**: Prevent unbounded growth
  ```bash
  command: memcached -m 512  # 512 MB limit
  ```

- [ ] **Monitor evictions**: High eviction rate means insufficient memory

- [ ] **Configure firewall**: Restrict network access if port is exposed

- [ ] **Regular monitoring**: Track hit rate, memory usage, evictions

---

## Troubleshooting

### Connection Refused

**Symptom:** `Connection refused` or `Unable to connect to localhost:11211`

**Solutions:**
1. Check if Memcached is running:
   ```bash
   docker compose ps
   ```

2. Verify port mapping:
   ```bash
   docker compose port memcached 11211
   ```

3. Check logs:
   ```bash
   docker compose logs memcached
   ```

### Low Hit Rate

**Symptom:** Hit rate below 80-90%

**Causes:**
1. **Insufficient memory**: Items being evicted too quickly
2. **Short TTL values**: Data expiring before reuse
3. **Cache stampede**: Multiple processes caching same key

**Solutions:**
```bash
# Check evictions
echo "stats" | docker compose exec -T memcached nc localhost 11211 | grep evictions

# If evictions > 0:
# 1. Increase memory limit in compose.yml
# 2. Review cache strategy
# 3. Implement cache warming
```

### High Memory Usage

**Symptom:** Memory usage approaching limit

**Solutions:**
1. **Increase memory limit**:
   ```yaml
   command: memcached -m 256  # Increase to 256 MB
   ```

2. **Reduce TTL values**: Let items expire sooner

3. **Review what's cached**: Remove unnecessary cached data

### Items Not Expiring

**Symptom:** Old data persisting beyond TTL

**Cause:** Memcached uses lazy deletion (deleted on next access)

**Solution:** This is normal behavior. Items will be cleaned up when:
- They're accessed (lazy delete)
- Memory is needed (eviction)
- Flush command is used

---

## Use Cases

### 1. Database Query Caching

Cache expensive database queries:

```python
import pymemcache
import psycopg2

cache = pymemcache.Client(('memcached', 11211))

def get_user(user_id):
    cache_key = f'user:{user_id}'

    # Try cache first
    cached = cache.get(cache_key)
    if cached:
        return json.loads(cached)

    # Query database
    conn = psycopg2.connect(...)
    user = conn.execute("SELECT * FROM users WHERE id = %s", (user_id,))

    # Store in cache (5 minutes)
    cache.set(cache_key, json.dumps(user), expire=300)
    return user
```

### 2. Session Storage

Store user sessions:

```php
<?php
// Configure PHP to use Memcached for sessions
ini_set('session.save_handler', 'memcached');
ini_set('session.save_path', 'memcached:11211');

session_start();
$_SESSION['user_id'] = 123;
?>
```

### 3. API Response Caching

Cache external API responses:

```javascript
const memjs = require('memjs');
const fetch = require('node-fetch');

const cache = memjs.Client.create('memcached:11211');

async function getWeather(city) {
    const cacheKey = `weather:${city}`;

    // Check cache
    const cached = await cache.get(cacheKey);
    if (cached.value) {
        return JSON.parse(cached.value.toString());
    }

    // Fetch from API
    const response = await fetch(`https://api.weather.com/${city}`);
    const data = await response.json();

    // Cache for 30 minutes
    await cache.set(cacheKey, JSON.stringify(data), { expires: 1800 });
    return data;
}
```

### 4. Counter/Statistics

Implement simple counters:

```go
mc := memcache.New("memcached:11211")

// Increment page view counter
mc.Increment("page:views", 1)

// Get counter value
item, _ := mc.Get("page:views")
fmt.Println(string(item.Value))
```

---

## Redis vs Memcached

### When to Use Memcached

✅ **Use Memcached when:**
- Simple key-value caching
- Horizontal scaling (multiple servers)
- Multi-threaded performance
- Lower memory overhead
- Simpler setup

❌ **Don't use Memcached when:**
- Need data persistence
- Complex data structures (lists, sets, hashes)
- Pub/sub messaging
- Transactions
- Lua scripting

### Comparison Table

| Feature | Memcached | Redis |
|---------|-----------|-------|
| **Data Types** | String only | String, List, Set, Hash, etc. |
| **Persistence** | ❌ No | ✅ Yes (AOF, RDB) |
| **Threading** | Multi-threaded | Single-threaded |
| **Memory Efficiency** | ✅ Better | Good |
| **Replication** | ❌ No built-in | ✅ Yes |
| **Max Value Size** | 1 MB | 512 MB |
| **Eviction** | LRU only | Multiple policies |
| **Use Case** | Simple caching | Cache + more |

---

## Advanced Configuration

### Connection Pooling

**Python example:**
```python
from pymemcache.client.hash import HashClient

# Multiple servers for redundancy
servers = [
    ('memcached1:11211', 1),  # (server, weight)
    ('memcached2:11211', 1),
]

client = HashClient(servers)
```

### Custom Eviction Behavior

Memcached uses LRU (Least Recently Used) by default. To modify:

```yaml
command: |
  memcached -m 256 \
    -c 1024 \        # max simultaneous connections
    -t 4 \           # number of threads
    -I 5m            # max item size (5 MB)
```

### Verbosity for Debugging

Enable verbose logging:

```yaml
command: memcached -m 64 -vv  # -v, -vv, or -vvv
```

---

## Performance Tips

1. **Right-size memory**: Monitor evictions, increase if needed
2. **Use connection pooling**: Reuse connections across requests
3. **Batch operations**: Use multi-get/multi-set when possible
4. **Appropriate TTL**: Balance freshness vs hit rate
5. **Monitor hit rate**: Target > 90% for good performance
6. **Consider compression**: For large values
7. **Use multiple servers**: Distribute load horizontally

---

## Integration with Buildbox

**Note:** Memcached is not included in Buildbox templates. However, you can use this standalone configuration
alongside Buildbox services for projects requiring Memcached instead of Redis.

### Running with Buildbox Services

**Start Memcached (from this directory):**
```bash
cd memcached
docker compose up -d
# Memcached available at localhost:11211
```

**Start Buildbox database (from buildbox directory):**
```bash
cd ../buildbox
make postgres  # or make mariadb
```

### Connect Your Application

Reference both Memcached and Buildbox services in your `docker-compose.yml`:

```yaml
services:
  your-app:
    environment:
      MEMCACHED_HOST: memcached
      DATABASE_URL: postgresql://postgres:passw0rd@postgres_dev:5432/app_db
    networks:
      - memcached_cache-network
      - buildbox_data-network
    depends_on:
      - memcached
      - postgres

networks:
  memcached_cache-network:
    external: true
  buildbox_data-network:
    external: true
```

**See also:**
- [Buildbox README](../buildbox/README.md) for PostgreSQL/MariaDB templates
- [Redis README](../redis/README.md) for Redis alternative (included in Buildbox)

---

## References

### Official Documentation
- [Memcached Official Site](https://memcached.org/)
- [Memcached Wiki](https://github.com/memcached/memcached/wiki)
- [Memcached Docker Hub](https://hub.docker.com/_/memcached)
- [Protocol Documentation](https://github.com/memcached/memcached/blob/master/doc/protocol.txt)

### Client Libraries
- Python: [pymemcache](https://github.com/pinterest/pymemcache)
- Node.js: [memjs](https://github.com/alevy/memjs)
- PHP: [php-memcached](https://www.php.net/manual/en/book.memcached.php)
- Go: [gomemcache](https://github.com/bradfitz/gomemcache)
- Java: [spymemcached](https://github.com/couchbase/spymemcached)

### Tools
- [memcached-tool](https://github.com/memcached/memcached/blob/master/scripts/memcached-tool) - Stats and debugging
- [mc-crusher](https://github.com/couchbase/mctester) - Load testing

---

## License

This Docker Compose configuration is provided for development and testing purposes.
Memcached is released under the [BSD 3-Clause License](https://github.com/memcached/memcached/blob/master/LICENSE).
