# sb-docker-images

도커 이미지 및 도커 컴포즈 테스트용
개발/테스트 이미지 생성용

라이센스는 전체적으로는 MIT지향이지만 다른고스이 이미지를 사용하는 경우 그짝을따름(GPL, AGPL등)

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
- postgres-exts, mariadb, devpi
- jenkins, squid, kratos

### 실험적/테스트용
- docker-bitcoin, docker-ethereum
- mastodon, forem
- jupyter, jupyter2

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

## Repository Maintenance

### Git History Cleanup (Completed: 2025-11-15)
- ✅ 대용량 파일 제거 완료 (BFG Repo Cleaner 사용)
  - `latest.zip` (75.9 MB) 제거
  - `db-4.8.30.zip` (31.2 MB) 제거
- ✅ 저장소 크기 최적화: 115MB → 632KB (99.5% 감소)
- Tool used: https://rtyley.github.io/bfg-repo-cleaner/
