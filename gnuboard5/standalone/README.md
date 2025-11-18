# GNUboard5 Standalone Docker Setup

Complete standalone GNUboard5 setup with MariaDB.

## Features

- **GNUboard5**: Custom built PHP-FPM image with required extensions
- **Nginx**: Web server (Alpine-based)
- **MariaDB**: Database server with health check

## Quick Start

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Access GNUboard5
# Open http://localhost:8080 in your browser
```

## Installation

1. Build and start the containers:
   ```bash
   docker compose up -d --build
   ```

2. Wait for the services to initialize:
   ```bash
   docker compose logs -f php
   ```

3. Open http://localhost:8080/install in your browser

4. Follow the installation wizard:
   - **DB 호스트**: mariadb
   - **DB 이름**: db01
   - **DB 사용자**: user01
   - **DB 비밀번호**: passw0rd
   - **테이블 접두사**: g5_ (기본값)

5. Enter administrator information:
   - 관리자 ID
   - 관리자 비밀번호
   - 관리자 이메일

6. Complete installation

7. **중요**: 설치 완료 후 install 디렉토리 삭제:
   ```bash
   docker compose exec php rm -rf /var/www/html/install
   ```

## Database Connection

Pre-configured via environment variables:

- **Host**: mariadb
- **Port**: 3306 (internal)
- **Database**: db01
- **Username**: user01
- **Password**: passw0rd
- **Root Password**: rootpass

## Administration

### Admin Panel

Access the admin panel at: http://localhost:8080/adm

### File Permissions

GNUboard5 requires specific file permissions for data and upload directories:

```bash
# Set permissions (if needed)
docker compose exec php chmod 707 /var/www/html/data
docker compose exec php chmod 707 /var/www/html/data/cache
docker compose exec php chmod 707 /var/www/html/data/session
docker compose exec php chmod 707 /var/www/html/data/file
```

## Common Tasks

### Install Themes

1. Download theme files
2. Upload to `/var/www/html/theme/` directory
3. Activate in Admin → 환경설정 → 기본환경설정

### Install Plugins

1. Download plugin files
2. Upload to `/var/www/html/plugin/` directory
3. Activate in Admin → 플러그인 관리

### Skin Management

Skins are located in:
- Board skins: `/var/www/html/skin/board/`
- Member skins: `/var/www/html/skin/member/`
- New post skins: `/var/www/html/skin/new/`
- Search skins: `/var/www/html/skin/search/`

## Data Persistence

All data is stored in named volumes:
- `gnuboard5-data`: GNUboard5 files, uploads, and data
- `mariadb-data`: Database data

## Backup

```bash
# Backup volumes
docker run --rm -v gnuboard5-data:/source -v $(pwd):/backup alpine tar czf /backup/gnuboard5-backup.tar.gz -C /source .
docker run --rm -v mariadb-data:/source -v $(pwd):/backup alpine tar czf /backup/mariadb-backup.tar.gz -C /source .

# Export database
docker compose exec mariadb mysqldump -u root -prootpass db01 > gnuboard5-db-backup.sql
```

## Restore

```bash
# Restore volumes
docker run --rm -v gnuboard5-data:/target -v $(pwd):/backup alpine tar xzf /backup/gnuboard5-backup.tar.gz -C /target
docker run --rm -v mariadb-data:/target -v $(pwd):/backup alpine tar xzf /backup/mariadb-backup.tar.gz -C /target

# Import database
docker compose exec -T mariadb mysql -u root -prootpass db01 < gnuboard5-db-backup.sql
```

## Upgrading GNUboard5

### 방법 1: 수동 업그레이드

1. Download latest GNUboard5
2. Extract files
3. Upload to container:
   ```bash
   docker cp /path/to/gnuboard5/* gnuboard5:/var/www/html/
   ```
4. Set permissions
5. Run upgrade script: http://localhost:8080/install

### 방법 2: 이미지 재빌드

1. Update source files
2. Rebuild image:
   ```bash
   docker compose up -d --build
   ```

## Troubleshooting

### Check logs
```bash
# All services
docker compose logs -f

# GNUboard5 PHP logs
docker compose logs -f php

# Nginx logs
docker compose logs -f nginx

# MariaDB logs
docker compose logs -f mariadb
```

### Database connection issues
```bash
# Check MariaDB health
docker compose exec mariadb healthcheck.sh --connect --innodb_initialized

# Test connection
docker compose exec mariadb mysql -u user01 -ppassw0rd db01 -e "SELECT 1"
```

### File permission issues
```bash
# Fix permissions
docker compose exec php chown -R www-data:www-data /var/www/html
docker compose exec php chmod 707 /var/www/html/data
```

### Cannot access install page
```bash
# Check if install directory exists
docker compose exec php ls -la /var/www/html/install

# If missing, extract GNUboard5 again
```

## Security Recommendations

1. **Change default passwords** in production:
   - MariaDB passwords (in compose.yml)
   - Admin account password

2. **Enable HTTPS** using reverse proxy (Nginx, Traefik, Caddy)

3. **Delete install directory** after installation:
   ```bash
   docker compose exec php rm -rf /var/www/html/install
   ```

4. **Set strong admin password**

5. **Regular updates**:
   - Keep GNUboard5 updated
   - Apply security patches

6. **Restrict admin access**:
   - Use strong passwords
   - Limit admin IP access
   - Enable two-factor authentication (via plugin)

## Performance Optimization

### PHP-FPM Optimization

Edit Dockerfile to adjust PHP-FPM settings:
```dockerfile
RUN echo "pm.max_children = 50" >> /usr/local/etc/php-fpm.d/www.conf
RUN echo "pm.start_servers = 10" >> /usr/local/etc/php-fpm.d/www.conf
```

### Database Optimization

```bash
# Run VACUUM
docker compose exec mariadb mysql -u root -prootpass db01 -e "OPTIMIZE TABLE g5_board_new, g5_write_notice"
```

### Enable Caching

Install caching plugins in Admin panel:
- OPcache (built-in PHP extension)
- File-based cache
- Memory cache plugins

## Clean Up

```bash
# Stop and remove containers (keeps volumes)
docker compose down

# Remove everything including volumes
docker compose down -v
```

## Port Information

See [PORT_GUIDE.md](../../PORT_GUIDE.md) for port allocation strategy.

**Default ports:**
- GNUboard5: 8080

**Recommended port**: 8200

To change port, edit compose.yml:
```yaml
nginx:
  ports:
    - "8200:80"
```

Also update G5_DOMAIN environment variable:
```yaml
environment:
  - G5_DOMAIN=localhost:8200
```

## Official Resources

- GNUboard5: https://www.gnuboard.kr/
- Community: https://sir.kr/
- Plugins: https://sir.kr/g5_plugin
- Themes: https://sir.kr/g5_skin

## Korean Language Support

GNUboard5 is primarily designed for Korean users and includes:
- Korean language interface
- Korean character encoding (UTF-8)
- Korean community support
- Korean payment gateway integration
