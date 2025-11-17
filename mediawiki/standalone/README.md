# MediaWiki Standalone Docker Setup

Complete standalone MediaWiki setup with MariaDB and Redis.

## Features

- **MediaWiki**: Official image `mediawiki:latest`
- **MariaDB**: Database server with health check
- **Redis**: Cache backend with health check

## Quick Start

```bash
# Start all services
docker compose up -d

# Or use Makefile
make up

# View logs
make logs

# Access MediaWiki
# Open http://localhost:8080 in your browser
```

## Installation

1. Start the containers:
   ```bash
   docker compose up -d
   ```

2. Open http://localhost:8080 in your browser

3. Follow the installation wizard:
   - Select language
   - **Database type**: MySQL, MariaDB, or compatible
   - **Database host**: mariadb
   - **Database name**: db01
   - **Database username**: user01
   - **Database password**: passw0rd
   - Complete other settings (admin account, wiki name, etc.)

4. Download `LocalSettings.php` at the end of installation

5. Copy LocalSettings.php to this directory:
   ```bash
   # Or use the Makefile command
   make download-config
   ```

6. Uncomment the LocalSettings.php volume mount in `compose.yml`:
   ```yaml
   volumes:
     - mediawiki-images:/var/www/html/images
     - ./LocalSettings.php:/var/www/html/LocalSettings.php
   ```

7. Restart the container:
   ```bash
   docker compose restart mediawiki
   ```

## Database Connection

- **Host**: mariadb
- **Port**: 3306
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Root Password**: rootpass

## Redis Configuration

To enable Redis caching in MediaWiki, add to `LocalSettings.php`:

```php
// Redis cache configuration
$wgMainCacheType = CACHE_REDIS;
$wgSessionCacheType = CACHE_REDIS;

$wgObjectCaches['redis'] = [
    'class' => 'RedisBagOStuff',
    'servers' => ['redis:6379'],
    'persistent' => true,
];

$wgMainCacheType = 'redis';
```

## Data Persistence

All data is stored in named volumes:
- `mediawiki-images`: Uploaded images and media files
- `mariadb-data`: Database data
- `redis-data`: Redis persistence

## Backup

```bash
# Backup volumes
docker run --rm -v mediawiki-images:/source -v $(pwd):/backup alpine tar czf /backup/mediawiki-images-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > mediawiki-db-backup.sql

# Backup LocalSettings.php
cp LocalSettings.php LocalSettings.php.backup
```

## Restore

```bash
# Restore database
docker compose exec -T mariadb mysql -u root -prootpass db01 < mediawiki-db-backup.sql

# Restore images
docker run --rm -v mediawiki-images:/target -v $(pwd):/backup alpine tar xzf /backup/mediawiki-images-backup.tar.gz -C /target
```

## Maintenance

Common maintenance tasks:

```bash
# Update database schema
docker compose exec mediawiki php maintenance/update.php

# Rebuild recent changes
docker compose exec mediawiki php maintenance/rebuildrecentchanges.php

# Run jobs
docker compose exec mediawiki php maintenance/runJobs.php
```

## Health Checks

All services include health checks for reliable startup:

- **MariaDB**: Checks database readiness with `healthcheck.sh`
- **Redis**: Verifies Redis is responding with `redis-cli ping`

Services will wait for dependencies to be healthy before starting:
- MediaWiki waits for MariaDB and Redis to be ready

This ensures proper initialization and prevents connection errors.

## Troubleshooting

### Port Already in Use

If port 8080 is already in use, create a `.env` file:

```bash
echo "MEDIAWIKI_PORT=8081" > .env
docker compose up -d
```

### Database Connection Errors

If MediaWiki can't connect to the database:

1. Check if MariaDB is healthy:
   ```bash
   docker compose ps
   ```

2. Verify database credentials in installer or `LocalSettings.php`

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

2. Verify Redis configuration in `LocalSettings.php`

### LocalSettings.php Not Found

If MediaWiki asks you to run the installer again after restart:

1. Make sure you downloaded `LocalSettings.php` after installation

2. Uncomment the volume mount in `compose.yml`:
   ```yaml
   - ./LocalSettings.php:/var/www/html/LocalSettings.php
   ```

3. Restart the container:
   ```bash
   docker compose restart mediawiki
   ```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
make clean
```

## Official Documentation

- MediaWiki: https://www.mediawiki.org/
- Docker Hub: https://hub.docker.com/_/mediawiki
- Installation Guide: https://www.mediawiki.org/wiki/Manual:Installation_guide
