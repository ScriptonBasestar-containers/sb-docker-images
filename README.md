# sb-docker-images

[![CI](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml)
[![CD](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml)

도커 이미지 및 도커 컴포즈 테스트용
개발/테스트 이미지 생성용

라이센스는 전체적으로는 MIT지향이지만 다른곳의 이미지를 사용하는 경우 그쪽을 따름(GPL, AGPL등)

## 검증 상태

총 24개 프로젝트 중:
- ✅ **완전 성공**: 23개 (95.8%)
- ⚠️ **이슈 발견**: 0개 (0%)
- 🔄 **미검증**: 1개 (4.2%)

상세 검증 결과: [`docs/verification/VERIFICATION-PROGRESS.md`](docs/verification/VERIFICATION-PROGRESS.md)

### 성공 프로젝트 (23개)

| 프로젝트 | 포트 | 접근 URL | 비고 |
|---------|------|----------|------|
| Wiki.js | 80 | http://localhost | 수정 없음 |
| Gitea | 3001, 2222 | http://localhost:3001 | 포트 수정 |
| Flarum | 8082, 8081, 8026 | http://localhost:8082 | 포트 + ARM64 |
| Gnuboard6 | 8084 | http://localhost:8084 | Python 3.11 업그레이드 |
| WordPress | 8085 | http://localhost:8085 | MariaDB/Redis 추가 |
| MediaWiki | 8086 | http://localhost:8086 | MariaDB/Redis 추가 |
| Jenkins | 8087, 50000 | http://localhost:8087 | 포트 수정 |
| Joomla | 8088 | http://localhost:8088 | MariaDB/Redis 추가 |
| XpressEngine | 8089 | http://localhost:8089 | 포트 수정 |
| Gnuboard5 | 8090, 8091 | http://localhost:8090 | 포트 수정 |
| Misago | 8092, 8443 | http://localhost:8092 | 포트 수정 |
| Django CMS | 8093, 8094 | http://localhost:8093 | 포트 수정, 설정 개선 |
| TSBoard | 8095, 3100 | http://localhost:8095 | 포트 수정, DATABASE_URL 설정 |
| Docker Ethereum | 8545, 8546, 4000 | http://localhost:4000 | Geth + BlockScout |
| Minio | 9000, 9001 | http://localhost:9001 | 수정 없음 |
| **Devpi** | **3141** | http://localhost:3141 | Dockerfile 경로 수정 |
| **Gollum** | **4567** | http://localhost:4567 | Dockerfile 경로 + 포트 수정 |
| **Docker Bitcoin** | **8332, 8333, 3002** | http://localhost:3002 | 이미지 변경 (tyzbit) |
| **RTMP Proxy** | **1935** | rtmp://localhost:1935 | Dockerfile 경로 수정 |
| **Discourse** | **3000, 8080, 8443** | http://localhost:3000 | PostgreSQL/Redis 추가 |
| **DokuWiki** | **8130** | http://localhost:8130 | 수정 없음 |
| **Forem** | **3000, 3333** | http://localhost:3000 | 수정 없음 |
| **FlaskBB** | **8250** | http://localhost:8250 | 환경변수 기반 설정 |

**추가 검증 통과**:
- **Home Assistant**: host 네트워크 모드 (포트 충돌 없음)
- **Kratos**: 전용 포트 사용 (4433, 4434, 4455)

## 주요 기능

### 🔧 자동화 스크립트
프로젝트 품질 검증을 위한 자동화 도구 제공:

```bash
# 포트 충돌 감지
./scripts/check-port-conflicts.sh

# Compose 파일 검증
./scripts/validate-compose.sh

# 환경변수 템플릿 테스트
./scripts/test-env-examples.sh

# Health check 검증
./scripts/verify-health-checks.sh
```

상세 사용법: [`scripts/README.md`](./scripts/README.md)

### 📝 환경변수 템플릿
모든 프로젝트에 `.env.example` 파일 제공:
- 64개 프로젝트 100% 커버리지
- 상세한 설명과 기본값 포함
- 프로덕션 배포 시 필수 설정 가이드

### 🚀 Standalone 구성
프로덕션 준비된 독립 실행 구성 (23개 프로젝트):
- 완전한 스택 (DB, Cache, Application)
- Health check 설정
- 자동 재시작 정책
- 상세한 README 포함

위치: `<project>/standalone/`

### 🔌 포트 할당 가이드
프로젝트 간 포트 충돌 방지:
- 체계적인 포트 범위 할당
- 충돌 해결 계획 문서화
- 자동 충돌 감지 스크립트

문서: [`PORT_GUIDE.md`](./PORT_GUIDE.md) | [`docs/PORT_GUIDE.md`](./docs/PORT_GUIDE.md)

## 사용법

### 빠른 시작

1. **프로젝트 선택 및 이동**
```bash
cd discourse  # 또는 원하는 프로젝트
```

2. **환경변수 설정**
```bash
cp .env.example .env
# .env 파일 수정
```

3. **서비스 시작**
```bash
# Makefile이 있는 경우
make up

# 또는 Docker Compose 직접 사용
docker compose up -d
```

4. **로그 확인**
```bash
make logs  # 또는
docker compose logs -f
```

### Standalone 구성 사용

완전한 프로덕션 스택이 필요한 경우:

```bash
cd nextcloud/standalone
cp .env.example .env
docker compose up -d
```

### Makefile 명령어

대부분의 프로젝트에서 사용 가능:
- `make help` - 사용 가능한 명령어 목록
- `make up` - 서비스 시작
- `make down` - 서비스 중지
- `make logs` - 로그 확인
- `make ps` - 컨테이너 상태
- `make clean` - 리소스 정리

### Docker Compose 파일
- **표준 네이밍**: `compose.yml` (Docker Compose V2 권장)
- **레거시**: `docker-compose.yml` (일부 프로젝트에서 사용 중)
- 두 네이밍 모두 정상 동작하며, 80%가 이미 최신 표준 사용 중
- 상세 분석: `tmp/compose-naming-report.md` 참조

## List

- nextcloud
- squid
- jenkins-agent
- git, vcs
  - gitea
- storage
  - minio
- auth,security
  - https://github.com/freeipa/freeipa
  - keycloak
  - authelia
  - ory kratos
  - cas
- wiki
  - gollum
  - mediawiki
  - wikijs
- forum
  - discourse
  - misago
  - flaskbb
  - nodebb
- cms
  - https://github.com/pyrocms/pyrocms
  - joomla
  - drupal
  - wordpress
  - gnuboard
  - djangocms
- static, blog
  - ghost
  - jekyll
  - hugo
  - https://github.com/hexojs/hexo
  - gatsby
- sns, timeline
  - mastodon

## 프로젝트 분류

### 프로덕션 준비 완료
상세 내용은 [RELEASE.md](./RELEASE.md) 참조

### 개발/테스트 도구
- **buildbox** - 통합 테스트 환경 (Kratos, Redis, PostgreSQL 등)
- **ansible-dev** - Ansible 개발 환경
- **chef-dev** - Chef 개발 환경
- **ruby-dev** - Ruby 개발 환경

### 활발히 유지보수 중
- discourse, flarum, nextcloud, wordpress
- gnuboard5, gnuboard6, mediawiki, gollum
- postgres-exts, mariadb, devpi, minio
- jenkins, squid, kratos, gitea

### 실험적/테스트용
- docker-bitcoin, docker-ethereum
- mastodon, forem
- jupyter, jupyter2
- **home-assistant** (참조용, Docker 비권장 - HA OS 사용 권장)

### Deprecated / 아카이브 예정
- **xe3** (현재: xpressengine) - 레거시 XE3, 공식 지원 종료
- **flaskbb** - Flask 기반 포럼, 개발 중단됨
- **openNamu** - 개발 중단 위키
- **spree/solidus** - Ruby 이커머스, 테스트만 진행

> 아카이브 예정 프로젝트는 필요 시 `archive/` 디렉토리로 이동

## REF
https://github.com/docker/build-push-action/issues/561
https://products.containerize.com
https://axbom.com/fediverse/

## Legacy
### docker에서 letsencrypt 적용할 때 쓰던것들
- https://github.com/nginx-proxy/docker-gen
- https://github.com/nginx-proxy/nginx-proxy
- https://github.com/jwilder/docker-letsencrypt-nginx-proxy-companion

## CI/CD

### Automated Workflows

**Continuous Integration (CI)**:
- ✅ Compose 파일 자동 검증
- ✅ Makefile 타겟 테스트
- ✅ PostgreSQL 확장 이미지 빌드/테스트
- ✅ 보안 스캔 (Trivy)

**Continuous Deployment (CD)**:
- 🚀 Tag 기반 자동 배포 (`v*.*.*`, `postgres-exts-v*`)
- 🚀 Manual workflow dispatch 지원
- 🚀 Multi-architecture 빌드 (amd64, arm64)

**Pull Request Checks**:
- 📋 변경된 파일 자동 분석
- 📋 관련 테스트만 선택적 실행
- 📋 코드 품질 자동 체크

### Workflow Files
- `.github/workflows/ci.yml` - CI 워크플로우
- `.github/workflows/cd.yml` - CD 워크플로우
- `.github/workflows/pr-check.yml` - PR 자동 체크

## Repository Maintenance

### Git History Cleanup (Completed: 2025-11-15)
- ✅ 대용량 파일 제거 완료 (BFG Repo Cleaner 사용)
  - `latest.zip` (75.9 MB) 제거
  - `db-4.8.30.zip` (31.2 MB) 제거
- ✅ 저장소 크기 최적화: 115MB → 632KB (99.5% 감소)
- Tool used: https://rtyley.github.io/bfg-repo-cleaner/
