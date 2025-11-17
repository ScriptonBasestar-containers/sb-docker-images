# Nextcloud Standalone Docker Setup

Complete standalone Nextcloud 29 setup with MariaDB and Redis.

## Features

- **Nextcloud**: Official image `nextcloud:29` (Apache variant)
- **MariaDB**: Database server with health check
- **Redis**: Cache and session backend

## Quick Start

```bash
# Start all services
docker compose -f compose.apache.yml up -d

# Or use Makefile
make up

# View logs
make logs

# Access Nextcloud
# Open http://localhost:8080 in your browser
```

## Default Credentials

- **Admin Username**: admin
- **Admin Password**: passw0rd

**⚠️ Important**: Change the password immediately after first login!

## Database Connection

The database is automatically configured via environment variables:

- **Host**: mariadb
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Root Password**: rootpass

## Redis Configuration

Redis is automatically configured for:
- File locking
- Caching
- Session management

No manual configuration needed - it's set up via environment variables.

## Data Persistence

All data is stored in named volumes:
- `nxc_root`: Nextcloud core files
- `nxc_apps`: Custom apps
- `nxc_data`: User data and files
- `nxc_themes`: Custom themes
- `mariadb-data`: Database data
- `redis-data`: Redis persistence

## OCC Command

Use the `occ` command for maintenance:

```bash
# Via Makefile
make occ

# Examples
docker compose -f compose.apache.yml exec -u www-data nextcloud php occ status
docker compose -f compose.apache.yml exec -u www-data nextcloud php occ app:list
docker compose -f compose.apache.yml exec -u www-data nextcloud php occ maintenance:mode --on
docker compose -f compose.apache.yml exec -u www-data nextcloud php occ db:add-missing-indices
```

## Backup

```bash
# Enable maintenance mode
make occ
# Then: maintenance:mode --on

# Backup volumes
docker run --rm -v nxc_data:/source -v $(pwd):/backup alpine tar czf /backup/nextcloud-data-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose -f compose.apache.yml exec mariadb mysqldump -u root -prootpass db01 > nextcloud-db-backup.sql

# Disable maintenance mode
# maintenance:mode --off
```

## Upgrade

```bash
# Pull new image
docker compose -f compose.apache.yml pull

# Restart with new image
docker compose -f compose.apache.yml up -d

# The upgrade will happen automatically
# Monitor logs to ensure it completes
docker compose -f compose.apache.yml logs -f nextcloud
```

## Docker Hooks

Nextcloud supports lifecycle hooks. Create directories and scripts:

```bash
mkdir -p app-hooks/{pre-installation,post-installation,pre-upgrade,post-upgrade,before-starting}
```

Uncomment the corresponding volume mounts in `compose.apache.yml`.

Hook execution order:
- `pre-installation`: Before Nextcloud is installed/initiated
- `post-installation`: After Nextcloud is installed/initiated
- `pre-upgrade`: Before Nextcloud is upgraded
- `post-upgrade`: After Nextcloud is upgraded
- `before-starting`: Before Nextcloud starts

## Trusted Domains

To add trusted domains, use occ:

```bash
docker compose -f compose.apache.yml exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=example.com
```

Or set via environment variable in compose.yml:
```yaml
environment:
  NEXTCLOUD_TRUSTED_DOMAINS: example.com another-domain.com
```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose -f compose.apache.yml down

# Remove everything including volumes
make clean
```

## Official Documentation

- Nextcloud: https://nextcloud.com/
- Docker Hub: https://hub.docker.com/_/nextcloud
- Nextcloud Admin Manual: https://docs.nextcloud.com/server/latest/admin_manual/
