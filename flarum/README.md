# Flarum Docker Setup

Modern, elegant forum software. Uses community-maintained Docker image (no official image available).

## Features

- **Flarum**: Community image `mondedie/flarum:stable`
- **MariaDB**: Database server with health check
- **phpMyAdmin**: Database management interface
- **MailHog**: Email testing tool

## Quick Start

```bash
# Start all services
docker compose up -d

# Or use Makefile
make up

# View logs
make logs

# Access Flarum
# Open http://localhost:8080 in your browser
```

## Default Credentials

Pre-configured via environment variables:

- **Admin Username**: admin
- **Admin Password**: password
- **Admin Email**: admin@example.com

**⚠️ Important**: Change these credentials after installation!

## Database Connection

The database is automatically configured:

- **Host**: mariadb
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Table Prefix**: flarum_
- **Root Password**: rootpass

## Additional Services

### phpMyAdmin
- URL: http://localhost:8081
- Username: root
- Password: rootpass

### MailHog (Email Testing)
- Web UI: http://localhost:8025
- SMTP: localhost:1025

Configure Flarum to use MailHog for email testing:
- SMTP Host: mailhog
- SMTP Port: 1025
- Encryption: None

## Data Persistence

All data is stored in named volumes:
- `flarum-data`: Flarum files, extensions, assets
- `mariadb-data`: Database data

## Extensions

To install extensions, access the container:

```bash
make shell
# or
docker compose exec flarum bash

# Install extension
cd /flarum/app
composer require vendor/extension-name
php flarum cache:clear
```

Popular extensions:
- `fof/upload` - File upload
- `fof/pages` - Static pages
- `flarum/tags` - Tag system
- `flarum/mentions` - User mentions

Extension lists:
- https://discuss.flarum.org/d/1534-extension-list
- https://github.com/realodix/awesome-flarum

## Themes

Install custom themes:

```bash
composer require vendor/theme-name
php flarum cache:clear
```

Theme resources:
- https://www.knthost.com/flarum/install-flarum-themes
- https://github.com/afrux/flarum-theme-base

## Backup

```bash
# Backup volumes
docker run --rm -v flarum-data:/source -v $(pwd):/backup alpine tar czf /backup/flarum-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > flarum-db-backup.sql
```

## Restore

```bash
# Restore volumes
docker run --rm -v flarum-data:/target -v $(pwd):/backup alpine tar xzf /backup/flarum-backup.tar.gz -C /target

# Import database
docker compose exec -T mariadb mysql -u root -prootpass db01 < flarum-db-backup.sql
```

## Troubleshooting

### Clear cache
```bash
docker compose exec flarum php flarum cache:clear
```

### Check logs
```bash
make logs-flarum
make logs-mariadb
```

### Reset permissions
```bash
docker compose exec flarum chown -R www-data:www-data /flarum/app
```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
make clean
```

## References

- Flarum: https://flarum.org/
- Docker Image: https://github.com/mondediefr/docker-flarum
- Flarum GitHub: https://github.com/flarum/flarum
- Flarum Community: https://discuss.flarum.org/
