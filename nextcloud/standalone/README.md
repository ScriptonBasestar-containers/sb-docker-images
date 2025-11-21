# Nextcloud Standalone

Nextcloud 독립 실행 환경을 위한 Docker Compose 구성입니다.

## 개요

이 디렉토리는 Nextcloud의 두 가지 독립 실행 구성을 제공합니다:

- **Apache 변형** (`compose.apache.yml`): Apache + MariaDB + Redis
- **FPM 변형** (`compose.fpm.yml`): Nginx + PHP-FPM + PostgreSQL + Redis

## 특징

- ✅ 완전한 독립 실행 환경 (메인 프로젝트와 별도)
- ✅ 두 가지 웹서버 선택지 (Apache 또는 Nginx+FPM)
- ✅ 두 가지 데이터베이스 선택지 (MariaDB 또는 PostgreSQL)
- ✅ Redis 캐싱 통합
- ✅ Health check 기반 의존성 관리
- ✅ Docker hooks 지원 (설치/업그레이드 시점 스크립트 실행)
- ✅ 볼륨 기반 데이터 영속성

---

## 빠른 시작

### Apache 변형 (권장 - 초보자용)

```bash
cd nextcloud/standalone

# 서비스 시작
docker compose -f compose.apache.yml up -d

# 로그 확인
docker compose -f compose.apache.yml logs -f

# 서비스 중지
docker compose -f compose.apache.yml down
```

### FPM 변형 (고급 사용자용)

```bash
cd nextcloud/standalone

# 서비스 시작
docker compose -f compose.fpm.yml up -d

# 로그 확인
docker compose -f compose.fpm.yml logs -f

# 서비스 중지
docker compose -f compose.fpm.yml down
```

---

## 구성 비교

| 항목 | Apache 변형 | FPM 변형 |
|------|-------------|----------|
| **웹서버** | Apache (내장) | Nginx + PHP-FPM |
| **데이터베이스** | MariaDB 11.8 | PostgreSQL 16 |
| **캐시** | Redis 8.2 | Redis 8.2 |
| **포트** | 8210 | 8210 |
| **난이도** | 간단 (초보자 권장) | 고급 (성능 최적화) |
| **성능** | 보통 | 우수 |

---

## 접속 정보

### 웹 인터페이스
- **URL**: http://localhost:8210
- **관리자 계정**: admin
- **관리자 비밀번호**: passw0rd

### 데이터베이스 (내부 접속)

**Apache 변형 (MariaDB):**
- Host: mariadb
- Database: db01
- User: user01
- Password: passw0rd

**FPM 변형 (PostgreSQL):**
- Host: postgres
- Database: db01
- User: user01
- Password: passw0rd

### Redis (내부 접속)
- Host: redis
- Port: 6379
- Password: passw0rd

---

## 서비스 구성

### Apache 변형

```yaml
services:
  nextcloud:       # Nextcloud with Apache
  mariadb:         # MariaDB 11.8
  redis:           # Redis 8.2
```

### FPM 변형

```yaml
services:
  nextcloud:       # Nextcloud with PHP-FPM
  postgres:        # PostgreSQL 16
  redis:           # Redis 8.2
```

---

## 볼륨 구조

| 볼륨 | 경로 | 용도 |
|------|------|------|
| `nxc_root` | `/var/www/html` | Nextcloud 루트 디렉토리 |
| `nxc_apps` | `/var/www/html/custom_apps` | 사용자 정의 앱 |
| `nxc_data` | `/var/www/html/data` | 사용자 데이터 |
| `nxc_themes` | `/var/www/html/themes` | 사용자 정의 테마 |
| `mariadb` | `/var/lib/mysql` | MariaDB 데이터 (Apache 변형) |
| `postgres` | `/var/lib/postgresql/data` | PostgreSQL 데이터 (FPM 변형) |
| `redis` | `/data` | Redis 데이터 |

---

## Docker Hooks

Nextcloud는 다양한 시점에서 커스텀 스크립트를 실행할 수 있는 hooks를 지원합니다:

| Hook | 실행 시점 |
|------|-----------|
| `pre-installation` | Nextcloud 설치 **전** |
| `post-installation` | Nextcloud 설치 **후** |
| `pre-upgrade` | Nextcloud 업그레이드 **전** |
| `post-upgrade` | Nextcloud 업그레이드 **후** |
| `before-starting` | Nextcloud 시작 **전** |

### Hook 사용 방법

1. Hook 디렉토리 생성:
```bash
mkdir -p app-hooks/post-installation
```

2. 스크립트 작성:
```bash
cat > app-hooks/post-installation/01-custom-setup.sh << 'EOF'
#!/bin/sh
# 설치 후 자동으로 실행될 스크립트
occ config:system:set overwrite.cli.url --value="http://localhost:8210"
EOF

chmod +x app-hooks/post-installation/01-custom-setup.sh
```

3. compose.yml에서 볼륨 마운트 주석 해제:
```yaml
volumes:
  - ./app-hooks/post-installation:/docker-entrypoint-hooks.d/post-installation
```

---

## 환경변수 커스터마이징

### 기본 설정

```yaml
environment:
  NEXTCLOUD_ADMIN_USER: admin
  NEXTCLOUD_ADMIN_PASSWORD: passw0rd
  NC_DEBUG: true  # 디버그 모드 활성화
```

### 신뢰할 수 있는 도메인 추가

```yaml
environment:
  NEXTCLOUD_TRUSTED_DOMAINS: "example.com cloud.example.com"
```

### 업로드 제한 변경

```yaml
environment:
  NEXTCLOUD_UPLOAD_MAX_FILESIZE: 4G
  NEXTCLOUD_MAX_FILE_UPLOADS: 20
```

---

## 운영 명령어

### 상태 확인

```bash
# 컨테이너 상태 확인
docker compose -f compose.apache.yml ps

# Health check 상태 확인
docker compose -f compose.apache.yml ps --format json | jq '.[].Health'

# 로그 확인
docker compose -f compose.apache.yml logs nextcloud
```

### 데이터 백업

```bash
# 볼륨 백업
docker run --rm \
  -v nextcloud_nxc_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/nextcloud-data-backup.tar.gz /data

# 데이터베이스 백업 (MariaDB)
docker compose -f compose.apache.yml exec mariadb \
  mysqldump -u root -ppassw0rd db01 > backup.sql

# 데이터베이스 백업 (PostgreSQL)
docker compose -f compose.fpm.yml exec postgres \
  pg_dump -U user01 db01 > backup.sql
```

### 유지보수 모드

```bash
# 유지보수 모드 활성화
docker compose -f compose.apache.yml exec -u www-data nextcloud \
  php occ maintenance:mode --on

# 유지보수 모드 비활성화
docker compose -f compose.apache.yml exec -u www-data nextcloud \
  php occ maintenance:mode --off
```

### 캐시 관리

```bash
# 캐시 정리
docker compose -f compose.apache.yml exec -u www-data nextcloud \
  php occ files:scan --all

# Redis 캐시 확인
docker compose -f compose.apache.yml exec redis redis-cli -a passw0rd INFO
```

---

## Health Check

모든 서비스는 자동 health check가 구성되어 있습니다:

### MariaDB
```yaml
healthcheck:
  test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
  interval: 10s
  timeout: 5s
  retries: 5
```

### PostgreSQL
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U user01 -d db01"]
  interval: 10s
  timeout: 5s
  retries: 5
```

### Redis
```yaml
healthcheck:
  test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
  interval: 10s
  timeout: 3s
  retries: 5
```

---

## 문제 해결

### 로그인 화면이 표시되지 않음

1. 신뢰할 수 있는 도메인 설정 확인:
```bash
docker compose -f compose.apache.yml exec -u www-data nextcloud \
  php occ config:system:get trusted_domains
```

2. 신뢰할 수 있는 도메인 추가:
```bash
docker compose -f compose.apache.yml exec -u www-data nextcloud \
  php occ config:system:set trusted_domains 1 --value="localhost:8210"
```

### 데이터베이스 연결 오류

1. 데이터베이스 health check 확인:
```bash
docker compose -f compose.apache.yml ps mariadb
# 또는
docker compose -f compose.fpm.yml ps postgres
```

2. 데이터베이스 로그 확인:
```bash
docker compose -f compose.apache.yml logs mariadb
# 또는
docker compose -f compose.fpm.yml logs postgres
```

### Redis 연결 오류

1. Redis health check 확인:
```bash
docker compose -f compose.apache.yml ps redis
```

2. Redis 연결 테스트:
```bash
docker compose -f compose.apache.yml exec redis redis-cli -a passw0rd PING
```

---

## 참조

### 공식 문서
- [Nextcloud Docker Hub](https://hub.docker.com/_/nextcloud)
- [Nextcloud 관리자 매뉴얼](https://docs.nextcloud.com/server/latest/admin_manual/)
- [Nextcloud occ 명령어](https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/occ_command.html)

### 관련 이슈
- [GitHub Issue #2226 - NC_* 환경변수 제한](https://github.com/nextcloud/docker/issues/2226)
  > `NC_*` 환경변수는 `.`를 포함하는 파라미터나 배열 값을 지원하지 않습니다.
  > 대신 `occ config:system:set` 명령어나 Docker hooks를 사용하는 것이 권장됩니다.

### 포트 충돌 해결
- 이 구성은 포트 8210을 사용합니다
- 메인 nextcloud 프로젝트와 동시에 실행하지 마세요
- 포트 변경이 필요한 경우:
  ```yaml
  ports:
    - "8888:80"  # 8210 대신 8888 사용
  ```

---

## 라이선스

이 프로젝트는 테스트 및 개발 목적으로만 사용하세요.
프로덕션 환경에서는 추가 보안 설정이 필요합니다.
