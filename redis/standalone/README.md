# Redis Standalone Configuration

완전한 독립 실행 가능한 Redis In-Memory 데이터 저장소 구성

## 개요

이 standalone 구성은 Redis를 즉시 실행할 수 있도록 구성되어 있습니다. Redis는 고성능 인메모리 데이터베이스로 캐시, 세션 저장, 메시지 큐, 실시간 분석 등 다양한 용도로 사용됩니다.

### 포함된 서비스

- **Redis 7 Alpine**: 경량화된 공식 이미지
- **AOF Persistence**: 데이터 영구 저장
- **Password Authentication**: 보안 강화
- **Health Check**: 서비스 상태 모니터링

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env 파일 생성
cp .env.example .env

# 필수 항목 수정
# - REDIS_PASSWORD: 강력한 비밀번호
```

### 2. Redis 시작

```bash
# 서비스 시작
make up
```

### 3. 연결 테스트

```bash
# Ping 테스트
make ping

# 결과: PONG
```

### 4. Redis CLI 접속

```bash
# Redis CLI 실행
make cli

# 명령어 예시
127.0.0.1:6379> SET mykey "Hello Redis"
OK
127.0.0.1:6379> GET mykey
"Hello Redis"
```

## 사용 가능한 명령어

### 서비스 관리

```bash
# Redis 시작
make up

# Redis 중지
make down

# 로그 확인
make logs

# Redis 재시작
make restart

# 실행 중인 컨테이너 확인
make ps
```

### Redis 명령

```bash
# Redis CLI 접속
make cli

# 실시간 명령어 모니터링
make monitor

# Redis 정보 확인
make info

# 연결 테스트
make ping
```

### 백업 및 복원

```bash
# Redis 데이터 백업
make backup

# 백업에서 복원
make restore
```

### 데이터 정리

```bash
# 모든 데이터 삭제 (⚠️ 주의: 복구 불가능)
make clean
```

## Redis 주요 기능

### 데이터 타입

Redis는 다양한 데이터 구조를 지원합니다:

**1. Strings (문자열)**
```bash
SET key "value"
GET key
INCR counter
DECR counter
EXPIRE key 60  # 60초 후 만료
```

**2. Lists (리스트)**
```bash
LPUSH mylist "first"
RPUSH mylist "last"
LRANGE mylist 0 -1  # 전체 조회
LPOP mylist
```

**3. Sets (집합)**
```bash
SADD myset "member1"
SADD myset "member2"
SMEMBERS myset
SISMEMBER myset "member1"
```

**4. Hashes (해시)**
```bash
HSET user:1000 name "John"
HSET user:1000 email "john@example.com"
HGET user:1000 name
HGETALL user:1000
```

**5. Sorted Sets (정렬된 집합)**
```bash
ZADD leaderboard 100 "player1"
ZADD leaderboard 200 "player2"
ZRANGE leaderboard 0 -1 WITHSCORES
ZRANK leaderboard "player1"
```

### 사용 사례

**캐싱**
```bash
# 캐시 저장 (5분 TTL)
SET cache:user:123 '{"name":"John","age":30}' EX 300
GET cache:user:123
```

**세션 저장**
```bash
# 세션 저장 (1시간 TTL)
HSET session:abc123 user_id 42
HSET session:abc123 logged_in true
EXPIRE session:abc123 3600
```

**카운터**
```bash
# 페이지 뷰 카운터
INCR page:views:homepage
GET page:views:homepage
```

**메시지 큐**
```bash
# Producer
LPUSH queue:tasks '{"task":"send_email","to":"user@example.com"}'

# Consumer
RPOP queue:tasks
```

**Pub/Sub**
```bash
# Publisher (터미널 1)
PUBLISH news "Breaking news!"

# Subscriber (터미널 2)
SUBSCRIBE news
```

## 설정

### 메모리 관리

`.env` 파일에서 설정:

```bash
# 최대 메모리 (256MB)
REDIS_MAX_MEMORY=256mb

# 메모리 초과 시 정책
REDIS_MAX_MEMORY_POLICY=allkeys-lru
```

**메모리 정책 옵션:**
- `noeviction`: 메모리 초과 시 오류 반환
- `allkeys-lru`: LRU로 모든 키 제거 (캐시 권장)
- `volatile-lru`: TTL 있는 키만 LRU로 제거
- `allkeys-random`: 랜덤 키 제거
- `volatile-random`: TTL 있는 키 랜덤 제거
- `volatile-ttl`: TTL이 가장 짧은 키 제거

### Persistence 설정

```bash
# AOF 활성화 (권장)
REDIS_AOF=yes

# AOF 비활성화 (캐시 전용)
REDIS_AOF=no
```

**Persistence 옵션:**
- **AOF (Append Only File)**: 모든 쓰기 작업 기록, 데이터 손실 최소화
- **RDB (Snapshot)**: 주기적 스냅샷, AOF보다 빠름
- **Both**: 최대 내구성 (프로덕션 권장)
- **None**: 캐시 전용 (가장 빠름)

## 백업 및 복원

### 자동 백업

```bash
# 매일 새벽 2시 백업 (cron)
0 2 * * * cd /path/to/redis/standalone && make backup
```

### 수동 백업

```bash
# SAVE 명령으로 즉시 스냅샷 생성
make cli
127.0.0.1:6379> SAVE

# 또는 백그라운드로
127.0.0.1:6379> BGSAVE
```

### 백업 복원

```bash
# 대화형 복원
make restore

# 프롬프트에서 백업 파일 선택
```

## 문제 해결

### Redis가 시작되지 않는 경우

```bash
# 로그 확인
make logs

# 일반적인 원인:
# 1. 포트 충돌 (6379)
# 2. 메모리 부족
# 3. 권한 문제
```

### 비밀번호 오류

```bash
# .env 파일에서 비밀번호 확인
cat .env | grep REDIS_PASSWORD

# Redis CLI에서 인증
redis-cli -a your-password
```

### 메모리 부족

```bash
# 현재 메모리 사용량 확인
make cli
127.0.0.1:6379> INFO memory

# 메모리 제한 확인
127.0.0.1:6379> CONFIG GET maxmemory

# 필요시 .env에서 REDIS_MAX_MEMORY 증가
```

### 느린 쿼리 확인

```bash
# Slow log 확인
make cli
127.0.0.1:6379> SLOWLOG GET 10

# 실시간 모니터링
make monitor
```

### 연결 문제

```bash
# Ping 테스트
make ping

# 네트워크 확인
docker network inspect cache-network

# 포트 확인
netstat -an | grep 6379
```

## 보안 권장사항

### 1. 강력한 비밀번호

```bash
# 강력한 비밀번호 생성
openssl rand -base64 32
```

### 2. 네트워크 격리

프로덕션에서는 Redis를 localhost에만 바인드:

```yaml
# compose.yml
ports:
  - "127.0.0.1:6379:6379"  # localhost만 접근 가능
```

### 3. TLS/SSL (선택사항)

Redis 6+ 에서 TLS 지원:

```bash
# redis:7 (not alpine) 이미지 사용
REDIS_TAG=7

# TLS 설정 추가
command: >
  redis-server
  --tls-port 6379
  --port 0
  --tls-cert-file /path/to/redis.crt
  --tls-key-file /path/to/redis.key
  --tls-ca-cert-file /path/to/ca.crt
```

### 4. 위험한 명령어 비활성화

```bash
# redis.conf에서 위험한 명령어 제거
rename-command FLUSHDB ""
rename-command FLUSHALL ""
rename-command KEYS ""
rename-command CONFIG ""
```

### 5. 정기 백업

자동화된 백업 시스템 구축

## 성능 최적화

### 1. Pipelining 사용

여러 명령을 한 번에 전송:

```bash
# 파이프라인 없이 (느림)
SET key1 value1
SET key2 value2
SET key3 value3

# 파이프라인 사용 (빠름)
echo -e "SET key1 value1\nSET key2 value2\nSET key3 value3" | redis-cli --pipe
```

### 2. 적절한 데이터 구조 선택

- 단순 key-value: String
- 객체: Hash (메모리 효율적)
- 유니크 아이템: Set
- 순위/점수: Sorted Set
- 큐/스택: List

### 3. KEYS 대신 SCAN 사용

```bash
# ❌ 나쁨 (프로덕션에서 사용 금지)
KEYS user:*

# ✅ 좋음
SCAN 0 MATCH user:* COUNT 100
```

### 4. 적절한 만료 시간 설정

```bash
# TTL 설정으로 자동 정리
SETEX cache:user:123 3600 "data"  # 1시간 후 만료
```

## 모니터링

### Redis INFO

```bash
make info

# 주요 섹션
127.0.0.1:6379> INFO server      # 서버 정보
127.0.0.1:6379> INFO memory      # 메모리 사용량
127.0.0.1:6379> INFO stats       # 통계
127.0.0.1:6379> INFO replication # 복제 상태
```

### 실시간 모니터링

```bash
# 모든 명령 모니터링
make monitor

# 느린 쿼리 확인
make cli
127.0.0.1:6379> SLOWLOG GET 10
```

### 주요 메트릭

- `used_memory`: 사용 중인 메모리
- `used_memory_rss`: 시스템 메모리
- `connected_clients`: 연결된 클라이언트 수
- `evicted_keys`: 제거된 키 수
- `keyspace_hits`: 캐시 히트
- `keyspace_misses`: 캐시 미스

## 고급 기능

### Lua 스크립팅

```bash
# 원자적 연산을 위한 Lua 스크립트
EVAL "return redis.call('incr', KEYS[1])" 1 mycounter
```

### 트랜잭션

```bash
MULTI
SET key1 value1
SET key2 value2
EXEC
```

### Redis Modules (Redis 7+)

- RedisJSON: JSON 데이터 타입
- RedisSearch: 전문 검색
- RedisGraph: 그래프 데이터베이스
- RedisTimeSeries: 시계열 데이터

## 참고 자료

- [Redis 공식 사이트](https://redis.io/)
- [Redis 문서](https://redis.io/docs/)
- [Redis 명령어](https://redis.io/commands/)
- [데이터 타입](https://redis.io/docs/data-types/)
- [Persistence](https://redis.io/docs/management/persistence/)
- [보안](https://redis.io/docs/management/security/)
- [포트 가이드](../../docs/PORT_GUIDE.md)

## 라이센스

Redis는 BSD License를 따릅니다.
