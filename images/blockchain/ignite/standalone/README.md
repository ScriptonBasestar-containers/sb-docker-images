# Apache Ignite Standalone Configuration

완전한 독립 실행 가능한 Apache Ignite In-Memory Computing 플랫폼 구성

## 개요

이 standalone 구성은 Apache Ignite를 즉시 실행할 수 있도록 구성되어 있습니다. Apache Ignite는 분산 인메모리 컴퓨팅 플랫폼으로 캐싱, SQL, 컴퓨팅, 스트리밍 등 다양한 기능을 제공합니다.

### 포함된 서비스

- **Apache Ignite**: In-Memory Computing 플랫폼
- **REST API**: HTTP REST API 활성화
- **Persistence**: 데이터 영구 저장
- **Health Check**: 서비스 상태 모니터링

## 빠른 시작

### 1. 환경 변수 설정 (선택사항)

```bash
# .env 파일 생성
cp .env.example .env

# 필요시 JVM 메모리 조정
# IGNITE_JVM_MAX_MEMORY=1g
```

### 2. Ignite 시작

```bash
# 서비스 시작
make up

# 로그 확인 (초기화 완료 확인)
make logs
```

### 3. 버전 확인

```bash
# Ignite 버전 확인
make version
```

### 4. REST API 테스트

```bash
# 버전 정보
curl http://localhost:11211/ignite?cmd=version

# 토폴로지 정보
curl http://localhost:11211/ignite?cmd=top
```

## 사용 가능한 명령어

### 서비스 관리

```bash
# Ignite 시작
make up

# Ignite 중지
make down

# 로그 확인
make logs

# Ignite 재시작
make restart

# 실행 중인 컨테이너 확인
make ps
```

### Ignite 명령

```bash
# 컨테이너 쉘 접속
make shell

# 버전 확인
make version
```

### 데이터 정리

```bash
# 모든 데이터 삭제 (⚠️ 주의: 복구 불가능)
make clean
```

## Apache Ignite 주요 기능

### 1. Distributed Cache

키-값 저장소로 사용:

```bash
# REST API로 캐시 사용
# 데이터 저장
curl "http://localhost:11211/ignite?cmd=put&cacheName=myCache&key=user1&val=John"

# 데이터 조회
curl "http://localhost:11211/ignite?cmd=get&cacheName=myCache&key=user1"

# 데이터 삭제
curl "http://localhost:11211/ignite?cmd=rmv&cacheName=myCache&key=user1"
```

### 2. SQL Database

분산 SQL 지원:

```bash
# Thin Client를 통한 SQL
# Python 예시
from pyignite import Client

client = Client()
client.connect('localhost', 10800)

# 테이블 생성
client.sql('''
    CREATE TABLE Person (
        id INT PRIMARY KEY,
        name VARCHAR,
        age INT
    ) WITH "template=replicated"
''')

# 데이터 삽입
client.sql('INSERT INTO Person VALUES (1, "John", 30)')

# 조회
result = client.sql('SELECT * FROM Person WHERE age > 25')
```

### 3. Compute Grid

분산 컴퓨팅:

```java
// Java 예시
IgniteCompute compute = ignite.compute();

// 모든 노드에서 실행
compute.broadcast(() -> System.out.println("Hello from " + ignite.name()));

// Map-Reduce
Collection<Integer> res = compute.apply(
    String::length,
    Arrays.asList("How", "many", "letters")
);
```

### 4. Streaming

실시간 데이터 스트리밍:

```java
try (IgniteDataStreamer<Integer, String> streamer =
     ignite.dataStreamer("myCache")) {

    for (int i = 0; i < 1000000; i++)
        streamer.addData(i, "Value " + i);
}
```

## 포트 설명

| 포트 | 용도 | 설명 |
|------|------|------|
| 10800 | Thin Client | JDBC, ODBC, .NET, Python 등 클라이언트 연결 |
| 11211 | REST API | HTTP REST API |
| 47100 | Discovery | 클러스터 노드 발견 |
| 47500 | Communication | 노드 간 통신 |

## 클라이언트 연결

### Python

```bash
# 설치
pip install pyignite

# 사용
from pyignite import Client

client = Client()
client.connect('localhost', 10800)

# 캐시 사용
cache = client.get_or_create_cache('my_cache')
cache.put('key', 'value')
print(cache.get('key'))  # 'value'
```

### Java

```xml
<!-- Maven dependency -->
<dependency>
    <groupId>org.apache.ignite</groupId>
    <artifactId>ignite-core</artifactId>
    <version>2.16.0</version>
</dependency>
```

```java
Ignite ignite = Ignition.start();
IgniteCache<String, String> cache = ignite.getOrCreateCache("myCache");
cache.put("key", "value");
System.out.println(cache.get("key"));
```

### Node.js

```bash
# 설치
npm install apache-ignite-client

# 사용
const IgniteClient = require('apache-ignite-client');

const igniteClient = new IgniteClient();
await igniteClient.connect(new IgniteClientConfiguration('localhost:10800'));

const cache = await igniteClient.getOrCreateCache('myCache');
await cache.put('key', 'value');
console.log(await cache.get('key'));
```

### .NET/C#

```bash
# NuGet 패키지
Install-Package Apache.Ignite
```

```csharp
var cfg = new IgniteClientConfiguration
{
    Endpoints = new[] { "localhost:10800" }
};

using (var client = Ignition.StartClient(cfg))
{
    var cache = client.GetOrCreateCache<string, string>("myCache");
    cache.Put("key", "value");
    Console.WriteLine(cache.Get("key"));
}
```

## 설정

### JVM 메모리

`.env` 파일에서 설정:

```bash
# 작은 데이터셋 (< 1GB)
IGNITE_JVM_MIN_MEMORY=512m
IGNITE_JVM_MAX_MEMORY=512m

# 중간 데이터셋 (1-10GB)
IGNITE_JVM_MIN_MEMORY=1g
IGNITE_JVM_MAX_MEMORY=2g

# 큰 데이터셋 (> 10GB)
IGNITE_JVM_MIN_MEMORY=2g
IGNITE_JVM_MAX_MEMORY=4g
```

**주의**: 시스템 RAM의 약 75%만 Ignite에 할당 (OS용 여유 필요)

### Persistence 활성화

기본적으로 persistence가 활성화되어 있습니다. 데이터는 `/persistence` 볼륨에 저장됩니다.

## 문제 해결

### Ignite가 시작되지 않는 경우

```bash
# 로그 확인
make logs

# 일반적인 원인:
# 1. 포트 충돌 (10800, 11211, 47100, 47500)
# 2. 메모리 부족 (JVM heap)
# 3. 디스크 공간 부족 (persistence)
```

### REST API가 작동하지 않는 경우

```bash
# OPTION_LIBS 확인 (.env에서)
IGNITE_OPTION_LIBS=ignite-rest-http

# 재시작
make restart
```

### Out of Memory 오류

```bash
# JVM 메모리 증가 (.env에서)
IGNITE_JVM_MAX_MEMORY=2g

# 재시작
make down
make up
```

### 클라이언트 연결 실패

```bash
# 포트 확인
docker compose ps

# 네트워크 확인
docker network inspect ignite-network

# Thin client 포트 테스트
telnet localhost 10800
```

## 보안 권장사항

### 1. 네트워크 격리

프로덕션에서는 포트를 외부에 노출하지 마세요:

```yaml
# compose.yml에서 localhost만 바인딩
ports:
  - "127.0.0.1:10800:10800"
  - "127.0.0.1:11211:11211"
```

### 2. 인증 활성화

Custom configuration으로 인증 설정:

```xml
<!-- ignite-config.xml -->
<property name="authenticationEnabled" value="true"/>
```

### 3. SSL/TLS 사용

프로덕션에서는 SSL 연결 사용

### 4. 방화벽 설정

필요한 포트만 허용

## 클러스터 구성

단일 노드 대신 클러스터로 실행:

```bash
# 3개 노드 클러스터
docker compose up -d --scale ignite=3
```

Custom discovery configuration 필요 (파일 기반 또는 multicast)

## 모니터링

### JMX

Ignite는 JMX를 통해 메트릭 제공:

```bash
# JMX 포트 추가 (compose.yml)
ports:
  - "49112:49112"

environment:
  JVM_OPTS: >-
    -Xmx1g
    -Dcom.sun.management.jmxremote
    -Dcom.sun.management.jmxremote.port=49112
    -Dcom.sun.management.jmxremote.authenticate=false
    -Dcom.sun.management.jmxremote.ssl=false
```

### REST Monitoring

```bash
# Topology 정보
curl http://localhost:11211/ignite?cmd=top

# Cache 정보
curl http://localhost:11211/ignite?cmd=size&cacheName=myCache

# 노드 정보
curl http://localhost:11211/ignite?cmd=node
```

## 사용 사례

- **High-Performance Cache**: 데이터베이스 앞단 캐싱
- **HTAP**: 트랜잭션 + 분석 동시 처리
- **Real-Time Analytics**: 대용량 실시간 분석
- **Machine Learning**: 분산 ML 모델 학습
- **IoT Data Processing**: IoT 센서 데이터 처리
- **Microservices Data Grid**: 마이크로서비스 간 데이터 공유

## 참고 자료

- [Apache Ignite 공식 사이트](https://ignite.apache.org/)
- [문서](https://ignite.apache.org/docs/latest/)
- [REST API](https://ignite.apache.org/docs/latest/restapi)
- [Thin Clients](https://ignite.apache.org/docs/latest/thin-clients/getting-started-with-thin-clients)
- [Docker Hub](https://hub.docker.com/r/apacheignite/ignite)
- [포트 가이드](../../docs/PORT_GUIDE.md)

## 라이센스

Apache Ignite는 Apache License 2.0을 따릅니다.
