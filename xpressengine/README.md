# XpressEngine 3 (XE3)

XpressEngine 3 PHP 기반 CMS 및 게시판 플랫폼

> 💡 **Quick Start**: This project does not have a standalone setup. Use the basic setup below for development and testing.

> ⚠️ **주의**: XE3는 업데이트가 중단된 상태입니다. 프로덕션 사용을 권장하지 않으며, WordPress, Drupal, Joomla 등의 대안을 고려하세요.

## 개요

XpressEngine 3(XE3)는 네이버에서 개발한 PHP 기반의 오픈소스 CMS 및 게시판 플랫폼입니다:
- 🏗️ Laravel 프레임워크 기반
- 🎨 다양한 플러그인과 테마
- 🔌 확장 가능한 아키텍처
- 📱 반응형 디자인 지원
- 🌐 다국어 지원
- 👥 회원 관리 시스템
- 📊 커뮤니티 사이트 최적화

커뮤니티 사이트, 기업 홈페이지, 블로그 등 다양한 용도로 활용할 수 있습니다.

## Deployment Options

### 🔧 Basic Setup (For Development)

**For development and testing only.** XpressEngine 3 does not have a standalone configuration.

## Quick Start (Basic Setup)

```bash
# XE3 소스 코드 다운로드
make prepare

# Docker 이미지 빌드
make docker-build-debian

# 컨테이너 시작
make docker-up
# 또는
docker-compose up -d

# 웹 브라우저로 접속
# http://localhost:8270

# 설치 마법사 실행
# 웹 브라우저에서 초기 설정 진행
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **xe**: XpressEngine 3 애플리케이션 (포트 8270)
- **mariadb**: MariaDB 11.8 데이터베이스
- **redis**: Redis 8.2 (캐시/세션/큐)

## Default Configuration

**Default port:** 8270 (recommended port - see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** xe

Environment variables:

```bash
APP_ENV=production
APP_NAME=XE Website
APP_DEBUG=false
APP_URL=http://localhost
DB_CONNECTION=mysql
DB_DATABASE=xe_db
DB_HOST=mariadb
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=password
CACHE_DRIVER=redis
REDIS_HOST=redis
REDIS_PORT=6379
SESSION_DRIVER=redis
QUEUE_DRIVER=redis
XE_PORT=8270  # Customizable
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8270 | xe | XpressEngine 3 web application |
| 3306 | mariadb | Database (internal) |
| 6379 | redis | Cache/Session/Queue (internal) |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## 환경 변수

compose.yml에서 설정:

```yaml
environment:
  # Laravel 설정
  - APP_ENV=production
  - APP_NAME=XE Website
  - APP_DEBUG=false
  - APP_URL=http://localhost
  - APP_TIMEZONE=Asia/Seoul
  - APP_LOG=daily
  - APP_LOG_LEVEL=info

  # 캐시 설정 (file/redis/memcached)
  - CACHE_DRIVER=redis
  - REDIS_HOST=redis
  - REDIS_PORT=6379
  - REDIS_PASSWORD=password

  # 데이터베이스 설정 (sqlite/mysql)
  - DB_CONNECTION=mysql
  - DB_DATABASE=xe_db
  - DB_HOST=mariadb
  - DB_PORT=3306
  - DB_USERNAME=root
  - DB_PASSWORD=password
  - DB_PREFIX=

  # 세션 설정 (file/cookie/database/redis)
  - SESSION_DRIVER=redis

  # 큐 설정 (sync/database/redis)
  - QUEUE_DRIVER=redis

  # 파일 시스템 (local/s3/rackspace/ftp)
  - FILESYSTEM_DRIVER=local
```

## 디렉토리 구조

```
xpressengine/
├── docker-compose.yml       # Docker Compose 설정
├── alpine-3.11/
│   └── Dockerfile          # Alpine 기반 Dockerfile
├── debian-buster/
│   └── Dockerfile          # Debian 기반 Dockerfile
├── Makefile                # 빌드 스크립트
├── README.md               # 이 문서
└── app/                    # XE3 소스 (클론됨)
    ├── composer.json
    ├── artisan
    └── ...
```

## 설치 방법

### 1. XE3 소스 코드 다운로드

```bash
# Makefile을 사용한 자동 다운로드
make prepare

# 또는 수동 다운로드
git clone https://github.com/xpressengine/xpressengine.git --depth 1 app
```

### 2. Docker 이미지 빌드

```bash
# Debian 기반 빌드 (권장)
make docker-build-debian

# 또는 수동 빌드
docker build . -f debian-buster/Dockerfile -t xe3:latest
```

### 3. 컨테이너 실행

```bash
make docker-up
# 또는
docker-compose up -d
```

### 4. XE3 설치

```
1. 웹 브라우저에서 http://localhost:8270 접속
2. 설치 마법사 시작
3. 데이터베이스 정보 입력:
   - DB Host: mariadb
   - DB Name: xe_db
   - DB User: root
   - DB Password: password
   - DB Prefix: (비워둠)
4. 사이트 정보 입력:
   - Site URL: http://localhost:8270
   - Timezone: Asia/Seoul
   - Locale: ko
5. 관리자 정보 입력
6. 설치 완료
```

## 사용법

### 관리자 페이지

```
URL: http://localhost:8270/settings
ID: 설치 시 입력한 관리자 ID
PW: 설치 시 입력한 관리자 비밀번호
```

### Composer 명령 실행

```bash
docker-compose exec xe composer install
docker-compose exec xe composer update
```

### Artisan 명령 실행

```bash
# 캐시 클리어
docker-compose exec xe php artisan cache:clear

# 설정 캐시
docker-compose exec xe php artisan config:cache

# 라우트 캐시
docker-compose exec xe php artisan route:cache
```

### 플러그인 설치

```bash
# 관리자 페이지에서 플러그인 설치
# 또는 Composer로 직접 설치
docker-compose exec xe composer require xpressengine-plugin/plugin-name
```

## 데이터베이스 관리

### 데이터베이스 백업

```bash
# 백업
docker-compose exec mariadb mysqldump -u root -ppassword xe_db > backup.sql

# 복원
docker-compose exec -T mariadb mysql -u root -ppassword xe_db < backup.sql
```

### 마이그레이션

```bash
docker-compose exec xe php artisan migrate
```

## 볼륨

```yaml
volumes:
  - redis:/data  # Redis 데이터
  # XE3 애플리케이션 볼륨 (필요시 추가)
```

## 네트워크

기본 네트워크 사용

## 문제 해결

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker-compose logs -f xe

# 컨테이너 재시작
docker-compose restart xe
```

### 데이터베이스 연결 실패

```bash
# MariaDB 컨테이너 상태 확인
docker-compose ps mariadb

# 재시작
docker-compose restart mariadb

# 설치 시 DB 정보 확인:
# Host: mariadb (localhost 아님!)
# Database: xe_db
# User: root
# Password: password
```

### 권한 오류

```bash
# 스토리지 디렉토리 권한 설정
docker-compose exec xe chmod -R 755 storage
docker-compose exec xe chmod -R 755 bootstrap/cache
```

### Composer 의존성 오류

```bash
# Composer 의존성 재설치
docker-compose exec xe composer install --no-dev
docker-compose exec xe composer dump-autoload
```

### 캐시 문제

```bash
# 모든 캐시 클리어
docker-compose exec xe php artisan cache:clear
docker-compose exec xe php artisan config:clear
docker-compose exec xe php artisan route:clear
docker-compose exec xe php artisan view:clear
```

### 포트 충돌

```yaml
# docker-compose.yml의 포트 변경
services:
  xe:
    ports:
      - "8271:80"  # 기본 8270 대신 8271 사용 (충돌 시)
```

## 포트 변경 방법

PORT_GUIDE.md의 표준 포트(8270)로 변경:

```yaml
# docker-compose.yml 수정
services:
  xe:
    ports:
      - "8270:80"  # 기존 8080:80에서 변경
```

## 보안 설정

### 1. 데이터베이스 비밀번호 변경

```yaml
environment:
  - MYSQL_ROOT_PASSWORD=강력한비밀번호
  - DB_PASSWORD=강력한비밀번호
```

### 2. Redis 비밀번호 변경

```yaml
# redis 서비스
command: redis-server --requirepass 강력한비밀번호

# xe 서비스
environment:
  - REDIS_PASSWORD=강력한비밀번호
```

### 3. APP_DEBUG 비활성화

```yaml
environment:
  - APP_DEBUG=false
```

### 4. APP_URL 설정

```yaml
environment:
  - APP_URL=https://yourdomain.com
```

## 개발 환경

### 로그 확인

```bash
# 애플리케이션 로그
docker-compose logs -f xe

# Laravel 로그
docker-compose exec xe tail -f storage/logs/laravel.log
```

### 컨테이너 내부 접속

```bash
docker-compose exec xe bash
```

### 의존성 업데이트

```bash
docker-compose exec xe composer update
```

## 프로덕션 배포

### 1. 환경 변수 수정

```yaml
environment:
  - APP_ENV=production
  - APP_DEBUG=false
  - APP_URL=https://yourdomain.com
  - DB_PASSWORD=강력한비밀번호
  - REDIS_PASSWORD=강력한비밀번호
```

### 2. 캐시 최적화

```bash
docker-compose exec xe php artisan config:cache
docker-compose exec xe php artisan route:cache
docker-compose exec xe php artisan view:cache
```

### 3. HTTPS 설정

Nginx 리버스 프록시 사용 권장

## 기술 스택

- **PHP**: 7.4+
- **Laravel**: 5.x
- **Database**: MariaDB 11.8
- **Cache**: Redis 8.2
- **Web Server**: Apache/Nginx

## 참고 자료

- [XpressEngine 공식 사이트](https://www.xpressengine.com/)
- [XE3 GitHub](https://github.com/xpressengine/xpressengine)
- [XE3 설치 가이드](https://www.xpressengine.com/guide/getting-started/installation)
- [XE3 문서](https://www.xpressengine.com/guide/)

## 대안 프로젝트

XE3는 업데이트가 중단되었으므로 다음 대안을 권장합니다:

- **WordPress** - 가장 인기 있는 CMS
  - [wordpress](../wordpress/README.md)
- **Drupal** - 엔터프라이즈급 CMS
  - [drupal](../drupal/README.md)
- **Joomla** - 유연한 CMS
  - [joomla](../joomla/README.md)

### 기타 대안

- **October CMS** - Laravel 기반 CMS
  - GitHub: https://github.com/octobercms/october
- **Grav** - 파일 기반 CMS
  - GitHub: https://github.com/getgrav/grav

## 관련 프로젝트

- [gnuboard5](../gnuboard5/README.md) - 그누보드5
- [gnuboard6](../gnuboard6/README.md) - 그누보드6
- [tsboard](../tsboard/README.md) - TypeScript 게시판

## 라이선스

XpressEngine 3는 LGPL 라이선스를 따릅니다.

## 주의사항

- XE3는 2020년 이후 업데이트가 중단되었습니다.
- 보안 취약점이 발견될 수 있으므로 프로덕션 사용을 권장하지 않습니다.
- 새로운 프로젝트는 WordPress, Drupal, Joomla 등의 활발히 유지되는 대안을 사용하세요.
- 기존 XE3 사이트는 다른 CMS로 마이그레이션을 고려하세요.
- 테스트 및 학습 목적으로만 사용하는 것이 좋습니다.
