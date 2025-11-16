# sb-docker-images

[![CI](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/ci.yml)
[![CD](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml/badge.svg)](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml)

도커 이미지 및 도커 컴포즈 테스트용
개발/테스트 이미지 생성용

라이센스는 전체적으로는 MIT지향이지만 다른곳의 이미지를 사용하는 경우 그쪽을 따름(GPL, AGPL등)

## 검증 상태

총 24개 프로젝트 중:
- ✅ **완전 성공**: 12개 (50%)
- ⚠️ **이슈 발견**: 4개 (16.7%)
- 🔄 **미검증**: 8개 (33.3%)

상세 검증 결과: [`docs/verification/VERIFICATION-PROGRESS.md`](docs/verification/VERIFICATION-PROGRESS.md)

### 성공 프로젝트 (12개)

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
| Minio | 9000, 9001 | http://localhost:9001 | 수정 없음 |

**추가 검증 통과**:
- **Home Assistant**: host 네트워크 모드 (포트 충돌 없음)
- **Kratos**: 전용 포트 사용 (4433, 4434, 4455)

### 알려진 이슈 (4개)

| 프로젝트 | 문제 | 상태 |
|---------|------|------|
| Devpi | Dockerfile 누락 | ⚠️ |
| Gollum | Dockerfile 누락 | ⚠️ |
| Docker Bitcoin | 이미지 접근 불가 | ⚠️ |
| RTMP Proxy | Dockerfile 누락 | ⚠️ |

## 사용법

### 테스트개발

make 명령 사용
- prepare: 소스받기, 도커 이미지 받기
- setup: 의존성 컨테이너 실행 등
- docker-*: 도커 이미지를 직업 빌드해서 쓰는 경우
- server-*: 도커 이미지 받은걸로 실행시키는 경우

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
