# Rhymix

Korean open source CMS forked from XpressEngine.

## Why This Image?

[Rhymix does not provide official Docker images](https://github.com/rhymix/rhymix). This project provides:

- **Alpine-based**: Minimal image size
- **PHP 8.2**: Modern PHP with OPcache
- **Korean optimized**: UTF-8, Asia/Seoul timezone
- **MariaDB included**: Complete stack in compose.yml

## Features

- XpressEngine 호환 모듈/애드온 지원
- 강력한 게시판 시스템
- SEO 최적화
- 반응형 디자인 지원
- 다국어 지원 (한국어 기본)
- 보안 강화 (XSS, CSRF 방어)

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Start services
make up

# Access Rhymix
open http://localhost:8310
```

## Configuration

### Essential Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `RHYMIX_PORT` | 8310 | Web interface port |
| `RHYMIX_BRANCH` | master | GitHub branch to use |
| `PHP_VERSION` | 8.2 | PHP version |

> Note: Rhymix does not publish official releases. This image uses the master branch from GitHub.

### Database Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `DB_DATABASE` | rhymix | Database name |
| `DB_USERNAME` | rhymix | Database user |
| `DB_PASSWORD` | rhymix_password | Database password |

## Installation

1. Start services: `make up`
2. Access http://localhost:8310
3. Follow the installation wizard
4. Database settings:
   - **Host**: db
   - **Port**: 3306
   - **Database**: rhymix
   - **Username**: rhymix
   - **Password**: rhymix_password
   - **Table Prefix**: rx_ (recommended)

## Commands

```bash
make up       # Start services
make down     # Stop services
make build    # Build image
make logs     # View logs
make shell    # Access container shell
make clean    # Remove all data
```

## Architecture

```
┌──────────────────────────────────────────┐
│           Rhymix Container               │
│  ┌─────────────┐  ┌──────────────┐       │
│  │   nginx     │  │   php-fpm    │       │
│  │   :80       │──│   :9000      │       │
│  └─────────────┘  └──────────────┘       │
└──────────────────────────────────────────┘
         │
         ▼
┌─────────────────┐
│    MariaDB      │
│    :3306        │
└─────────────────┘
```

## Data Persistence

| Volume | Purpose |
|--------|---------|
| rhymix-files | Uploaded files, cache |
| rhymix-db | MariaDB database |

## Korean PHP CMS Comparison

| CMS | Base | Features | Status |
|-----|------|----------|--------|
| Gnuboard5 | PHP | 게시판 중심 | Active |
| Gnuboard6 | PHP | 프레임워크 기반 | Active |
| Rhymix | XE 포크 | 모듈/애드온 시스템 | Active |
| XpressEngine | PHP | 레거시 | Deprecated |

## Troubleshooting

### Installation fails
- Verify database connection settings
- Check container logs: `make logs`

### Permission issues
- The files directory should be writable
- Container runs as www-data user

### Memory errors
- Increase PHP memory_limit in php.ini
- Default is 256M, can be increased

## References

- [Rhymix GitHub](https://github.com/rhymix/rhymix)
- [Rhymix Manual](https://rhymix.org/manual)
- [XpressEngine to Rhymix Migration](https://rhymix.org/manual/migration)
