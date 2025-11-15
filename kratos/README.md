# Ory Kratos

Ory Kratos 인증/사용자 관리 시스템 테스트 환경

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

Kratos 설정은 `../buildbox/config/kratos/` 참조:
- `kratos.dev.yml`: 개발 환경
- `kratos.prd.yml`: 프로덕션 환경

## 📝 Notes

- 이 프로젝트는 테스트/개발용입니다
- 프로덕션 사용 시 보안 설정 검토 필수

## 📚 References

- [Ory Kratos Official](https://www.ory.sh/kratos/)
- [Ory Kratos GitHub](https://github.com/ory/kratos)
