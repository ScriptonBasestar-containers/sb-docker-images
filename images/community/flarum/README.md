# Flarum

> 💡 **Quick Start**: For production deployment with MariaDB and Redis, use the [standalone setup](standalone/README.md) - it includes all services and comprehensive documentation!

## 개요

Flarum은 현대적이고 우아한 포럼 소프트웨어입니다. 커뮤니티가 유지 관리하는 Docker 이미지를 사용합니다:
- 🎨 현대적이고 우아한 디자인
- ⚡ 빠르고 가벼운 성능
- 📱 완전한 모바일 반응형
- 🔌 풍부한 확장 기능 (Extensions)
- 🎭 커스터마이징 가능한 테마
- 🌐 다국어 지원
- 🔍 강력한 검색 기능
- 👥 사용자 권한 관리

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Flarum (mondedie/flarum:stable)
- ✅ MariaDB 11.8 with health check
- ✅ Redis 7 for session/cache
- ✅ Network isolation (app-network, data-network)
- ✅ Standardized Makefile with helpful commands
- ✅ Environment variable configuration (.env.example)

**Access:** http://localhost:8140

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Includes additional development tools.

#### Web Server Variants

이 디렉토리는 두 가지 웹서버 구성을 제공합니다 (**하나만 선택하여 사용**):

**1. Apache 변형 (권장 - 초보자용)**
```bash
docker compose -f compose.apache.yml up -d
```
- ✅ Apache 웹서버 내장
- ✅ 간단한 설정 (단일 컨테이너)
- ✅ 초보자에게 권장
- 📦 빌드: `flarum-apache.dockerfile`

**2. Nginx 변형 (고급 사용자용)**
```bash
docker compose -f compose.nginx.yml up -d
```
- ✅ Nginx + PHP-FPM 분리 아키텍처
- ✅ 고성능 처리
- ✅ 세밀한 설정 가능
- 📦 빌드: `flarum-fpm.dockerfile`

**⚠️ 포트 충돌 주의:**
- 두 구성 모두 포트 **8140**을 사용합니다
- **동시에 실행하지 마세요**
- 하나를 선택하여 사용하세요

**기본 설정 (compose.yml):**
- 개발 도구 포함: phpMyAdmin, MailHog
- Apache 기반 구성
- 추가 개발 도구와 함께 사용

## Default Configuration

**Default port:** 8140 (see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** flarum

**Additional Services:**
- phpMyAdmin (port 8081) - Database management interface
- MailHog (port 8025) - Email testing tool

Environment variables:
```bash
FLARUM_PORT=8140          # Web server port
MARIADB_ROOT_PASSWORD=rootpass
MARIADB_DATABASE=db01
MARIADB_USER=user01
MARIADB_PASSWORD=passw0rd
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8140 | flarum | Flarum web server |
| 8081 | phpmyadmin | Database management |
| 8025 | mailhog | Email testing UI |
| 1025 | mailhog | SMTP server |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## Default Credentials

Pre-configured via environment variables:

- **Admin Username**: admin
- **Admin Password**: password
- **Admin Email**: admin@example.com

**⚠️ Important**: Change these credentials after installation!

## Database Connection

The database is automatically configured:

- **Host**: mariadb
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Table Prefix**: flarum_
- **Root Password**: rootpass

## Additional Services

### phpMyAdmin
- URL: http://localhost:8081
- Username: root
- Password: rootpass

### MailHog (Email Testing)
- Web UI: http://localhost:8025
- SMTP: localhost:1025

Configure Flarum to use MailHog for email testing:
- SMTP Host: mailhog
- SMTP Port: 1025
- Encryption: None

## Data Persistence

All data is stored in named volumes:
- `flarum-data`: Flarum files, extensions, assets
- `mariadb-data`: Database data

## Extensions

To install extensions, access the container:

```bash
make shell
# or
docker compose exec flarum bash

# Install extension
cd /flarum/app
composer require vendor/extension-name
php flarum cache:clear
```

Popular extensions:
- `fof/upload` - File upload
- `fof/pages` - Static pages
- `flarum/tags` - Tag system
- `flarum/mentions` - User mentions

Extension lists:
- https://discuss.flarum.org/d/1534-extension-list
- https://github.com/realodix/awesome-flarum

## Themes

Install custom themes:

```bash
composer require vendor/theme-name
php flarum cache:clear
```

Theme resources:
- https://www.knthost.com/flarum/install-flarum-themes
- https://github.com/afrux/flarum-theme-base

## Backup

```bash
# Backup volumes
docker run --rm -v flarum-data:/source -v $(pwd):/backup alpine tar czf /backup/flarum-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > flarum-db-backup.sql
```

## Restore

```bash
# Restore volumes
docker run --rm -v flarum-data:/target -v $(pwd):/backup alpine tar xzf /backup/flarum-backup.tar.gz -C /target

# Import database
docker compose exec -T mariadb mysql -u root -prootpass db01 < flarum-db-backup.sql
```

## Troubleshooting

### Clear cache
```bash
docker compose exec flarum php flarum cache:clear
```

### Check logs
```bash
make logs-flarum
make logs-mariadb
```

### Reset permissions
```bash
docker compose exec flarum chown -R www-data:www-data /flarum/app
```

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
make clean
```

## References

- Flarum: https://flarum.org/
- Docker Image: https://github.com/mondediefr/docker-flarum
- Flarum GitHub: https://github.com/flarum/flarum
- Flarum Community: https://discuss.flarum.org/
