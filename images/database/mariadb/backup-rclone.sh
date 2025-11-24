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

# 백업 스크립트 종료 시 LAST_BACKUP 업데이트 (옵션: 필요 시 구현)
# export LAST_BACKUP=$BACKUP_PATH

# rsync를 사용하여 S3로 백업 전송 (bwlimit 추가)
rclone sync $BACKUP_DIR $RCLONE_REMOTE --bwlimit=$RCLONE_BWLIMIT --progress

# 오래된 백업 삭제 (보관 정책에 따라 조정)
# find $BACKUP_DIR -type d -mtime +30 -exec rm -rf {} \;
