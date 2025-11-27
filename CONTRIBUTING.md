# Contributing Guide

sb-docker-images 프로젝트에 기여해 주셔서 감사합니다!

## 목차

- [새 프로젝트 추가하기](#새-프로젝트-추가하기)
  - [이미지 추가 기준 확인](#0-이미지-추가-기준-확인)
- [Compose 파일 작성 규칙](#compose-파일-작성-규칙)
- [포트 할당 정책](#포트-할당-정책)
- [환경변수 템플릿](#환경변수-템플릿)
- [Makefile 작성](#makefile-작성)
- [문서화](#문서화)
- [테스트 및 검증](#테스트-및-검증)

## 새 프로젝트 추가하기

### 0. 이미지 추가 기준 확인

새 Docker 이미지를 추가하기 전에 다음 기준을 검토하세요:

#### ✅ 추가해야 하는 경우

다음 조건 중 **하나 이상** 해당하면 새 이미지를 추가합니다:

1. **공식 이미지가 없는 경우**
   - Docker Hub에 공식 이미지가 없음
   - 커뮤니티 이미지만 존재하고 신뢰할 수 없음
   - 예: Discourse, Taiga, TSBoard

2. **공식 이미지 품질이 낮은 경우**
   - 오래된 버전만 제공 (1년 이상 업데이트 없음)
   - 보안 취약점이 있음 (Trivy 스캔 결과 High/Critical)
   - 문서화가 부족하거나 실행이 어려움
   - Health check가 없음
   - 예: 일부 레거시 CMS, 개인 개발자 이미지

3. **특수 설정이 필요한 경우**
   - 한국 환경 특화 설정 (locale, timezone, 한글 폰트)
   - 복잡한 멀티 서비스 통합 (DB, Cache, Queue)
   - Buildbox 통합이 필요한 개발 환경
   - 예: Gnuboard, XpressEngine, Rhymix

4. **교육/실험 목적**
   - 새로운 기술 스택 테스트
   - 프로토타이핑용 환경
   - 예: Jupyter, Chef-dev, Ansible-dev

#### ❌ 추가하지 말아야 하는 경우

다음 경우에는 새 이미지를 **추가하지 않습니다**:

1. **공식 이미지가 충분히 좋은 경우**
   - Docker Hub 공식 이미지 (Library Images)
   - 잘 관리되는 Verified Publisher 이미지
   - 최신 버전 유지, 문서화 충실, 보안 패치 정기 제공
   - 예: `postgres`, `redis`, `nginx`, `mysql`, `node`, `python`

2. **공식/커뮤니티 이미지로 충분한 경우**
   - 간단한 Compose 파일로 실행 가능
   - 특별한 설정 불필요
   - 예: Portainer, Grafana, Prometheus (공식 이미지 사용 권장)

3. **활발히 유지보수되는 서드파티 이미지**
   - 신뢰할 수 있는 조직/커뮤니티 관리
   - 정기 업데이트 및 보안 패치
   - 충분한 스타/다운로드 수
   - 예: `linuxserver/*` 이미지들

#### 🔍 검증 프로세스

새 이미지 추가 전 다음을 확인하세요:

```bash
# 1. Docker Hub에서 공식 이미지 확인
https://hub.docker.com/_/<project-name>

# 2. 커뮤니티 이미지 검색 및 평가
docker search <project-name> --filter is-official=false

# 3. 보안 스캔 (있는 경우)
trivy image <existing-image>

# 4. 이미지 메타데이터 확인
docker inspect <existing-image>
docker history <existing-image>
```

#### 📋 추가 결정 체크리스트

- [ ] Docker Hub에서 공식 이미지 검색 완료
- [ ] 커뮤니티 이미지 품질 평가 완료 (stars, pulls, last update)
- [ ] 보안 취약점 확인 (가능한 경우)
- [ ] 특수 요구사항 확인 (한국 환경, 복잡한 설정 등)
- [ ] 유사 프로젝트와 중복 확인 (예: Koel vs Navidrome)
- [ ] 유지보수 계획 수립 (업스트림 추적, 업데이트 주기)

**참고**: 의심스러운 경우 Issue를 열어 커뮤니티와 논의하세요.

---

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

## 버전 관리 및 릴리스

### 프로젝트별 독립 버전 관리

각 Docker 이미지 프로젝트는 독립적인 버전을 가집니다.

**태그 형식**: `<project>-v<major>.<minor>.<patch>`

예시:
```bash
discourse-v1.2.3
wikijs-v2.0.0
postgres-exts-v16.2.1
```

### 버전 태깅 워크플로우

#### 1. 변경 사항 커밋

```bash
cd discourse/
# ... 파일 수정 ...

git add .
git commit -m "feat(discourse): add Redis caching support"
```

#### 2. 버전 태그 생성

```bash
# Helper 스크립트 사용 (권장)
./scripts/version-tag.sh discourse 1.2.3

# 또는 수동으로
git tag discourse-v1.2.3
```

#### 3. 태그 푸시

```bash
# 커밋과 태그 모두 푸시
git push origin master
git push origin discourse-v1.2.3
```

#### 4. 자동 빌드

CD 워크플로우가 자동으로:
- Docker 이미지 빌드
- Docker Hub에 푸시
- Release summary 생성

### 버전 증가 규칙

**Major (X.0.0)**:
- Breaking changes
- 주요 upstream 버전 업그레이드
- 호환성 없는 변경

**Minor (0.X.0)**:
- 새로운 기능 추가
- Compose 설정 개선
- 의존성 업데이트 (호환성 유지)

**Patch (0.0.X)**:
- 버그 수정
- 문서 업데이트
- 환경변수 수정

### 버전 관리 도구

```bash
# 모든 프로젝트 버전 확인
./scripts/list-versions.sh

# 특정 프로젝트 버전 확인
./scripts/list-versions.sh discourse

# 최신 버전만 표시
./scripts/list-versions.sh --latest

# 통계 확인
./scripts/list-versions.sh --summary

# Dry-run 테스트
./scripts/version-tag.sh discourse 1.2.3 --dry-run
```

### Phase 버전 vs 프로젝트 버전

**Phase 버전** (`phase-11.7`, `phase-12.0`):
- 저장소 전체 마일스톤
- 문서화, 인프라 개선
- Docker 이미지 빌드 없음

**프로젝트 버전** (`discourse-v1.2.3`):
- 개별 Docker 이미지 릴리스
- 자동 빌드/배포 트리거
- Docker Hub 업데이트

### Docker Hub 이미지 태그

각 버전 태그는 Docker Hub에 여러 태그로 배포:

```bash
# Git tag: discourse-v1.2.3 생성 시

# Docker Hub에 자동 푸시:
scriptonbasestar/discourse:1.2.3    # 특정 버전
scriptonbasestar/discourse:1.2      # Minor 버전 별칭
scriptonbasestar/discourse:1        # Major 버전 별칭
scriptonbasestar/discourse:latest   # 최신 버전
```

### 릴리스 체크리스트

프로젝트 릴리스 전 확인 사항:

- [ ] 모든 변경 사항 커밋 완료
- [ ] 로컬에서 테스트 완료
- [ ] CHANGELOG.md 업데이트 (선택)
- [ ] README.md 버전 정보 업데이트 (필요시)
- [ ] 버전 번호 확인 (Semantic Versioning)
- [ ] 태그 생성 및 푸시
- [ ] CD 워크플로우 성공 확인
- [ ] Docker Hub 이미지 확인

상세 내용: [`docs/VERSIONING.md`](./docs/VERSIONING.md)

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
