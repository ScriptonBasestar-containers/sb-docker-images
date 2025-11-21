# Forem

> 💡 **Quick Start**: This project does not have a standalone setup. Use the basic setup below for development and testing.

## 개요

Forem은 커뮤니티 플랫폼을 구축하기 위한 오픈소스 소프트웨어입니다. [DEV Community](https://dev.to)를 구동하는 플랫폼이기도 합니다:
- 🌐 커뮤니티 중심 플랫폼
- ✍️ 마크다운 기반 콘텐츠 작성
- 🏷️ 태그 기반 콘텐츠 구성
- 👥 사용자 프로필 및 팔로우
- 🔔 실시간 알림
- 💬 댓글 및 토론
- 📱 반응형 디자인
- 🔌 확장 가능한 아키텍처

## Deployment Options

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default port:** 8520 (see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** forem-web

Environment variables:
```bash
RAILS_ENV=development
NODE_ENV=development
DATABASE_URL=postgresql://forem:forem@postgres:5432/forem_development
REDIS_URL=redis://redis:6379
PG_MAJOR=13
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8520 | web | Rails application |
| 5432 | postgres | PostgreSQL (internal) |
| 6379 | redis | Redis (internal) |
| 3333 | chrome | Chrome for testing |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## 빠른 시작

```bash
# 1. Forem 소스코드 클론 (최초 1회만)
make prepare

# 2. 서비스 시작
make up

# 3. 데이터베이스 초기화
make db-setup

# 4. 브라우저에서 접속
# http://localhost:8520
```

## 사용 가능한 명령어

```bash
make help         # 도움말 보기
make prepare      # Forem 소스코드 클론
make up           # 모든 서비스 시작
make down         # 모든 서비스 중지
make restart      # 서비스 재시작
make logs         # 로그 보기
make shell        # 웹 컨테이너 쉘 접속
make db-setup     # 데이터베이스 생성 및 마이그레이션
make db-migrate   # 데이터베이스 마이그레이션 실행
make db-seed      # 샘플 데이터 로드
make clean        # 모든 컨테이너 및 볼륨 삭제
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **web**: Forem Rails 애플리케이션 서버 (포트 8520)
- **sidekiq**: 백그라운드 작업 처리
- **esbuild**: JavaScript 빌드 (watch 모드)
- **postgres**: PostgreSQL 13 데이터베이스
- **redis**: Redis 8.2 캐시 서버
- **chrome**: Headless Chrome (테스트용, 포트 3333)

## 디렉토리 구조

```
forem/
├── compose.yml       # Docker Compose 설정
├── Makefile          # 편의 명령어
├── README.md         # 이 문서
└── forem-src/        # Forem 소스코드 (make prepare로 생성)
```

## 환경 변수

주요 환경 변수 (compose.yml에서 설정):

- `RAILS_ENV`: Rails 환경 (기본값: development)
- `NODE_ENV`: Node.js 환경 (기본값: development)
- `DATABASE_URL`: PostgreSQL 연결 URL
- `REDIS_URL`: Redis 연결 URL
- `PG_MAJOR`: PostgreSQL 버전 (기본값: 13)


## 기술 스택

- Ruby 3.3.0
- Rails 7.x
- Node.js 20.x
- PostgreSQL 13
- Redis 8.2
- ImageMagick (이미지 처리)

## 문제 해결

### 소스코드가 없다는 에러
```bash
# forem-src 디렉토리가 없으면
make prepare
```

### 빌드 에러
```bash
# 컨테이너와 볼륨을 모두 삭제하고 재시작
make clean
make prepare  # 소스코드가 없으면
make up
```

### 데이터베이스 연결 에러
```bash
# postgres 서비스가 준비될 때까지 기다리고 재시도
make down
make up
make db-setup
```

## 참고 자료

- [Forem 공식 GitHub](https://github.com/forem/forem)
- [Forem 공식 문서](https://docs.forem.com/)
- [Forem 공식 Docker 가이드](https://docs.forem.com/getting-started/installation/containers/)
- [DEV Community](https://dev.to)

## Docker 이미지

이 설정은 Forem을 소스코드에서 빌드합니다:
- `context: ./forem-src` - 로컬에 클론된 소스에서 빌드
- `target: development` - 개발 환경용 이미지
- `image: ghcr.io/forem/forem:1.0.0-development` - 빌드된 이미지 태그

공식 이미지도 사용 가능하지만, 개발 환경에서는 소스 빌드를 권장합니다.

## 라이선스

Forem은 AGPLv3 라이선스로 배포됩니다.
