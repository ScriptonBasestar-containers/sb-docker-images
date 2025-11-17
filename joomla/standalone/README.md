# Joomla Standalone Docker Setup

Complete standalone Joomla 5 setup with MariaDB and Redis.

## Features

- **Joomla**: Official image `joomla:5-php8.3-apache`
- **MariaDB**: Database server with health check
- **Redis**: Cache backend

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
