# MariaDB Backup System

MariaDB 데이터베이스 자동 백업 시스템 - Restic 및 Rclone 지원

## 개요

MariaDB 백업 시스템은 MariaDB/MySQL 데이터베이스를 자동으로 백업하고 원격 스토리지에 저장하는 Docker 기반 솔루션입니다. Restic과 Rclone 두 가지 백업 방식을 지원합니다.

### 주요 기능

- 자동화된 정기 백업 (Cron 기반)
- 증분 백업 지원 (Restic)
- 다양한 스토리지 백엔드 지원
- MariaBackup을 통한 일관성 있는 백업
- 대역폭 제한 기능
- 백업 보관 정책 지원
- 백업 복원 기능

### 지원 스토리지

#### Rclone 백엔드
- Amazon S3
- Google Cloud Storage
- Azure Blob Storage
- Backblaze B2
- Dropbox
- Google Drive
- OneDrive
- 기타 70개 이상의 스토리지

#### Restic 백엔드
- Local
- SFTP
- REST Server
- Amazon S3
- Backblaze B2
- Azure
- Google Cloud Storage
- 기타

## 빠른 시작

### 필수 요구사항

- Docker 및 Docker Compose
- MariaDB/MySQL 서버
- 원격 스토리지 계정 (S3, GCS 등)
- 충분한 디스크 공간

### Restic 백업 시스템

#### 1. 환경 변수 설정

`.env` 파일 생성:

```bash
# MariaDB 연결 정보
MYSQL_HOST=mariadb
MYSQL_PORT=3306
MYSQL_USER=backup_user
MYSQL_PASSWORD=secure_password
MYSQL_DATABASE=your_database

# Restic 저장소 설정
RESTIC_REPOSITORY=s3:s3.amazonaws.com/your-backup-bucket
RESTIC_PASSWORD=your_restic_password

# AWS 자격 증명 (S3 사용 시)
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_DEFAULT_REGION=us-east-1

# 백업 보관 정책
RESTIC_KEEP_DAILY=7
RESTIC_KEEP_WEEKLY=4
RESTIC_KEEP_MONTHLY=12
RESTIC_KEEP_YEARLY=2
```

#### 2. Docker Compose 설정

```yaml
version: '3.8'

services:
  mariadb:
    image: mariadb:10.6
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: myapp
      MYSQL_USER: myapp_user
      MYSQL_PASSWORD: myapp_pass
    volumes:
      - mariadb-data:/var/lib/mysql
    ports:
      - "3306:3306"

  backup:
    build:
      context: .
      dockerfile: mariadb-backup-restic.dockerfile
    environment:
      - MYSQL_HOST=mariadb
      - MYSQL_USER=root
      - MYSQL_PASSWORD=root_password
      - RESTIC_REPOSITORY=${RESTIC_REPOSITORY}
      - RESTIC_PASSWORD=${RESTIC_PASSWORD}
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
    volumes:
      - ./backups:/backups
      - ./backup-restic.sh:/scripts/backup.sh
    depends_on:
      - mariadb

volumes:
  mariadb-data:
```

### Rclone 백업 시스템

#### 1. 환경 변수 설정

```bash
# MariaDB 연결
MYSQL_HOST=mariadb
MYSQL_USER=root
MYSQL_PASSWORD=root_password

# Rclone 설정
RCLONE_REMOTE=s3-backup:my-bucket/mariadb
RCLONE_BWLIMIT=10M

# AWS 자격 증명
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
```

#### 2. Docker Compose 설정

```yaml
version: '3.8'

services:
  backup-rclone:
    build:
      context: .
      dockerfile: mariadb-backup-rclone.dockerfile
    environment:
      - MYSQL_HOST=mariadb
      - MYSQL_USER=root
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - RCLONE_REMOTE=${RCLONE_REMOTE}
      - RCLONE_BWLIMIT=10M
      - AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
      - AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
    volumes:
      - ./backups:/backups
      - ./backup-rclone.sh:/scripts/backup.sh
      - ./rclone.conf:/root/.config/rclone/rclone.conf
    depends_on:
      - mariadb
```

## 서비스 구성

### 핵심 컴포넌트

#### Restic 백업
- **Alpine Linux 3.14**: 경량 베이스 이미지
- **MariaDB Client**: 데이터베이스 연결
- **MariaBackup**: 물리적 백업 도구
- **Restic 0.15.3**: 백업 및 복원 도구
- **Cron**: 스케줄러

#### Rclone 백업
- **Alpine Linux 3.14**: 경량 베이스 이미지
- **MariaDB Client**: 데이터베이스 연결
- **Rclone**: 클라우드 스토리지 동기화
- **rsync**: 파일 동기화
- **Cron**: 스케줄러

## 백업 방식 비교

| 기능 | Restic | Rclone |
|------|--------|--------|
| 증분 백업 | ✓ | ✗ (전체 동기화) |
| 압축 | ✓ | ✗ |
| 암호화 | ✓ | ✗ (스토리지 의존) |
| 중복 제거 | ✓ | ✗ |
| 보관 정책 | ✓ | 수동 |
| 속도 | 중간 | 빠름 |
| 저장 공간 | 효율적 | 비효율적 |
| 복원 | 복잡 | 단순 |

**권장**: 장기 보관 및 효율성이 중요한 경우 Restic, 단순성이 중요한 경우 Rclone

## 환경 변수

### 공통 환경 변수

```bash
# MariaDB 연결 정보
MYSQL_HOST=mariadb           # 데이터베이스 호스트
MYSQL_PORT=3306              # 데이터베이스 포트
MYSQL_USER=root              # 데이터베이스 사용자
MYSQL_PASSWORD=password      # 데이터베이스 비밀번호
MYSQL_DATABASE=myapp         # 백업할 데이터베이스 (선택, 전체 백업 시 생략)

# 백업 디렉토리
BACKUP_DIR=/backups          # 로컬 백업 저장 경로
```

### Restic 전용 환경 변수

```bash
# Restic 저장소
RESTIC_REPOSITORY=s3:s3.amazonaws.com/bucket/path
RESTIC_PASSWORD=encryption_password

# AWS S3 (S3 백엔드 사용 시)
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=secret...
AWS_DEFAULT_REGION=us-east-1

# 보관 정책
RESTIC_KEEP_DAILY=7          # 일일 백업 보관 수
RESTIC_KEEP_WEEKLY=4         # 주간 백업 보관 수
RESTIC_KEEP_MONTHLY=12       # 월간 백업 보관 수
RESTIC_KEEP_YEARLY=2         # 연간 백업 보관 수

# 증분 백업 (선택)
LAST_BACKUP=/backups/last    # 이전 백업 경로
```

### Rclone 전용 환경 변수

```bash
# Rclone 원격 저장소
RCLONE_REMOTE=s3-backup:bucket/path

# 대역폭 제한
RCLONE_BWLIMIT=10M           # 10MB/s 제한

# AWS 자격 증명
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=secret...
AWS_REGION=us-east-1
```

## 사용법

### 백업 실행

#### 수동 백업

```bash
# Restic 백업
docker compose exec backup /scripts/backup.sh

# Rclone 백업
docker compose exec backup-rclone /scripts/backup.sh
```

#### 자동 백업 (Cron)

백업은 기본적으로 매일 새벽 2시에 자동 실행됩니다.

Cron 스케줄 변경:

```bash
# backup_cron 파일 수정
0 2 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1

# 예시: 매 6시간마다 실행
0 */6 * * * /scripts/backup.sh >> /var/log/backup.log 2>&1

# 예시: 매주 일요일 새벽 3시
0 3 * * 0 /scripts/backup.sh >> /var/log/backup.log 2>&1
```

### 백업 복원

#### Restic 복원

```bash
# 저장소 내용 확인
docker compose exec backup restic snapshots

# 최신 백업 복원
docker compose exec backup restic restore latest --target /restore

# 특정 스냅샷 복원
docker compose exec backup restic restore abc123def --target /restore

# 특정 파일만 복원
docker compose exec backup restic restore latest \
  --target /restore \
  --include /var/lib/mysql/mydb
```

#### Rclone 복원

```bash
# 백업 목록 확인
docker compose exec backup-rclone rclone ls $RCLONE_REMOTE

# 최신 백업 다운로드
docker compose exec backup-rclone rclone copy \
  $RCLONE_REMOTE/mariadb_2024-01-01_02-00-00 \
  /restore

# 전체 동기화
docker compose exec backup-rclone rclone sync \
  $RCLONE_REMOTE \
  /restore
```

### 보관 정책 적용

#### Restic 자동 정리

```bash
# 보관 정책에 따라 오래된 백업 삭제
docker compose exec backup restic forget \
  --keep-daily 7 \
  --keep-weekly 4 \
  --keep-monthly 12 \
  --prune

# 확인
docker compose exec backup restic snapshots
```

#### Rclone 수동 정리

```bash
# 30일 이상 오래된 백업 삭제
docker compose exec backup-rclone find /backups \
  -type d -mtime +30 -exec rm -rf {} \;
```

## 백업 전략

### 증분 백업 (Restic)

```bash
#!/bin/bash
# backup-restic.sh

# 환경 변수 로드
export RESTIC_REPOSITORY
export RESTIC_PASSWORD

# MariaBackup으로 증분 백업
if [ -z "$LAST_BACKUP" ]; then
    # 전체 백업
    mariabackup --backup --target-dir=$BACKUP_DIR/full
    export LAST_BACKUP=$BACKUP_DIR/full
else
    # 증분 백업
    mariabackup --backup \
      --target-dir=$BACKUP_DIR/inc \
      --incremental-basedir=$LAST_BACKUP
fi

# Restic으로 업로드
restic backup $BACKUP_DIR

# 보관 정책 적용
restic forget \
  --keep-daily ${RESTIC_KEEP_DAILY:-7} \
  --keep-weekly ${RESTIC_KEEP_WEEKLY:-4} \
  --keep-monthly ${RESTIC_KEEP_MONTHLY:-12} \
  --prune
```

### 전체 백업 (Rclone)

```bash
#!/bin/bash
# backup-rclone.sh

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_PATH=$BACKUP_DIR/mariadb_$TIMESTAMP

# mysqldump으로 전체 백업
mysqldump -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD \
  --all-databases \
  --single-transaction \
  --quick \
  --lock-tables=false \
  > $BACKUP_PATH.sql

# 압축
gzip $BACKUP_PATH.sql

# Rclone으로 업로드
rclone sync $BACKUP_DIR $RCLONE_REMOTE \
  --bwlimit=$RCLONE_BWLIMIT \
  --progress
```

## 문제 해결

### 백업 실패

```bash
# 로그 확인
docker compose logs backup

# 수동으로 백업 실행하여 오류 확인
docker compose exec backup bash
/scripts/backup.sh

# MariaDB 연결 테스트
docker compose exec backup mysql -h $MYSQL_HOST -u $MYSQL_USER -p
```

### 권한 오류

```bash
# 백업 스크립트 권한 확인
docker compose exec backup ls -la /scripts/

# 권한 부여
docker compose exec backup chmod +x /scripts/backup.sh
```

### 디스크 공간 부족

```bash
# 디스크 사용량 확인
docker compose exec backup df -h

# 백업 디렉토리 크기 확인
docker compose exec backup du -sh /backups

# 오래된 백업 삭제
docker compose exec backup rm -rf /backups/old_*
```

### Restic 저장소 문제

```bash
# 저장소 초기화 (처음 사용 시)
docker compose exec backup restic init

# 저장소 검증
docker compose exec backup restic check

# 저장소 복구
docker compose exec backup restic repair snapshots
```

### Rclone 연결 실패

```bash
# 설정 테스트
docker compose exec backup-rclone rclone config show

# 연결 테스트
docker compose exec backup-rclone rclone lsd $RCLONE_REMOTE

# 디버그 모드
docker compose exec backup-rclone rclone -vv ls $RCLONE_REMOTE
```

## 보안

### 암호화

Restic은 기본적으로 암호화를 제공하지만, Rclone 사용 시 추가 암호화를 권장합니다:

```bash
# Rclone crypt 백엔드 사용
rclone config create encrypted crypt \
  remote=s3-backup:bucket \
  filename_encryption=standard \
  directory_name_encryption=true \
  password=your_password
```

### 자격 증명 관리

```bash
# .env 파일 권한 설정
chmod 600 .env

# Docker Secrets 사용 (Swarm)
echo "my_password" | docker secret create mysql_password -
```

### 네트워크 보안

```bash
# SSL/TLS로 MariaDB 연결
MYSQL_SSL_MODE=REQUIRED
MYSQL_SSL_CA=/path/to/ca.pem
```

## 모니터링

### 백업 로그 확인

```bash
# 실시간 로그
docker compose logs -f backup

# 백업 로그 파일
docker compose exec backup tail -f /var/log/backup.log

# 최근 백업 확인
docker compose exec backup ls -lht /backups | head
```

### 백업 상태 확인

```bash
# Restic 스냅샷 목록
docker compose exec backup restic snapshots

# Rclone 백업 목록
docker compose exec backup-rclone rclone ls $RCLONE_REMOTE

# 마지막 백업 시간
docker compose exec backup stat /backups/last_backup
```

### 알림 설정

백업 스크립트에 알림 추가:

```bash
# Slack 알림
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Backup completed successfully"}' \
  YOUR_SLACK_WEBHOOK_URL

# 이메일 알림 (sendmail)
echo "Backup completed" | mail -s "Backup Status" admin@example.com
```

## 성능 최적화

### 압축 레벨

```bash
# Restic 압축 (자동)
# 추가 설정 불필요

# Rclone 압축
gzip -9 backup.sql  # 최대 압축
gzip -1 backup.sql  # 빠른 압축
```

### 대역폭 제한

```bash
# Rclone
RCLONE_BWLIMIT=10M  # 10MB/s

# Restic
restic backup --limit-upload 10240  # KB/s
```

### 병렬 처리

```bash
# Rclone 병렬 전송
rclone sync /backups $RCLONE_REMOTE --transfers 4

# Restic 병렬 업로드
restic backup /backups --pack-size 64
```

## 유용한 명령어

```bash
# Restic
restic snapshots                    # 스냅샷 목록
restic stats                        # 저장소 통계
restic diff snap1 snap2            # 스냅샷 비교
restic mount /mnt/restic           # 백업 마운트
restic unlock                       # 잠금 해제

# Rclone
rclone ls remote:                   # 파일 목록
rclone size remote:                 # 총 크기
rclone ncdu remote:                 # 디스크 사용량 (ncurses)
rclone check local remote:          # 파일 검증
rclone dedupe remote:               # 중복 제거

# MariaDB
mysqldump --all-databases           # 전체 백업
mariabackup --backup                # 물리적 백업
mariabackup --prepare               # 백업 준비
mariabackup --copy-back             # 복원
```

## 참고 자료

- [MariaDB 공식 문서](https://mariadb.com/kb/en/documentation/)
- [MariaBackup 가이드](https://mariadb.com/kb/en/mariabackup-overview/)
- [Restic 공식 문서](https://restic.readthedocs.io/)
- [Rclone 공식 문서](https://rclone.org/docs/)
- [MySQL 백업 전략](https://dev.mysql.com/doc/refman/8.0/en/backup-strategy-summary.html)
- [Docker Volumes 백업](https://docs.docker.com/storage/volumes/#backup-restore-or-migrate-data-volumes)
- [Cron 표현식 가이드](https://crontab.guru/)
