#!/bin/bash
# 스크립트명: backup-restic.sh
# 용도: MariaBackup으로 로컬 백업을 만들고 Restic 저장소로 푸시
# 사용법: 컨테이너 cron에서 자동 호출됨. 수동: /scripts/backup.sh
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backups}"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
BACKUP_PATH="$BACKUP_DIR/mariadb_$TIMESTAMP"
LOG_TAG="[restic-backup $TIMESTAMP]"

mkdir -p "$BACKUP_DIR"

echo "$LOG_TAG starting MariaBackup → $BACKUP_PATH"
mariabackup --backup \
    --target-dir="$BACKUP_PATH" \
    --host="${MYSQL_HOST:-mariadb}" \
    --port="${MYSQL_PORT:-3306}" \
    --user="${MYSQL_USER:-backup_user}" \
    --password="${MYSQL_PASSWORD:?MYSQL_PASSWORD required}"

echo "$LOG_TAG preparing snapshot"
mariabackup --prepare --target-dir="$BACKUP_PATH"

if ! restic snapshots --quiet >/dev/null 2>&1; then
    echo "$LOG_TAG initializing restic repo at $RESTIC_REPOSITORY"
    restic init
fi

echo "$LOG_TAG pushing to restic repo"
restic backup "$BACKUP_PATH" \
    --tag "mariadb" \
    --tag "$TIMESTAMP" \
    --host "${MYSQL_HOST:-mariadb}"

echo "$LOG_TAG applying retention"
restic forget --prune \
    --keep-daily   "${BACKUP_KEEP_DAYS:-7}" \
    --keep-weekly  "${BACKUP_KEEP_WEEKS:-4}" \
    --keep-monthly "${BACKUP_KEEP_MONTHS:-12}"

echo "$LOG_TAG cleaning local staging"
rm -rf "$BACKUP_PATH"

echo "$LOG_TAG done"
