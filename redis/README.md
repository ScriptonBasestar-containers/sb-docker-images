# Redis Docker Setup

The world's fastest data platform for caching, vector search, and NoSQL databases.

## Features

- Official Docker image: `redis:7-alpine`
- Persistence enabled (AOF)
- Password protection: `passw0rd` (change in production)
- Port: 6379
- Health check enabled

## Quick Start

```bash
# Start Redis
docker compose up -d

# View logs
docker compose logs -f

# Access Redis CLI
make cli
# or
docker compose exec redis redis-cli -a passw0rd

# Stop Redis
docker compose down
```

## Standalone Configuration

완전한 독립 실행 가능한 Redis In-Memory 데이터 저장소 구성이 `standalone/` 디렉토리에 제공됩니다.

### Features

- **Redis 7 Alpine**: 경량화된 공식 이미지
- **AOF Persistence**: 데이터 영구 저장
- **환경 변수 지원**: .env 파일을 통한 유연한 설정
- **Health check**: 서비스 상태 모니터링
- **완전한 문서**: 데이터 타입, 사용 사례, 모니터링, 성능 최적화

### Usage

```bash
# standalone 디렉토리로 이동
cd standalone/

# 환경 변수 설정
cp .env.example .env
# .env 파일에서 REDIS_PASSWORD 수정

# Redis 시작
make up

# 연결 테스트
make ping

# Redis CLI 접속
make cli
```

자세한 내용은 [standalone/README.md](./standalone/README.md)를 참조하세요.

## Configuration

The Redis server is configured with:
- `--appendonly yes`: Enable AOF persistence
- `--requirepass passw0rd`: Password authentication

### Change Password

Edit the `command` in `compose.yml`:

```yaml
command: redis-server --appendonly yes --requirepass YOUR_NEW_PASSWORD
```

### Additional Configuration

Create a `redis.conf` file and mount it:

```yaml
volumes:
  - redis-data:/data
  - ./redis.conf:/usr/local/etc/redis/redis.conf
command: redis-server /usr/local/etc/redis/redis.conf
```

## Testing Connection

```bash
# Test connection
make test

# Or manually
docker compose exec redis redis-cli -a passw0rd ping
# Should return: PONG

# Set and get a value
docker compose exec redis redis-cli -a passw0rd set mykey "Hello"
docker compose exec redis redis-cli -a passw0rd get mykey
# Should return: "Hello"
```

## Persistence

Data is persisted in the `redis-data` volume. To backup:

```bash
# Backup
docker compose exec redis redis-cli -a passw0rd BGSAVE

# Copy AOF file
docker cp redis:/data/appendonly.aof ./backup/
```

## Official Documentation

- Docker Hub: https://hub.docker.com/_/redis
- Redis Documentation: https://redis.io/docs/
- Docker Official Image Guide: https://www.docker.com/blog/how-to-use-the-redis-docker-official-image/
