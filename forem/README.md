# Forem

Forem은 커뮤니티 플랫폼을 구축하기 위한 오픈소스 소프트웨어입니다. [DEV Community](https://dev.to)를 구동하는 플랫폼이기도 합니다.

## 빠른 시작

이 디렉토리에서 바로 Forem을 실행할 수 있습니다:

```bash
# 1. Forem 소스코드 클론 (최초 1회만)
make prepare

# 2. 서비스 시작
make up

# 3. 데이터베이스 초기화
make db-setup

# 4. 브라우저에서 접속
# http://localhost:3000
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

- **web**: Forem Rails 애플리케이션 서버 (포트 3000)
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

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 3000 | web | Rails 애플리케이션 (권장 포트 사용 중) |
| 5432 | postgres | PostgreSQL (내부) |
| 6379 | redis | Redis (내부) |
| 3333 | chrome | Chrome (테스트용) |

> ✅ **포트 설정**: 이미 권장 포트(3000, 3333)를 사용하고 있습니다. ([포트 가이드](../docs/PORT_GUIDE.md) 참조)

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

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
