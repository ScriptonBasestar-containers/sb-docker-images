# Discourse Standalone Docker Setup

Complete standalone Discourse setup with PostgreSQL and Redis.

## Features

- **Discourse**: Official base image `discourse/base:2.0.20241119-0129`
- **PostgreSQL**: Database server with health check
- **Redis**: Cache and session backend

## Quick Start

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Access Discourse
# Open http://localhost:8080 in your browser
```

## Installation

1. Start the containers:
   ```bash
   docker compose up -d
   ```

2. Wait for the services to initialize (this may take a few minutes on first run):
   ```bash
   docker compose logs -f discourse
   ```

3. Open http://localhost:8080 in your browser

4. Follow the setup wizard to create the admin account

## Database Connection

Pre-configured via environment variables:

- **Host**: postgres
- **Port**: 5432
- **Database**: discourse
- **Username**: discourse
- **Password**: discourse_password

## Redis Connection

Pre-configured via environment variables:

- **Host**: redis
- **Port**: 6379

## Administration

### Admin Panel

Access the admin panel at: http://localhost:8080/admin

### Console Access

Access the Rails console:

```bash
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rails console
```

### Common Commands

```bash
# Rebuild Discourse (after updates)
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rake assets:precompile
bundle exec rake db:migrate

# Create admin user manually
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rake admin:create
```

## Plugins

To install plugins, you need to rebuild the Discourse image with the plugin included.

Popular plugins:
- `discourse-solved` - Mark topics as solved
- `discourse-voting` - Topic voting
- `discourse-calendar` - Event calendar
- `discourse-spoiler-alert` - Spoiler tags
- `discourse-assign` - Assign topics to users

Plugin directory: https://github.com/discourse/discourse/blob/main/docs/INSTALL-plugins.md

## Themes

Install themes via the Admin Panel:

1. Go to Admin → Customize → Themes
2. Click "Install"
3. Choose from popular themes or add custom theme repository

Popular themes:
- Graceful - Minimalist theme
- Material Design Theme - Material Design
- Brand Header Theme - Custom brand headers

## Data Persistence

All data is stored in named volumes:
- `discourse-data`: Discourse uploads, backups, and shared data
- `postgres-data`: Database data
- `redis-data`: Redis persistence (cache, sessions)

## Backup

```bash
# Backup volumes
docker run --rm -v discourse-data:/source -v $(pwd):/backup alpine tar czf /backup/discourse-backup.tar.gz -C /source .
docker run --rm -v postgres-data:/source -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /source .

# Export database
docker compose exec postgres pg_dump -U discourse discourse > discourse-db-backup.sql

# Discourse built-in backup (recommended)
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rake backup:create
```

Backups are stored in `/shared/backups/default/` inside the Discourse container.

## Restore

```bash
# Restore database
docker compose exec -T postgres psql -U discourse discourse < discourse-db-backup.sql

# Restore Discourse backup (recommended)
# 1. Copy backup file to container
docker cp backup-file.tar.gz discourse:/shared/backups/default/

# 2. Restore via web interface
# Go to Admin → Backups → Upload and select the backup file
```

## Upgrading Discourse

```bash
# Pull latest image
docker compose pull discourse

# Restart container
docker compose up -d discourse

# Run migrations
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rake db:migrate
bundle exec rake assets:precompile
```

## Email Configuration

Configure email via environment variables in compose.yml:

```yaml
environment:
  DISCOURSE_SMTP_ADDRESS: smtp.example.com
  DISCOURSE_SMTP_PORT: 587
  DISCOURSE_SMTP_USER_NAME: user@example.com
  DISCOURSE_SMTP_PASSWORD: your-password
  DISCOURSE_SMTP_ENABLE_START_TLS: true
```

Or configure via Admin Panel → Settings → Email.

For development, consider using MailHog or similar email testing tools.

## Troubleshooting

### Check logs
```bash
# All services
docker compose logs -f

# Discourse only
docker compose logs -f discourse

# PostgreSQL only
docker compose logs -f postgres
```

### Database connection issues
```bash
# Check PostgreSQL health
docker compose exec postgres pg_isready -U discourse

# Test connection
docker compose exec postgres psql -U discourse -d discourse -c "SELECT 1"
```

### Rebuild assets
```bash
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rake assets:precompile
```

### Clear cache
```bash
# Clear Redis cache
docker compose exec redis redis-cli FLUSHALL

# Clear Rails cache
docker compose exec discourse bash
cd /var/www/discourse
bundle exec rake cache:clear
```

### Reset to fresh install
```bash
# Stop and remove all data
docker compose down -v

# Start fresh
docker compose up -d
```

## Performance Optimization

### Database Optimization

```bash
# Run VACUUM
docker compose exec postgres psql -U discourse -d discourse -c "VACUUM ANALYZE"
```

### Redis Optimization

Redis is already configured for:
- Session storage
- Cache
- Message bus (pub/sub)

### Sidekiq Background Jobs

Discourse uses Sidekiq for background job processing, which is included in the main Discourse container.

## Security Recommendations

1. **Change default passwords** in production:
   - PostgreSQL password (in compose.yml)
   - Admin account password

2. **Enable HTTPS** using reverse proxy (Nginx, Traefik, Caddy)

3. **Configure email** properly for password resets and notifications

4. **Enable two-factor authentication** for admin accounts

5. **Regular updates**:
   ```bash
   docker compose pull
   docker compose up -d
   ```

6. **Regular backups**:
   - Use Discourse's built-in backup system
   - Schedule automatic backups via Admin Panel

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
- Discourse: 8080

**Recommended port** (to avoid conflicts): 8230

To change port, edit compose.yml:
```yaml
ports:
  - "8230:80"
```

## Official Documentation

- Discourse: https://www.discourse.org/
- Docker Hub: https://hub.docker.com/r/discourse/base
- Discourse Docs: https://docs.discourse.org/
- Meta Discourse: https://meta.discourse.org/
- GitHub: https://github.com/discourse/discourse
