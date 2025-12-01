# Nextcloud

> 💡 **Quick Start**: For production deployment with PostgreSQL/MariaDB and Redis, use the [standalone setup](standalone/README.md) - it includes all services and comprehensive documentation!

## 개요

Nextcloud는 개인 클라우드 스토리지 및 협업 플랫폼을 구축하기 위한 오픈소스 소프트웨어입니다:
- 📁 파일 동기화 및 공유
- 📝 온라인 오피스 (Collabora, OnlyOffice 연동)
- 📅 캘린더 및 연락처 관리
- 💬 채팅 및 화상 통화 (Nextcloud Talk)
- 📧 웹메일 통합
- 🔐 엔드투엔드 암호화
- 📱 모바일 앱 지원 (iOS, Android)
- 🔌 확장 앱 마켓플레이스
- 👥 사용자 및 그룹 관리
- 🌐 연합 파일 공유 (Federation)

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Nextcloud (Apache or FPM)
- ✅ PostgreSQL 16 / MariaDB
- ✅ Redis 8.2 cache
- ✅ Network isolation

**Access:** http://localhost:8210

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default port:** 8210 (see [PORT_STATUS.md](../PORT_STATUS.md))

**Container name:** nextcloud

Environment variables:
```bash
WEB_PORT=8210
NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=passw0rd
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8210 | nextcloud | 웹 서버 (WEB_PORT로 변경 가능) |
| 6379 | redis | Redis (FPM 버전, 내부) |
| 9020 | phpmyadmin | phpMyAdmin (MariaDB 사용 시, 선택사항) |

**Port conflicts:** See [PORT_STATUS.md](../PORT_STATUS.md) for port allocation details.

> ✅ **포트 설정**: 기본 포트는 8210입니다. WEB_PORT 환경변수로 변경 가능합니다.

## 빠른 시작

### Apache 버전 (권장)

standalone 디렉토리에서 바로 Nextcloud를 실행할 수 있습니다:

```bash
# 1. standalone 디렉토리로 이동
cd nextcloud/standalone

# 2. Apache 버전 실행 (PostgreSQL + Redis)
docker compose -f compose.fpm.yml up -d

# 3. 브라우저에서 접속
# http://localhost:8210
```

### 외부 데이터베이스 사용

devbox의 PostgreSQL/MariaDB/Redis를 사용하려면:

```bash
# standalone 디렉토리에서
make server-up

# 또는 직접 실행
docker compose -f compose.apache.yml \
  -f ../../devbox/compose.bn-pg15.yml \
  -f ../../devbox/compose.bn-redis.yml \
  -f ../../devbox/compose.mariadb.yml \
  up -d
```

## 서비스 구성

### Apache 버전 (compose.apache.yml)

독립 실행형 구성, 외부 데이터베이스 서비스 필요:

- **nextcloud**: Nextcloud Apache 웹 서버 (포트 8210)
- **외부 MariaDB**: 데이터베이스 (devbox 사용)
- **외부 Redis**: 캐시 서버 (devbox 사용)

### FPM 버전 (compose.fpm.yml)

완전한 올인원 구성, 모든 서비스 포함:

- **nextcloud**: Nextcloud FPM 애플리케이션 (포트 8210)
- **postgres**: PostgreSQL 16 데이터베이스
- **redis**: Redis 8.2 캐시 서버 (포트 6379)


## 환경 변수

### 관리자 계정

- `NEXTCLOUD_ADMIN_USER`: 관리자 사용자명 (기본값: admin)
- `NEXTCLOUD_ADMIN_PASSWORD`: 관리자 비밀번호 (기본값: passw0rd)

### 데이터베이스 설정 (MariaDB)

- `MYSQL_HOST`: MariaDB 호스트 (기본값: mariadb)
- `MYSQL_DATABASE`: 데이터베이스 이름 (기본값: db01)
- `MYSQL_USER`: 데이터베이스 사용자 (기본값: user01)
- `MYSQL_PASSWORD`: 데이터베이스 비밀번호 (기본값: passw0rd)

### 데이터베이스 설정 (PostgreSQL)

- `POSTGRES_HOST`: PostgreSQL 호스트 (기본값: postgres)
- `POSTGRES_DB`: 데이터베이스 이름 (기본값: db01)
- `POSTGRES_USER`: 데이터베이스 사용자 (기본값: user01)
- `POSTGRES_PASSWORD`: 데이터베이스 비밀번호 (기본값: passw0rd)

### Redis 설정

- `REDIS_HOST`: Redis 호스트 (기본값: redis)
- `REDIS_HOST_PORT`: Redis 포트 (기본값: 6379)
- `REDIS_HOST_PASSWORD`: Redis 비밀번호 (기본값: passw0rd)

### 선택적 설정

- `NC_DEBUG`: 디버그 모드 활성화 (기본값: true)
- `NEXTCLOUD_TRUSTED_DOMAINS`: 신뢰할 도메인 목록
- `NEXTCLOUD_UPLOAD_MAX_FILESIZE`: 최대 업로드 파일 크기 (예: 4G)
- `NEXTCLOUD_MAX_FILE_UPLOADS`: 최대 업로드 파일 개수

## 사용법

### 서비스 시작

```bash
# FPM 버전 (올인원)
cd nextcloud/standalone
docker compose -f compose.fpm.yml up -d

# Apache 버전 (외부 DB)
cd nextcloud/standalone
make server-up
```

### 서비스 중지

```bash
# FPM 버전
docker compose -f compose.fpm.yml down

# Apache 버전 (볼륨 포함 삭제)
make server-down
```

### 컨테이너 쉘 접속

```bash
# Nextcloud 컨테이너 접속
docker compose -f compose.fpm.yml exec nextcloud bash

# 또는 Makefile 사용
make server-enter
```

### 로그 확인

```bash
# 모든 서비스 로그
docker compose -f compose.fpm.yml logs -f

# Nextcloud 로그만 확인
docker compose -f compose.fpm.yml logs -f nextcloud
```

## 볼륨 구조

Nextcloud 데이터는 다음 볼륨에 저장됩니다:

- `nxc_root`: Nextcloud 루트 디렉토리 (/var/www/html)
- `nxc_apps`: 커스텀 앱 (/var/www/html/custom_apps)
- `nxc_data`: 사용자 데이터 (/var/www/html/data)
- `nxc_themes`: 테마 파일 (/var/www/html/themes)
- `postgres` 또는 `mariadb`: 데이터베이스 데이터
- `redis`: Redis 데이터

## Docker Hooks

Nextcloud는 라이프사이클의 다양한 단계에서 커스텀 스크립트를 실행할 수 있습니다:

- **pre-installation**: Nextcloud 설치/초기화 전 실행
- **post-installation**: Nextcloud 설치/초기화 후 실행
- **pre-upgrade**: Nextcloud 업그레이드 전 실행
- **post-upgrade**: Nextcloud 업그레이드 후 실행
- **before-starting**: Nextcloud 시작 전 실행

hooks 사용 방법:
```yaml
volumes:
  - ./app-hooks/pre-installation:/docker-entrypoint-hooks.d/pre-installation
  - ./app-hooks/post-installation:/docker-entrypoint-hooks.d/post-installation
  - ./app-hooks/before-starting:/docker-entrypoint-hooks.d/before-starting
```

## 문제 해결

### 데이터베이스 연결 실패

```bash
# 데이터베이스 서비스가 준비될 때까지 대기
docker compose -f compose.fpm.yml down
docker compose -f compose.fpm.yml up -d

# 로그 확인
docker compose -f compose.fpm.yml logs postgres
docker compose -f compose.fpm.yml logs nextcloud
```

### 권한 문제

```bash
# Nextcloud 컨테이너 내부에서 권한 수정
docker compose -f compose.fpm.yml exec nextcloud chown -R www-data:www-data /var/www/html
```

### Redis 연결 실패

```bash
# Redis 서비스 상태 확인
docker compose -f compose.fpm.yml exec redis redis-cli ping

# Redis 비밀번호 확인
docker compose -f compose.fpm.yml exec redis redis-cli -a passw0rd ping
```

### 업로드 파일 크기 제한

compose 파일에 환경 변수 추가:
```yaml
environment:
  NEXTCLOUD_UPLOAD_MAX_FILESIZE: 4G
  NEXTCLOUD_MAX_FILE_UPLOADS: 10
```

### 신뢰할 도메인 추가

```bash
# occ 명령어 사용
docker compose -f compose.fpm.yml exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=example.com

# 또는 환경 변수 사용
environment:
  NEXTCLOUD_TRUSTED_DOMAINS: example.com another-domain.com
```

### 초기화 및 재설치

```bash
# 모든 컨테이너와 볼륨 삭제
docker compose -f compose.fpm.yml down -v

# 재시작
docker compose -f compose.fpm.yml up -d
```

## 디렉토리 구조

```
nextcloud/
├── Makefile                    # 편의 명령어 (외부 DB 사용)
├── README.md                   # 이 문서
└── standalone/
    ├── Makefile                # standalone 편의 명령어
    ├── README.md               # standalone 가이드
    ├── compose.apache.yml      # Apache 버전 (외부 DB)
    ├── compose.fpm.yml         # FPM 버전 (올인원)
    ├── app-hooks/              # Docker 라이프사이클 hooks
    │   ├── pre-installation/
    │   ├── post-installation/
    │   ├── pre-upgrade/
    │   ├── post-upgrade/
    │   └── before-starting/
    └── config/                 # 설정 파일
        └── log.config.php
```

## 참고 자료

### 공식 문서

- [Nextcloud 공식 웹사이트](https://nextcloud.com/)
- [Nextcloud 문서](https://docs.nextcloud.com/)
- [Nextcloud Docker Hub](https://hub.docker.com/_/nextcloud)
- [Nextcloud GitHub (Server)](https://github.com/nextcloud/server)
- [Nextcloud GitHub (Docker)](https://github.com/nextcloud/docker)
- [Nextcloud GitHub (All-in-One)](https://github.com/nextcloud/all-in-one)

### Docker 설정

- [Docker 환경 변수 설정](https://github.com/nextcloud/docker#environment-variables)
- [Docker Hooks 지원](https://github.com/nextcloud/docker/pull/2231)
- [occ 명령어 가이드](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html)

### 추가 정보

- [설치 가이드](https://docs.nextcloud.com/server/latest/admin_manual/installation/)
- [설정 옵션](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html)
- [성능 튜닝](https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html)

## 기술 스택

- **Nextcloud**: 29 (최신 버전)
- **PostgreSQL**: 16 (Alpine)
- **Redis**: 8.2 (Alpine)
- **PHP**: 8.x (Nextcloud 이미지에 포함)
- **Apache** 또는 **PHP-FPM**: 웹 서버 옵션

## 라이선스

Nextcloud는 AGPLv3 라이선스로 배포됩니다.

## 버전 선택 가이드

### Apache vs FPM

| 항목 | Apache 버전 | FPM 버전 |
|------|-------------|----------|
| **구성** | 외부 DB 필요 | 올인원 (모든 서비스 포함) |
| **난이도** | 중급 | 초급 |
| **성능** | 기본 | 최적화 가능 (Nginx + FPM) |
| **용도** | 기존 인프라 활용 | 빠른 테스트/개발 |
| **추천** | 프로덕션 환경 | 개발/테스트 환경 |

### 데이터베이스 선택

| 데이터베이스 | 장점 | 단점 |
|--------------|------|------|
| **PostgreSQL** | 고급 기능, 트랜잭션 | 약간 느린 설정 |
| **MariaDB** | 빠른 속도, 익숙함 | 일부 고급 기능 제한 |

## 보안 권장사항

1. **기본 비밀번호 변경**: 프로덕션에서는 반드시 강력한 비밀번호 사용
2. **HTTPS 사용**: 리버스 프록시(Nginx, Traefik 등)로 SSL/TLS 설정
3. **신뢰할 도메인 설정**: `NEXTCLOUD_TRUSTED_DOMAINS`로 허용 도메인 제한
4. **정기 업데이트**: 보안 패치를 위해 정기적으로 이미지 업데이트
5. **백업**: 데이터와 설정을 정기적으로 백업
