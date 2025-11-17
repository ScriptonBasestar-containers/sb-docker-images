# sb-docker-images

Docker 이미지 및 Docker Compose 테스트/개발용 저장소

개발/테스트 환경을 위한 다양한 오픈소스 애플리케이션의 Docker Compose 구성을 제공합니다.

## 라이센스

전체적으로는 MIT 라이센스를 지향하지만, 다른 오픈소스 이미지를 사용하는 경우 해당 프로젝트의 라이센스를 따릅니다 (GPL, AGPL 등).

## 사용법

### 기본 사용법

각 디렉토리에서 `docker compose up -d` 또는 `make up` 명령으로 실행할 수 있습니다.

```bash
# 예시: WordPress 실행
cd wordpress/standalone
docker compose up -d

# 또는 Makefile 사용
make up
```

### Standalone 구성

주요 CMS/플랫폼은 `standalone` 디렉토리에 완전한 독립 실행 구성이 포함되어 있습니다:
- 데이터베이스 (MariaDB)
- 캐시 (Redis)
- 애플리케이션
- 완전한 문서 (README.md)

### Makefile 명령어

대부분의 이미지는 공통 Makefile 명령어를 지원합니다:

- `make up` - 서비스 시작
- `make down` - 서비스 중지
- `make logs` - 로그 확인
- `make clean` - 서비스 중지 및 볼륨 삭제
- `make shell` - 컨테이너 쉘 접속

## 이미지 목록

### 🗄️ Cache & Database

| 이미지 | 공식/커뮤니티 | 설명 | 상태 |
|--------|--------------|------|------|
| **redis** | 🟢 공식 | Redis 7 - In-memory 데이터 저장소 | ✅ |
| **memcached** | 🟢 공식 | Memcached - 분산 메모리 캐싱 시스템 | ✅ |
| **mariadb** | 🟢 공식 | MariaDB - MySQL 호환 데이터베이스 | ✅ |
| **postgres-exts** | 🟢 공식 | PostgreSQL with extensions | ✅ |
| **ignite** | 🟢 공식 | Apache Ignite - In-memory 컴퓨팅 플랫폼 | ✅ |

### 📝 CMS (Content Management System)

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **wordpress** | 🟢 공식 | WordPress 6 - PHP 8.3 | ✅ |
| **drupal** | 🟢 공식 | Drupal 10 - Enterprise CMS | ✅ |
| **joomla** | 🟢 공식 | Joomla 5 - PHP 8.3 | ✅ |
| **django-cms** | 🔵 커뮤니티 | Django CMS - Python | ⚠️ |
| **gnuboard5** | 🔵 커뮤니티 | 그누보드5 - 한국형 CMS | ⚠️ |
| **gnuboard6** | 🔵 커뮤니티 | 그누보드6 - 한국형 CMS | ⚠️ |
| **xpressengine** | 🔵 커뮤니티 | XpressEngine - 한국형 CMS | ⚠️ |

### 📚 Wiki

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **mediawiki** | 🟢 공식 | MediaWiki - Wikipedia 엔진 | ✅ |
| **dokuwiki** | 🟢 공식 | DokuWiki - 파일 기반 위키 | ✅ |
| **wikijs** | 🟢 공식 | Wiki.js - 현대적인 위키 | ✅ |
| **gollum** | 🔵 커뮤니티 | Gollum - Git 기반 위키 | ⚠️ |
| **openNamu** | 🔵 커뮤니티 | 오픈나무 - 한국형 위키 | ⚠️ |

### 💬 Forum & Community

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **flarum** | 🔵 커뮤니티 | Flarum - 현대적인 포럼 | ✅ |
| **discourse** | 🟢 공식 | Discourse - 토론 플랫폼 | ✅ |
| **nodebb** | 🟢 공식 | NodeBB - Node.js 포럼 | ⚠️ |
| **misago** | 🔵 커뮤니티 | Misago - Python 포럼 | ⚠️ |
| **flaskbb** | 🔵 커뮤니티 | FlaskBB - Flask 포럼 | ⚠️ |
| **forem** | 🔵 커뮤니티 | Forem - dev.to 플랫폼 | ✅ |
| **tsboard** | 🔵 커뮤니티 | TSBoard - TypeScript 게시판 | ⚠️ |

### ☁️ Cloud & Productivity

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **nextcloud** | 🟢 공식 | Nextcloud 29 - 파일 공유/협업 | ✅ |

### 🔐 Authentication & Security

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **kratos** | 🟢 공식 | Ory Kratos - Identity 서버 | ⚠️ |

### 🛠️ Development Tools

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **devpi** | 🔵 커뮤니티 | DevPI - PyPI 서버 | ⚠️ |
| **jenkins** | 🟢 공식 | Jenkins - CI/CD | ⚠️ |
| **ansible-dev** | 🔵 커뮤니티 | Ansible 개발 환경 | ⚠️ |
| **chef-dev** | 🔵 커뮤니티 | Chef 개발 환경 | ⚠️ |
| **ruby-dev** | 🔵 커뮤니티 | Ruby 개발 환경 | ⚠️ |

### 🐍 Python Tools

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **jupyter** | 🟢 공식 | Jupyter Notebook | ⚠️ |
| **jupyter2** | 🟢 공식 | Jupyter Lab | ⚠️ |

### 🛒 E-Commerce

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **solidus** | 🔵 커뮤니티 | Solidus - Ruby 전자상거래 | ⚠️ |
| **spree** | 🔵 커뮤니티 | Spree - Ruby 전자상거래 | ⚠️ |

### 🌐 Social Network

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **mastodon** | 🟢 공식 | Mastodon - 분산형 SNS | ⚠️ |

### 🔧 Utilities

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **mailslurper** | 🔵 커뮤니티 | Mail Slurper - 이메일 테스팅 | ⚠️ |
| **squid** | 🟢 공식 | Squid - 프록시 서버 | ⚠️ |
| **rtmp-proxy** | 🔵 커뮤니티 | RTMP 프록시 | ⚠️ |

### 🪙 Blockchain

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **docker-bitcoin** | 🔵 커뮤니티 | Bitcoin 노드 | ⚠️ |
| **docker-ethereum** | 🔵 커뮤니티 | Ethereum 노드 | ⚠️ |

### 📡 RSS & Feed

| 이미지 | 공식/커뮤니티 | 설명 | Standalone |
|--------|--------------|------|------------|
| **rsshub** | 🔵 커뮤니티 | RSSHub - RSS 생성기 | ⚠️ |

### 🏗️ Infrastructure

| 이미지 | 설명 |
|--------|------|
| **buildbox** | 공통 빌드 환경 및 compose 설정 |

## 아이콘 설명

- 🟢 공식: Docker Hub 공식 이미지 사용
- 🔵 커뮤니티: 커뮤니티 또는 자체 제작 이미지
- ✅ Standalone: 완전한 독립 실행 구성 포함
- ⚠️ 추가 설정 필요

## 최근 업데이트

### 2025-11 업데이트

**새로 추가된 이미지:**
- redis - Redis 7 공식 이미지
- memcached - Memcached 공식 이미지
- dokuwiki - DokuWiki 공식 이미지
- ignite - Apache Ignite 공식 이미지

**Standalone 구성 추가:**
- drupal/standalone - 완전한 독립 실행 구성
- joomla/standalone - 완전한 독립 실행 구성
- mediawiki/standalone - 완전한 독립 실행 구성
- wordpress/standalone - 완전한 독립 실행 구성

**개선된 이미지:**
- nextcloud - MariaDB/Redis 추가, 문서 대폭 개선
- flarum - 네트워크 정리, 설정 개선

## 참고 자료

- Docker Build Push Action: https://github.com/docker/build-push-action/issues/561
- Containerize Products: https://products.containerize.com
- Fediverse: https://axbom.com/fediverse/

## Legacy

### Docker에서 Let's Encrypt 적용할 때 사용하던 도구들

- https://github.com/nginx-proxy/docker-gen
- https://github.com/nginx-proxy/nginx-proxy
- https://github.com/jwilder/docker-letsencrypt-nginx-proxy-companion

## TODO

- 주기적으로 삭제하기: https://rtyley.github.io/bfg-repo-cleaner/
- 자동화된 테스트 추가
- CI/CD 파이프라인 구축
- 환경변수 파일 분리 (.env.example)
