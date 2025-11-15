# MariaDB Backup Toolkit

**MariaDB Backup Toolkit**은 MariaDB 데이터베이스의 자동 백업을 위한 Docker 기반 유틸리티 모음입니다.

> **Note**: 이 디렉토리는 MariaDB 서버 자체를 실행하는 것이 아니라, **기존 MariaDB 컨테이너의 백업**을 담당합니다.

## 주요 기능

- **자동 백업**: Cron을 통한 정기 백업 자동화
- **증분 백업**: MariaBackup을 사용한 효율적인 증분 백업
- **원격 저장소 전송**: Rclone/Restic을 통한 S3/클라우드 백업
- **보관 정책**: 오래된 백업 자동 정리
- **대역폭 제한**: 네트워크 대역폭 제어

## 백업 방식 선택

이 툴킷은 두 가지 백업 방식을 제공합니다:

### 1. Rclone 방식 (권장)

**장점**:
- S3, Google Drive, Dropbox 등 70+ 클라우드 지원
- 간단한 설정
- 빠른 동기화

**사용 사례**:
- 클라우드 스토리지 백업
- 단순한 파일 동기화

### 2. Restic 방식

**장점**:
- 암호화 백업
- 중복 제거
- 스냅샷 관리

**사용 사례**:
- 보안이 중요한 백업
- 장기 보관 백업

## 시스템 요구사항

| 항목 | 사양 |
|------|------|
| **디스크** | 백업 크기의 2배 이상 |
| **네트워크** | 안정적인 인터넷 연결 |
| **MariaDB** | 실행 중인 MariaDB 컨테이너 필요 |

## Quick Start

### 1. Rclone 백업 설정

#### 환경 변수 설정

`.env` 파일 생성:

```env
# Rclone 설정
RCLONE_REMOTE=s3:my-backup-bucket/mariadb
RCLONE_BWLIMIT=10M

# AWS S3 (또는 S3 호환 스토리지)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1

# MariaDB 연결 정보
MYSQL_HOST=mariadb
MYSQL_USER=root
MYSQL_PASSWORD=your-password
MYSQL_DATABASE=your-database
```

#### Docker Compose 설정

기존 MariaDB 스택에 백업 서비스 추가:

```yaml
services:
  mariadb:
    image: mariadb:11
    environment:
      - MYSQL_ROOT_PASSWORD=your-password
      - MYSQL_DATABASE=your-database
    volumes:
      - mariadb-data:/var/lib/mysql
    networks:
      - db-network

  mariadb-backup:
    build:
      context: ./mariadb
      dockerfile: mariadb-backup-rclone.dockerfile
    environment:
      - RCLONE_REMOTE=${RCLONE_REMOTE}
      - RCLONE_BWLIMIT=${RCLONE_BWLIMIT}
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - AWS_REGION=${AWS_REGION}
      - MYSQL_HOST=mariadb
      - MYSQL_USER=root
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
    volumes:
      - backup-data:/backups
    depends_on:
      - mariadb
    networks:
      - db-network

volumes:
  mariadb-data:
  backup-data:

networks:
  db-network:
    driver: bridge
```

#### 백업 스케줄 설정

`backup_cron` 파일 수정:

```cron
# 매일 새벽 2시에 백업
0 2 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1

# 또는 4시간마다 백업
0 */4 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1
```

### 2. Restic 백업 설정

#### 환경 변수 설정

`.env` 파일에 추가:

```env
# Restic 설정
RESTIC_REPOSITORY=s3:s3.amazonaws.com/my-backup-bucket/mariadb
RESTIC_PASSWORD=your-encryption-password
RESTIC_COMPRESSION=auto

# S3 백엔드
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
```

#### Docker Compose 설정

```yaml
services:
  mariadb-backup-restic:
    build:
      context: ./mariadb
      dockerfile: mariadb-backup-restic.dockerfile
    environment:
      - RESTIC_REPOSITORY=${RESTIC_REPOSITORY}
      - RESTIC_PASSWORD=${RESTIC_PASSWORD}
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
      - MYSQL_HOST=mariadb
      - MYSQL_USER=root
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
    volumes:
      - backup-data:/backups
    depends_on:
      - mariadb
    networks:
      - db-network
```

## 백업 관리

### 수동 백업 실행

```bash
# Rclone 백업
docker exec mariadb-backup /scripts/backup.sh

# Restic 백업
docker exec mariadb-backup-restic restic backup /backups
```

### 백업 상태 확인

```bash
# 로컬 백업 확인
docker exec mariadb-backup ls -lh /backups

# Rclone 원격 확인
docker exec mariadb-backup rclone ls s3:my-backup-bucket/mariadb

# Restic 스냅샷 확인
docker exec mariadb-backup-restic restic snapshots
```

### 백업 복원

#### Rclone 백업 복원

```bash
# 1. 백업 다운로드
docker exec mariadb-backup rclone sync s3:my-backup-bucket/mariadb /restore

# 2. MariaDB 서비스 중지
docker compose stop mariadb

# 3. MariaBackup으로 복원
docker run --rm \
  -v backup-data:/backups \
  -v mariadb-data:/var/lib/mysql \
  mariadb:11 \
  mariabackup --prepare --target-dir=/backups/mariadb_YYYY-MM-DD_HH-MM-SS

docker run --rm \
  -v backup-data:/backups \
  -v mariadb-data:/var/lib/mysql \
  mariadb:11 \
  mariabackup --copy-back --target-dir=/backups/mariadb_YYYY-MM-DD_HH-MM-SS

# 4. 권한 수정
docker run --rm \
  -v mariadb-data:/var/lib/mysql \
  mariadb:11 \
  chown -R mysql:mysql /var/lib/mysql

# 5. MariaDB 서비스 시작
docker compose start mariadb
```

#### Restic 백업 복원

```bash
# 1. 스냅샷 확인
docker exec mariadb-backup-restic restic snapshots

# 2. 최신 스냅샷 복원
docker exec mariadb-backup-restic restic restore latest --target /restore

# 3. MariaDB 서비스 중지 및 복원 (위와 동일)
docker compose stop mariadb
# ... (MariaBackup 복원 과정 동일)
```

## 백업 스크립트 상세

### backup-rclone.sh

```bash
#!/bin/bash

# 환경 변수 로드
export RCLONE_REMOTE
export RCLONE_BWLIMIT
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_REGION

# 백업 디렉토리 설정
BACKUP_DIR=/backups
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH=$BACKUP_DIR/mariadb_$TIMESTAMP

mkdir -p $BACKUP_DIR

# MariaBackup을 사용한 증분 백업
mariabackup --backup --target-dir=$BACKUP_PATH --incremental-basedir=${LAST_BACKUP:-}

# Rclone으로 S3 전송
rclone sync $BACKUP_DIR $RCLONE_REMOTE --bwlimit=$RCLONE_BWLIMIT --progress

# 오래된 백업 삭제 (30일 이상)
find $BACKUP_DIR -type d -mtime +30 -exec rm -rf {} \;
```

### backup-restic.sh (예제)

```bash
#!/bin/bash

# Restic 저장소 초기화 (최초 1회)
restic init || true

# 백업 생성
BACKUP_DIR=/backups
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH=$BACKUP_DIR/mariadb_$TIMESTAMP

# MariaBackup 실행
mariabackup --backup --target-dir=$BACKUP_PATH

# Restic 백업
restic backup $BACKUP_PATH

# 보관 정책 (7일치 일일, 4주치 주간, 12개월치 월간)
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --prune
```

## Rclone 클라우드 설정 예제

### AWS S3

```bash
docker exec -it mariadb-backup rclone config

# 설정 옵션:
# type: s3
# provider: AWS
# env_auth: true (환경 변수 사용)
# region: us-east-1
```

### Minio (S3 호환)

```bash
# rclone.conf
[minio]
type = s3
provider = Minio
env_auth = false
access_key_id = minioadmin
secret_access_key = minioadmin
endpoint = http://minio:9000
```

### Google Drive

```bash
docker exec -it mariadb-backup rclone config

# 설정 옵션:
# type: drive
# OAuth 인증 필요
```

### Dropbox

```bash
docker exec -it mariadb-backup rclone config

# 설정 옵션:
# type: dropbox
# OAuth 인증 필요
```

## 고급 설정

### 증분 백업 관리

MariaBackup은 증분 백업을 지원합니다:

```bash
# 전체 백업 (기준)
mariabackup --backup --target-dir=/backups/full

# 증분 백업 1
mariabackup --backup --target-dir=/backups/inc1 \
  --incremental-basedir=/backups/full

# 증분 백업 2
mariabackup --backup --target-dir=/backups/inc2 \
  --incremental-basedir=/backups/inc1
```

### 압축 백업

```bash
# 백업 시 압축
mariabackup --backup --target-dir=/backups/compressed \
  --stream=xbstream | gzip > backup.xbstream.gz

# 압축 해제 후 복원
gunzip < backup.xbstream.gz | mbstream -x -C /var/lib/mysql
```

### 대역폭 제한

```bash
# Rclone 대역폭 제한
rclone sync /backups s3:bucket --bwlimit 10M

# Restic 대역폭 제한
restic backup /backups --limit-upload 10 --limit-download 10
```

## 모니터링

### 백업 로그 확인

```bash
# Cron 로그
docker exec mariadb-backup tail -f /var/log/backup.log

# Docker 컨테이너 로그
docker logs -f mariadb-backup
```

### 백업 성공 알림 (선택)

Slack 알림 추가:

```bash
# backup.sh에 추가
if [ $? -eq 0 ]; then
  curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"MariaDB backup succeeded"}' \
    $SLACK_WEBHOOK_URL
else
  curl -X POST -H 'Content-type: application/json' \
    --data '{"text":"MariaDB backup FAILED!"}' \
    $SLACK_WEBHOOK_URL
fi
```

## 보안 고려사항

### 1. 자격증명 보호

```bash
# .env 파일 권한 설정
chmod 600 .env

# Git에서 제외
echo ".env" >> .gitignore
```

### 2. Restic 암호화

Restic은 기본적으로 AES-256 암호화를 사용합니다:

```bash
# 강력한 암호 설정
RESTIC_PASSWORD=$(openssl rand -base64 32)
```

### 3. 네트워크 분리

```yaml
networks:
  db-network:
    driver: bridge
    internal: true  # 외부 접근 차단
```

## 문제 해결

### 백업 실패

```bash
# MariaDB 연결 확인
docker exec mariadb-backup mysql -h mariadb -u root -p -e "SHOW DATABASES;"

# 디스크 공간 확인
docker exec mariadb-backup df -h

# 백업 로그 확인
docker exec mariadb-backup cat /var/log/backup.log
```

### Rclone 전송 실패

```bash
# Rclone 설정 테스트
docker exec mariadb-backup rclone ls s3:my-bucket

# 연결 확인
docker exec mariadb-backup rclone check /backups s3:my-bucket/mariadb
```

### Restic 저장소 오류

```bash
# 저장소 검증
docker exec mariadb-backup-restic restic check

# 저장소 복구
docker exec mariadb-backup-restic restic rebuild-index
docker exec mariadb-backup-restic restic prune
```

## 성능 최적화

### 백업 병렬화

```bash
# MariaBackup 병렬 처리
mariabackup --backup --parallel=4 --target-dir=/backups/parallel
```

### Rclone 전송 최적화

```bash
# 병렬 전송
rclone sync /backups s3:bucket --transfers 8 --checkers 16

# 멀티파트 업로드
rclone sync /backups s3:bucket --s3-upload-concurrency 8
```

## 통합 예제

### Nextcloud + MariaDB 백업

```yaml
services:
  nextcloud:
    image: nextcloud:29
    depends_on:
      - mariadb

  mariadb:
    image: mariadb:11
    environment:
      - MYSQL_ROOT_PASSWORD=passw0rd
      - MYSQL_DATABASE=nextcloud
    volumes:
      - mariadb-data:/var/lib/mysql

  mariadb-backup:
    build:
      context: ./mariadb
      dockerfile: mariadb-backup-rclone.dockerfile
    environment:
      - RCLONE_REMOTE=s3:my-bucket/nextcloud-db
      - MYSQL_HOST=mariadb
      - MYSQL_PASSWORD=passw0rd
    volumes:
      - backup-data:/backups
    depends_on:
      - mariadb
```

### WordPress + MariaDB 백업

```yaml
services:
  wordpress:
    image: wordpress:latest
    depends_on:
      - mariadb

  mariadb:
    image: mariadb:11
    environment:
      - MYSQL_ROOT_PASSWORD=passw0rd
      - MYSQL_DATABASE=wordpress

  mariadb-backup:
    build:
      context: ./mariadb
      dockerfile: mariadb-backup-restic.dockerfile
    environment:
      - RESTIC_REPOSITORY=s3:bucket/wordpress-db
      - RESTIC_PASSWORD=${RESTIC_PASSWORD}
      - MYSQL_HOST=mariadb
      - MYSQL_PASSWORD=passw0rd
```

## 참고 자료

### 공식 문서
- [MariaBackup](https://mariadb.com/kb/en/mariabackup-overview/)
- [Rclone Documentation](https://rclone.org/docs/)
- [Restic Documentation](https://restic.readthedocs.io/)

### 도구
- [MariaDB Docker Hub](https://hub.docker.com/_/mariadb)
- [Rclone Supported Backends](https://rclone.org/#providers)
- [Restic Backends](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html)

## 라이선스

각 도구의 라이선스를 따릅니다:
- MariaDB: GPLv2
- Rclone: MIT
- Restic: BSD 2-Clause

## 관련 프로젝트

- **Percona XtraBackup**: MySQL/MariaDB 백업 도구
- **mydumper**: 멀티스레드 MySQL 덤프 도구
- **Duplicity**: 암호화 백업 도구
- **Borg**: 중복 제거 백업 프로그램
