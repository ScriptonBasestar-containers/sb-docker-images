# Ethereum Node

Ethereum 노드 테스트 환경

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

Ethereum 노드 설정 파일 참조

## 📝 Notes

- 이 프로젝트는 테스트/개발용입니다
- 실제 Ethereum 네트워크 연결 주의

## 📚 References

- [Go Ethereum](https://geth.ethereum.org/)
- [Ethereum Docker](https://hub.docker.com/r/ethereum/client-go)
