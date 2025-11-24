# Outline - Modern Team Knowledge Base

Open-source wiki and knowledge base for growing teams.

## Features

- **Modern UI**: Beautiful, fast, and intuitive interface
- **Real-time Collaboration**: Collaborative editing with live updates
- **Rich Editor**: Markdown-based editor with slash commands
- **Integrations**: Slack, Google, Azure AD authentication
- **Search**: Fast full-text search
- **API**: RESTful API for automation

## Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Generate secret keys
openssl rand -hex 32  # Copy to SECRET_KEY
openssl rand -hex 32  # Copy to UTILS_SECRET

# 3. Edit .env file
vim .env

# 4. Start services
docker compose up -d

# 5. Access Outline
# Open http://localhost:3000
```

## Configuration

### Required Environment Variables

- `SECRET_KEY`: Random secret for encryption (generate with `openssl rand -hex 32`)
- `UTILS_SECRET`: Another random secret (generate with `openssl rand -hex 32`)
- `URL`: Public URL where Outline will be accessed

### Optional: Slack Authentication

1. Create a Slack App: https://api.slack.com/apps
2. Add OAuth redirect URL: `{URL}/auth/slack.callback`
3. Copy Client ID and Secret to `.env`

### Optional: SMTP Email

Configure SMTP settings in `.env` for:
- Email notifications
- Password reset
- Invitations

## Services

- **outline**: Main application (Port 3000)
- **postgres**: PostgreSQL database
- **redis**: Cache and session storage

## Data Persistence

All data is stored in Docker volumes:
- `postgres-data`: Database files
- `redis-data`: Cache data
- `outline-data`: Uploaded files

## Backup

```bash
# Backup database
docker compose exec postgres pg_dump -U outline outline > backup.sql

# Backup uploads
docker compose exec outline tar czf - /var/lib/outline/data > uploads.tar.gz
```

## Upgrade

```bash
# Pull latest images
docker compose pull

# Restart services
docker compose up -d
```

## Troubleshooting

### Cannot access Outline

Check if all services are running:
```bash
docker compose ps
docker compose logs outline
```

### Database connection error

Ensure PostgreSQL is healthy:
```bash
docker compose exec postgres pg_isready -U outline
```

## Documentation

- Official Docs: https://docs.getoutline.com
- GitHub: https://github.com/outline/outline
- Community: https://community.getoutline.com

## License

Outline is licensed under the Business Source License (BSL).
