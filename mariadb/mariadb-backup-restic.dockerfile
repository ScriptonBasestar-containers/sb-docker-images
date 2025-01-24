# backup/Dockerfile
FROM alpine:3.14

# 필요한 패키지 설치
RUN apk update && apk add --no-cache mariadb-client curl bash bash-completion openssh-client

# Restic 설치
RUN curl -L https://github.com/restic/restic/releases/download/v0.15.3/restic_0.15.3_linux_amd64.bz2 | bunzip2 - > /usr/local/bin/restic && \
    chmod +x /usr/local/bin/restic

# MariaBackup 설치
RUN apk add --no-cache mariadb-backup

# 백업 스크립트 복사
COPY backup.sh /scripts/backup.sh
COPY backup_cron /etc/crontabs/root

# 실행 권한 부여
RUN chmod +x /scripts/backup.sh

# 크론 데몬 실행
CMD ["crond", "-f"]
