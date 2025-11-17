# Solidus

Solidus Ruby 기반 오픈소스 E-commerce 플랫폼

## 개요

Solidus는 Ruby on Rails 기반의 오픈소스 전자상거래 플랫폼입니다. Spree에서 포크된 프로젝트로, 확장 가능하고 유연한 아키텍처를 제공합니다. 중소규모부터 대규모 온라인 쇼핑몰까지 다양한 규모의 전자상거래 사이트 구축에 활용됩니다.

## 빠른 시작

```bash
# 소스 코드 다운로드
make setup

# Docker 이미지 빌드
make build

# 컨테이너 시작
make run

# 웹 브라우저로 접속
# http://localhost:8410
```

## 서비스 구성

- **web**: Solidus 애플리케이션 (포트 8410)
- **postgres**: PostgreSQL 데이터베이스
- **redis**: Redis (캐시/세션)

※ 주의: Solidus 프로젝트는 공식 저장소를 클론한 후 해당 디렉토리 내의 docker-compose를 사용합니다.

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8410 | web | 웹 사이트 (권장 포트 사용 중) |

> ✅ **포트 설정**: 이미 권장 포트(8410)를 사용하고 있습니다. ([포트 가이드](../docs/PORT_GUIDE.md) 참조)

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

docker-compose.yml에서 설정 (solidus 디렉토리 내):

```yaml
environment:
  - DATABASE_URL=postgresql://postgres:password@postgres/solidus_development
  - REDIS_URL=redis://redis:6379/0
  - RAILS_ENV=development
```

## 디렉토리 구조

```
solidus/
├── Makefile              # 빌드 및 실행 스크립트
├── README.md             # 이 문서
└── solidus/              # 클론된 Solidus 저장소
    ├── docker-compose.yml
    ├── Dockerfile
    └── ...
```

## 설치 방법

### 1. Solidus 저장소 클론

```bash
make setup
# 또는
git clone https://github.com/solidusio/solidus.git
cd solidus && git checkout v4.3
```

### 2. Docker 이미지 빌드

```bash
make build
# 또는
cd solidus && docker compose build --no-cache
```

### 3. 컨테이너 실행

```bash
make run
# 또는
cd solidus && docker compose up -d
```

### 4. 데이터베이스 초기화

```bash
cd solidus
docker compose exec web rails db:create db:migrate
docker compose exec web rails db:seed
```

## 사용법

### 관리자 페이지

```
URL: http://localhost:8410/admin
ID: admin@example.com (기본값, 시드 데이터에 따라 다름)
PW: test123 (기본값, 시드 데이터에 따라 다름)
```

### 샘플 데이터 로드

```bash
cd solidus
docker compose exec web rails spree_sample:load
```

### Rails 콘솔 접속

```bash
cd solidus
docker compose exec web rails console
```

## 데이터베이스 관리

### 데이터베이스 백업

```bash
cd solidus
docker compose exec postgres pg_dump -U postgres solidus_development > backup.sql
```

### 데이터베이스 복원

```bash
cd solidus
docker compose exec -T postgres psql -U postgres solidus_development < backup.sql
```

### 마이그레이션 실행

```bash
cd solidus
docker compose exec web rails db:migrate
```

## 볼륨

Solidus 저장소 내의 docker-compose.yml에 정의됨:

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data
  - redis_data:/data
```

## 문제 해결

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
cd solidus
docker compose logs -f web

# 컨테이너 재시작
docker compose restart web
```

### 데이터베이스 연결 실패

```bash
# PostgreSQL 컨테이너 상태 확인
cd solidus
docker compose ps postgres

# 데이터베이스 재생성
docker compose exec web rails db:drop db:create db:migrate db:seed
```

### 포트 충돌

```bash
# docker-compose.yml의 포트 변경
ports:
  - "8411:3000"  # 기본 8410 대신 8411 사용
```

### 이미지 빌드 실패

```bash
# 캐시 없이 재빌드
cd solidus
docker compose build --no-cache
```

## 개발 환경

### 로그 확인

```bash
cd solidus
docker compose logs -f web
```

### 컨테이너 내부 접속

```bash
cd solidus
docker compose exec web bash
```

### 의존성 업데이트

```bash
cd solidus
docker compose exec web bundle update
```

## 기술 스택

- **Ruby**: 3.x
- **Rails**: 7.x
- **PostgreSQL**: latest
- **Redis**: latest
- **Solidus**: v4.3

## 참고 자료

- [Solidus 공식 사이트](https://solidus.io/)
- [Solidus GitHub](https://github.com/solidusio/solidus)
- [Solidus 문서](https://guides.solidus.io/)
- [Solidus API 문서](https://api.solidus.io/)

## 관련 프로젝트

- [spree](../spree/README.md) - Spree Commerce (Solidus의 원본 프로젝트)

## 라이선스

Solidus는 BSD 3-Clause 라이선스를 따릅니다.

## 주의사항

- 이 프로젝트는 외부 저장소(https://github.com/solidusio/solidus)를 클론하여 사용합니다.
- `make setup` 명령으로 먼저 저장소를 클론해야 합니다.
- docker-compose 파일은 클론된 solidus 디렉토리 내에 있습니다.
- 프로덕션 환경에서는 환경 변수와 시크릿을 반드시 변경하세요.
