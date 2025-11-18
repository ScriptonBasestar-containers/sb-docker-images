# Contributing to sb-docker-images

이 프로젝트에 기여해 주셔서 감사합니다! 🎉

이 문서는 프로젝트에 기여하는 방법과 코드 표준을 설명합니다.

## 📋 목차

- [시작하기](#시작하기)
- [프로젝트 구조](#프로젝트-구조)
- [표준 및 규칙](#표준-및-규칙)
- [검증 및 테스트](#검증-및-테스트)
- [기여 프로세스](#기여-프로세스)

---

## 시작하기

### 저장소 클론

```bash
git clone https://github.com/your-org/sb-docker-images.git
cd sb-docker-images
```

### 새 프로젝트 추가하기

1. 프로젝트 디렉토리 생성
2. 필수 파일 작성 (README.md, Makefile, compose.yml)
3. Standalone 구성 추가 (권장)
4. 검증 스크립트 실행
5. PR 생성

---

## 프로젝트 구조

### 기본 구조

```
project-name/
├── README.md              # 프로젝트 문서 (필수)
├── Makefile               # 표준 타겟 제공 (필수)
├── compose.yml            # Docker Compose 설정 (필수)
├── .env.example           # 환경변수 예제 (권장)
└── standalone/            # 독립 실행 구성 (권장)
    ├── README.md
    ├── compose.yml
    ├── Makefile
    └── .env.example
```

### Standalone 구성

완전한 독립 실행 가능한 구성은 `standalone/` 디렉토리에 배치:

- 데이터베이스 (MariaDB, PostgreSQL 등)
- 캐시 (Redis, Memcached 등)
- 애플리케이션
- 네트워크 분리 (app-network, data-network)
- Health checks

---

## 표준 및 규칙

### 1. Makefile 표준

모든 프로젝트는 다음 표준 타겟을 제공해야 합니다:

```makefile
.PHONY: help up down restart logs ps shell clean

help:  ## 도움말 표시
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

up:  ## 서비스 시작
	@echo "🚀 Starting services..."
	docker compose up -d
	@echo "✅ Services started!"
	@echo "📍 Access: http://localhost:8080"

down:  ## 서비스 중지
	docker compose down

restart:  ## 서비스 재시작
	docker compose restart

logs:  ## 로그 보기
	docker compose logs -f

ps:  ## 컨테이너 상태 확인
	docker compose ps

shell:  ## 컨테이너 쉘 접속
	docker compose exec <service-name> sh

clean:  ## 데이터 포함 완전 삭제
	@echo "⚠️  WARNING: This will remove all data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ Cleaned!"; \
	fi
```

**중요:**
- `.PHONY` 선언 필수
- `help`를 기본 타겟으로 설정
- 이모지로 시각적 피드백 제공
- `clean` 타겟에 확인 프롬프트 추가

### 2. 포트 할당 규칙

포트는 [PORT_GUIDE.md](./PORT_GUIDE.md)를 참조하여 할당:

**포트 범위:**
- 웹 애플리케이션: 8000-8999
- 데이터베이스: 3000-3999
- 캐시: 6000-6999
- 특수 서비스: 프로젝트별 할당

**환경변수 사용:**

```yaml
services:
  web:
    container_name: ${WEB_CONTAINER_NAME:-myapp}
    ports:
      - "${WEB_PORT:-8100}:80"
    environment:
      - SERVER_URL=http://localhost:${WEB_PORT:-8100}
```

**포트 충돌 검사:**

```bash
./scripts/check-port-conflicts.sh
```

### 3. Docker Compose 파일 작성

**기본 원칙:**
- 환경변수 기본값 제공: `${VAR:-default}`
- 컨테이너 이름 변수화: `${CONTAINER_NAME:-default}`
- 네트워크 분리 (app-network, data-network)
- Health checks 추가 (데이터베이스 필수)

**Health Check 예제:**

```yaml
# PostgreSQL
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-user01}"]
  interval: 10s
  timeout: 5s
  retries: 5

# MariaDB
healthcheck:
  test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
  interval: 10s
  timeout: 5s
  retries: 5

# Redis
healthcheck:
  test: ["CMD", "redis-cli", "ping"]
  interval: 10s
  timeout: 3s
  retries: 3
```

### 4. .env.example 작성

모든 환경변수를 문서화하고 안전한 기본값 제공:

```bash
# ====================
# Project Settings
# ====================
PROJECT_NAME=myapp
TZ=Asia/Seoul

# ====================
# Port Configuration
# ====================
WEB_PORT=8100
# Default: 8100 (avoid conflicts with other services)

# ====================
# Database Configuration
# ====================
DB_HOST=postgres
DB_PORT=5432
DB_NAME=db01
DB_USER=user01
DB_PASSWORD=change-me-strong-password

# ====================
# Container Names
# ====================
WEB_CONTAINER_NAME=myapp
DB_CONTAINER_NAME=myapp_postgres

# ====================
# Security Notes
# ====================
# ⚠️  IMPORTANT: Change all default passwords before deploying to production!
#
# Generate secure passwords:
#   openssl rand -base64 32
```

### 5. README 작성 표준

모든 프로젝트 README는 다음 섹션을 포함:

1. **프로젝트 제목 및 설명**
2. **Features** - 주요 기능
3. **Quick Start** - 빠른 시작 가이드
4. **Ports** - 포트 정보 테이블
5. **Environment Variables** - 환경변수 설명
6. **Usage** - Makefile 명령어
7. **Configuration** - 설정 방법
8. **Troubleshooting** - 문제 해결
9. **References** - 참고 자료

**포트 정보 표준 형식:**

```markdown
## Ports

| Port | Service | Description |
|------|---------|-------------|
| 8100 | web | Web application (WEB_PORT) |
| 5432 | postgres | PostgreSQL database (internal) |

> ✅ **Port Configuration**: Default port is 8100. Change via WEB_PORT environment variable.
>
> See [PORT_GUIDE.md](../PORT_GUIDE.md) for details.
```

---

## 검증 및 테스트

### 로컬 검증

PR 생성 전 반드시 모든 검증 스크립트 실행:

```bash
# 1. YAML 문법 검증
./scripts/validate-compose.sh

# 2. .env.example 파일 검증
./scripts/test-env-examples.sh

# 3. 필수 파일 확인
./scripts/check-required-files.sh

# 4. 포트 충돌 확인
./scripts/check-port-conflicts.sh

# 5. Health check 검증
./scripts/verify-health-checks.sh
```

### 검증 통과 기준

**필수 (Must Pass):**
- ✅ Docker Compose YAML 문법 오류 없음
- ✅ .env.example 파일 구조 올바름
- ✅ README.md, Makefile, compose.yml 존재

**권장 (Should Pass):**
- ⚠️ 포트 충돌 없음 (독립 실행 서비스 예외)
- ℹ️ 데이터베이스 서비스에 health check 존재

### 실제 실행 테스트

```bash
# 서비스 시작
cd your-project/
make up

# 동작 확인
curl http://localhost:8100
docker compose ps

# 로그 확인
make logs

# 정리
make down
```

---

## 기여 프로세스

### 1. 이슈 생성 (선택)

버그 리포트나 기능 제안은 이슈로 먼저 등록하는 것을 권장합니다.

### 2. 브랜치 생성

```bash
# Feature 브랜치
git checkout -b feature/add-project-name

# Bugfix 브랜치
git checkout -b fix/port-conflict-issue

# Documentation 브랜치
git checkout -b docs/improve-readme
```

### 3. 변경 작업

표준 및 규칙을 준수하여 작업:
- Makefile 표준 타겟 구현
- 포트 충돌 회피
- Health checks 추가
- .env.example 작성
- README 문서화

### 4. 검증

```bash
# 모든 검증 스크립트 실행
./scripts/validate-compose.sh
./scripts/test-env-examples.sh
./scripts/check-required-files.sh

# 실제 실행 테스트
make up
# 동작 확인
make down
```

### 5. 커밋

명확하고 설명적인 커밋 메시지 작성:

```bash
# Good examples
git commit -m "feat: nextcloud standalone 구성 추가

- MariaDB, Redis 포함
- Health checks 적용
- 환경변수 설정
- 완전한 README 문서"

git commit -m "fix: flarum 포트 충돌 해결 (8080 → 8140)"

git commit -m "docs: jenkins README 포트 정보 업데이트"
```

**커밋 메시지 형식:**
- `feat:` - 새로운 기능
- `fix:` - 버그 수정
- `docs:` - 문서 변경
- `refactor:` - 코드 리팩토링
- `test:` - 테스트 추가
- `chore:` - 기타 변경

### 6. Pull Request 생성

**PR 제목:**
```
feat: Add PostgreSQL standalone configuration
fix: Resolve port conflict in WordPress
docs: Update PORT_GUIDE.md with new projects
```

**PR 설명 템플릿:**

```markdown
## Summary
간단한 변경 사항 요약

## Changes
- [ ] 새 프로젝트 추가/기존 프로젝트 수정
- [ ] Makefile 표준 적용
- [ ] Health checks 추가
- [ ] 포트 충돌 해결
- [ ] README 문서 작성/업데이트

## Testing
- [ ] 로컬에서 `make up` 실행 확인
- [ ] 모든 검증 스크립트 통과
- [ ] 실제 서비스 동작 확인

## Checklist
- [ ] 표준 준수 (Makefile, PORT_GUIDE, etc.)
- [ ] 문서 작성 (README.md, .env.example)
- [ ] 검증 스크립트 통과
- [ ] 커밋 메시지 명확함
```

### 7. 코드 리뷰

리뷰어의 피드백을 반영하여 수정:

```bash
# 수정 작업
git add .
git commit -m "fix: apply code review feedback"
git push
```

---

## 코드 스타일

### YAML 파일

- 들여쓰기: 2 spaces
- 따옴표: 필요한 경우에만 사용
- 주석: 복잡한 설정에 추가

### Shell 스크립트

- Shebang: `#!/bin/bash`
- 실행 권한: `chmod +x`
- 오류 처리: `set -e` 또는 명시적 체크

### Markdown

- 제목: ATX 스타일 (`#`, `##`)
- 코드 블록: 언어 명시 (```bash, ```yaml)
- 목록: 일관된 스타일 유지

---

## 질문 및 도움

- **이슈**: 버그 리포트, 기능 제안
- **토론**: 일반적인 질문, 아이디어 공유

---

## 라이선스

기여한 코드는 프로젝트의 라이선스(MIT)를 따릅니다.

---

감사합니다! 🙏
