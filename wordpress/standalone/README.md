# WordPress Standalone Docker Setup

Complete standalone WordPress 6 setup with MariaDB and Redis.

## Features

- **WordPress**: Official image `wordpress:6-php8.3-apache`
- **MariaDB**: Database server with health check
- **Redis**: Cache backend with health check (requires plugin)

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

# Access WordPress
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
   - Set site title, username, password, and email
   - Click "Install WordPress"

4. The database connection is pre-configured via environment variables

## Database Connection

Pre-configured via environment variables:

- **Host**: mariadb
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Root Password**: rootpass

## Redis Object Cache

To enable Redis caching:

1. Install Redis Object Cache plugin:
   ```bash
   docker compose exec wordpress wp plugin install redis-cache --activate
   ```

2. Enable Redis:
   ```bash
   docker compose exec wordpress wp redis enable
   ```

3. Check status:
   ```bash
   docker compose exec wordpress wp redis status
   ```

The Redis connection is pre-configured via `WORDPRESS_CONFIG_EXTRA` in compose.yml.

## WP-CLI Commands

WordPress CLI is available in the container:

```bash
# Via Makefile
make wp-cli

# Common commands
docker compose exec wordpress wp --info
docker compose exec wordpress wp plugin list
docker compose exec wordpress wp theme list
docker compose exec wordpress wp user list

# Install plugins
docker compose exec wordpress wp plugin install akismet --activate
docker compose exec wordpress wp plugin install jetpack

# Update WordPress
docker compose exec wordpress wp core update
docker compose exec wordpress wp plugin update --all
docker compose exec wordpress wp theme update --all
```

## Data Persistence

All data is stored in named volumes:
- `wordpress-data`: WordPress files, plugins, themes, uploads
- `mariadb-data`: Database data
- `redis-data`: Redis persistence

## Backup

```bash
# Backup volumes
docker run --rm -v wordpress-data:/source -v $(pwd):/backup alpine tar czf /backup/wordpress-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > wordpress-db-backup.sql

# Or use WP-CLI
docker compose exec wordpress wp db export - > wordpress-db-backup.sql
```

## Restore

```bash
# Restore database
docker compose exec -T mariadb mysql -u root -prootpass db01 < wordpress-db-backup.sql

# Or use WP-CLI
docker compose exec -T wordpress wp db import - < wordpress-db-backup.sql
```

## Health Checks

All services include health checks for reliable startup:

- **MariaDB**: Checks database readiness with `healthcheck.sh`
- **Redis**: Verifies Redis is responding with `redis-cli ping`

Services will wait for dependencies to be healthy before starting:
- WordPress waits for MariaDB and Redis to be ready

This ensures proper initialization and prevents connection errors.

## Troubleshooting

### Port Already in Use

If port 8080 is already in use, create a `.env` file:

```bash
echo "WORDPRESS_PORT=8081" > .env
docker compose up -d
```

### Database Connection Errors

If WordPress can't connect to the database:

1. Check if MariaDB is healthy:
   ```bash
   docker compose ps
   ```

2. Wait for health check to pass:
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

2. Verify Redis Object Cache plugin is installed and enabled

3. Check plugin status:
   ```bash
   docker compose exec wordpress wp redis status
   ```

### Permissions

If you encounter permission issues:

```bash
# Fix permissions
docker compose exec wordpress chown -R www-data:www-data /var/www/html
```

### White Screen of Death (WSOD)

If WordPress shows a blank white screen:

1. Enable debugging:
   ```bash
   docker compose exec wordpress wp config set WP_DEBUG true --raw
   docker compose exec wordpress wp config set WP_DEBUG_LOG true --raw
   ```

2. Check error logs:
   ```bash
   docker compose exec wordpress tail -f /var/www/html/wp-content/debug.log
   ```

## Security Recommendations

1. Change database passwords in production
2. Use strong WordPress admin password
3. Install security plugins (e.g., Wordfence, iThemes Security)
4. Keep WordPress, plugins, and themes updated
5. Enable SSL/TLS (use reverse proxy like Nginx/Traefik)

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
make clean
```

## Official Documentation

- WordPress: https://wordpress.org/
- Docker Hub: https://hub.docker.com/_/wordpress
- WP-CLI: https://wp-cli.org/
