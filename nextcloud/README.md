# Nextcloud - Self-Hosted File Sync and Share

**Nextcloud**는 자체 호스팅 파일 동기화 및 공유 플랫폼입니다. Dropbox, Google Drive의 오픈소스 대안입니다.

## 주요 기능

- **파일 동기화**: 데스크톱/모바일 클라이언트로 자동 동기화
- **파일 공유**: 공개/비공개 링크 공유, 권한 관리
- **협업**: 문서 편집, 캘린더, 연락처, 메일
- **앱 생태계**: 200+ 공식/커뮤니티 앱
- **End-to-End 암호화**: 클라이언트 측 암호화 지원
- **GDPR 준수**: EU 데이터 보호 규정 준수

## 디렉토리 구조

```
nextcloud/
├── README.md          # 이 파일
├── Makefile           # 공통 make 명령어
└── standalone/        # Standalone 배포
    ├── compose.fpm.yml      # FPM + Nginx 구성 (권장)
    ├── compose.apache.yml   # Apache 구성
    └── Makefile
```

## Quick Start

### Standalone 배포 (권장)

```bash
cd standalone
docker compose -f compose.fpm.yml up -d
```

웹 UI 접속: http://localhost:8080

**기본 Credentials**:
- Username: `admin`
- Password: `passw0rd`

> **⚠️ 보안 경고**: 프로덕션 환경에서는 반드시 비밀번호를 변경하세요!

## 시스템 요구사항

| 항목 | 최소 | 권장 |
|------|------|------|
| **메모리** | 512MB | 1GB+ |
| **CPU** | 1코어 | 2코어+ |
| **스토리지** | 10GB | 50GB+ |
| **Database** | SQLite (기본) | PostgreSQL/MySQL |

## 구성 옵션

### FPM + Nginx (고성능)

`standalone/compose.fpm.yml` 사용:

**장점**:
- 높은 성능 (PHP-FPM 프로세스 풀)
- 리소스 효율적
- 확장성 우수

**구성**:
- Nextcloud (PHP-FPM)
- PostgreSQL 16
- Redis (캐싱, 세션)

### Apache (간단한 설정)

`standalone/compose.apache.yml` 사용:

**장점**:
- 설정 간단
- 추가 웹서버 불필요

**단점**:
- FPM보다 성능 낮음

## 주요 설정

### 환경 변수

```yaml
services:
  nextcloud:
    environment:
      # 관리자 계정
      NEXTCLOUD_ADMIN_USER: admin
      NEXTCLOUD_ADMIN_PASSWORD: your-strong-password

      # 데이터베이스
      POSTGRES_HOST: postgres
      POSTGRES_DB: nextcloud
      POSTGRES_USER: nextcloud
      POSTGRES_PASSWORD: postgres-password

      # Redis 캐시
      REDIS_HOST: redis
      REDIS_HOST_PORT: 6379
      REDIS_HOST_PASSWORD: redis-password

      # 신뢰 도메인
      NEXTCLOUD_TRUSTED_DOMAINS: cloud.example.com
```

### Hooks (고급)

Docker Entrypoint Hooks를 사용한 자동화:

```yaml
volumes:
  - ./app-hooks/pre-installation:/docker-entrypoint-hooks.d/pre-installation
  - ./app-hooks/post-installation:/docker-entrypoint-hooks.d/post-installation
  - ./app-hooks/before-starting:/docker-entrypoint-hooks.d/before-starting
```

**Hook 타입**:
- `pre-installation`: Nextcloud 설치 전 실행
- `post-installation`: Nextcloud 설치 후 실행
- `pre-upgrade`: 업그레이드 전 실행
- `post-upgrade`: 업그레이드 후 실행
- `before-starting`: Nextcloud 시작 전 실행

**예제** (`app-hooks/post-installation/01-install-apps.sh`):
```bash
#!/bin/bash
set -e

# 앱 자동 설치
occ app:install calendar
occ app:install contacts
occ app:install deck
occ app:enable files_external

# S3 외부 스토리지 설정 (Minio)
occ config:system:set objectstore arguments bucket --value="nextcloud-data"
occ config:system:set objectstore arguments endpoint --value="minio:9000"
```

## 통합 예제

### Minio S3 외부 스토리지

Nextcloud의 파일을 Minio에 저장:

#### 1. compose.yml 수정

```yaml
services:
  nextcloud:
    depends_on:
      - minio
    networks:
      - db-network
      - minio-network  # Minio 네트워크 추가

networks:
  minio-network:
    external: true
```

#### 2. Web UI 설정

1. Settings → External storages
2. Add storage → Amazon S3
3. 설정:
   ```
   Bucket: nextcloud-data
   Hostname: minio:9000
   Port: 9000
   Region: us-east-1
   Enable SSL: No
   Enable Path Style: Yes
   Access Key: minioadmin
   Secret Key: minioadmin
   ```

#### 3. CLI 설정 (선택)

```bash
docker exec -u www-data nextcloud php occ files_external:create \
  "S3 Storage" amazons3 amazons3::accesskey \
  -c bucket=nextcloud-data \
  -c hostname=minio \
  -c port=9000 \
  -c use_ssl=false \
  -c use_path_style=true \
  -c region=us-east-1 \
  -c key=minioadmin \
  -c secret=minioadmin
```

### Collabora Online (문서 편집)

#### 1. Collabora 추가

```yaml
services:
  collabora:
    image: collabora/code:latest
    environment:
      - domain=cloud\\.example\\.com
      - extra_params=--o:ssl.enable=false
    ports:
      - "9980:9980"
    networks:
      - db-network
```

#### 2. Nextcloud 설정

```bash
# Collabora 앱 설치
docker exec -u www-data nextcloud php occ app:install richdocuments

# Collabora 서버 설정
docker exec -u www-data nextcloud php occ config:app:set richdocuments wopi_url --value="http://collabora:9980"
```

### OnlyOffice (대안)

```yaml
services:
  onlyoffice:
    image: onlyoffice/documentserver:latest
    environment:
      - JWT_SECRET=your-secret
    ports:
      - "9981:80"
    networks:
      - db-network
```

## 백업 및 복원

### 데이터 백업

```bash
#!/bin/bash
BACKUP_DIR="/backup/nextcloud"
DATE=$(date +%Y%m%d-%H%M%S)

# 유지보수 모드 활성화
docker exec -u www-data nextcloud php occ maintenance:mode --on

# PostgreSQL 백업
docker exec postgres pg_dump -U nextcloud nextcloud | gzip > $BACKUP_DIR/db-$DATE.sql.gz

# 파일 백업 (볼륨)
docker run --rm \
  -v nextcloud_nxc_data:/source:ro \
  -v $BACKUP_DIR:/backup \
  alpine tar czf /backup/files-$DATE.tar.gz -C /source .

# 유지보수 모드 비활성화
docker exec -u www-data nextcloud php occ maintenance:mode --off

echo "Backup completed: $DATE"
```

### 데이터 복원

```bash
#!/bin/bash
BACKUP_DATE="20250115-120000"
BACKUP_DIR="/backup/nextcloud"

# 서비스 중지
docker compose down

# PostgreSQL 복원
gunzip < $BACKUP_DIR/db-$BACKUP_DATE.sql.gz | \
  docker exec -i postgres psql -U nextcloud nextcloud

# 파일 복원
docker run --rm \
  -v nextcloud_nxc_data:/target \
  -v $BACKUP_DIR:/backup \
  alpine tar xzf /backup/files-$BACKUP_DATE.tar.gz -C /target

# 서비스 시작
docker compose up -d

# 파일 스캔
docker exec -u www-data nextcloud php occ files:scan --all
```

## 유지보수

### 버전 업그레이드

```bash
# 1. 백업 (위 스크립트 참조)

# 2. compose.yml에서 버전 변경
# image: nextcloud:29 → nextcloud:30

# 3. 컨테이너 재시작
docker compose pull
docker compose up -d

# 4. 업그레이드 완료 확인
docker exec -u www-data nextcloud php occ status
```

### 캐시 정리

```bash
# Redis 캐시 플러시
docker exec -u www-data nextcloud php occ redis:clear-cache

# OPcache 리셋
docker exec -u www-data nextcloud php occ opcache:reset
```

### 파일 스캔

```bash
# 모든 파일 재스캔
docker exec -u www-data nextcloud php occ files:scan --all

# 특정 사용자만
docker exec -u www-data nextcloud php occ files:scan username
```

### 앱 관리

```bash
# 앱 목록
docker exec -u www-data nextcloud php occ app:list

# 앱 설치
docker exec -u www-data nextcloud php occ app:install calendar

# 앱 활성화/비활성화
docker exec -u www-data nextcloud php occ app:enable contacts
docker exec -u www-data nextcloud php occ app:disable survey_client
```

## 성능 최적화

### PHP 설정

`php.ini` 또는 환경 변수로 조정:

```ini
memory_limit = 512M
upload_max_filesize = 16G
post_max_size = 16G
max_execution_time = 3600
max_input_time = 3600
```

### Redis 캐싱

이미 `compose.fpm.yml`에 포함됨. 추가 설정:

```bash
docker exec -u www-data nextcloud php occ config:system:set \
  memcache.local --value="\\OC\\Memcache\\APCu"
docker exec -u www-data nextcloud php occ config:system:set \
  memcache.distributed --value="\\OC\\Memcache\\Redis"
docker exec -u www-data nextcloud php occ config:system:set \
  memcache.locking --value="\\OC\\Memcache\\Redis"
```

### 백그라운드 작업

```bash
# Cron 활성화 (권장)
docker exec -u www-data nextcloud php occ background:cron

# 또는 compose.yml에 cron 컨테이너 추가
services:
  cron:
    image: nextcloud:29
    entrypoint: /cron.sh
    depends_on:
      - postgres
      - redis
    volumes_from:
      - nextcloud
```

## 보안 설정

### HTTPS 설정 (Nginx 리버스 프록시)

```nginx
server {
    listen 443 ssl http2;
    server_name cloud.example.com;

    ssl_certificate /etc/ssl/certs/cloud.example.com.crt;
    ssl_certificate_key /etc/ssl/private/cloud.example.com.key;

    client_max_body_size 16G;
    client_body_buffer_size 400M;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebDAV 지원
        proxy_set_header X-Forwarded-Host $host;
        proxy_buffering off;
    }
}
```

### 신뢰 도메인 추가

```bash
docker exec -u www-data nextcloud php occ config:system:set \
  trusted_domains 1 --value="cloud.example.com"
```

### 2단계 인증 강제

```bash
docker exec -u www-data nextcloud php occ config:app:set \
  twofactor_totp --value="1"
```

## 문제 해결

### 파일 업로드 실패

```bash
# PHP 메모리 제한 확인
docker exec nextcloud php -i | grep memory_limit

# 업로드 크기 제한 확인
docker exec nextcloud php -i | grep upload_max_filesize
```

### Redis 연결 실패

```bash
# Redis 상태 확인
docker exec redis redis-cli ping

# Nextcloud Redis 설정 확인
docker exec -u www-data nextcloud php occ config:list | grep redis
```

### "Trusted domain" 오류

```bash
# 신뢰 도메인 목록 확인
docker exec -u www-data nextcloud php occ config:system:get trusted_domains

# 도메인 추가
docker exec -u www-data nextcloud php occ config:system:set \
  trusted_domains 2 --value="192.168.1.100"
```

## 참고 자료

### 공식 문서
- [Nextcloud 공식 사이트](https://nextcloud.com/)
- [Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)
- [Docker Hub](https://hub.docker.com/_/nextcloud)
- [Docker 설치 가이드](https://github.com/nextcloud/docker)

### 앱 및 통합
- [App Store](https://apps.nextcloud.com/)
- [Collabora Online](https://www.collaboraoffice.com/)
- [OnlyOffice](https://www.onlyoffice.com/)
- [External Storage](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage/)

### 커뮤니티
- [Nextcloud Forum](https://help.nextcloud.com/)
- [GitHub Issues](https://github.com/nextcloud/server/issues)

## 라이선스

Nextcloud는 AGPLv3 라이선스로 배포됩니다.

## 관련 프로젝트

- **ownCloud**: Nextcloud의 원조 프로젝트
- **Seafile**: 고성능 파일 동기화
- **Syncthing**: P2P 파일 동기화
- **Minio**: S3 호환 오브젝트 스토리지 (외부 스토리지로 사용 가능)
