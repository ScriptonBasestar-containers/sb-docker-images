# NodeBB

NodeBB는 Node.js로 작성된 현대적이고 빠른 포럼 소프트웨어입니다. 실시간 상호작용과 모바일 친화적인 디자인으로 차세대 커뮤니티 플랫폼을 제공합니다.

## 개요

NodeBB는 다음과 같은 기능을 제공합니다:
- 실시간 채팅 및 알림
- 소셜 미디어 통합
- 반응형 디자인
- 강력한 플러그인 시스템
- 다국어 지원 (50개 이상의 언어)
- SEO 친화적
- 모바일 앱 지원
- 마크다운 및 BBCode 지원

## Deployment Options

### Standalone (Recommended)

Complete production-ready setup with all dependencies included:

```bash
cd standalone/
docker compose up -d
```

**Includes:**
- NodeBB (nodebb/docker:latest)
- PostgreSQL 15 with health check
- Redis 7 for cache and sessions
- Network isolation (app-network, data-network)

See [standalone/README.md](standalone/README.md) for detailed instructions.

### Development Setup (NodeBB Repository)

Development setup using official NodeBB repository:

## 빠른 시작

```bash
# 1. NodeBB 소스코드 클론 (최초 1회만)
make setup

# 2. 서비스 시작
cd nodebb
docker compose up -d

# 3. 브라우저에서 접속하여 설정 완료
# http://localhost:4567

# 4. 초기 설정 마법사를 따라 관리자 계정 생성
```

## 서비스 구성

NodeBB 저장소의 docker-compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **nodebb**: NodeBB 포럼 애플리케이션
  - Node.js 기반 웹 서버
  - 실시간 웹소켓 지원
  - 자동 재시작 기능

- **postgres**: PostgreSQL 15 데이터베이스
  - 사용자 데이터 및 게시물 저장
  - 자동 헬스체크
  - 영구 데이터 저장

- **redis**: Redis 7.2 캐시 서버
  - 세션 관리
  - 실시간 데이터 캐싱
  - Pub/Sub 메시징

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 4567 | nodebb | NodeBB 웹 서버 (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 4567 포트 사용 중입니다.
>
> **권장 포트**: 8240 ([포트 가이드](../docs/PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # NodeBB 저장소의 docker-compose.yml 파일에서 수정
> # (nodebb 디렉토리 내 docker-compose.yml 파일 수정)
>
> # 직접 편집
> # ports:
> #   - "8240:4567"
> ```

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

NodeBB는 웹 인터페이스를 통해 초기 설정을 진행하며, config.json 파일에 설정이 저장됩니다.

### 데이터베이스 설정 (초기 설정 시)

```bash
# PostgreSQL 설정
Database Type: PostgreSQL
Host IP or address: postgres
Host port: 5432
Database name: nodebb
Username: nodebb
Password: nodebb
```

### Redis 설정 (초기 설정 시)

```bash
Redis Host: redis
Redis Port: 6379
Redis Password: (비워두기)
```

### 사이트 설정

```bash
# 초기 설정 마법사에서 입력
URL: http://localhost:4567 (또는 실제 도메인)
Port: 4567
Admin Username: admin
Admin Email: admin@example.com
Admin Password: (강력한 비밀번호)
```

## 사용 가능한 명령어

### 초기 설정

```bash
# NodeBB 저장소 클론 및 설정
make setup

# NodeBB 초기화 및 데이터베이스 삭제
make reset

# NodeBB 완전 삭제
make teardown
```

### 서비스 관리

```bash
# 서비스 시작
cd nodebb
docker compose up -d

# 로그 확인
docker compose logs -f

# 특정 서비스 로그 확인
docker compose logs -f nodebb

# 서비스 재시작
docker compose restart nodebb

# 서비스 중지
docker compose down

# 서비스 중지 및 볼륨 삭제
docker compose down -v
```

### NodeBB 관리

```bash
# NodeBB 컨테이너 쉘 접속
docker compose exec nodebb bash

# NodeBB CLI 명령어 실행
docker compose exec nodebb ./nodebb <command>

# 사용 가능한 CLI 명령어 확인
docker compose exec nodebb ./nodebb help
```

## 사용법

### 플러그인 설치

웹 인터페이스를 통한 설치:
```
1. 관리자로 로그인
2. 관리자 패널 (Admin Panel) 접속
3. Extend > Plugins 선택
4. "Find Plugins" 탭에서 플러그인 검색
5. Install 버튼 클릭
6. NodeBB 재시작
```

CLI를 통한 설치:
```bash
# 컨테이너 내부로 진입
docker compose exec nodebb bash

# npm으로 플러그인 설치
npm install nodebb-plugin-name

# NodeBB 재빌드
./nodebb build

# 컨테이너 재시작
exit
docker compose restart nodebb
```

### 테마 변경

```bash
# 웹 인터페이스에서
1. 관리자 패널 > Appearance > Themes
2. 원하는 테마 선택 또는 새 테마 설치
3. "Apply" 클릭

# 또는 CLI를 통해
docker compose exec nodebb ./nodebb reset -t
docker compose restart nodebb
```

### 데이터베이스 백업

```bash
# PostgreSQL 백업
docker compose exec postgres pg_dump -U nodebb nodebb > nodebb-backup.sql

# 백업 복원
docker compose exec -T postgres psql -U nodebb nodebb < nodebb-backup.sql
```

### NodeBB 업그레이드

```bash
# 컨테이너 내부로 진입
docker compose exec nodebb bash

# Git으로 최신 버전 가져오기
git fetch
git checkout v1.19.x  # 원하는 버전으로 변경
git pull

# 의존성 업데이트
./nodebb upgrade

# 컨테이너 재시작
exit
docker compose restart nodebb
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 준비 상태 확인
docker compose logs postgres

# "database system is ready" 메시지 확인 후
docker compose restart nodebb
```

### Redis 연결 오류

```bash
# Redis 상태 확인
docker compose exec redis redis-cli ping
# PONG 응답이 와야 함

# Redis 재시작
docker compose restart redis
docker compose restart nodebb
```

### NodeBB가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f nodebb

# config.json 초기화
docker compose exec nodebb rm -f config.json
docker compose restart nodebb
# 브라우저에서 초기 설정 다시 진행

# 또는 완전 초기화
make reset
```

### 플러그인 충돌

```bash
# 플러그인 비활성화
docker compose exec nodebb ./nodebb reset -p

# NodeBB 재시작
docker compose restart nodebb

# 웹 인터페이스에서 문제 플러그인 제거
```

### 권한 오류

```bash
# NodeBB 디렉토리 권한 확인 및 수정
docker compose exec nodebb chown -R node:node /usr/src/app

# 재시작
docker compose restart nodebb
```

### 빌드 오류

```bash
# NodeBB 재빌드
docker compose exec nodebb ./nodebb build

# npm 캐시 삭제 후 재빌드
docker compose exec nodebb rm -rf node_modules
docker compose exec nodebb npm install
docker compose exec nodebb ./nodebb build
docker compose restart nodebb
```

### 로그 확인

```bash
# 컨테이너 로그
docker compose logs -f nodebb

# NodeBB 로그 파일 (컨테이너 내부)
docker compose exec nodebb tail -f logs/output.log
```

## 디렉토리 구조

```
nodebb/
├── Makefile              # 편의 명령어
├── README.md             # 이 문서
└── nodebb/               # NodeBB 소스코드 (make setup으로 생성)
    ├── docker-compose.yml # Docker Compose 설정
    ├── config.json       # NodeBB 설정 (초기 설정 후 생성)
    ├── public/           # 정적 파일
    ├── build/            # 빌드된 파일
    ├── plugins/          # 설치된 플러그인
    └── .docker/          # Docker 데이터 볼륨
        ├── database/     # PostgreSQL 데이터
        └── redis/        # Redis 데이터
```

## 참고 자료

- [NodeBB 공식 GitHub](https://github.com/NodeBB/NodeBB)
- [NodeBB 공식 문서](https://docs.nodebb.org/)
- [NodeBB 커뮤니티](https://community.nodebb.org/)
- [NodeBB 플러그인 디렉토리](https://www.npmjs.com/search?q=nodebb-plugin)
- [NodeBB 테마 디렉토리](https://www.npmjs.com/search?q=nodebb-theme)
- [NodeBB API 문서](https://docs.nodebb.org/api/)

## 기술 스택

- **Backend**: Node.js, Express.js
- **Frontend**: JavaScript, Bootstrap
- **Database**: PostgreSQL (또는 MongoDB, Redis 지원)
- **Cache**: Redis
- **Real-time**: Socket.io
- **Container**: Docker, Docker Compose

## 고급 설정

### 이메일 설정

config.json 파일에 SMTP 설정 추가:
```json
{
  "email": {
    "from": "no-reply@example.com",
    "smtp": {
      "host": "smtp.gmail.com",
      "port": 587,
      "secure": false,
      "auth": {
        "user": "your-email@gmail.com",
        "pass": "your-app-password"
      }
    }
  }
}
```

### SSL/HTTPS 설정

Nginx 리버스 프록시를 사용하거나, config.json에서 설정:
```json
{
  "url": "https://yourdomain.com",
  "ssl": {
    "enabled": true,
    "key": "/path/to/privkey.pem",
    "cert": "/path/to/fullchain.pem"
  }
}
```

### 성능 최적화

config.json에서 클러스터 모드 활성화:
```json
{
  "cluster": {
    "enabled": true,
    "workers": 4
  }
}
```

## 주의사항

1. **초기 설정**: 첫 실행 시 반드시 웹 인터페이스를 통해 초기 설정을 완료해야 합니다.
2. **보안**: 프로덕션 환경에서는 강력한 비밀번호와 HTTPS를 사용하세요.
3. **백업**: config.json과 데이터베이스를 정기적으로 백업하세요.
4. **업데이트**: NodeBB 업그레이드 전에 백업을 권장합니다.
5. **포트**: 기본 포트 4567이 다른 서비스와 충돌할 수 있으니 필요 시 변경하세요.

## 라이선스

NodeBB는 GPL-3.0 라이선스로 배포됩니다.
