# Contributing Guide

sb-docker-images 프로젝트에 기여해 주셔서 감사합니다!

## 목차

- [새 프로젝트 추가하기](#새-프로젝트-추가하기)
- [Compose 파일 작성 규칙](#compose-파일-작성-규칙)
- [포트 할당 정책](#포트-할당-정책)
- [환경변수 템플릿](#환경변수-템플릿)
- [Makefile 작성](#makefile-작성)
- [문서화](#문서화)
- [테스트 및 검증](#테스트-및-검증)

## 새 프로젝트 추가하기

### 1. 디렉토리 구조 생성

```bash
mkdir <project-name>
cd <project-name>
```

### 2. 필수 파일 생성

**최소 구성**:
```
<project-name>/
├── compose.yml          # Docker Compose 설정
├── .env.example         # 환경변수 템플릿
├── Makefile            # 자동화 명령어
└── README.md           # 프로젝트 문서
```

**Standalone 구성 (선택사항)**:
```
<project-name>/
├── compose.yml
├── .env.example
├── Makefile
├── README.md
└── standalone/         # 프로덕션 준비 구성
    ├── compose.yml
    ├── .env.example
    ├── Makefile (선택)
    └── README.md
```

### 3. PORT_GUIDE.md 확인

포트 충돌을 방지하기 위해 [`PORT_GUIDE.md`](./PORT_GUIDE.md)를 확인하고 사용 가능한 포트를 할당받으세요.

```bash
# 포트 충돌 확인
./scripts/check-port-conflicts.sh
```

### 4. 검증 실행

```bash
# Compose 파일 검증
./scripts/validate-compose.sh ./<project-name>

# 환경변수 템플릿 테스트
./scripts/test-env-examples.sh

# 필수 파일 확인
./scripts/check-required-files.sh
```

## Compose 파일 작성 규칙

### 네이밍

- **우선**: `compose.yml` (Docker Compose V2 표준)
- **대체**: `compose.<variant>.yml` (예: `compose.apache.yml`, `compose.fpm.yml`)
- **레거시**: `docker-compose.yml` (호환성 유지)

### 기본 구조

```yaml
services:
  app:
    image: app:latest
    container_name: app-name
    restart: always
    ports:
      - "8XXX:80"  # PORT_GUIDE.md 참조
    environment:
      # 환경변수 설정
    volumes:
      - app-data:/data
    networks:
      - app-network
    healthcheck:  # 권장
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 10s
      timeout: 5s
      retries: 5
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    # ... 데이터베이스 설정
    healthcheck:  # 필수
      test: ["CMD-SHELL", "pg_isready"]
      interval: 10s
      timeout: 5s
      retries: 5

networks:
  app-network:
    driver: bridge

volumes:
  app-data:
  db-data:
```

### 필수 사항

1. **Health Checks**: 모든 데이터베이스 서비스에 필수
2. **네트워크**: 명시적인 네트워크 정의
3. **볼륨**: 데이터 영속성을 위한 named volumes
4. **Restart Policy**: 프로덕션 구성에는 `restart: always`

### 권장 사항

- `depends_on`에 health check 조건 사용
- 민감한 정보는 환경변수로 분리
- 컨테이너 이름 명시 (`container_name`)

## 포트 할당 정책

### 포트 범위

| 범위 | 용도 | 예시 |
|------|------|------|
| 3000-3999 | 데이터베이스 관련 | 3306 (MySQL), 5432 (PostgreSQL) |
| 8000-8999 | 웹 애플리케이션 | 8080, 8090, 8100 |
| 기타 | 특수 목적 서비스 | 1935 (RTMP), 6379 (Redis) |

### 할당 절차

1. [`PORT_GUIDE.md`](./PORT_GUIDE.md) 확인
2. 사용 가능한 포트 선택
3. `PORT_GUIDE.md`에 등록
4. 충돌 검사 실행

```bash
./scripts/check-port-conflicts.sh
```

### 포트 설정 예시

```yaml
services:
  web:
    ports:
      - "${WEB_PORT:-8150}:80"  # 환경변수로 설정 가능
```

## 환경변수 템플릿

### .env.example 작성

모든 프로젝트는 `.env.example` 파일을 포함해야 합니다.

**템플릿 구조**:
```bash
# Project Name - Environment Variables
# Copy this file to .env and update the values
#
# This is a development setup. For production, see standalone/
# See: https://project-url.com/

# ============================================================================
# Port Configuration
# ============================================================================
WEB_PORT=8080
# Web application port
# Default: 8080

# ============================================================================
# Database Configuration
# ============================================================================
DB_HOST=db
DB_PORT=5432
DB_NAME=myapp
DB_USER=user01
DB_PASSWORD=changeme
# SECURITY: Change this password in production!

# ============================================================================
# Redis Configuration
# ============================================================================
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=changeme
```

### 작성 규칙

1. **섹션 구분**: `# ===...===` 헤더 사용
2. **주석**: 각 변수에 설명과 기본값 명시
3. **보안 경고**: 민감한 정보에 경고 추가
4. **참조**: 관련 문서 링크 포함

## Makefile 작성

### 표준 타겟

모든 Makefile은 다음 타겟을 포함해야 합니다:

```makefile
.PHONY: help up down logs restart clean ps

help:
	@echo "Available commands:"
	@echo "  make up      - Start services"
	@echo "  make down    - Stop services"
	@echo "  make logs    - View logs"
	@echo "  make restart - Restart services"
	@echo "  make clean   - Remove all resources"
	@echo "  make ps      - Show container status"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

clean:
	docker compose down -v
	docker system prune -f

ps:
	docker compose ps
```

### 추가 타겟 (선택사항)

- `prepare`: 초기 설정 (파일 다운로드, 권한 설정 등)
- `build`: 이미지 빌드
- `test`: 서비스 테스트
- `backup`: 데이터 백업

## 문서화

### README.md 구조

모든 프로젝트 README는 다음 섹션을 포함해야 합니다:

```markdown
# Project Name

간단한 프로젝트 설명

## Features

- 주요 기능 1
- 주요 기능 2

## Quick Start

```bash
# 환경변수 설정
cp .env.example .env

# 서비스 시작
docker compose up -d
```

## Configuration

환경변수 설명

## Ports

- 8080: Web UI
- 3306: MySQL

## Volumes

- `app-data`: 애플리케이션 데이터
- `db-data`: 데이터베이스

## Deployment Options

- Development: 루트의 compose.yml
- Production: standalone/ 디렉토리

## Troubleshooting

일반적인 문제와 해결 방법

## References

- [Official Documentation](https://...)
- [Docker Hub](https://hub.docker.com/_/...)
```

### Standalone README

Standalone 구성은 추가로 다음 정보를 포함:

- 프로덕션 준비 사항
- 백업/복구 절차
- 스케일링 방법
- 모니터링 설정

## 테스트 및 검증

### 로컬 테스트

```bash
# 1. Compose 파일 검증
docker compose config

# 2. 서비스 시작
docker compose up -d

# 3. 헬스 체크 확인
docker compose ps

# 4. 로그 확인
docker compose logs

# 5. 정리
docker compose down -v
```

### 자동화 검증

```bash
# 전체 검증 실행
./scripts/validate-compose.sh
./scripts/check-port-conflicts.sh
./scripts/test-env-examples.sh
./scripts/verify-health-checks.sh
```

### Pull Request 전 체크리스트

- [ ] 포트 충돌 확인
- [ ] Compose 파일 검증 통과
- [ ] .env.example 작성
- [ ] README.md 작성
- [ ] Makefile 작성 (선택)
- [ ] Health check 설정 (데이터베이스)
- [ ] 로컬 테스트 완료
- [ ] 자동화 검증 통과

## 커밋 메시지 규칙

Conventional Commits 형식 사용:

```
<type>(<scope>): <subject>

<body>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**:
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `refactor`: 코드 리팩토링
- `test`: 테스트 추가/수정
- `chore`: 빌드/도구 변경

## 문의 및 지원

- 이슈: [GitHub Issues](https://github.com/scriptonbasestar/sb-docker-images/issues)
- 토론: [GitHub Discussions](https://github.com/scriptonbasestar/sb-docker-images/discussions)

---

감사합니다! 🎉
