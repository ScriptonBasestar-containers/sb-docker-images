# Memcached Standalone Configuration

완전한 독립 실행 가능한 Memcached 분산 메모리 캐시 시스템 구성

## 개요

이 standalone 구성은 Memcached를 즉시 실행할 수 있도록 구성되어 있습니다. Memcached는 고성능 분산 메모리 캐싱 시스템으로 데이터베이스 부하 감소, API 응답 캐싱, 세션 저장 등에 사용됩니다.

### 포함된 서비스

- **Memcached 1.6 Alpine**: 경량화된 공식 이미지
- **Health Check**: 서비스 상태 모니터링
- **설정 가능한 메모리**: 메모리 크기 조정

## 빠른 시작

### 1. 환경 변수 설정 (선택사항)

```bash
# .env 파일 생성
cp .env.example .env

# 필요시 메모리 크기 조정
# MEMCACHED_MEMORY=128
```

### 2. Memcached 시작

```bash
# 서비스 시작
make up
```

### 3. 연결 테스트

```bash
# 테스트 실행
make test
```

### 4. 통계 확인

```bash
# Memcached 통계 보기
make stats
```

## 사용 가능한 명령어

### 서비스 관리

```bash
# Memcached 시작
make up

# Memcached 중지
make down

# 로그 확인
make logs

# Memcached 재시작
make restart

# 실행 중인 컨테이너 확인
make ps
```

### Memcached 명령

```bash
# 통계 확인
make stats

# 연결 테스트
make test
```

### 컨테이너 정리

```bash
# 컨테이너 중지 및 제거
make clean
```

## Memcached 사용법

### 기본 명령어

Memcached는 텍스트 프로토콜을 사용합니다. `nc` (netcat) 또는 `telnet`으로 접속 가능:

**값 저장 (SET)**
```bash
# set <key> <flags> <exptime> <bytes>
echo -e "set mykey 0 60 5\r\nhello\r\n" | nc localhost 11211
# STORED

# flags: 0 (사용자 정의 플래그)
# exptime: 60 (60초 후 만료)
# bytes: 5 (데이터 길이)
```

**값 가져오기 (GET)**
```bash
echo -e "get mykey\r\n" | nc localhost 11211
# VALUE mykey 0 5
# hello
# END
```

**값 삭제 (DELETE)**
```bash
echo -e "delete mykey\r\n" | nc localhost 11211
# DELETED
```

**숫자 증가 (INCR)**
```bash
echo -e "set counter 0 0 1\r\n0\r\n" | nc localhost 11211
echo -e "incr counter 1\r\n" | nc localhost 11211
# 1
echo -e "incr counter 5\r\n" | nc localhost 11211
# 6
```

**숫자 감소 (DECR)**
```bash
echo -e "decr counter 2\r\n" | nc localhost 11211
# 4
```

**모든 데이터 삭제 (FLUSH_ALL)**
```bash
echo -e "flush_all\r\n" | nc localhost 11211
# OK
```

### 프로그래밍 언어별 사용 예시

**Python**
```python
import memcache

# 연결
mc = memcache.Client(['localhost:11211'])

# 저장 (60초 TTL)
mc.set('user:123', {'name': 'John', 'age': 30}, time=60)

# 가져오기
user = mc.get('user:123')
print(user)  # {'name': 'John', 'age': 30}

# 삭제
mc.delete('user:123')
```

**Node.js**
```javascript
const Memcached = require('memcached');
const memcached = new Memcached('localhost:11211');

// 저장 (60초 TTL)
memcached.set('user:123', {name: 'John', age: 30}, 60, (err) => {
  if (err) console.error(err);
});

// 가져오기
memcached.get('user:123', (err, data) => {
  if (err) console.error(err);
  console.log(data);  // {name: 'John', age: 30}
});

// 삭제
memcached.del('user:123', (err) => {
  if (err) console.error(err);
});
```

**PHP**
```php
<?php
$memcached = new Memcached();
$memcached->addServer('localhost', 11211);

// 저장 (60초 TTL)
$memcached->set('user:123', ['name' => 'John', 'age' => 30], 60);

// 가져오기
$user = $memcached->get('user:123');
print_r($user);  // Array ( [name] => John [age] => 30 )

// 삭제
$memcached->delete('user:123');
?>
```

**Go**
```go
package main

import (
    "github.com/bradfitz/gomemcache/memcache"
)

func main() {
    mc := memcache.New("localhost:11211")

    // 저장 (60초 TTL)
    mc.Set(&memcache.Item{
        Key:   "user:123",
        Value: []byte(`{"name":"John","age":30}`),
        Expiration: 60,
    })

    // 가져오기
    item, _ := mc.Get("user:123")
    println(string(item.Value))

    // 삭제
    mc.Delete("user:123")
}
```

## 설정

### 메모리 관리

`.env` 파일에서 설정:

```bash
# 메모리 크기 (MB)
MEMCACHED_MEMORY=64

# 최대 동시 연결 수
MEMCACHED_MAX_CONNECTIONS=1024

# 최대 아이템 크기
MEMCACHED_MAX_ITEM_SIZE=1m
```

**메모리 크기 가이드:**
- 작은 애플리케이션: 64MB
- 중간 애플리케이션: 128-256MB
- 대형 애플리케이션: 512MB-2GB

### 통계 확인

```bash
# 전체 통계
make stats

# 주요 메트릭:
# - curr_items: 현재 아이템 수
# - bytes: 사용 중인 메모리
# - get_hits: 캐시 히트 수
# - get_misses: 캐시 미스 수
# - evictions: 제거된 아이템 수
# - curr_connections: 현재 연결 수
```

**주요 메트릭 해석:**
```bash
# 캐시 히트율 계산
hit_rate = get_hits / (get_hits + get_misses) * 100

# 90% 이상이 좋음
# 낮으면 TTL 조정 또는 메모리 증가 필요
```

## 사용 사례

### 1. 데이터베이스 쿼리 캐싱

```python
def get_user(user_id):
    # 캐시 확인
    cache_key = f'user:{user_id}'
    user = mc.get(cache_key)

    if user is None:
        # DB에서 조회
        user = db.query('SELECT * FROM users WHERE id = ?', user_id)
        # 캐시에 저장 (5분)
        mc.set(cache_key, user, time=300)

    return user
```

### 2. API 응답 캐싱

```python
def get_weather(city):
    cache_key = f'weather:{city}'
    weather = mc.get(cache_key)

    if weather is None:
        # API 호출
        weather = api.fetch_weather(city)
        # 10분 캐싱
        mc.set(cache_key, weather, time=600)

    return weather
```

### 3. 세션 저장

```php
<?php
session_set_save_handler(
    function() { /* open */ },
    function() { /* close */ },
    function($id) use ($memcached) {
        return $memcached->get("session:$id");
    },
    function($id, $data) use ($memcached) {
        $memcached->set("session:$id", $data, 3600);
    },
    function($id) use ($memcached) {
        $memcached->delete("session:$id");
    },
    function() { /* gc */ }
);
?>
```

### 4. 페이지 캐싱

```python
def cached_page(cache_time=60):
    def decorator(f):
        def wrapper(*args, **kwargs):
            cache_key = f'page:{request.path}'
            content = mc.get(cache_key)

            if content is None:
                content = f(*args, **kwargs)
                mc.set(cache_key, content, time=cache_time)

            return content
        return wrapper
    return decorator

@app.route('/products')
@cached_page(cache_time=300)  # 5분 캐싱
def products():
    return render_template('products.html')
```

### 5. Rate Limiting

```python
def rate_limit(user_id, limit=100, window=60):
    key = f'rate:{user_id}'
    count = mc.get(key)

    if count is None:
        mc.set(key, 1, time=window)
        return True

    if int(count) >= limit:
        return False  # Rate limit exceeded

    mc.incr(key, 1)
    return True
```

## 문제 해결

### Memcached가 시작되지 않는 경우

```bash
# 로그 확인
make logs

# 일반적인 원인:
# 1. 포트 충돌 (11211)
# 2. 메모리 부족
```

### 연결 실패

```bash
# 포트 확인
netstat -an | grep 11211

# 테스트
make test

# nc가 없는 경우
telnet localhost 11211
```

### 높은 Eviction Rate

```bash
# 통계 확인
make stats | grep evictions

# 해결 방법:
# 1. 메모리 증가 (.env에서 MEMCACHED_MEMORY)
# 2. TTL 재조정
# 3. 불필요한 캐시 제거
# 4. 여러 인스턴스로 분산
```

### 낮은 캐시 히트율

```bash
# 히트/미스 확인
make stats | grep -E "get_hits|get_misses"

# 개선 방법:
# 1. TTL 증가
# 2. 캐싱 전략 재검토
# 3. Warm-up 구현
```

## 보안 권장사항

### ⚠️ 중요: Memcached는 인증 기능이 없습니다!

**1. 네트워크 격리**

localhost에만 바인딩:
```yaml
# compose.yml
ports:
  - "127.0.0.1:11211:11211"  # localhost만 접근 가능
```

**2. 방화벽 설정**

```bash
# 특정 IP만 허용 (iptables)
iptables -A INPUT -p tcp --dport 11211 -s 192.168.1.0/24 -j ACCEPT
iptables -A INPUT -p tcp --dport 11211 -j DROP
```

**3. Docker 네트워크 사용**

```yaml
# 애플리케이션과 같은 네트워크에만
networks:
  - app-network

# 외부 포트 노출하지 않음 (ports 제거)
```

**4. VPN 또는 Private Network**

프로덕션에서는 반드시:
- VPC 내부에서만 접근
- VPN을 통한 접근
- Private subnet 사용

## 성능 최적화

### 1. 적절한 메모리 할당

```bash
# 메모리 사용량 모니터링
make stats | grep -E "bytes|limit_maxbytes"

# 메모리 부족 시
MEMCACHED_MEMORY=256  # .env에서 조정
```

### 2. Connection Pooling

대부분의 Memcached 클라이언트는 connection pooling 지원:

```python
# Python - persistent connections
mc = memcache.Client(['localhost:11211'],
                     server_max_value_length=1024*1024)
```

### 3. 여러 인스턴스로 분산 (Sharding)

```python
# 여러 Memcached 인스턴스 사용
mc = memcache.Client([
    'memcached1:11211',
    'memcached2:11211',
    'memcached3:11211'
])
# 자동으로 키를 분산 저장
```

### 4. 적절한 TTL 설정

```python
# 자주 변경되는 데이터: 짧은 TTL
mc.set('live_score', data, time=10)  # 10초

# 거의 변경되지 않는 데이터: 긴 TTL
mc.set('config', data, time=3600)  # 1시간
```

## 모니터링

### 주요 메트릭

```bash
# 전체 통계
make stats

# 중요 메트릭:
# curr_items: 저장된 아이템 수
# bytes: 사용 메모리
# limit_maxbytes: 최대 메모리
# get_hits: 성공한 조회
# get_misses: 실패한 조회
# evictions: LRU로 제거된 수
# curr_connections: 현재 연결 수
```

### 모니터링 스크립트

```bash
#!/bin/bash
# memcached-monitor.sh

stats=$(echo "stats" | nc localhost 11211)

hits=$(echo "$stats" | grep "get_hits" | awk '{print $3}')
misses=$(echo "$stats" | grep "get_misses" | awk '{print $3}')
evictions=$(echo "$stats" | grep "evictions" | awk '{print $3}')

total=$((hits + misses))
if [ $total -gt 0 ]; then
    hit_rate=$(echo "scale=2; $hits * 100 / $total" | bc)
    echo "Cache Hit Rate: $hit_rate%"
fi

echo "Evictions: $evictions"
```

## Memcached vs Redis

### Memcached 선택 시:
- 단순한 key-value 캐싱
- LRU eviction만 필요
- 최대 성능 (단순한 작업)
- 분산 캐싱

### Redis 선택 시:
- 복잡한 데이터 구조 (Lists, Sets, Hashes)
- Persistence 필요
- Pub/Sub 필요
- 트랜잭션 필요

## 참고 자료

- [Memcached 공식 사이트](https://memcached.org/)
- [Memcached Wiki](https://github.com/memcached/memcached/wiki)
- [Protocol 문서](https://github.com/memcached/memcached/blob/master/doc/protocol.txt)
- [Docker Hub](https://hub.docker.com/_/memcached)
- [포트 가이드](../../docs/PORT_STATUS.md)

## 라이센스

Memcached는 BSD License를 따릅니다.
