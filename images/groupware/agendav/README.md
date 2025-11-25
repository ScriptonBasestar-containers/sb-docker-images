# AgenDAV

CalDAV web client for managing calendars and events.

## Why This Image?

[AgenDAV does not provide official Docker images](https://libreselfhosted.com/project/agendav/). Community images are often outdated. This project provides:

- **Alpine-based**: Minimal image size
- **PHP 8.2**: Modern PHP with OPcache
- **Auto-configuration**: Settings from environment variables
- **MariaDB included**: Complete stack in compose.yml
- **CalDAV server agnostic**: Works with Radicale, Baikal, Nextcloud

## Features

- Web-based calendar management
- Multiple calendar support
- Event creation, editing, deletion
- Recurring events
- Calendar sharing (if CalDAV server supports)
- Multi-language support
- Responsive design

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Configure CalDAV server URL in .env
# CALDAV_URL=http://your-caldav-server/

# Generate encryption key
openssl rand -base64 32
# Copy to AGENDAV_ENCRYPTION_KEY in .env

# Start services
make up

# Initialize database (first run only)
make init

# Access AgenDAV
open http://localhost:8300
```

## Configuration

### Essential Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENDAV_PORT` | 8300 | Web interface port |
| `AGENDAV_ENCRYPTION_KEY` | (change me) | Session encryption key |
| `CALDAV_URL` | http://caldav:5232/ | CalDAV server URL |

### AgenDAV Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENDAV_TITLE` | AgenDAV | Site title |
| `AGENDAV_TIMEZONE` | UTC | Default timezone |
| `AGENDAV_LANGUAGE` | en | Default language |
| `AGENDAV_LOG_LEVEL` | WARNING | Log level |

### Database Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | db | Database hostname |
| `DB_DATABASE` | agendav | Database name |
| `DB_USERNAME` | agendav | Database user |
| `DB_PASSWORD` | agendav_password | Database password |

## Commands

```bash
make up       # Start services
make down     # Stop services
make init     # Initialize database (first run)
make logs     # View logs
make shell    # Access container shell
make clean    # Remove all data
```

## Compatible CalDAV Servers

AgenDAV works with any CalDAV-compliant server:

| Server | Type | URL Pattern |
|--------|------|-------------|
| Radicale | Lightweight | `http://server:5232/` |
| Baikal | Feature-rich | `https://server/dav.php/` |
| Nextcloud | Full groupware | `https://server/remote.php/dav/` |
| DAViCal | Enterprise | `https://server/caldav.php/` |
| SOGo | Enterprise | `https://server/SOGo/dav/` |

## With Radicale (Built-in CalDAV)

Uncomment the caldav service in compose.yml:

```yaml
caldav:
  image: tomsquest/docker-radicale:latest
  container_name: agendav-caldav
  ports:
    - "5232:5232"
  volumes:
    - caldav-data:/data
  restart: unless-stopped
```

Then set:
```env
CALDAV_URL=http://caldav:5232/
```

## Architecture

```
┌──────────────────────────────────────────┐
│           AgenDAV Container              │
│  ┌─────────────┐  ┌──────────────┐       │
│  │   nginx     │  │   php-fpm    │       │
│  │   :80       │──│   :9000      │       │
│  └─────────────┘  └──────────────┘       │
└──────────────────────────────────────────┘
         │                    │
         ▼                    ▼
┌─────────────┐       ┌─────────────────┐
│   MariaDB   │       │  CalDAV Server  │
│   :3306     │       │  (external)     │
└─────────────┘       └─────────────────┘
```

## Data Persistence

| Volume | Purpose |
|--------|---------|
| agendav-db | MariaDB database |

Note: Calendar data is stored on the CalDAV server, not in AgenDAV.

## Troubleshooting

### Can't connect to CalDAV server
- Verify CALDAV_URL is correct
- Check if CalDAV server is accessible from container
- Try `docker compose exec agendav curl $CALDAV_URL`

### Login fails
- AgenDAV uses CalDAV server credentials
- Verify username/password on CalDAV server directly

### Database errors
- Run `make init` to initialize/update database schema

## References

- [AgenDAV Documentation](https://agendav.github.io/agendav/)
- [AgenDAV GitHub](https://github.com/agendav/agendav)
- [CalDAV Protocol](https://en.wikipedia.org/wiki/CalDAV)
