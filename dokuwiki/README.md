# DokuWiki Docker Setup

Simple to use and highly versatile Open Source wiki software that doesn't require a database.

## Features

- Official Docker image: `dokuwiki/dokuwiki:stable`
- File-based storage (no database required)
- Admin user pre-configured
- Port: 8080

## Quick Start

```bash
# Start DokuWiki
docker compose up -d

# View logs
docker compose logs -f

# Access DokuWiki
# Open http://localhost:8080 in your browser

# Stop DokuWiki
docker compose down
```

## Default Credentials

- **Username**: admin
- **Password**: passw0rd
- **Email**: admin@example.com

**⚠️ Important**: Change the default password after first login!

## Configuration

Edit environment variables in `compose.yml`:

```yaml
environment:
  - DOKUWIKI_ADMIN_USER=admin
  - DOKUWIKI_ADMIN_PASS=YOUR_SECURE_PASSWORD
  - DOKUWIKI_ADMIN_NAME=Administrator
  - DOKUWIKI_ADMIN_EMAIL=admin@yourdomain.com
  - DOKUWIKI_WIKI_TITLE=Your Wiki Title
```

## Data Persistence

All wiki data is stored in the `dokuwiki-storage` volume:
- Pages
- Media files
- Configuration
- Plugins

To backup:

```bash
docker run --rm -v dokuwiki-storage:/source -v $(pwd):/backup alpine tar czf /backup/dokuwiki-backup.tar.gz -C /source .
```

To restore:

```bash
docker run --rm -v dokuwiki-storage:/target -v $(pwd):/backup alpine tar xzf /backup/dokuwiki-backup.tar.gz -C /target
```

## Plugins and Templates

Access the container shell to install plugins:

```bash
make shell
# or
docker compose exec dokuwiki sh
```

## Available Tags

- `stable` - Latest stable release (recommended)
- `latest` - Alias for stable
- `oldstable` - Previous stable release
- `master` - Development version

## Official Documentation

- Docker Hub: https://hub.docker.com/r/dokuwiki/dokuwiki
- GitHub: https://github.com/dokuwiki/docker
- DokuWiki: https://www.dokuwiki.org/
