# Rocket.Chat - Open Source Team Communication

Feature-rich team chat platform with powerful integrations and apps.

## Features

- **Team Messaging**: Channels, direct messages, threads
- **Voice & Video**: Audio/video calls and conferencing
- **File Sharing**: Share files with drag and drop
- **Screen Sharing**: Share screen during calls
- **Apps & Integrations**: Extensive app marketplace
- **Omnichannel**: Customer support integration
- **Mobile Apps**: iOS and Android native apps
- **Federation**: Connect with other Rocket.Chat servers

## Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit configuration (set ADMIN_PASS)
vim .env

# 3. Start services
docker compose up -d

# 4. Wait for services to be ready (1-2 minutes)
docker compose logs -f rocketchat

# 5. Access Rocket.Chat
# Open http://localhost:3000
```

## Initial Setup

1. Open http://localhost:3000 in your browser
2. Wait for initialization to complete
3. Login with admin credentials from `.env`
4. Complete the setup wizard (or skip if `SHOW_SETUP_WIZARD=completed`)

## Configuration

### Required Settings

- `MONGO_USER`: MongoDB username
- `MONGO_PASSWORD`: MongoDB password
- `ROOT_URL`: Public URL where Rocket.Chat will be accessed
- `ADMIN_PASS`: Initial admin password (set before first start)

### Admin Account

Default admin account is created on first startup:
- Username: from `ADMIN_USERNAME` (default: admin)
- Email: from `ADMIN_EMAIL`
- Password: from `ADMIN_PASS` (must set in `.env`)

### Email Configuration

Set `MAIL_URL` in format:
```
smtp://username:password@smtp.example.com:587
```

Example for Gmail:
```
smtp://your-email@gmail.com:app-password@smtp.gmail.com:587
```

## Services

- **rocketchat**: Main application (Port 3000)
- **mongodb**: MongoDB database with replica set
- **mongodb-init-replica**: One-time replica set initialization

## Data Persistence

All data is stored in Docker volumes:
- `mongodb-data`: Database files
- `mongodb-config`: MongoDB configuration
- `rocketchat-uploads`: Uploaded files and avatars

## Apps & Integrations

### Marketplace Apps

1. Go to Administration → Apps → Marketplace
2. Browse and install apps
3. Configure app settings

### Webhooks

- Incoming Webhooks: Receive messages from external services
- Outgoing Webhooks: Send messages to external services

### Bots

Create bot users for automation:
1. Administration → Users → New User
2. Set role to "bot"
3. Use API token for authentication

## Mobile Apps

- **iOS**: https://apps.apple.com/app/rocket-chat/id1148741252
- **Android**: https://play.google.com/store/apps/details?id=chat.rocket.android

Configure server URL: Your `ROOT_URL` value

## Backup

```bash
# Backup database
docker compose exec mongodb mongodump --username=root --password=rocketchat --out=/tmp/backup
docker compose cp mongodb:/tmp/backup ./backup

# Backup uploads
docker compose exec rocketchat tar czf - /app/uploads > uploads-backup.tar.gz
```

## Restore

```bash
# Restore database
docker compose cp ./backup mongodb:/tmp/backup
docker compose exec mongodb mongorestore --username=root --password=rocketchat /tmp/backup

# Restore uploads
docker compose exec -T rocketchat tar xzf - -C / < uploads-backup.tar.gz
```

## Upgrade

```bash
# Pull latest image
docker compose pull rocketchat

# Restart service
docker compose up -d rocketchat
```

## Performance Tuning

For production use:
1. Increase MongoDB oplog size in `compose.yml`
2. Use external MongoDB for better performance
3. Enable CDN for file uploads
4. Configure Redis for sessions (optional)

## Troubleshooting

### Services not starting

Check MongoDB replica set initialization:
```bash
docker compose logs mongodb-init-replica
```

### Cannot login

Verify admin password is set in `.env`:
```bash
grep ADMIN_PASS .env
```

### Upload errors

Check volume permissions:
```bash
docker compose exec rocketchat ls -la /app/uploads
```

## Federation

Connect your Rocket.Chat server with others:
1. Administration → Federation
2. Enable federation
3. Exchange federation keys with other servers

## Documentation

- Official Docs: https://docs.rocket.chat
- GitHub: https://github.com/RocketChat/Rocket.Chat
- Community: https://open.rocket.chat

## License

Rocket.Chat is licensed under MIT License.
