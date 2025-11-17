# Forem

Forem은 커뮤니티 플랫폼을 구축하기 위한 오픈소스 소프트웨어입니다. [DEV Community](https://dev.to)를 구동하는 플랫폼이기도 합니다.

## 개요

이 디렉토리는 Forem 애플리케이션의 개발 환경을 Docker Compose로 실행하기 위한 설정을 포함하고 있습니다.

## 사용 방법

### 1. Forem 소스코드 준비

Forem을 실행하려면 먼저 공식 리포지토리를 클론해야 합니다:

```bash
# Forem 리포지토리 클론
git clone https://github.com/forem/forem.git
cd forem

# 이 리포지토리의 compose.yml을 Forem 디렉토리로 복사
cp /path/to/sb-docker-images/forem/compose.yml .
```

### 2. 개발 환경 실행

```bash
# 모든 서비스 시작
docker compose up

# 백그라운드 실행
docker compose up -d

# 특정 서비스만 시작
docker compose up web postgres redis
```

### 3. 데이터베이스 초기화

```bash
# 데이터베이스 생성 및 마이그레이션
docker compose exec web bundle exec rails db:create db:migrate

# 샘플 데이터 로드 (선택사항)
docker compose exec web bundle exec rails db:seed
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **web**: Forem Rails 애플리케이션 서버 (포트 3000)
- **sidekiq**: 백그라운드 작업 처리
- **esbuild**: JavaScript 빌드 (watch 모드)
- **postgres**: PostgreSQL 13 데이터베이스
- **redis**: Redis 8.2 캐시 서버
- **chrome**: Headless Chrome (테스트용, 포트 3333)

## 환경 변수

주요 환경 변수:

- `RAILS_ENV`: Rails 환경 (기본값: development)
- `NODE_ENV`: Node.js 환경 (기본값: development)
- `DATABASE_URL`: PostgreSQL 연결 URL
- `REDIS_URL`: Redis 연결 URL
- `LOCAL_WORKSPACE_FOLDER`: 로컬 작업 디렉토리 경로

## 포트

- `3000`: Rails 애플리케이션
- `5432`: PostgreSQL (내부)
- `6379`: Redis (내부)
- `3333`: Chrome (테스트용)

## 기술 스택

- Ruby 3.3.0
- Rails 7.x
- Node.js 20.x
- PostgreSQL 13
- Redis 8.2
- ImageMagick (이미지 처리)

## 참고 자료

- [Forem 공식 GitHub](https://github.com/forem/forem)
- [Forem 공식 문서](https://docs.forem.com/)
- [Forem 공식 Docker 가이드](https://docs.forem.com/getting-started/installation/containers/)
- [DEV Community](https://dev.to)

## Docker 이미지

Forem 공식 Docker 이미지:
- `ghcr.io/forem/forem:development` - 개발 환경용
- `ghcr.io/forem/forem:latest` - 프로덕션 환경용

공식 이미지를 사용하므로 별도로 Dockerfile을 빌드할 필요가 없습니다.

## 라이선스

Forem은 AGPLv3 라이선스로 배포됩니다.
