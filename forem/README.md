# Forem Docker Image

Forem은 커뮤니티 플랫폼을 구축하기 위한 오픈소스 소프트웨어입니다. [DEV Community](https://dev.to)를 구동하는 플랫폼이기도 합니다.

## 개요

이 디렉토리는 Forem 애플리케이션을 Docker 컨테이너로 실행하기 위한 설정을 포함하고 있습니다.

## 구성 요소

- **Dockerfile**: Forem 애플리케이션 이미지 (multi-stage build)
  - `development`: 개발 환경용 이미지
  - `builder`: 빌드 스테이지
  - `production`: 프로덕션 환경용 이미지
- **Dockerfile.base**: Ruby, Node.js, PostgreSQL 클라이언트 등 기본 의존성을 포함한 베이스 이미지
- **compose.yml**: Docker Compose 설정 파일

## 필요한 서비스

Forem은 다음 서비스들을 필요로 합니다:

- **PostgreSQL 13**: 메인 데이터베이스
- **Redis 8.2**: 캐시 및 백그라운드 작업 큐
- **Chrome (browserless)**: E2E 테스트용 (선택사항)

## 사용 방법

### 개발 환경 실행

```bash
# 모든 서비스 시작
docker-compose up

# 특정 서비스만 시작
docker-compose up web postgres redis

# 백그라운드 실행
docker-compose up -d
```

### 초기 설정

```bash
# 데이터베이스 생성 및 마이그레이션
docker-compose exec web bundle exec rails db:create db:migrate

# 샘플 데이터 로드 (선택사항)
docker-compose exec web bundle exec rails db:seed
```

### 서비스 설명

- **web**: Forem Rails 애플리케이션 서버 (포트 3000)
- **sidekiq**: 백그라운드 작업 처리
- **esbuild**: JavaScript 빌드 (watch 모드)
- **postgres**: PostgreSQL 데이터베이스
- **redis**: Redis 캐시 서버
- **chrome**: Headless Chrome (테스트용)

## 환경 변수

주요 환경 변수:

- `RAILS_ENV`: Rails 환경 (development/production)
- `NODE_ENV`: Node.js 환경
- `DATABASE_URL`: PostgreSQL 연결 URL
- `REDIS_URL`: Redis 연결 URL
- `WEB_CONCURRENCY`: Web worker 수

## 포트

- `3000`: Rails 애플리케이션
- `5432`: PostgreSQL (내부)
- `6379`: Redis (내부)
- `3333`: Chrome (테스트용)

## 볼륨

- `bundle`: Ruby gems 캐시
- `node_modules`: NPM 패키지 캐시
- `postgres`: PostgreSQL 데이터
- `redis`: Redis 데이터
- `rails_cache`: Rails 캐시
- `history`: Shell 히스토리

## 참고 자료

- [Forem 공식 GitHub](https://github.com/forem/forem)
- [Forem 공식 문서](https://docs.forem.com/)
- [DEV Community](https://dev.to)

## 기술 스택

- Ruby 3.3.0
- Rails 7.x
- Node.js 20.x
- PostgreSQL 13
- Redis 8.2
- ImageMagick (이미지 처리)

## 라이선스

Forem은 AGPLv3 라이선스로 배포됩니다.
