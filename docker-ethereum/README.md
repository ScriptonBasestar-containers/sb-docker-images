# Docker Ethereum

Ethereum Geth 노드 및 블록 탐색기 환경

## 목차

- [개요](#개요)
- [빠른 시작](#빠른 시작)
- [Makefile 명령어](#makefile-명령어)
- [서비스 구성](#서비스-구성)
- [포트](#포트)
- [환경 변수](#환경-변수)
- [사용법](#사용법)
- [네트워크 모드](#네트워크-모드)
- [JSON-RPC API 사용](#json-rpc-api-사용)
- [동기화 모드](#동기화-모드)
- [볼륨 및 데이터](#볼륨-및-데이터)
- [보안 설정](#보안-설정)
- [모니터링](#모니터링)
- [Health Checks](#health-checks)
- [문제 해결](#문제-해결)
- [시스템 요구사항](#시스템-요구사항)

## 개요

Ethereum Geth (Go Ethereum) 풀 노드와 BlockScout 블록 탐색기를 Docker로 실행할 수 있는 환경입니다. 개발, 테스트, 또는 프라이빗 네트워크 운영에 사용할 수 있습니다.

## 빠른 시작

```bash
# 환경 변수 설정
cat > .env <<EOF
SYNC_MODE=snap
CACHE=2048
SECRET_KEY_BASE=$(openssl rand -base64 64)
EOF

# Makefile 사용 (권장)
make up

# 또는 Geth 노드만 실행 (BlockScout 제외)
docker compose up -d geth

# 모든 서비스 실행 (Geth + BlockScout + PostgreSQL)
docker compose up -d

# 로그 확인
make logs
# 또는
docker compose logs -f geth
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
make shell     # Geth 컨테이너 접속
make clean     # 모든 데이터 삭제 (주의!)
```

## 서비스 구성

- **geth**: Ethereum Go 클라이언트 (공식 이미지)
- **blockscout**: Ethereum 블록 탐색기 (선택사항)
- **postgres**: BlockScout용 PostgreSQL (선택사항)

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8545 | geth | HTTP JSON-RPC API (권장 포트 사용 중) |
| 8546 | geth | WebSocket API (권장 포트 사용 중) |
| 30303 | geth | P2P 네트워크 (TCP/UDP) |
| 4000 | blockscout | 웹 UI |

> ✅ **포트 설정**: 이미 권장 포트(8545, 8546, 30303)를 사용하고 있습니다. ([포트 가이드](../docs/PORT_GUIDE.md) 참조)

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

```.env
# Geth 설정
SYNC_MODE=snap      # snap, full, light
CACHE=2048          # 캐시 크기 (MB)

# BlockScout 설정
SECRET_KEY_BASE=your-secret-key-here
```

## 사용법

### Geth 명령어

```bash
# Geth 콘솔 접속
docker-compose exec geth geth attach http://localhost:8545

# 계정 생성
docker-compose exec geth geth account new

# 계정 목록
docker-compose exec geth geth account list

# 동기화 상태 확인
docker-compose exec geth geth attach --exec "eth.syncing"

# 블록 번호 확인
docker-compose exec geth geth attach --exec "eth.blockNumber"

# 피어 수 확인
docker-compose exec geth geth attach --exec "net.peerCount"
```

### BlockScout

브라우저에서 접속:
- http://localhost:4000

주요 기능:
- 블록 탐색
- 트랜잭션 조회
- 스마트 컨트랙트 검증
- 주소 잔액 및 히스토리
- 토큰 정보

## 네트워크 모드

### Mainnet (기본)

```bash
# 기본 설정으로 실행
docker-compose up -d geth

# 동기화 시간: 수일 소요 (snap mode)
# 디스크 공간: 800GB+ 필요
```

### Sepolia Testnet

```yaml
# docker-compose.override.yml
services:
  geth:
    command: |
      --sepolia
      --http
      --http.addr=0.0.0.0
      --http.port=8545
      --http.api=eth,net,web3,personal,admin
      --ws
      --ws.addr=0.0.0.0
      --ws.port=8546
      --syncmode=${SYNC_MODE:-snap}
```

### Goerli Testnet (deprecated)

```yaml
services:
  geth:
    command: |
      --goerli
      --http
      --http.addr=0.0.0.0
```

### Private Network (Dev Mode)

```yaml
# docker-compose.override.yml
services:
  geth:
    command: |
      --dev
      --dev.period=1
      --http
      --http.addr=0.0.0.0
      --http.port=8545
      --http.corsdomain="*"
      --http.api=eth,net,web3,personal,admin,miner
      --ws
      --ws.addr=0.0.0.0
```

```bash
# Dev 모드 실행
docker-compose up -d

# 자동으로 계정 생성됨
docker-compose exec geth geth attach --exec "eth.accounts"

# 마이닝 시작/중지
docker-compose exec geth geth attach --exec "miner.start()"
docker-compose exec geth geth attach --exec "miner.stop()"
```

## JSON-RPC API 사용

### curl로 RPC 호출

```bash
# 블록 번호 조회
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# 계정 잔액 조회
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc":"2.0",
    "method":"eth_getBalance",
    "params":["0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb", "latest"],
    "id":1
  }'

# 최신 블록 조회
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", false],"id":1}'
```

### Web3.js로 연결

```javascript
const Web3 = require('web3');
const web3 = new Web3('http://localhost:8545');

// 블록 번호 조회
web3.eth.getBlockNumber().then(console.log);

// 계정 잔액 조회
web3.eth.getBalance('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb')
  .then(balance => console.log(web3.utils.fromWei(balance, 'ether')));

// 스마트 컨트랙트 호출
const contract = new web3.eth.Contract(ABI, contractAddress);
contract.methods.myMethod().call().then(console.log);
```

### Python (web3.py)로 연결

```python
from web3 import Web3

w3 = Web3(Web3.HTTPProvider('http://localhost:8545'))

# 연결 확인
print(f"Connected: {w3.is_connected()}")

# 블록 번호
print(f"Block: {w3.eth.block_number}")

# 가스 가격
print(f"Gas Price: {w3.eth.gas_price}")

# 계정 잔액
balance = w3.eth.get_balance('0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb')
print(f"Balance: {w3.from_wei(balance, 'ether')} ETH")
```

## 동기화 모드

### Snap Sync (권장)

```bash
# 가장 빠른 동기화
SYNC_MODE=snap
# 시간: 수일
# 디스크: ~800GB
```

### Full Sync

```bash
# 전체 블록 검증
SYNC_MODE=full
# 시간: 수주
# 디스크: ~1TB+
```

### Light Sync

```bash
# 경량 클라이언트
SYNC_MODE=light
# 시간: 수시간
# 디스크: ~10GB
# 제약: 일부 RPC API 제한
```

## 볼륨 및 데이터

```yaml
volumes:
  geth-data:      # 블록체인 데이터
  postgres-data:  # BlockScout DB
```

### 데이터 백업

```bash
# Geth 데이터 백업
docker run --rm \
  -v docker-ethereum_geth-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/geth-data-backup-$(date +%Y%m%d).tar.gz /data

# 키스토어 백업 (중요!)
docker cp geth:/root/.ethereum/keystore ./keystore-backup
```

## 보안 설정

### 1. RPC API 제한

```yaml
services:
  geth:
    command: |
      --http.api=eth,net,web3  # personal, admin 제거
      --http.corsdomain="https://yourdomain.com"
      --http.vhosts="yourdomain.com"
```

### 2. 네트워크 접근 제어

```bash
# RPC 포트는 내부 네트워크만
ufw allow from 192.168.0.0/24 to any port 8545
ufw allow from 192.168.0.0/24 to any port 8546

# P2P 포트는 전체 허용
ufw allow 30303
```

### 3. 키스토어 보안

```bash
# 키스토어 암호화
docker-compose exec geth geth account new

# 키스토어 백업 후 권한 설정
chmod 600 keystore-backup/*
```

## 모니터링

### 동기화 상태

```bash
# JavaScript 콘솔
docker compose exec geth geth attach --exec "eth.syncing"

# 블록 번호
docker compose exec geth geth attach --exec "eth.blockNumber"

# 헤더 vs 블록 비교
docker compose exec geth geth attach --exec "web3.eth.syncing"
```

### 리소스 사용량

```bash
# CPU/메모리 사용량
docker stats geth

# 디스크 사용량
docker exec geth df -h /root/.ethereum

# 피어 정보
docker compose exec geth geth attach --exec "admin.peers.length"
```

## Health Checks

### 서비스 상태 확인

```bash
# 컨테이너 health status 확인
docker compose ps

# 상세 health check 로그
docker inspect --format='{{json .State.Health}}' docker-ethereum-geth-1 | jq

# 수동으로 health check 테스트
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Health Check 설정

Docker Compose에 정의된 health check:
```yaml
healthcheck:
  test: ["CMD-SHELL", "geth attach --exec 'eth.blockNumber' || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 120s
```

## 문제 해결

### 일반적인 문제

#### 1. 컨테이너가 시작되지 않는 경우

```bash
# 로그 확인
make logs
# 또는
docker compose logs geth

# 컨테이너 상태 확인
make ps
# 또는
docker compose ps
```

#### 2. 동기화가 멈춘 경우

```bash
# 피어 추가
docker compose exec geth geth attach --exec '
  admin.addPeer("enode://...")
'

# 재시작
make restart
# 또는
docker compose restart geth
```

#### 3. 디스크 공간 부족

```bash
# 오래된 트랜잭션 정리 (gcmode=archive 제거)
# docker-compose.yml에서 --gcmode=archive 라인 삭제 후 재시작
```

#### 4. RPC 연결 실패

```bash
# 로그 확인
docker compose logs geth

# 포트 확인
curl http://localhost:8545 -X POST \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# 네트워크 연결 확인
docker compose exec geth netstat -tlnp | grep 8545
```

#### 5. BlockScout 시작 실패

```bash
# DB 마이그레이션
docker compose exec blockscout mix ecto.migrate

# DB 재생성
make clean
docker compose up -d postgres
# 잠시 대기
docker compose up -d blockscout
```

### 데이터 영속성 확인

```bash
# 볼륨 확인
docker volume ls | grep ethereum

# 볼륨 상세 정보
docker volume inspect docker-ethereum_geth-data

# 데이터 크기 확인
docker run --rm -v docker-ethereum_geth-data:/data alpine du -sh /data
```

## 시스템 요구사항

### Mainnet 풀 노드 (Snap Sync)

- **디스크**: 1TB SSD (권장)
- **메모리**: 8GB+ RAM
- **네트워크**: 무제한 (월 500GB+ 대역폭)
- **CPU**: 4+ 코어

### Testnet

- **디스크**: 100GB
- **메모리**: 4GB RAM
- **네트워크**: 제한적

### Dev Mode

- **디스크**: 10GB
- **메모리**: 2GB RAM
- **네트워크**: 불필요

## 참고 자료

- [Geth 공식 문서](https://geth.ethereum.org/docs)
- [Ethereum JSON-RPC API](https://ethereum.org/en/developers/docs/apis/json-rpc/)
- [BlockScout](https://docs.blockscout.com/)
- [Web3.js](https://web3js.readthedocs.io/)
- [Ethereum Developer Resources](https://ethereum.org/en/developers/)

## 관련 프로젝트

- [docker-bitcoin](../docker-bitcoin/README.md) - Bitcoin 노드

## 라이선스

MIT
