# Wiki.js Standalone Docker Setup

Complete standalone Wiki.js setup with PostgreSQL.

## Features

- **Wiki.js**: Official image `ghcr.io/requarks/wiki:2`
- **PostgreSQL**: Database server with health check

## Quick Start

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Access Wiki.js
# Open http://localhost:8080 in your browser
```

## Installation

1. Start the containers:
   ```bash
   docker compose up -d
   ```

2. Wait for the services to initialize:
   ```bash
   docker compose logs -f wiki
   ```

3. Open http://localhost:8080 in your browser

4. Follow the setup wizard:
   - Configure administrator account
   - Set site URL
   - Database connection is pre-configured
   - Choose authentication method
   - Complete installation

## Database Connection

Pre-configured via environment variables:

- **Database Type**: PostgreSQL
- **Host**: postgres
- **Port**: 5432
- **Database**: wiki
- **Username**: wikijs
- **Password**: wikijs_password

## Administration

### Admin Panel

Access the admin panel at: http://localhost:8080/a

Default admin path: `/a`

### Common Tasks

**Add New Page:**
1. Click the "+" button or "New Page"
2. Choose page editor (Markdown, Visual, etc.)
3. Write content
4. Save and publish

**Manage Users:**
1. Go to Admin → Users
2. Add, edit, or remove users
3. Assign roles and permissions

**Configure Authentication:**
1. Go to Admin → Authentication
2. Enable authentication providers (Local, OAuth, LDAP, SAML, etc.)
3. Configure provider settings

**Backup & Export:**
1. Go to Admin → Storage
2. Configure storage targets (Git, S3, etc.)
3. Enable automatic backups

## Git Integration

Wiki.js supports Git synchronization:

1. Go to Admin → Storage
2. Select "Git" as storage target
3. Configure repository URL and credentials
4. Set sync schedule
5. Enable two-way sync if needed

Supported Git providers:
- GitHub
- GitLab
- Bitbucket
- Gitea
- Generic Git

## Search Engines

Configure search engine in Admin → Search Engine:

- **Database** - Built-in PostgreSQL search (default)
- **Elasticsearch** - Advanced search
- **Algolia** - Cloud-based search
- **AWS CloudSearch** - AWS managed search
- **Azure Search** - Azure managed search

## Themes

Change theme in Admin → Theme:

- **Default** - Light theme
- **Dark** - Dark mode
- Custom themes via CSS

## Data Persistence

All data is stored in named volumes:
- `wiki-data`: Wiki.js data, uploads, and cache
- `postgres-data`: Database data

## Backup

```bash
# Backup volumes
docker run --rm -v wiki-data:/source -v $(pwd):/backup alpine tar czf /backup/wiki-data-backup.tar.gz -C /source .
docker run --rm -v postgres-data:/source -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /source .

# Export database
docker compose exec postgres pg_dump -U wikijs wiki > wikijs-db-backup.sql
```

**Recommended:** Use Git sync for automatic content backup.

## Restore

```bash
# Restore volumes
docker run --rm -v wiki-data:/target -v $(pwd):/backup alpine tar xzf /backup/wiki-data-backup.tar.gz -C /target
docker run --rm -v postgres-data:/target -v $(pwd):/backup alpine tar xzf /backup/postgres-backup.tar.gz -C /target

# Import database
docker compose exec -T postgres psql -U wikijs wiki < wikijs-db-backup.sql
```

## Upgrading Wiki.js

```bash
# Pull latest image
docker compose pull wiki

# Restart container
docker compose up -d wiki
```

Wiki.js will automatically run database migrations on startup.

## Email Configuration

Configure email in Admin → Mail:

1. **SMTP Settings:**
   - Host: your-smtp-host
   - Port: 587 or 465
   - Secure: TLS/SSL
   - Username: your-email
   - Password: your-password
   - From Address: wiki@example.com

2. **Test Email:**
   - Use "Send Test Email" button
   - Check recipient inbox

## Troubleshooting

### Check logs
```bash
# All services
docker compose logs -f

# Wiki.js only
docker compose logs -f wiki

# PostgreSQL only
docker compose logs -f postgres
```

### Database connection issues
```bash
# Check PostgreSQL health
docker compose exec postgres pg_isready -U wikijs

# Test connection
docker compose exec postgres psql -U wikijs -d wiki -c "SELECT 1"
```

### Reset admin password
```bash
# Access PostgreSQL
docker compose exec postgres psql -U wikijs -d wiki

# Find user ID
SELECT id, email FROM users WHERE email = 'admin@example.com';

# Update password (hash for 'newpassword')
UPDATE users SET password = '$2a$12$...' WHERE id = 1;
```

Or rebuild the container to run setup wizard again.

### Clear cache
```bash
# Restart Wiki.js
docker compose restart wiki
```

## Performance Optimization

### Database Optimization

```bash
# Run VACUUM
docker compose exec postgres psql -U wikijs -d wiki -c "VACUUM ANALYZE"

# Create indexes (if needed)
# Wiki.js creates necessary indexes automatically
```

### Enable Caching

Wiki.js has built-in caching. Additional optimization:

1. Go to Admin → Performance
2. Enable page caching
3. Set cache duration
4. Enable compression

## Security Recommendations

1. **Change default password** in production:
   - PostgreSQL password (in compose.yml)
   - Admin account password

2. **Enable HTTPS** using reverse proxy (Nginx, Traefik, Caddy)

3. **Configure authentication**:
   - Enable two-factor authentication
   - Use OAuth/SAML for enterprise
   - Disable local auth if not needed

4. **Set permissions**:
   - Configure user groups
   - Set page permissions
   - Restrict admin access

5. **Regular updates**:
   ```bash
   docker compose pull
   docker compose up -d
   ```

6. **Enable Git backup**:
   - Automatic content versioning
   - Easy rollback
   - Disaster recovery

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
- Wiki.js: 8080

**Recommended port** (to avoid conflicts): 8320

To change port, edit compose.yml:
```yaml
ports:
  - "8320:3000"
```

## Official Documentation

- Wiki.js: https://js.wiki/
- Documentation: https://docs.requarks.io/
- GitHub: https://github.com/requarks/wiki
- Community: https://github.com/requarks/wiki/discussions
