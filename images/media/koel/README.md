# Koel

Personal music streaming server - self-hosted alternative to Spotify/Apple Music.

## Why This Image?

[Koel does not provide official Docker images](https://forum.rockstor.com/t/adding-a-koel-rock-on/5240). Community images are fragmented and often outdated. This project provides:

- **Alpine-based**: Minimal image size
- **ffmpeg included**: Full audio transcoding support
- **PHP 8.2**: Modern PHP with OPcache
- **Redis caching**: Fast response times
- **Worker process**: Background job processing

## Features

- Stream your personal music collection
- Support for MP3, FLAC, AAC, OGG, WAV formats
- Automatic metadata parsing (ID3 tags)
- Album artwork fetching
- Playlist creation
- Mobile-friendly web interface
- Scrobbling to Last.fm (optional)

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Generate APP_KEY
make key
# Copy the output to APP_KEY in .env

# Set your music path in .env
# MUSIC_PATH=/path/to/your/music

# Start services
make up

# Initialize database (first run only)
make init

# Create admin user
make admin

# Scan music library
make sync

# Access Koel
open http://localhost:8290
```

## Initial Setup

1. Generate and set `APP_KEY` in `.env`
2. Configure `MUSIC_PATH` to your music directory
3. Start services: `make up`
4. Initialize: `make init`
5. Create admin: `make admin`
6. Scan library: `make sync`
7. Login at `http://localhost:8290`

## Configuration

### Essential Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `KOEL_PORT` | 8290 | Web interface port |
| `APP_KEY` | (generate) | Laravel encryption key |
| `APP_URL` | http://localhost:8290 | Full access URL |
| `MUSIC_PATH` | ./music | Host path to music library |

### Database Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_HOST` | db | Database hostname |
| `DB_DATABASE` | koel | Database name |
| `DB_USERNAME` | koel | Database user |
| `DB_PASSWORD` | koel_password | Database password |

### Streaming Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `STREAMING_METHOD` | php | php, x-sendfile, x-accel-redirect |

## Commands

```bash
make up       # Start services
make down     # Stop services
make init     # Initialize database (first run)
make admin    # Create admin user
make sync     # Scan music library
make logs     # View logs
make shell    # Access container shell
make clean    # Remove all data (not music!)
```

## Architecture

```
┌───────────────────────────────────────────────────────┐
│                  Koel Container                       │
│  ┌─────────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │   nginx     │  │ php-fpm  │  │  koel-worker     │ │
│  │   :80       │──│  :9000   │  │  (queue jobs)    │ │
│  └─────────────┘  └──────────┘  └──────────────────┘ │
└───────────────────────────────────────────────────────┘
         │                 │                │
         ▼                 ▼                ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   MariaDB   │    │    Redis    │    │   /music    │
│   :3306     │    │    :6379    │    │  (volume)   │
└─────────────┘    └─────────────┘    └─────────────┘
```

## Supported Audio Formats

| Format | Extension | Transcoding |
|--------|-----------|-------------|
| MP3 | .mp3 | Native |
| FLAC | .flac | To MP3/OGG |
| AAC | .aac, .m4a | Native |
| OGG Vorbis | .ogg | Native |
| WAV | .wav | To MP3/OGG |
| WMA | .wma | To MP3/OGG |

## Data Persistence

| Volume | Purpose |
|--------|---------|
| koel-db | MariaDB database |
| koel-redis | Redis cache |
| koel-covers | Album artwork |
| /music | Music files (read-only mount) |

## Production Tips

### Large Libraries (10,000+ tracks)

```bash
# Increase PHP memory limit
docker compose exec koel sed -i 's/memory_limit = 512M/memory_limit = 1024M/' /usr/local/etc/php/conf.d/koel.ini

# Run sync in background
docker compose exec -d koel php artisan koel:sync
```

### nginx X-Accel-Redirect (Recommended)

For better streaming performance, set:
```env
STREAMING_METHOD=x-accel-redirect
```

## Comparison: Koel vs Alternatives

| Feature | Koel | Navidrome | Jellyfin |
|---------|------|-----------|----------|
| Focus | Music | Music | All Media |
| Interface | Modern | Modern | Feature-rich |
| Resources | Low | Very Low | Medium |
| Mobile Apps | Web | Subsonic | Native |
| Best For | Personal use | Large libraries | Home theater |

## Troubleshooting

### Music not appearing
```bash
# Check music path is mounted
docker compose exec koel ls /music

# Re-scan library
make sync

# Check for errors
docker compose logs koel | grep -i error
```

### Slow streaming
- Enable Redis caching
- Use `x-accel-redirect` streaming method
- Check network between host and container

## References

- [Koel Official](https://koel.dev/)
- [Koel GitHub](https://github.com/koel/koel)
- [Koel Documentation](https://docs.koel.dev/)
