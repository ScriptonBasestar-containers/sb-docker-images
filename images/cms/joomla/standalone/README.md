# Joomla Standalone Docker Setup

Complete standalone Joomla 5 setup with MariaDB and Redis.

## Features

- **Joomla**: Official image `joomla:5-php8.3-apache`
- **MariaDB**: Database server with health check
- **Redis**: Cache backend with health check

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

# Access Joomla
# Open http://localhost:8080 in your browser
```

## Default Credentials

As configured in the compose file:

- **Admin Username**: joomla
- **Admin Password**: joomla@secured
- **Admin Email**: joomla@example.com
- **Site Name**: Joomla

**⚠️ Important**: Change these credentials in production!

## Database Connection

During Joomla installation:

- **Database Type**: MySQLi
- **Host**: mariadb
- **Username**: user01
- **Password**: passw0rd
- **Database Name**: db01
- **Table Prefix**: (default)

Or use environment variables (auto-configured):
- Root Password: rootpass

## Redis Configuration

To enable Redis caching in Joomla:

1. Install Redis extension in your container:
   ```bash
   docker compose exec joomla apt-get update && apt-get install -y php-redis
   docker compose restart joomla
   ```

2. Configure in Joomla admin panel:
   - System → Global Configuration → System → Cache
   - Cache Handler: Redis
   - Redis Server Host: redis
   - Redis Server Port: 6379

## Data Persistence

All data is stored in named volumes:
- `joomla-data`: Joomla files, extensions, templates
- `mariadb-data`: Database data
- `redis-data`: Redis persistence

## Backup

```bash
# Backup volumes
docker run --rm -v joomla-data:/source -v $(pwd):/backup alpine tar czf /backup/joomla-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > joomla-db-backup.sql
```

## Health Checks

All services include health checks for reliable startup:

- **MariaDB**: Checks database readiness with `healthcheck.sh`
- **Redis**: Verifies Redis is responding with `redis-cli ping`

Services will wait for dependencies to be healthy before starting:
- Joomla waits for MariaDB and Redis to be ready

This ensures proper initialization and prevents connection errors.

## Troubleshooting

### Port Already in Use

If port 8080 is already in use, you can change it using environment variables:

```bash
# Create .env file
echo "JOOMLA_PORT=8081" > .env

# Or directly in docker compose
docker compose -p joomla up -d
```

### Database Connection Errors

If Joomla can't connect to the database:

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

2. Check logs:
   ```bash
   docker compose logs redis
   ```

### Permission Issues

If you encounter file permission errors:

```bash
docker compose exec joomla chown -R www-data:www-data /var/www/html
```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
make clean
```

## Extensions and Templates

Access the container to install extensions:

```bash
make shell
# or
docker compose exec joomla bash
```

## Official Documentation

- Joomla: https://www.joomla.org/
- Docker Hub: https://hub.docker.com/_/joomla
- Joomla Documentation: https://docs.joomla.org/
