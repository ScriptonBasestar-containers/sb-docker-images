# sb-docker-images

[![CI](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml)
[![CD](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml)

도커 이미지 및 도커 컴포즈 테스트용
개발/테스트 이미지 생성용

라이센스는 전체적으로는 MIT지향이지만 다른곳의 이미지를 사용하는 경우 그쪽을 따름(GPL, AGPL등)

## 검증 상태

총 56개 프로젝트 (+ 6개 archived):
- ✅ **완전 성공**: 56개 (100%)
- ⚠️ **이슈 발견**: 0개 (0%)
- 🔄 **미검증**: 0개 (0%)
- 📦 **Archived**: 6개 (deprecated)

**Phase 14 완료**: 팀 협업, 자동화, 모니터링, 분석, Q&A 플랫폼 추가 (7개 이미지)
**Phase 13 완료**: Deprecated 프로젝트 archive 이동, Dockerfile 업데이트, 버전 고정

### 품질 지표

| 지표 | 커버리지 | 상태 |
|------|---------|------|
| README.md | 56/56 (100%) | ✅ |
| .env.example | 56/56 (100%) | ✅ |
| VERSION 파일 | 56/56 (100%) | ✅ |
| Git 버전 태그 | 62/64 (98%) | ✅ ⭐ **NEW** |
| Multi-Arch 배포 | 60/62 (97%) | ✅ 🍎🥧 **NEW** |
| Makefile | 56/56 (100%) | ✅ |
| Compose 파일 | 86/86 (100%) | ✅ |

**Multi-Architecture Support**: 🍎 Apple Silicon (M1/M2/M3) | 🥧 Raspberry Pi 4/5 | ☁️ AWS Graviton
All images now support both **AMD64** and **ARM64** architectures!

**📖 [Multi-Arch Usage Guide](./docs/MULTI_ARCH_GUIDE.md)** - Complete guide for using multi-architecture images
**⚡ [Docker Caching Guide](./docs/DOCKER_CACHING_GUIDE.md)** - Optimize build times by 20-30%
**🔒 [Security Scanning Guide](./docs/SECURITY_SCANNING_GUIDE.md)** - Automated vulnerability scanning

### CI/CD Optimization ⭐ **NEW Phase 16** (2025-12-08)
**🚀 [ARM64 Native Runners](./docs/ci/arm64-native-runners.md)** - 5-10x faster builds with native ARM64 execution
**✅ [CI Validation Suite](./scripts/ci-validation-suite.sh)** - 20 automated quality tests with scoring (0-100)
**📊 [Docker Hub Analytics](./docs/ci/docker-hub-analytics.md)** - Weekly usage insights and multi-arch tracking

상세 검증 결과: [`QUALITY_REPORT.md`](./QUALITY_REPORT.md)

### 프로젝트 카테고리 (61개 + 8 archived)

#### 🚀 웹 애플리케이션 & CMS (19개)
Wiki.js, Gitea, Flarum, Gnuboard5, Gnuboard6, WordPress, MediaWiki, Joomla, XpressEngine, Discourse, DokuWiki, Forem, Misago, Django CMS, TSBoard, Drupal, Jupyter, Mailslurper, Mastodon, Nextcloud, NodeBB

#### 🔧 개발 도구 (5개)
- **Buildbox**: 재사용 가능한 Docker Compose 템플릿 컬렉션
  - PostgreSQL, MariaDB, Redis 등 모듈식 서비스 제공
  - Django/Rails/PHP 스택 사전 구성
- **Node-pnpm**: Node.js with pnpm 패키지 매니저 ⭐ **NEW**
  - 공식 pnpm Docker 이미지 없음 대응
  - Debian, Alpine, Builder 3가지 변형
- **Taiga**: 애자일 프로젝트 관리 플랫폼 ⭐ **NEW**
  - Jira/Trello 오픈소스 대안
  - Scrum & Kanban 지원
- **Ansible-dev**: Ansible 2.18 개발 환경
- **Chef-dev**: Chef DK 3.4.28 개발 환경

#### 📊 웹 분석 (1개) ⭐ **NEW**
- **OWA**: Open Web Analytics (8280)
  - 경량 웹 분석 (Matomo 대안)
  - PHP 8.2 + MariaDB

#### 🎵 미디어 (1개) ⭐ **NEW**
- **Koel**: Personal music streaming (8290)
  - 셀프 호스트 음악 스트리밍
  - ffmpeg 트랜스코딩 지원

#### 📅 그룹웨어 (1개) ⭐ **NEW**
- **AgenDAV**: CalDAV web client (8300)
  - 캘린더 관리 웹 클라이언트
  - Radicale, Baikal, Nextcloud 호환

#### 🗄️ 인프라 서비스 (3개)
- **Redis**: In-memory data store (6379)
- **Memcached**: Memory caching (11211)
- **Apache Ignite**: In-memory computing platform (10800, 11211, 47100, 47500)

#### 🔐 인증 & 보안 (2개)
- **Kratos**: Identity & user management (4433, 4434, 4455)
- **Home Assistant**: Smart home platform (host network)

#### ⚡ 블록체인 & 스트리밍 (3개)
- **Docker Ethereum**: Geth + BlockScout (8545, 8546, 4000)
- **Docker Bitcoin**: Bitcoin node (8332, 8333, 3002)
- **RTMP Proxy**: RTMP streaming (1935)

#### 📦 기타 도구 (19개)
Jenkins, Minio, Devpi, Gollum, Squid, 기타 프로젝트

**전체 프로젝트 목록**: [`PORT_STATUS.md`](./PORT_STATUS.md) 참조

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

# Multi-arch 매니페스트 검증
./scripts/verify-multiarch-manifest.sh --sample

# CI 품질 검증 스위트 (20 tests) ⭐ NEW
./scripts/ci-validation-suite.sh --verbose --report ci-report.json

# Docker Hub 분석 ⭐ NEW
./scripts/docker-hub-analytics.sh --username scriptonbasestar --output analytics.json

# ARM64 러너 설정 ⭐ NEW
./scripts/setup-arm64-runner.sh --token YOUR_TOKEN --url https://github.com/org/repo
```

상세 사용법: [`scripts/README.md`](./scripts/README.md)

### 📝 환경변수 템플릿
모든 프로젝트에 `.env.example` 파일 제공:
- 54개 프로젝트 100% 커버리지
- 상세한 설명과 기본값 포함
- 프로덕션 배포 시 필수 설정 가이드
- **Phase 12**: node-pnpm, owa, taiga 추가

### 🏷️ 버전 관리 시스템 ⭐ **완료 (2025-12-01)**
표준화된 프로젝트 버전 관리 및 자동 배포:

```bash
# 모든 프로젝트 버전 목록
make version-list

# 특정 프로젝트 버전 확인
make version-show PROJECT=wikijs

# 버전 파일 검증
make version-check

# 버전 태그 생성 및 배포
git tag <project>-v1.0.0
git push origin <project>-v1.0.0  # CD 파이프라인 자동 트리거
```

**Features**:
- ✅ 56개 프로젝트 VERSION 파일 (100%)
- ✅ 62개 Git 버전 태그 생성 완료 (98% - 2 archived 제외)
- ✅ Semantic versioning (MAJOR.MINOR.PATCH)
- ✅ CD 파이프라인 통합 완료 (tag-triggered builds)
- ✅ Docker Hub 자동 배포 준비 완료
- **Phase 11.10**: 버전 관리 시스템 구축
- **Phase 12**: 버전 태그 롤아웃 완료 (2025-12-01)

**자동 배포 프로세스**:
1. 로컬에서 버전 태그 생성 (`git tag <project>-v1.0.0`)
2. 태그를 GitHub로 푸시 (`git push origin <project>-v1.0.0`)
3. CD 워크플로우 자동 실행 (Docker 이미지 빌드 & 테스트)
4. Docker Hub에 자동 배포 (`:latest`, `:1.0.0`, `:1.0`, `:1` 태그)

상세 가이드: [`docs/VERSIONING.md`](./docs/VERSIONING.md)

### 🚀 Standalone 구성
프로덕션 준비된 독립 실행 구성 (19개 프로젝트, 20개 파일):
- 완전한 스택 (DB, Cache, Application)
- Health check 설정
- 자동 재시작 정책
- 상세한 README 포함
- **검증 완료**: 20개 파일 100% 통과

위치: `<project>/standalone/`

**Standalone 전용 프로젝트** (5개):
- drupal, jupyter, mailslurper, mastodon, nextcloud, nodebb, squid

### 🔌 포트 할당 가이드
프로젝트 간 포트 충돌 방지:
- 체계적인 포트 범위 할당
- 충돌 해결 계획 문서화
- 자동 충돌 감지 스크립트

문서: [`PORT_STATUS.md`](./PORT_STATUS.md) | [`docs/PORT_STATUS.md`](./docs/PORT_STATUS.md)

## 📚 문서

### 시작하기
- [빠른 시작](#빠른-시작) - 프로젝트 실행 기본 가이드
- [PORT_STATUS.md](./PORT_STATUS.md) - 포트 할당 및 충돌 방지
- [VERSIONING.md](./docs/VERSIONING.md) - 프로젝트별 버전 관리 전략 ⭐ **NEW**
- [CONTRIBUTING.md](./CONTRIBUTING.md) - 기여 가이드라인
  - [이미지 추가 기준](./CONTRIBUTING.md#0-이미지-추가-기준-확인) - 새 Docker 이미지 추가 규칙 ⭐ **NEW**

### 고급 가이드
- [**Buildbox 통합 가이드**](docs/BUILDBOX_INTEGRATION.md) - 프레임워크별 통합 패턴
  - Django, Rails, PHP/Laravel, Node.js 통합 방법
  - 3가지 통합 패턴 (Shared Network, Override, External)
  - 네트워크 아키텍처 및 베스트 프랙티스
  - 트러블슈팅 가이드
- [**실전 예시**](docs/PRACTICAL_EXAMPLES.md) - 실제 사용 사례 및 완전한 예제
  - Full Stack 애플리케이션 (Django 블로그, Rails 이커머스)
  - 마이크로서비스 아키텍처 (API Gateway + 서비스)
  - 개발 워크플로우 (Hot-reload, 테스팅 환경)
  - 프로덕션 배포 (모니터링 포함)
- [**성능 가이드**](docs/PERFORMANCE.md) - 벤치마크, 최적화, 모니터링
  - 시스템 요구사항 및 리소스 할당
  - 데이터베이스/캐시/애플리케이션 최적화
  - 실제 벤치마크 결과 (PostgreSQL: 1,247 TPS, Redis: 71k-83k ops/sec)
  - Prometheus, Grafana 모니터링 설정
- [**업데이트 전략**](docs/UPDATE_STRATEGY.md) - 프로젝트별 업데이트 관리 ⭐ **Phase 11.8 NEW**
  - 프로젝트 카테고리별 업데이트 주기
  - 버전 증가 규칙 및 워크플로우
  - 보안 업데이트 프로토콜
  - 업스트림 추적 및 자동화

### 참고 문서
- [CHANGELOG.md](./CHANGELOG.md) - 변경 이력
- [QUALITY_REPORT.md](./QUALITY_REPORT.md) - 품질 보고서
- [docs/verification/](./docs/verification/) - 검증 문서

## 사용법

### 빠른 시작

1. **프로젝트 선택 및 이동**
```bash
cd images/community/discourse  # 또는 원하는 프로젝트
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
cd images/cms/nextcloud/standalone
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

## 프로젝트 디렉토리 구조

모든 프로젝트는 `images/` 아래 용도별로 분류되어 있습니다:

```
images/
├── analytics/     (2개)  - 웹 분석 및 BI ⭐ **Phase 14**
├── archive/       (6개)  - Deprecated 프로젝트 (archived)
├── cms/           (9개)  - CMS 및 컨텐츠 플랫폼
├── collaboration/ (3개)  - 팀 협업 도구 ⭐ **Phase 14**
├── automation/    (1개)  - 워크플로우 자동화 ⭐ **Phase 14**
├── monitoring/    (1개)  - 모니터링 및 알림 ⭐ **Phase 14**
├── community/     (5개)  - 커뮤니티 및 포럼
├── wiki/          (4개)  - 위키 시스템
├── devtools/      (8개)  - 개발 도구
├── media/         (1개)  - 미디어 스트리밍
├── groupware/     (1개)  - 그룹웨어
├── database/      (4개)  - 데이터베이스 및 캐시
├── infrastructure/(5개)  - 인프라 서비스
├── auth/          (2개)  - 인증 및 보안
├── blockchain/    (3개)  - 블록체인 플랫폼
├── registry/      (1개)  - 패키지 레지스트리
├── vcs/           (1개)  - 버전 관리 시스템
├── feed/          (1개)  - RSS/피드
└── social/        (2개)  - 소셜 네트워크
```

**총 55개 활성 프로젝트** + 6개 archived (카테고리별 자동 분류)

## 카테고리별 프로젝트 목록

### 🎨 CMS (9개)
`images/cms/` - 컨텐츠 관리 시스템
- drupal, wordpress, joomla, nextcloud
- django-cms, gnuboard5, gnuboard6, rhymix, xpressengine

### 💬 Community (6개) ⭐ **Phase 14**
`images/community/` - 커뮤니티 및 포럼 플랫폼
- discourse, flarum, nodebb, misago, tsboard
- answer (8400): Q&A 커뮤니티 플랫폼 (Stack Overflow 대안), 투표/평판 시스템, 한국어 지원

### 🤝 Collaboration (3개) ⭐ **Phase 14**
`images/collaboration/` - 팀 협업 및 커뮤니케이션 도구
- mattermost (8350): 오픈소스 팀 협업 플랫폼 (Slack 대안)
- rocket.chat (8340): 오픈소스 팀 커뮤니케이션 (Slack/Teams 대안), 무제한 사용자
- bookstack (8390): 계층적 위키 및 문서화 플랫폼

### 🤖 Automation (1개) ⭐ **Phase 14**
`images/automation/` - 워크플로우 자동화 도구
- n8n (5678): 워크플로우 자동화 플랫폼 (Zapier/Make 대안), 200+ 통합

### 📊 Monitoring (1개) ⭐ **Phase 14**
`images/monitoring/` - 모니터링 및 알림 시스템
- uptime-kuma (3011): 셀프 호스트 모니터링 도구 (Uptime Robot 대안), 60+ 알림 채널

### 📖 Wiki (4개)
`images/wiki/` - 위키 및 문서화 시스템
- wikijs, mediawiki, gollum, dokuwiki

### 🔧 Development Tools (8개)
`images/devtools/` - 개발 및 CI/CD 도구
- ansible-dev, chef-dev, ruby-dev, jenkins
- jupyter, jupyter2
- node-pnpm, taiga ⭐ **NEW**

### 📊 Analytics (2개) ⭐ **Phase 14**
`images/analytics/` - 웹 분석 및 Business Intelligence
- owa (8280): 경량 웹 분석 (Matomo 대안)
- metabase (3020): BI 및 데이터 분석 플랫폼, 다중 데이터베이스 지원

### 🎵 Media (1개) ⭐ **NEW**
`images/media/` - 미디어 스트리밍
- koel

### 📅 Groupware (1개) ⭐ **NEW**
`images/groupware/` - 그룹웨어 및 협업 도구
- agendav

### 🗄️ Database (4개)
`images/database/` - 데이터베이스 및 캐시
- postgres-exts, mariadb, redis, memcached

### 🏗️ Infrastructure (5개)
`images/infrastructure/` - 인프라 서비스
- minio, squid, rtmp-proxy, mailslurper, supabase

### 🔐 Auth & Security (2개)
`images/auth/` - 인증 및 보안
- kratos, home-assistant

### ⛓️ Blockchain (3개)
`images/blockchain/` - 블록체인 플랫폼
- docker-bitcoin, docker-ethereum, ignite

### 📦 Registry (1개)
`images/registry/` - 패키지 레지스트리
- devpi

### 🌿 VCS (1개)
`images/vcs/` - 버전 관리 시스템
- gitea

### 📦 Archive (6개)
`images/archive/` - Deprecated 프로젝트
- flaskbb, openNamu, spree, solidus (upstream 개발 중단)
- discourse_fast_switch, discourse_bench (7년+ 오래된 이미지)

### 📡 Feed (1개)
`images/feed/` - RSS 및 피드
- rsshub

### 🌐 Social (2개)
`images/social/` - 소셜 네트워크
- mastodon, forem

---

### 프로젝트 상태 분류

**프로덕션 준비 완료** - [RELEASE.md](./RELEASE.md) 참조

**활발히 유지보수 중**:
- CMS: discourse, flarum, nextcloud, wordpress, gnuboard5, gnuboard6
- Wiki: mediawiki, gollum, wikijs
- Database: postgres-exts, mariadb
- Infrastructure: devpi, minio, jenkins, squid
- Auth: kratos
- VCS: gitea

**실험적/테스트용**:
- blockchain: docker-bitcoin, docker-ethereum
- social: mastodon, forem
- devtools: jupyter, jupyter2
- auth: home-assistant (참조용, Docker 비권장 - HA OS 사용 권장)

**Deprecated / Archived**:
- xpressengine (레거시 XE3, 공식 지원 종료 - 아직 활성)
- **Archived** (6개): flaskbb, openNamu, spree, solidus, discourse_fast_switch, discourse_bench

> Deprecated 프로젝트는 `images/archive/` 디렉토리로 이동됨 (Phase 13)

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
- 🚀 **프로젝트별 버전 태그** (`discourse-v1.0.0`, `wikijs-v2.0.0`) ⭐ **NEW**
- 🚀 Phase 태그 지원 (`phase-11.7`, `phase-12.0`)
- 🚀 자동 Docker 이미지 빌드 및 배포
- 🚀 Manual workflow dispatch 지원
- 🚀 Multi-architecture 빌드 (amd64, arm64)

**Pull Request Checks**:
- 📋 변경된 파일 자동 분석
- 📋 관련 테스트만 선택적 실행
- 📋 코드 품질 자동 체크

### Version Management

각 프로젝트는 독립적인 버전 관리:

```bash
# 프로젝트 버전 태그 생성
./scripts/version-tag.sh discourse 1.2.3

# 버전 목록 확인
./scripts/list-versions.sh
./scripts/list-versions.sh --latest
```

상세 내용: [VERSIONING.md](./docs/VERSIONING.md)

### Workflow Files
- `.github/workflows/ci.yml` - CI 워크플로우
- `.github/workflows/cd.yml` - CD 워크플로우 (프로젝트별 빌드 지원)
- `.github/workflows/pr-check.yml` - PR 자동 체크

## Repository Maintenance

### Git History Cleanup (Completed: 2025-11-15)
- ✅ 대용량 파일 제거 완료 (BFG Repo Cleaner 사용)
  - `latest.zip` (75.9 MB) 제거
  - `db-4.8.30.zip` (31.2 MB) 제거
- ✅ 저장소 크기 최적화: 115MB → 632KB (99.5% 감소)
- Tool used: https://rtyley.github.io/bfg-repo-cleaner/
