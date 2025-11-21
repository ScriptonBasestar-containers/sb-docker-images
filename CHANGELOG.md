# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [2025-11-21] - Phase 11

### Added

#### 추가 프로젝트 검증 완료
**4개 프로젝트 Docker Compose 검증 및 개선**:

**검증 완료 프로젝트:**
- **discourse** - PostgreSQL/Redis 서비스 추가, 환경변수 기반 포트 설정
  - PostgreSQL 16-alpine, Redis 7-alpine 서비스 정의
  - healthcheck 기반 의존성 설정
  - 환경변수 기반 포트 및 컨테이너명 설정
  - deprecated links 제거
- **dokuwiki** - 검증 통과 (수정 불필요)
  - 환경변수 기반 설정 이미 적용됨
  - 포트 8130 사용으로 충돌 없음
- **forem** - 검증 통과 (수정 불필요)
  - 복잡한 마이크로서비스 구조 (Rails, Sidekiq, esbuild, Chrome)
  - healthcheck 기반 의존성 이미 적용됨
- **flaskbb** - 환경변수 기반 설정 개선
  - 컨테이너명, 포트 환경변수화
  - PostgreSQL/Redis healthcheck 조건 추가
  - Redis 이미지 8.2 → 7-alpine 변경

**검증 커버리지 향상:**
- 19개 (79.2%) → 23개 (95.8%) ✅

#### CI/CD 자동화 완성
**GitHub Actions에 품질 검증 스크립트 통합**:

**quality-checks job 추가:**
- `validate-compose.sh` - Docker Compose 파일 검증
- `test-env-examples.sh` - 환경변수 파일 검증
- `check-required-files.sh` - 필수 파일 존재 확인
- `check-port-conflicts.sh` - 포트 충돌 감지
- `verify-health-checks.sh` - Health check 검증

**이점:**
- ✅ PR 자동 품질 검증
- ✅ 회귀 방지 자동화
- ✅ 코드 리뷰 시간 단축
- ✅ 표준 준수 자동 확인

### Improved

#### 포트 충돌 스크립트 오탐 제거
**check-port-conflicts.sh 정확도 향상**:

**개선사항:**
- 동일 파일 내 중복 포트 감지 제외 (TCP/UDP 동시 사용)
- 포트 충돌 감소: 7개 → 4개
- 실제 충돌은 모두 선택적 구성 (apache vs nginx, fpm 등)

**오탐 사례 해결:**
- docker-ethereum 30303/tcp, 30303/udp → 정상
- gollum 4567 중복 포트 매핑 → 정상

#### 문서 업데이트
**검증 결과 반영:**
- `README.md` - 검증 완료 프로젝트 23개로 업데이트
- `docs/verification/VERIFICATION-PROGRESS.md` - 검증 진행 상황 업데이트
- 최종 업데이트 날짜: 2025-11-21

### Coverage Statistics (Phase 11)
- **검증 완료 프로젝트**: 19개 → 23개 (79.2% → 95.8%)
- **포트 충돌**: 7개 → 4개 (모두 선택적 구성)
- **실질적 포트 충돌**: 0개 (100% 해결)
- **CI/CD 자동화**: 품질 검증 스크립트 5개 통합

---

## [2025-11-17] - Phase 8

### Added

#### Makefile 표준화 및 확장
**41개 프로젝트 Makefile 전면 개선** - CLI 사용성 대폭 향상:

**표준 타겟 통일:**
- `help` - 사용 가능한 명령어 및 설명 표시
- `up` - 서비스 시작 (접속 정보 포함)
- `down` - 서비스 중지
- `restart` - 서비스 재시작
- `logs` - 로그 실시간 보기
- `ps` - 실행 중인 컨테이너 확인
- `shell` - 컨테이너 쉘 접근
- `clean` - 데이터 포함 완전 삭제 (확인 프롬프트)

**프로젝트별 특수 타겟 유지:**
- 데이터베이스: `mysql`, `db-setup`, `db-migrate`
- 빌드: `build`, `prepare`, `build-base`
- 테스트: `test`, `verify`
- 백업: `backup`, `restore` (데이터 서비스)

**사용자 친화성 향상:**
- ✅ 이모지로 시각적 피드백
- ✅ 접속 URL/포트/credentials 안내
- ✅ 의존성 명시 (buildbox 서비스)
- ✅ clean 타겟에 안전 확인 프롬프트 (데이터 손실 방지)

**복잡한 Compose 구성 개선:**
```makefile
COMPOSE_FILES=-f compose.yml \
    -f ../buildbox/compose/compose.base-network.yml \
    -f ../buildbox/compose/compose.redis.yml
```

**영향:**
- 41개 Makefile 표준화 (+1774/-429 라인)
- help 타겟 커버리지: 25% → 100%
- .PHONY 선언: 47% → 100%
- 명명 규칙 통일 (server-*, docker_* → 표준)

#### Port 표준화
**PORT_GUIDE.md 정확성 개선:**
- 각 프로젝트별 기본 포트 문서화
- 포트 충돌 방지 가이드
- 표준 포트 범위 정의

#### Redis Health Check 표준화
**7개 standalone 프로젝트에 Redis health check 추가:**
- drupal/standalone, joomla/standalone, mediawiki/standalone
- nextcloud/standalone, flarum/standalone, nodebb/standalone
- gnuboard5/standalone

**개선사항:**
```yaml
healthcheck:
  test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
  interval: 10s
  timeout: 3s
  retries: 5
```

#### 환경변수 템플릿 100% 커버리지 달성
**마지막 5개 프로젝트 .env.example 추가:**
- dokuwiki, ignite, memcached, redis (루트)
- 최종 커버리지: 43/43 (100%)

### Improved

#### Standalone README 품질 개선
**모든 standalone 프로젝트 README에 추가:**
- Health checks 상세 설명
- Troubleshooting 섹션
- 일반적인 문제 해결 방법
- 로그 확인 방법
- 데이터 영속성 확인

**영향받은 프로젝트:**
- drupal, joomla, mediawiki, nextcloud, wordpress
- flarum, nodebb, discourse, wikijs, gnuboard5
- dokuwiki, redis, memcached, ignite, jenkins
- flaskbb, mailslurper, squid, jupyter, mastodon
- django-cms, solidus, openNamu

### Coverage Statistics (Phase 8)
- **Makefile help 타겟**: 14개 → 52개 (25% → 100%)
- **Makefile .PHONY 선언**: 27개 → 52개 (47% → 100%)
- **.env.example 지원**: 43개 (100% 유지)
- **Standalone health checks**: 대부분 프로젝트 적용

## [2025-11-17] - Phase 7

### Added

#### Environment Variable Templates (.env.example)
11개 프로젝트에 환경변수 템플릿 추가:

**인프라/도구 (3개):**
- **buildbox/.env.example** - 재사용 가능한 Docker Compose 템플릿 컬렉션, PostgreSQL, MariaDB, Redis, Kratos, Authelia
- **mailslurper/.env.example** - SMTP 메일 서버 (개발/테스트용), Web UI, API 포함
- **squid/.env.example** - 캐싱 및 포워드 프록시 서버, 접근 제어, 인증 지원

**블록체인 (2개):**
- **docker-bitcoin/.env.example** - Bitcoin Core 노드, RPC, BTC Explorer, Testnet/Mainnet 지원
- **docker-ethereum/.env.example** - Ethereum Geth 노드, WebSocket, BlockScout, Snap/Full 동기화

**데이터 과학 (2개):**
- **jupyter/.env.example** - Jupyter Notebook, Python/R/Julia/TensorFlow/Spark 커널, 권한 관리
- **jupyter2/.env.example** - Jupyter Lab, Scala/Ruby/R/JVM 멀티 언어 커널

**소셜/스트리밍 (4개):**
- **mastodon/.env.example** - 연합형 소셜 네트워크, PostgreSQL, Redis, Elasticsearch, S3, SMTP
- **rsshub/.env.example** - RSS 피드 생성기 (300+ 웹사이트), Redis 캐싱, Puppeteer 동적 콘텐츠
- **rtmp-proxy/.env.example** - RTMP 프록시, 멀티플랫폼 스트리밍 (Twitch, YouTube, Facebook)
- **solidus/.env.example** - Ruby 전자상거래 플랫폼, PostgreSQL, Redis, Stripe 결제 게이트웨이

**주요 특징:**
- 블록체인 노드 설정 가이드 (RPC, 동기화 모드, 탐색기)
- 데이터 과학 도구 커널 및 리소스 관리
- 소셜 미디어 연합 및 스트리밍 설정
- 전자상거래 결제 게이트웨이 및 S3 통합
- 개발/테스트 도구 사용 시나리오 및 API 예제

### Coverage Statistics (Phase 7)
- **.env.example 지원**: 33개 → 43개 (77% → 100%)

## [2025-11-17] - Phase 6

### Added

#### Environment Variable Templates (.env.example)
10개 프로젝트에 환경변수 템플릿 추가:

**포럼/커뮤니티 (2개):**
- **flaskbb/.env.example** - Flask 포럼, PostgreSQL, Redis, Celery 백그라운드 작업
- **misago/.env.example** - Django 포럼, PostgreSQL, Redis, Nginx 프록시, SSL/TLS

**개발 도구 (5개):**
- **devpi/.env.example** - Python 패키지 서버, 플러그인 시스템, PyPI 미러링
- **jenkins/.env.example** - CI/CD 서버, JDK 21, 88개 플러그인, Docker-in-Docker
- **ansible-dev/.env.example** - 인프라 자동화, Playbook 실행, AWS 지원
- **chef-dev/.env.example** - Chef DK 개발 환경, knife-solo, Test Kitchen
- **ruby-dev/.env.example** - Ruby/Rails 개발 환경, MySQL, Bundler

**블로그/CMS (3개):**
- **django-cms/.env.example** - Django CMS, PostgreSQL, 프론트엔드 webpack
- **gollum/.env.example** - Git 기반 위키, 다양한 마크업 지원, 버전 관리
- **spree/.env.example** - Ruby 전자상거래, PostgreSQL, Redis, 결제 게이트웨이

**주요 특징:**
- 개발 도구에 명령줄 사용 예제 및 워크플로우 포함
- CI/CD 및 인프라 자동화 도구 상세 문서화
- E-commerce 및 위키 시스템 설정 가이드
- 각 도구별 베스트 프랙티스 및 보안 권장사항
- 실무 사용 시나리오 및 트러블슈팅 가이드

### Coverage Statistics (Phase 6)
- **.env.example 지원**: 23개 → 33개 (53% → 77%)

## [2025-11-17] - Phase 5

### Added

#### Environment Variable Templates (.env.example)
7개 프로젝트에 환경변수 템플릿 추가:

**인기 오픈소스 프로젝트 (4개):**
- **forem/.env.example** - Rails/Node.js 개발 환경, PostgreSQL, Redis, Elasticsearch
- **mariadb/.env.example** - MariaDB 백업 시스템 (Restic, Rclone)
- **postgres-exts/.env.example** - PostgreSQL 확장 (pgvector, PostGIS, TimescaleDB), CloudNativePG
- **kratos/.env.example** - Ory Kratos 인증 시스템, PostgreSQL/SQLite DSN, 쿠키 시크릿

**한국 프로젝트 (3개, 한국어 주석):**
- **tsboard/.env.example** - TypeScript 게시판, Go 백엔드, MySQL, JWT 설정
- **openNamu/.env.example** - 한국어 위키, Python/Flask, SQLite/MariaDB, Redis 캐싱
- **xpressengine/.env.example** - Laravel 기반 CMS (⚠️ 지원 중단), MariaDB, Redis

**주요 특징:**
- 한국어 프로젝트에 한국어 주석 및 가이드 제공
- 개발 환경과 프로덕션 환경 설정 구분
- 데이터베이스 선택 가이드 (SQLite vs MariaDB/MySQL/PostgreSQL)
- 백업 및 복원 설정 포함
- 보안 권장사항 및 비밀번호 생성 방법 안내

### Coverage Statistics (Phase 5)
- **.env.example 지원**: 16개 → 23개 (37% → 53%)

## [2025-11-17] - Phase 4

### Added

#### Environment Variable Templates (.env.example)
8개 프로젝트에 환경변수 템플릿 추가 또는 개선:

**새로 추가 (3개):**
- **discourse/.env.example** - PostgreSQL, Redis, SMTP 설정
- **wikijs/.env.example** - PostgreSQL 설정
- **gnuboard6/.env.example** - Django, MariaDB 설정 (한국어 주석)

**기존 개선 (5개):**
- **redis/.env.example** - 보안 권장사항, persistence 설정 추가
- **memcached/.env.example** - 성능 튜닝 가이드 추가
- **dokuwiki/.env.example** - 보안 권장사항 추가
- **ignite/.env.example** - JVM 메모리 권장사항 추가
- **gnuboard5/.env.example** - 한국어 주석, 보안 가이드 추가

**표준 섹션:**
- Project Settings (이름, 타임존)
- Port Configuration (포트 번호)
- Database Configuration (DB 설정)
- Application Settings (앱별 설정)
- Container Names (컨테이너 이름)
- Volume Names (볼륨 이름)
- Network Names (네트워크 이름)
- Security Notes (보안 경고 및 권장사항)

### Improved
- 모든 .env.example 파일에 보안 권장사항 추가
- 한국어 프로젝트(gnuboard5, gnuboard6)에 한국어 주석 추가
- 일관된 포맷과 구조 적용

### Coverage Statistics (Phase 4)
- **.env.example 지원**: 8개 → 16개 (19% → 37%)

## [2025-11-17] - Phase 3

### Added

#### Additional Standalone Configurations
3개 프로젝트에 독립 실행 가능한 완전한 구성 추가:

- **discourse/standalone/**
  - Discourse (discourse/base:2.0.20241119-0129)
  - PostgreSQL 15 Alpine with health check
  - Redis 7 Alpine for cache and sessions
  - Network isolation (app-network, data-network)
  - 완전한 문서 및 관리 가이드

- **wikijs/standalone/**
  - Wiki.js (ghcr.io/requarks/wiki:2)
  - PostgreSQL 15 Alpine with health check
  - Network isolation (app-network, data-network)
  - Git 동기화 및 검색 엔진 가이드 포함

- **gnuboard5/standalone/**
  - GNUboard5 (Custom PHP-FPM image)
  - Nginx Alpine web server
  - MariaDB 11.8 with health check
  - Network isolation (app-network, data-network)
  - 한국어 사용자 맞춤 문서

### Improved
- **discourse/README.md** - Standalone 구성 안내 추가
- **wikijs/README.md** - Standalone 구성 안내 추가
- **gnuboard5/README.md** - Standalone 구성 안내 추가

### Coverage Statistics (Phase 3)
- **Standalone 구성**: 7개 → 10개 (16% → 23%)

## [2025-11-17] - Phase 2

### Added

#### New Standalone Configurations
추가 프로젝트에 독립 실행 가능한 완전한 구성 추가:

- **flarum/standalone/**
  - Flarum (mondedie/flarum:stable)
  - MariaDB 11.8 with health check
  - Redis 7 Alpine for session/cache
  - Network isolation (app-network, data-network)
  - 완전한 문서 및 설치 가이드

- **nodebb/standalone/**
  - NodeBB (nodebb/docker:latest)
  - PostgreSQL 15 Alpine with health check
  - Redis 7 Alpine for cache and sessions
  - Network isolation (app-network, data-network)
  - CLI 명령어 및 플러그인 가이드 포함

#### Makefile Standardization
13개 프로젝트에 표준 Makefile 추가:
- chef-dev, django-cms, docker-bitcoin, docker-ethereum
- jupyter, jupyter2, mariadb, mastodon
- openNamu, rtmp-proxy, ruby-dev, spree, wikijs

**표준 명령어:**
- `make up` - 서비스 시작
- `make down` - 서비스 중지
- `make logs` - 로그 보기
- `make restart` - 재시작
- `make clean` - 모든 데이터 삭제
- `make shell` - 컨테이너 접속

#### Environment Variable Templates
주요 CMS 프로젝트에 `.env.example` 파일 추가:
- flarum, nodebb, wordpress, drupal, joomla
- mediawiki, nextcloud

**표준 섹션:**
- Project Settings (이름, 타임존)
- Port Configuration (포트 번호)
- Database Configuration (DB 설정)
- Redis Configuration (캐시 설정)
- Application Settings (앱별 설정)
- Security Notes (보안 경고)

### Improved
- **flarum/README.md** - Standalone 구성 안내 추가
- **nodebb/README.md** - Standalone 구성 안내 추가
- Documentation 일관성 향상

### Coverage Statistics
- **Standalone 구성**: 5개 → 7개 (11% → 16%)
- **Makefile 지원**: 29개 → 42개 (67% → 98%)
- **.env.example 지원**: 1개 → 8개 (2% → 19%)

## [2025-11-17] - Phase 1

### Added

#### New Official Images
- **redis** - Redis 7 Alpine 기반 공식 이미지
  - AOF persistence 활성화
  - Password 인증 설정
  - Health check 포함
  - Makefile, README.md 포함

- **memcached** - Memcached 1.6 Alpine 기반 공식 이미지
  - 64MB 메모리 제한 기본 설정
  - 간편한 설정 변경 가능
  - Makefile, README.md 포함

- **dokuwiki** - DokuWiki 공식 이미지
  - 파일 기반 위키 시스템 (데이터베이스 불필요)
  - 사전 구성된 관리자 계정
  - Makefile, README.md 포함

- **ignite** - Apache Ignite 공식 이미지
  - In-memory 컴퓨팅 플랫폼
  - REST API, SQL 인터페이스 지원
  - Persistence 볼륨 구성
  - Makefile, README.md 포함

#### Standalone Configurations
독립 실행 가능한 완전한 구성 추가 (MariaDB, Redis 포함):

- **drupal/standalone/**
  - Drupal 10 Apache Bookworm
  - MariaDB 11.8 with health check
  - Redis 7 Alpine
  - 완전한 문서 및 Makefile

- **joomla/standalone/**
  - Joomla 5 PHP 8.3 Apache
  - MariaDB 11.8 with health check
  - Redis 7 Alpine
  - 완전한 문서 및 Makefile

- **mediawiki/standalone/**
  - MediaWiki latest
  - MariaDB 11.8 with health check
  - Redis 7 Alpine
  - 완전한 문서 및 Makefile
  - LocalSettings.php 다운로드 가이드

- **wordpress/standalone/**
  - WordPress 6 PHP 8.3 Apache
  - MariaDB 11.8 with health check
  - Redis 7 Alpine
  - WP-CLI 사용 가이드
  - 완전한 문서 및 Makefile

### Changed

#### Improved Configurations

- **nextcloud/standalone/compose.apache.yml**
  - MariaDB 11.8 추가 (health check 포함)
  - Redis 7 Alpine 추가
  - 환경변수 정리 및 문서화
  - Makefile 개선 (occ 명령 추가)
  - README.md 대폭 개선 (백업, 복원, 업그레이드 가이드)

- **flarum/compose.yml**
  - 네트워크 구성 개선 (단일 app-network 사용)
  - 모든 서비스에 container_name 추가
  - phpMyAdmin 설정 수정 (PMA_HOST 사용)
  - restart policy 통일 (unless-stopped)
  - volume naming 개선
  - Makefile에 빠른 시작 명령 추가
  - README.md 전면 재작성 (확장, 테마, 백업 가이드)

#### Documentation

- **README.md** (프로젝트 루트)
  - 전체 이미지 카탈로그 재구성
  - 카테고리별 분류 개선
  - 공식/커뮤니티 이미지 구분 명확화
  - Standalone 구성 상태 표시
  - 사용법 섹션 추가
  - 최근 업데이트 섹션 추가

### Technical Details

#### Common Patterns Applied

모든 standalone 구성에 적용된 공통 패턴:

1. **Health Checks**
   ```yaml
   healthcheck:
     test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
     interval: 10s
     timeout: 5s
     retries: 5
   ```

2. **Depends On Conditions**
   ```yaml
   depends_on:
     mariadb:
       condition: service_healthy
     redis:
       condition: service_started
   ```

3. **Network Separation**
   - `app-network`: 애플리케이션 통신
   - `data-network`: 데이터베이스/캐시 통신

4. **Restart Policy**
   - `restart: unless-stopped` 사용

5. **Volume Naming**
   - 명확한 이름 사용 (예: `drupal-data`, `mariadb-data`, `redis-data`)

#### Image Versions

- MariaDB: `11.8`
- Redis: `7-alpine`
- WordPress: `6-php8.3-apache`
- Drupal: `10-apache-bookworm`
- Joomla: `5-php8.3-apache`
- MediaWiki: `latest`
- Nextcloud: `29`
- DokuWiki: `stable`
- Memcached: `1.6-alpine`
- Apache Ignite: `latest`
- Flarum: `mondedie/flarum:stable` (커뮤니티 이미지)

### Removed

- **trislv** - 오타로 판단되어 목록에서 제외
- **phabricator** - 개발 중단된 프로젝트로 제외

### Notes

#### Database Credentials (Development Only)

모든 standalone 구성의 기본 자격증명:
```
Database: db01
User: user01
Password: passw0rd
Root Password: rootpass
```

**⚠️ 중요**: 프로덕션 환경에서는 반드시 변경 필요

#### Port Mappings

대부분의 서비스가 `8080:80`을 사용하므로 동시 실행 시 포트 충돌 주의

#### Future Improvements

- 환경변수 파일 분리 (`.env.example`)
- 자동화된 테스트 추가
- CI/CD 파이프라인 구축
- Docker Compose override 패턴 적용
- 볼륨 백업/복원 스크립트 공통화

---

## Archive

### Before 2025-11

이전 변경사항은 Git 히스토리 참조
