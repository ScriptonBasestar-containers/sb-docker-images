# Memcached Docker Setup

High-performance distributed memory object caching system.

## Features

- Official Docker image: `memcached:1.6-alpine`
- Memory limit: 64MB (configurable)
- Port: 11211

## Quick Start

```bash
# Start memcached
docker compose up -d

# View logs
docker compose logs -f

# Stop memcached
docker compose down
```

## Standalone Configuration

완전한 독립 실행 가능한 Memcached 분산 메모리 캐시 시스템 구성이 `standalone/` 디렉토리에 제공됩니다.

### Features

- **Memcached 1.6 Alpine**: 경량화된 공식 이미지
- **환경 변수 지원**: .env 파일을 통한 유연한 설정
- **Health check**: 서비스 상태 모니터링
- **완전한 문서**: 사용법, 프로그래밍 예시, 보안, 모니터링

### Usage

```bash
# standalone 디렉토리로 이동
cd standalone/

# 환경 변수 설정 (선택사항)
cp .env.example .env

# Memcached 시작
make up

# 테스트
make test

# 통계 확인
make stats
```

자세한 내용은 [standalone/README.md](./standalone/README.md)를 참조하세요.

## Configuration

Edit the `command` in `compose.yml` to customize memcached settings:

```yaml
command: memcached -m 128  # Set memory to 128MB
```

Common options:
- `-m <num>`: Maximum memory in megabytes (default: 64)
- `-c <num>`: Max simultaneous connections (default: 1024)
- `-v`: Verbose output
- `-vv`: Very verbose output

## Testing Connection

```bash
# Using telnet
telnet localhost 11211

# Or using nc
echo "stats" | nc localhost 11211
```

## Official Documentation

- Docker Hub: https://hub.docker.com/_/memcached
- Memcached: https://memcached.org/
