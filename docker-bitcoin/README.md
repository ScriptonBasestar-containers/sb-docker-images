# Docker Bitcoin

Bitcoin Core 노드 및 탐색기 환경

## 목차

- [개요](#개요)
- [빠른 시작](#빠른 시작)
- [Makefile 명령어](#makefile-명령어)
- [서비스 구성](#서비스-구성)
- [포트](#포트)
- [환경 변수](#환경-변수)
- [사용법](#사용법)
- [네트워크 모드](#네트워크-모드)
- [RPC API 사용](#rpc-api-사용)
- [볼륨 및 데이터](#볼륨-및-데이터)
- [보안 설정](#보안-설정)
- [모니터링](#모니터링)
- [Health Checks](#health-checks)
- [문제 해결](#문제-해결)
- [시스템 요구사항](#시스템-요구사항)

## 개요

Bitcoin Core 풀 노드와 BTC RPC Explorer를 Docker로 실행할 수 있는 환경입니다. 개발, 테스트, 또는 프라이빗 네트워크 운영에 사용할 수 있습니다.

## 빠른 시작

```bash
# 환경 변수 설정
cat > .env <<EOF
RPC_USER=bitcoin
RPC_PASSWORD=your-secure-password
TESTNET=0
EOF

# Makefile 사용 (권장)
make up

# 또는 docker compose 직접 사용
docker compose up -d

# 로그 확인
make logs
# 또는
docker compose logs -f bitcoind
```

## Makefile 명령어

이 프로젝트는 간편한 관리를 위한 Makefile을 제공합니다:

```bash
make help      # 사용 가능한 명령어 보기
make up        # 서비스 시작
make down      # 서비스 중지
make restart   # 서비스 재시작
make logs      # 로그 보기
make ps        # 실행 중인 컨테이너 확인
make shell     # Bitcoin 컨테이너 접속
make clean     # 모든 데이터 삭제 (주의!)
```

## 서비스 구성

- **bitcoind**: Bitcoin Core 노드 (kylemanna/bitcoind)
- **btc-rpc-explorer**: Bitcoin 블록 탐색기 (선택사항)

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8332 | bitcoind | JSON-RPC API (권장 포트 사용 중) |
| 8333 | bitcoind | P2P 네트워크 |
| 3002 | btc-rpc-explorer | 웹 UI |

> ✅ **포트 설정**: 이미 권장 포트(8332, 8333)를 사용하고 있습니다. ([포트 가이드](../docs/PORT_GUIDE.md) 참조)

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

```.env
# RPC 인증
RPC_USER=bitcoin
RPC_PASSWORD=changeme

# 네트워크 설정
TESTNET=0          # 0=mainnet, 1=testnet
```

## 사용법

### Bitcoin Core 명령어

```bash
# bitcoin-cli 실행
docker-compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  getblockchaininfo

# 지갑 생성
docker-compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  createwallet "mywallet"

# 새 주소 생성
docker-compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  getnewaddress

# 잔액 확인
docker-compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  getbalance
```

### BTC Explorer

브라우저에서 접속:
- http://localhost:3002

주요 기능:
- 블록 탐색
- 트랜잭션 조회
- 주소 잔액 확인
- 네트워크 통계

## 네트워크 모드

### Mainnet (기본)

```bash
# .env
TESTNET=0

# 동기화 시간: 수일 ~ 수주 소요
# 디스크 공간: 500GB+ 필요
```

### Testnet

```bash
# .env
TESTNET=1

# 동기화 시간: 수시간 소요
# 디스크 공간: 50GB 정도 필요
```

### Regtest (로컬 개발)

```yaml
# docker-compose.override.yml
services:
  bitcoind:
    command: |
      bitcoind
      -printtoconsole
      -regtest
      -rpcallowip=0.0.0.0/0
      -rpcbind=0.0.0.0
      -rpcuser=${RPC_USER}
      -rpcpassword=${RPC_PASSWORD}
```

```bash
# 새 블록 생성 (regtest)
docker-compose exec bitcoind bitcoin-cli \
  -regtest \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  generatetoaddress 101 $(docker-compose exec bitcoind bitcoin-cli -regtest -rpcuser=bitcoin -rpcpassword=changeme getnewaddress)
```

## RPC API 사용

### curl로 RPC 호출

```bash
# 블록체인 정보 조회
curl --user bitcoin:changeme \
  --data-binary '{"jsonrpc":"1.0","id":"1","method":"getblockchaininfo","params":[]}' \
  -H 'content-type: text/plain;' \
  http://localhost:8332/

# 블록 해시 조회
curl --user bitcoin:changeme \
  --data-binary '{"jsonrpc":"1.0","id":"1","method":"getblockhash","params":[0]}' \
  -H 'content-type: text/plain;' \
  http://localhost:8332/
```

### Python에서 연결

```python
from bitcoinrpc.authproxy import AuthServiceProxy

rpc_user = "bitcoin"
rpc_password = "changeme"
rpc_url = f"http://{rpc_user}:{rpc_password}@localhost:8332"

bitcoin = AuthServiceProxy(rpc_url)

# 블록체인 정보
info = bitcoin.getblockchaininfo()
print(f"Blocks: {info['blocks']}")
print(f"Chain: {info['chain']}")

# 새 주소 생성
address = bitcoin.getnewaddress()
print(f"New address: {address}")
```

## 볼륨 및 데이터

```yaml
volumes:
  bitcoin-data:  # 블록체인 데이터 저장
```

### 데이터 백업

```bash
# 볼륨 백업
docker run --rm \
  -v docker-bitcoin_bitcoin-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/bitcoin-data-backup-$(date +%Y%m%d).tar.gz /data

# 지갑 백업 (중요!)
docker-compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  backupwallet /bitcoin/.bitcoin/wallet-backup.dat

docker cp bitcoind:/bitcoin/.bitcoin/wallet-backup.dat ./
```

## 보안 설정

### 1. RPC 인증 강화

```bash
# 강력한 비밀번호 생성
RPC_PASSWORD=$(openssl rand -base64 32)
```

### 2. 방화벽 설정

```bash
# RPC 포트는 내부 네트워크만 허용
ufw allow from 192.168.0.0/24 to any port 8332

# P2P 포트는 전체 허용
ufw allow 8333
```

### 3. RPC 화이트리스트

```yaml
# docker-compose.override.yml
services:
  bitcoind:
    command: |
      bitcoind
      -rpcallowip=172.16.0.0/12
      -rpcbind=0.0.0.0
```

## 모니터링

### 동기화 상태 확인

```bash
# 블록 동기화 상태
docker compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  getblockchaininfo | grep -E '(blocks|headers|verificationprogress)'

# 피어 연결 확인
docker compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  getpeerinfo | grep -c addr

# 메모리풀 확인
docker compose exec bitcoind bitcoin-cli \
  -rpcuser=bitcoin \
  -rpcpassword=changeme \
  getmempoolinfo
```

## Health Checks

### 서비스 상태 확인

```bash
# 컨테이너 health status 확인
docker compose ps

# 상세 health check 로그
docker inspect --format='{{json .State.Health}}' docker-bitcoin-bitcoind-1 | jq

# 수동으로 health check 테스트
docker compose exec bitcoind bitcoin-cli \
  -rpcuser=${RPC_USER} \
  -rpcpassword=${RPC_PASSWORD} \
  getblockchaininfo
```

### Health Check 설정

Docker Compose에 정의된 health check:
```yaml
healthcheck:
  test: ["CMD-SHELL", "bitcoin-cli -rpcuser=${RPC_USER} -rpcpassword=${RPC_PASSWORD} getblockchaininfo || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 60s
```

## 문제 해결

### 일반적인 문제

#### 1. 컨테이너가 시작되지 않는 경우

```bash
# 로그 확인
make logs
# 또는
docker compose logs bitcoind

# 컨테이너 상태 확인
make ps
# 또는
docker compose ps
```

#### 2. RPC 연결 실패

```bash
# RPC 인증 정보 확인
cat .env

# RPC 테스트
curl --user bitcoin:changeme http://localhost:8332/

# 네트워크 연결 확인
docker compose exec bitcoind netstat -tlnp | grep 8332
```

#### 3. 블록체인 데이터 손상

```bash
# 데이터베이스 재구축
make down
docker volume rm docker-bitcoin_bitcoin-data
make up
```

#### 4. 동기화가 느린 경우

```yaml
# docker-compose.override.yml
services:
  bitcoind:
    command: |
      bitcoind
      -dbcache=4096
      -maxconnections=125
```

#### 5. 디스크 공간 부족

```bash
# 블록체인 데이터 정리 (pruned mode)
# docker-compose.override.yml
services:
  bitcoind:
    command: |
      bitcoind
      -prune=10000  # 10GB로 제한
```

### 데이터 영속성 확인

```bash
# 볼륨 확인
docker volume ls | grep bitcoin

# 볼륨 상세 정보
docker volume inspect docker-bitcoin_bitcoin-data

# 데이터 크기 확인
docker run --rm -v docker-bitcoin_bitcoin-data:/data alpine du -sh /data
```

## 시스템 요구사항

### Mainnet 풀 노드

- **디스크**: 500GB+ (SSD 권장)
- **메모리**: 2GB+ RAM
- **네트워크**: 무제한 (월 200GB+ 대역폭)
- **CPU**: 2+ 코어

### Testnet

- **디스크**: 50GB
- **메모리**: 1GB RAM
- **네트워크**: 제한적

### Regtest (개발)

- **디스크**: 1GB
- **메모리**: 512MB RAM
- **네트워크**: 불필요

## 참고 자료

- [Bitcoin Core 공식 문서](https://bitcoin.org/en/bitcoin-core/)
- [Bitcoin RPC API](https://developer.bitcoin.org/reference/rpc/)
- [BTC RPC Explorer](https://github.com/janoside/btc-rpc-explorer)
- [Bitcoin Developer Guide](https://developer.bitcoin.org/devguide/)

## 관련 프로젝트

- [docker-ethereum](../docker-ethereum/README.md) - Ethereum 노드

## 라이선스

MIT
