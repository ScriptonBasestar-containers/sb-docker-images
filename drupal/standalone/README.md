# Drupal Standalone Docker Setup

Complete standalone Drupal 10 setup with MariaDB and Redis.

## Features

- **Drupal**: Official image `drupal:10-apache-bookworm`
- **MariaDB**: Database server with health check
- **Redis**: Cache backend

## Configuration

### Environment Variables (Optional)

For custom configuration, copy `.env.example` to `.env` and modify the values:

```bash
cp .env.example .env
# Edit .env with your preferred settings
```

The default values in `compose.yml` work out of the box without creating a `.env` file.

**⚠️ Security**: Always change default passwords in production!

## Quick Start

```bash
# Start all services
docker compose up -d

# Or use Makefile
make up

# View logs
make logs

# Access Drupal
# Open http://localhost:8080 in your browser
```

## Installation

1. Start the containers:
   ```bash
   docker compose up -d
   ```

2. Open http://localhost:8080 in your browser

3. Follow the installation wizard:
   - **Database type**: MySQL, MariaDB, Percona Server, or equivalent
   - **Database name**: `db01`
   - **Database username**: `user01`
   - **Database password**: `passw0rd`
   - **Advanced options** → **Host**: `mariadb`

4. Complete the site configuration

## Database Connection

- **Host**: mariadb
- **Port**: 3306
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Root Password**: rootpass

## Redis Configuration

To enable Redis caching in Drupal:

1. Install Redis module:
   ```bash
   docker compose exec drupal composer require drupal/redis
   ```

2. Add to `settings.php`:
   ```php
   $settings['redis.connection']['interface'] = 'PhpRedis';
   $settings['redis.connection']['host'] = 'redis';
   $settings['cache']['default'] = 'cache.backend.redis';
   ```

## Drush Commands

```bash
# Access Drush
make drush

# Common commands
docker compose exec drupal drush status
docker compose exec drupal drush cache-rebuild
docker compose exec drupal drush updatedb
docker compose exec drupal drush user:password admin "newpassword"
```

## Data Persistence

All data is stored in named volumes:
- `drupal-data`: Drupal files, modules, themes
- `mariadb-data`: Database data
- `redis-data`: Redis persistence

## Backup

```bash
# Backup volumes
docker run --rm -v drupal-data:/source -v $(pwd):/backup alpine tar czf /backup/drupal-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > drupal-db-backup.sql
```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
make clean
```

## Official Documentation

- Drupal: https://www.drupal.org/
- Docker Hub: https://hub.docker.com/_/drupal
