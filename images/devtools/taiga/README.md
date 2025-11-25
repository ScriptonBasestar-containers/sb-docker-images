# Taiga

Agile project management platform - open source alternative to Jira/Trello.

## Why This Configuration?

[Taiga does not provide simple Docker setup](https://www.ilovefreesoftware.com/26/featured/free-self-hosted-alternatives-to-trello.html). The official docker-taiga repository requires cloning and manual configuration. This project provides:

- **Ready-to-use compose.yml**: All services pre-configured
- **Official images**: Uses `taigaio/*` images from Kaleidos
- **Production-ready**: Health checks, restart policies
- **nginx gateway**: WebSocket support for real-time events

## Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                     nginx (gateway :9000)                     │
└───────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐    ┌──────────────────┐    ┌─────────────┐
│ taiga-front │    │    taiga-back    │    │taiga-events │
│  (Angular)  │    │    (Django)      │    │ (WebSocket) │
└─────────────┘    └──────────────────┘    └─────────────┘
                          │                       │
                          ▼                       ▼
                   ┌─────────────┐         ┌─────────────┐
                   │ PostgreSQL  │         │  RabbitMQ   │
                   │    :5432    │         │   :5672     │
                   └─────────────┘         └─────────────┘
```

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Update settings in .env (IMPORTANT for production!)
# - TAIGA_SECRET_KEY
# - TAIGA_DB_PASSWORD
# - RABBITMQ_PASS

# Start all services
make up

# Wait for services (2-3 minutes)
make status

# Access Taiga
open http://localhost:9000
```

## Default Credentials

| Field | Value |
|-------|-------|
| Username | admin |
| Password | 123123 |

**Change the password immediately after first login!**

## Services

| Service | Image | Purpose |
|---------|-------|---------|
| taiga-gateway | nginx:1.25-alpine | Reverse proxy, static files |
| taiga-front | taigaio/taiga-front | Angular SPA frontend |
| taiga-back | taigaio/taiga-back | Django REST API |
| taiga-async | taigaio/taiga-back | Celery async workers |
| taiga-events | taigaio/taiga-events | WebSocket server |
| taiga-protected | taigaio/taiga-protected | Protected media handler |
| taiga-db | postgres:15-alpine | PostgreSQL database |
| taiga-events-rabbitmq | rabbitmq:3.12-alpine | Message queue |

## Configuration

### Essential Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `TAIGA_PORT` | 9000 | Web interface port |
| `TAIGA_DOMAIN` | localhost:9000 | Domain name |
| `TAIGA_SCHEME` | http | http or https |
| `TAIGA_SECRET_KEY` | (change me) | Django secret key |
| `PUBLIC_REGISTER_ENABLED` | False | Allow public registration |

### Database Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `TAIGA_DB_NAME` | taiga | Database name |
| `TAIGA_DB_USER` | taiga | Database user |
| `TAIGA_DB_PASSWORD` | taiga_password | Database password |

### RabbitMQ Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `RABBITMQ_USER` | taiga | RabbitMQ user |
| `RABBITMQ_PASS` | taiga | RabbitMQ password |

## Commands

```bash
make up          # Start all services
make down        # Stop all services
make status      # Show service health
make logs        # View all logs
make logs-back   # View backend logs only
make shell-back  # Access backend shell
make shell-db    # Access PostgreSQL shell
make clean       # Remove all data (destructive!)
```

## Production Setup

### 1. Generate Secret Key

```bash
python -c "import secrets; print(secrets.token_urlsafe(64))"
```

### 2. Update .env

```env
TAIGA_SCHEME=https
TAIGA_DOMAIN=taiga.example.com
TAIGA_SECRET_KEY=<generated-key>
TAIGA_DB_PASSWORD=<strong-password>
RABBITMQ_PASS=<strong-password>
```

### 3. With Traefik (TLS)

```yaml
services:
  taiga-gateway:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.taiga.rule=Host(`taiga.example.com`)"
      - "traefik.http.routers.taiga.tls.certresolver=letsencrypt"
```

## Resource Requirements

| Level | CPU | RAM | Note |
|-------|-----|-----|------|
| Minimum | 2 cores | 4 GB | Small team (< 10) |
| Recommended | 4 cores | 8 GB | Medium team (10-50) |
| Production | 8 cores | 16 GB | Large team (50+) |

## Data Persistence

| Volume | Purpose |
|--------|---------|
| taiga-db-data | PostgreSQL database |
| taiga-static-data | Static files (CSS, JS) |
| taiga-media-data | User uploads, attachments |
| taiga-rabbitmq-data | RabbitMQ messages |

## Troubleshooting

### Services not starting
```bash
# Check all service logs
make logs

# Check specific service
docker compose logs taiga-back
```

### Database connection errors
```bash
# Verify database is healthy
docker compose exec taiga-db pg_isready

# Check database logs
docker compose logs taiga-db
```

### WebSocket not connecting
- Ensure `TAIGA_DOMAIN` matches your access URL
- Check that events service is running: `docker compose ps taiga-events`

## References

- [Taiga Official](https://www.taiga.io/)
- [Taiga GitHub](https://github.com/kaleidos-ventures/taiga-docker)
- [Taiga Documentation](https://docs.taiga.io/)
