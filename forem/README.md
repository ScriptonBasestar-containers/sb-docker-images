# Forem

Forem (DEV Community) 플랫폼 테스트 환경

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
- `FOREM_OWNER_SECRET`: Admin 비밀키

## 📝 Notes

- 이 프로젝트는 테스트/개발용입니다
- 프로덕션 사용 시 보안 설정 검토 필요

## 📚 References

- [Forem Official](https://www.forem.com/)
- [Forem GitHub](https://github.com/forem/forem)
