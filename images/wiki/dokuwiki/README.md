# DokuWiki

DokuWiki는 데이터베이스가 필요 없는 간단하고 다재다능한 오픈소스 위키 소프트웨어입니다. 파일 기반 저장소를 사용하여 설치와 유지보수가 매우 간단합니다.

> 💡 **Quick Start**: For production deployment, use the [standalone setup](standalone/README.md) - it includes enhanced configuration and comprehensive documentation!

## 개요

DokuWiki는 다음과 같은 기능을 제공합니다:
- 📁 파일 기반 저장소 (데이터베이스 불필요)
- 🔒 강력한 ACL (접근 제어 목록)
- 📝 Markdown 및 다양한 문법 지원
- 🔌 풍부한 플러그인 생태계
- 🎨 테마 커스터마이징
- 📱 모바일 반응형 디자인
- 🌍 50개 이상 언어 지원
- 🔍 전문 검색 기능

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup with enhanced features:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ DokuWiki (dokuwiki/dokuwiki:stable)
- ✅ Environment variable configuration
- ✅ Health checks
- ✅ Standardized Makefile
- ✅ Comprehensive README with production guide

**Access:** http://localhost:8130

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide, plugin installation, and production deployment checklist.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Uses minimal configuration.

## Quick Start (Basic Setup)

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

## Default Credentials

- **Username**: admin
- **Password**: passw0rd
- **Email**: admin@example.com

**⚠️ Important**: Change the default password after first login!

## Configuration

### Using Environment Variables (Recommended)

Create a `.env` file to customize settings:

```bash
# Copy example file
cp .env.example .env

# Edit with your values
DOKUWIKI_ADMIN_USER=admin
DOKUWIKI_ADMIN_PASS=YOUR_SECURE_PASSWORD
DOKUWIKI_ADMIN_NAME=Administrator
DOKUWIKI_ADMIN_EMAIL=admin@yourdomain.com
DOKUWIKI_WIKI_TITLE=Your Wiki Title
DOKUWIKI_PORT=8130
TZ=Asia/Seoul
```

### Direct compose.yml Edit (Alternative)

You can also edit environment variables directly in `compose.yml`:

```yaml
environment:
  - DOKUWIKI_ADMIN_USER=admin
  - DOKUWIKI_ADMIN_PASS=YOUR_SECURE_PASSWORD
  - DOKUWIKI_ADMIN_NAME=Administrator
  - DOKUWIKI_ADMIN_EMAIL=admin@yourdomain.com
  - DOKUWIKI_WIKI_TITLE=Your Wiki Title
```

## Makefile Commands

Common commands for managing DokuWiki (when using standalone setup):

```bash
make help     # Show available commands
make up       # Start DokuWiki
make down     # Stop DokuWiki
make restart  # Restart DokuWiki
make logs     # View logs (real-time)
make ps       # List running containers
make shell    # Access container shell
make clean    # Remove all data (with confirmation)
```

For basic setup without Makefile, use `docker compose` commands directly.

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

## Port Information

See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation strategy.

**Default port:**
- DokuWiki: 8130

To change the port, create a `.env` file (copy from `.env.example`) and modify:
```bash
DOKUWIKI_PORT=8130  # Change to your preferred port
```

## Official Documentation

- Docker Hub: https://hub.docker.com/r/dokuwiki/dokuwiki
- GitHub: https://github.com/dokuwiki/docker
- DokuWiki: https://www.dokuwiki.org/
