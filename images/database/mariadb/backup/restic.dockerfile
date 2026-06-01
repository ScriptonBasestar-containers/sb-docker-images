# MariaDB backup container — MariaBackup → Restic repository
# Build context: this directory (images/database/mariadb/backup/)
FROM alpine:3.20

RUN apk add --no-cache \
        mariadb-client \
        mariadb-backup \
        restic \
        bash \
        ca-certificates \
        openssh-client \
        tzdata

COPY backup-restic.sh /scripts/backup.sh
COPY backup_cron /etc/crontabs/root

RUN chmod +x /scripts/backup.sh \
 && chmod 0644 /etc/crontabs/root \
 && mkdir -p /backups /var/log \
 && touch /var/log/backup.log

CMD ["crond", "-f", "-d", "8"]
