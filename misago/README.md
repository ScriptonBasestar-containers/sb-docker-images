# Misago

Misago 포럼 소프트웨어 테스트 환경

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
├── compose-simple.yml # 간단한 구성
└── README.md         # This file
```

## 🔧 Configuration

환경변수 설정:
- `POSTGRES_PASSWORD`: 데이터베이스 비밀번호
- `SECRET_KEY`: Django 시크릿 키

## 📝 Notes

- 이 프로젝트는 테스트/개발용입니다
- Python/Django 기반 포럼

## 📚 References

- [Misago Official](https://misago-project.org/)
- [Misago GitHub](https://github.com/rafalp/Misago)
