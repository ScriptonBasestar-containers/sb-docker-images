# Wiki.js

Wiki.js 위키 시스템 테스트 환경

## 🚀 Quick Start

### Prerequisites
- Docker
- Docker Compose V2

### Build & Run
```bash
# Build images
docker compose build

# Start services
docker compose up -d

# Check logs
docker compose logs -f

# Stop services
docker compose down
```

## 📁 Structure

```
.
├── compose.yml        # Docker Compose configuration
└── README.md         # This file
```

## 🔧 Configuration

환경변수 설정:
- `DB_TYPE`: 데이터베이스 타입 (postgres, mysql, sqlite)
- `DB_HOST`: 데이터베이스 호스트

## 📝 Notes

- 이 프로젝트는 테스트/개발용입니다
- 현대적인 Wiki 플랫폼

## 📚 References

- [Wiki.js Official](https://js.wiki/)
- [Wiki.js GitHub](https://github.com/Requarks/wiki)
- [Wiki.js Docker Hub](https://hub.docker.com/r/requarks/wiki)
