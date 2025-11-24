# Flarum Standalone Docker Setup

Complete standalone Flarum setup with MariaDB and Redis.

## Features

- **Flarum**: Community image `mondedie/flarum:stable`
- **MariaDB**: Database server with health check
- **Redis**: Session and cache backend with health check (optional)

## Quick Start

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Access Flarum
# Open http://localhost:8080 in your browser
```

## Installation

1. Start the containers:
   ```bash
   docker compose up -d
   ```

2. Open http://localhost:8080 in your browser

3. The initial setup is automated:
   - Database is pre-configured and connected
   - Admin account is created automatically
   - Forum is ready to use

## Default Credentials

Pre-configured via environment variables:

- **Admin Username**: admin
- **Admin Password**: password
- **Admin Email**: admin@example.com

**⚠️ Important**: Change these credentials after installation!

## Database Connection

Pre-configured via environment variables:

- **Host**: mariadb
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Table Prefix**: flarum_
- **Root Password**: rootpass

## Redis Session Storage (Optional)

To use Redis for session storage, install the Redis extension:

```bash
# Access the Flarum container
docker compose exec flarum bash

# Navigate to Flarum directory
cd /flarum/app

# Install Redis extension
composer require fof/redis

# Clear cache
php flarum cache:clear
```

Then configure in Flarum admin panel:
- Redis Host: redis
- Redis Port: 6379

Available Redis extensions:
- `fof/redis` - Session storage and cache support

## Extensions

To install extensions:

```bash
# Access container
docker compose exec flarum bash
cd /flarum/app

# Install extension
composer require vendor/extension-name

# Clear cache
php flarum cache:clear
```

Popular extensions:
- `fof/upload` - File upload support
- `fof/pages` - Static pages
- `flarum/tags` - Tag system
- `flarum/mentions` - User mentions
- `fof/redis` - Redis support
- `flarum/pusher` - Real-time notifications
- `fof/nightmode` - Dark mode

Extension resources:
- https://discuss.flarum.org/d/1534-extension-list
- https://github.com/realodix/awesome-flarum
- https://extiverse.com/

## Themes

Install custom themes:

```bash
# Access container
docker compose exec flarum bash
cd /flarum/app

# Install theme
composer require vendor/theme-name

# Clear cache
php flarum cache:clear
```

Popular themes:
- `the-turk/flarum-diff` - Minimalist theme
- `fof/nightmode` - Dark theme

## Data Persistence

All data is stored in named volumes:
- `flarum-data`: Flarum files, extensions, assets
- `mariadb-data`: Database data
- `redis-data`: Redis persistence (sessions, cache)

## Backup

```bash
# Backup volumes
docker run --rm -v flarum-data:/source -v $(pwd):/backup alpine tar czf /backup/flarum-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .
docker run --rm -v redis-data:/source -v $(pwd):/backup alpine tar czf /backup/redis-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > flarum-db-backup.sql
```

## Restore

```bash
# Restore volumes
docker run --rm -v flarum-data:/target -v $(pwd):/backup alpine tar xzf /backup/flarum-backup.tar.gz -C /target
docker run --rm -v mariadb-data:/target -v $(pwd):/backup alpine tar xzf /backup/mariadb-backup.tar.gz -C /target

# Import database
docker compose exec -T mariadb mysql -u root -prootpass db01 < flarum-db-backup.sql
```

## Cache Management

```bash
# Clear Flarum cache
docker compose exec flarum php flarum cache:clear

# Clear Redis cache (if using Redis extension)
docker compose exec redis redis-cli FLUSHALL
```

## Troubleshooting

### Clear cache
```bash
docker compose exec flarum php flarum cache:clear
```

### Reset permissions
```bash
docker compose exec flarum chown -R www-data:www-data /flarum/app
```

### Check logs
```bash
# Flarum logs
docker compose logs -f flarum

# MariaDB logs
docker compose logs -f mariadb

# Redis logs
docker compose logs -f redis
```

### Database connection issues
```bash
# Check MariaDB health
docker compose exec mariadb healthcheck.sh --connect --innodb_initialized

# Test connection
docker compose exec mariadb mysql -u user01 -ppassw0rd db01 -e "SELECT 1"
```

## Security Recommendations

1. **Change default passwords** in production:
   - Admin password (via Flarum admin panel)
   - Database passwords (in compose.yml)

2. **Enable HTTPS** using reverse proxy (Nginx, Traefik, Caddy)

3. **Install security extensions**:
   - `the-turk/flarum-quiet-edits` - Edit tracking
   - `fof/ban-ips` - IP blocking

4. **Regular updates**:
   ```bash
   docker compose exec flarum bash
   cd /flarum/app
   composer update
   php flarum migrate
   php flarum cache:clear
   ```

5. **Disable debug mode** in production (check `/flarum/app/config.php`)

## Upgrading Flarum

```bash
# Pull latest image
docker compose pull flarum

# Restart container
docker compose up -d flarum

# Run migrations
docker compose exec flarum php flarum migrate

# Clear cache
docker compose exec flarum php flarum cache:clear
```

## Health Checks

All services include health checks for reliable startup:

- **MariaDB**: Checks database readiness with `healthcheck.sh`
- **Redis**: Verifies Redis is responding with `redis-cli ping`

Services will wait for dependencies to be healthy before starting:
- Flarum waits for MariaDB and Redis to be ready

This ensures proper initialization and prevents connection errors.

## Troubleshooting

### Port Already in Use

If port 8510 is already in use, create a `.env` file:

```bash
echo "FLARUM_PORT=8511" > .env
docker compose up -d
```

### Database Connection Errors

If Flarum can't connect to the database:

1. Check if MariaDB is healthy:
   ```bash
   docker compose ps
   ```

2. Check database logs:
   ```bash
   docker compose logs mariadb
   ```

3. Restart services:
   ```bash
   docker compose restart
   ```

### Redis Connection Issues

If Redis is not working:

1. Check Redis health:
   ```bash
   docker compose exec redis redis-cli ping
   # Should return: PONG
   ```

2. Verify Redis extension is installed in Flarum

### Forum Not Loading

If the forum doesn't load or shows errors:

1. Check all container logs:
   ```bash
   docker compose logs
   ```

2. Clear Flarum cache:
   ```bash
   docker compose exec flarum php flarum cache:clear
   ```

3. Check file permissions:
   ```bash
   docker compose exec flarum chown -R www-data:www-data /flarum/app
   ```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
docker compose down -v
```

## Port Information

See [PORT_GUIDE.md](../../docs/PORT_GUIDE.md) for port allocation strategy.

**Default ports:**
- Flarum: 8080

## Official Documentation

- Flarum: https://flarum.org/
- Docker Image: https://github.com/mondediefr/docker-flarum
- Flarum GitHub: https://github.com/flarum/flarum
- Flarum Community: https://discuss.flarum.org/
- Extensions: https://extiverse.com/
