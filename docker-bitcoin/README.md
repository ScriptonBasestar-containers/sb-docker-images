# Bitcoin Node

Bitcoin Core 노드 테스트 환경

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

Bitcoin Core 설정 파일 참조

## 📝 Notes

- 이 프로젝트는 테스트/개발용입니다
- 실제 비트코인 네트워크 연결 주의

## 📚 References

- [Bitcoin Core](https://bitcoin.org/en/bitcoin-core/)
- [Bitcoin Core Docker](https://github.com/bitcoin/bitcoin)
