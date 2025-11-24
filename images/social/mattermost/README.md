# Mattermost - Open Source Team Collaboration

Self-hosted Slack alternative for team messaging and collaboration.

## Features

- **Team Messaging**: Channels, direct messages, group messaging
- **File Sharing**: Share documents, images, and files
- **Integrations**: Webhooks, slash commands, bot accounts
- **Mobile Apps**: iOS and Android native apps
- **Search**: Full-text search across all messages
- **Security**: Enterprise-grade security features

## Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit configuration
vim .env

# 3. Start services
docker compose up -d

# 4. Access Mattermost
# Open http://localhost:8065

# 5. Create first admin account
# Follow the web setup wizard
```

## Initial Setup

1. Open http://localhost:8065 in your browser
2. Create the first admin account
3. Create a team
4. Invite team members

## Configuration

### Basic Settings

- `SITE_URL`: Public URL where Mattermost will be accessed
- `PORT`: Port to expose Mattermost (default: 8065)
- `ENABLE_OPEN_SERVER`: Allow anyone to create account (true/false)

### Email Notifications

Configure SMTP in `.env` to enable:
- Email invitations
- Email notifications
- Password reset

### Advanced Configuration

After initial setup, configure advanced settings via:
- System Console: `http://localhost:8065/admin_console`
- Or edit `config/config.json` directly

## Services

- **mattermost**: Main application (Port 8065)
- **postgres**: PostgreSQL database

## Data Persistence

All data is stored in Docker volumes:
- `postgres-data`: Database files
- `mattermost-data`: Uploaded files
- `mattermost-config`: Configuration files
- `mattermost-logs`: Application logs
- `mattermost-plugins`: Installed plugins

## Plugins

Install plugins from:
- System Console → Plugin Management
- Or manually place in `mattermost-plugins` volume

## Backup

```bash
# Backup database
docker compose exec postgres pg_dump -U mattermost mattermost > backup.sql

# Backup data directory
docker compose exec mattermost tar czf - /mattermost/data > data-backup.tar.gz

# Backup config
docker compose exec mattermost tar czf - /mattermost/config > config-backup.tar.gz
```

## Upgrade

```bash
# Pull latest image
docker compose pull

# Restart services
docker compose up -d
```

## Mobile Apps

- **iOS**: https://apps.apple.com/app/mattermost/id1257222717
- **Android**: https://play.google.com/store/apps/details?id=com.mattermost.rn

Configure server URL: Your `SITE_URL` value

## Integrations

### Incoming Webhooks

1. Go to Integrations → Incoming Webhooks
2. Create new webhook
3. Use webhook URL in external services

### Slash Commands

1. Go to Integrations → Slash Commands
2. Create custom command
3. Configure trigger and callback URL

## Troubleshooting

### Cannot create account

Check `ENABLE_OPEN_SERVER` setting in `.env`

### Email not working

Verify SMTP settings in `.env` and restart:
```bash
docker compose restart mattermost
```

### Database connection error

Check PostgreSQL health:
```bash
docker compose exec postgres pg_isready -U mattermost
```

## Documentation

- Official Docs: https://docs.mattermost.com
- GitHub: https://github.com/mattermost/mattermost
- Community: https://community.mattermost.com

## License

Mattermost Team Edition is licensed under MIT License.
