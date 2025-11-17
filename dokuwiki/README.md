# DokuWiki Docker Setup

Simple to use and highly versatile Open Source wiki software that doesn't require a database.

## Features

- Official Docker image: `dokuwiki/dokuwiki:stable`
- File-based storage (no database required)
- Admin user pre-configured
- Port: 8130 (configurable via `DOKUWIKI_PORT`)

## Quick Start

```bash
# Start DokuWiki
docker compose up -d

# View logs
docker compose logs -f

# Access DokuWiki
# Open http://localhost:8130 in your browser

# Stop DokuWiki
docker compose down
```

## Standalone Configuration

완전한 독립 실행 가능한 DokuWiki 위키 시스템 구성이 `standalone/` 디렉토리에 제공됩니다.

### Features

- **공식 이미지**: dokuwiki/dokuwiki:stable
- **파일 기반**: 데이터베이스 불필요
- **환경 변수 지원**: .env 파일을 통한 유연한 설정
- **Health check**: 서비스 상태 모니터링
- **완전한 문서**: 사용법, 플러그인, ACL, 백업/복원, 문제 해결

### Usage

```bash
# standalone 디렉토리로 이동
cd standalone/

# 환경 변수 설정
cp .env.example .env
# .env 파일에서 DOKUWIKI_ADMIN_PASS 수정

# DokuWiki 시작
make up

# 웹 브라우저에서 접속
# http://localhost:8130
```

자세한 내용은 [standalone/README.md](./standalone/README.md)를 참조하세요.

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
