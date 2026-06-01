#!/bin/bash
# 스크립트명: backup-rclone.sh
# 용도: MariaBackup으로 로컬 백업을 만들고 rclone으로 원격 저장소(S3/GCS/...)에 동기화
# 사용법: 컨테이너 cron에서 자동 호출됨. 수동: /scripts/backup.sh
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backups}"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
BACKUP_PATH="$BACKUP_DIR/mariadb_$TIMESTAMP"
LOG_TAG="[rclone-backup $TIMESTAMP]"

mkdir -p "$BACKUP_DIR"

# Pick full vs incremental based on whether a previous backup exists
LAST_BACKUP="$(ls -1dt "$BACKUP_DIR"/mariadb_* 2>/dev/null | head -n1 || true)"
if [[ -n "$LAST_BACKUP" && -d "$LAST_BACKUP" ]]; then
    echo "$LOG_TAG incremental backup against $LAST_BACKUP"
    INCREMENTAL_ARGS=(--incremental-basedir="$LAST_BACKUP")
else
    echo "$LOG_TAG full backup (no prior found)"
    INCREMENTAL_ARGS=()
fi

mariabackup --backup \
    --target-dir="$BACKUP_PATH" \
    --host="${MYSQL_HOST:-mariadb}" \
    --port="${MYSQL_PORT:-3306}" \
    --user="${MYSQL_USER:-backup_user}" \
    --password="${MYSQL_PASSWORD:?MYSQL_PASSWORD required}" \
    "${INCREMENTAL_ARGS[@]}"

echo "$LOG_TAG syncing $BACKUP_DIR -> $RCLONE_REMOTE"
rclone sync "$BACKUP_DIR" "${RCLONE_REMOTE:?RCLONE_REMOTE required}" \
    --bwlimit="${RCLONE_BWLIMIT:-0}" \
    --stats=30s

# Local retention (cloud-side retention managed via rclone or bucket lifecycle)
KEEP_DAYS="${BACKUP_KEEP_DAYS:-7}"
echo "$LOG_TAG pruning local backups older than $KEEP_DAYS days"
find "$BACKUP_DIR" -maxdepth 1 -type d -name 'mariadb_*' -mtime "+$KEEP_DAYS" -exec rm -rf {} +

echo "$LOG_TAG done"
