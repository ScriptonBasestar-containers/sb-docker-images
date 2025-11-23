# sb-docker-images

[![CI](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml)
[![CD](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml)

도커 이미지 및 도커 컴포즈 테스트용
개발/테스트 이미지 생성용

라이센스는 전체적으로는 MIT지향이지만 다른곳의 이미지를 사용하는 경우 그쪽을 따름(GPL, AGPL등)

## 검증 상태

총 53개 프로젝트 중:
- ✅ **완전 성공**: 53개 (100%)
- ⚠️ **이슈 발견**: 0개 (0%)
- 🔄 **미검증**: 0개 (0%)

**Phase 11.7 완성**: 모든 프로젝트 필수 파일 완비 및 검증 통과 ✅

상세 검증 결과: [`docs/verification/VERIFICATION-PROGRESS.md`](docs/verification/VERIFICATION-PROGRESS.md)

### 프로젝트 카테고리 (53개)

#### 🚀 웹 애플리케이션 & CMS (23개)
Wiki.js, Gitea, Flarum, Gnuboard5, Gnuboard6, WordPress, MediaWiki, Joomla, XpressEngine, Discourse, DokuWiki, Forem, FlaskBB, Misago, Django CMS, TSBoard, Drupal, Jupyter, Mailslurper, Mastodon, Nextcloud, NodeBB, OpenNamu, Solidus

#### 🔧 개발 도구 (3개)
- **Buildbox**: 재사용 가능한 Docker Compose 템플릿 컬렉션 ⭐ **NEW**
  - PostgreSQL, MariaDB, Redis 등 모듈식 서비스 제공
  - Django/Rails/PHP 스택 사전 구성
- **Ansible-dev**: Ansible 2.18 개발 환경 ⭐ **NEW**
  - Alpine 3.20 기반 경량 이미지
  - Playbook 실행 및 개발 지원
- **Chef-dev**: Chef DK 3.4.28 개발 환경 ⭐ **NEW**
  - Cookbook 개발 및 테스트
  - Test Kitchen, Berkshelf 포함

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

**전체 프로젝트 목록**: [`PORT_GUIDE.md`](./PORT_GUIDE.md) 참조

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
- 53개 프로젝트 100% 커버리지
- 상세한 설명과 기본값 포함
- 프로덕션 배포 시 필수 설정 가이드
- **Phase 11.7**: ansible-dev, chef-dev 템플릿 추가

### 🚀 Standalone 구성
프로덕션 준비된 독립 실행 구성 (23개 프로젝트, 24개 파일):
- 완전한 스택 (DB, Cache, Application)
- Health check 설정
- 자동 재시작 정책
- 상세한 README 포함
- **검증 완료**: 24개 파일 100% 통과

위치: `<project>/standalone/`

**Standalone 전용 프로젝트** (9개):
- drupal, jupyter, mailslurper, mastodon, nextcloud, nodebb, openNamu, solidus, squid

### 🔌 포트 할당 가이드
프로젝트 간 포트 충돌 방지:
- 체계적인 포트 범위 할당
- 충돌 해결 계획 문서화
- 자동 충돌 감지 스크립트

문서: [`PORT_GUIDE.md`](./PORT_GUIDE.md) | [`docs/PORT_GUIDE.md`](./docs/PORT_GUIDE.md)

## 📚 문서

### 시작하기
- [빠른 시작](#빠른-시작) - 프로젝트 실행 기본 가이드
- [PORT_GUIDE.md](./PORT_GUIDE.md) - 포트 할당 및 충돌 방지
- [VERSIONING.md](./docs/VERSIONING.md) - 프로젝트별 버전 관리 전략 ⭐ **NEW**
- [CONTRIBUTING.md](./CONTRIBUTING.md) - 기여 가이드라인

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
