# NodeBB Standalone Docker Setup

Complete standalone NodeBB setup with PostgreSQL and Redis.

## Features

- **NodeBB**: Official image `nodebb/docker:latest`
- **PostgreSQL**: Database server with health check
- **Redis**: Cache and session backend

## Quick Start

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Access NodeBB
# Open http://localhost:4567 in your browser
```

## Installation

1. Start the containers:
   ```bash
   docker compose up -d
   ```

2. Wait for the services to be ready (check logs):
   ```bash
   docker compose logs -f nodebb
   ```

3. Open http://localhost:4567 in your browser

4. Follow the installation wizard:
   - Set up administrator account
   - Database and Redis are pre-configured

## Database Connection

Pre-configured via environment variables:

- **Database Type**: PostgreSQL
- **Host**: postgres
- **Port**: 5432
- **Database**: nodebb
- **Username**: nodebb
- **Password**: nodebb_password

## Redis Connection

Pre-configured via environment variables:

- **Host**: redis
- **Port**: 6379
- **Password**: (none)

## Administration

### Admin Panel

Access the admin panel at: http://localhost:4567/admin

### CLI Commands

NodeBB provides CLI tools for management:

```bash
# Access NodeBB container
docker compose exec nodebb bash

# Inside the container
./nodebb setup      # Run setup wizard
./nodebb start      # Start NodeBB
./nodebb stop       # Stop NodeBB
./nodebb restart    # Restart NodeBB
./nodebb status     # Check status
./nodebb reset      # Reset database
./nodebb upgrade    # Upgrade NodeBB
./nodebb build      # Build assets
```

### User Management

```bash
# Create admin user
docker compose exec nodebb ./nodebb user:create

# Reset password
docker compose exec nodebb ./nodebb user:reset

# Delete user
docker compose exec nodebb ./nodebb user:delete
```

## Plugins

Install plugins via the Admin Panel or CLI:

```bash
# Access container
docker compose exec nodebb bash

# Install plugin
npm install nodebb-plugin-name

# Rebuild and restart
./nodebb build
./nodebb restart
```

Popular plugins:
- `nodebb-plugin-markdown` - Markdown support
- `nodebb-plugin-mentions` - User mentions
- `nodebb-plugin-imgur` - Image uploads to Imgur
- `nodebb-plugin-spam-be-gone` - Spam protection
- `nodebb-plugin-sso-oauth` - OAuth authentication

Plugin directory: https://community.nodebb.org/category/7/nodebb-plugins

## Themes

Install themes via the Admin Panel or CLI:

```bash
# Access container
docker compose exec nodebb bash

# Install theme
npm install nodebb-theme-name

# Rebuild and restart
./nodebb build
./nodebb restart
```

Then activate the theme in Admin Panel → Appearance → Themes.

Popular themes:
- `nodebb-theme-persona` - Default theme
- `nodebb-theme-vanilla` - Minimalist theme
- `nodebb-theme-lavender` - Purple theme

Theme directory: https://community.nodebb.org/category/6/nodebb-themes

## Data Persistence

All data is stored in named volumes:
- `nodebb-data`: NodeBB build files and uploads
- `nodebb-config`: Configuration files
- `nodebb-public`: Public assets
- `postgres-data`: Database data
- `redis-data`: Redis persistence (sessions, cache)

## Backup

```bash
# Backup volumes
docker run --rm -v nodebb-data:/source -v $(pwd):/backup alpine tar czf /backup/nodebb-data-backup.tar.gz -C /source .
docker run --rm -v nodebb-config:/source -v $(pwd):/backup alpine tar czf /backup/nodebb-config-backup.tar.gz -C /source .
docker run --rm -v postgres-data:/source -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /source .

# Export database
docker compose exec postgres pg_dump -U nodebb nodebb > nodebb-db-backup.sql
```

## Restore

```bash
# Restore volumes
docker run --rm -v nodebb-data:/target -v $(pwd):/backup alpine tar xzf /backup/nodebb-data-backup.tar.gz -C /target
docker run --rm -v nodebb-config:/target -v $(pwd):/backup alpine tar xzf /backup/nodebb-config-backup.tar.gz -C /target

# Import database
docker compose exec -T postgres psql -U nodebb nodebb < nodebb-db-backup.sql
```

## Troubleshooting

### Check logs
```bash
# All services
docker compose logs -f

# NodeBB only
docker compose logs -f nodebb

# PostgreSQL only
docker compose logs -f postgres
```

### Reset NodeBB
```bash
# Reset database and start fresh
docker compose exec nodebb ./nodebb reset

# Or completely clean install
docker compose down -v
docker compose up -d
```

### Database connection issues
```bash
# Check PostgreSQL health
docker compose exec postgres pg_isready -U nodebb

# Test connection
docker compose exec postgres psql -U nodebb -d nodebb -c "SELECT 1"
```

### Rebuild assets
```bash
# If frontend is not working properly
docker compose exec nodebb ./nodebb build
docker compose exec nodebb ./nodebb restart
```

### Clear cache
```bash
# Clear Redis cache
docker compose exec redis redis-cli FLUSHALL

# Clear NodeBB cache
docker compose exec nodebb ./nodebb build
```

## Upgrading NodeBB

```bash
# Pull latest image
docker compose pull nodebb

# Restart container
docker compose up -d nodebb

# Run upgrade
docker compose exec nodebb ./nodebb upgrade

# Rebuild assets
docker compose exec nodebb ./nodebb build
```

## Email Configuration

Configure email in Admin Panel → Settings → Email:

1. **SMTP Settings**:
   - Host: your-smtp-host
   - Port: 587 (or 465 for SSL)
   - Username: your-email
   - Password: your-password
   - Secure: Yes (for SSL/TLS)

2. **Email Testing**:
   - Send test email from Admin Panel
   - Check logs for errors

For development, consider using MailHog or Mailtrap.

## Performance Optimization

### Enable Clustering

Edit config.json to enable clustering:

```json
{
  "port": "4567",
  "cluster": true
}
```

### Redis Cache

Redis is already configured for:
- Session storage
- Real-time data caching
- Pub/Sub messaging

### Database Optimization

```bash
# Create indexes (already done by NodeBB)
docker compose exec postgres psql -U nodebb -d nodebb -c "VACUUM ANALYZE"
```

## Security Recommendations

1. **Change default passwords** in production:
   - PostgreSQL password (in compose.yml)
   - Admin account password

2. **Enable HTTPS** using reverse proxy (Nginx, Traefik, Caddy)

3. **Install security plugins**:
   - `nodebb-plugin-spam-be-gone` - Spam protection
   - `nodebb-plugin-2factor` - Two-factor authentication

4. **Configure firewall**:
   - Only expose port 4567 through reverse proxy
   - Restrict database and Redis access

5. **Regular updates**:
   ```bash
   docker compose pull
   docker compose up -d
   docker compose exec nodebb ./nodebb upgrade
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
- NodeBB: 4567

**Recommended port** (to avoid conflicts): 8240

To change port, edit compose.yml:
```yaml
ports:
  - "8240:4567"
```

Then update the `url` environment variable:
```yaml
environment:
  - url=http://localhost:8240
```

## Official Documentation

- NodeBB: https://nodebb.org/
- Docker Hub: https://hub.docker.com/r/nodebb/docker
- NodeBB Docs: https://docs.nodebb.org/
- Community: https://community.nodebb.org/
- GitHub: https://github.com/NodeBB/NodeBB
