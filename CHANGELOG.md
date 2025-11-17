# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

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
