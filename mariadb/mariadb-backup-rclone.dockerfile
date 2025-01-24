# backup/Dockerfile
FROM alpine:3.14

# 필요한 패키지 설치
RUN apk update && \
    apk add --no-cache mariadb-client rsync rclone bash bash-completion openssh-client cron

# rsync 설치는 이미 포함되어 있으므로 별도 설치 필요 없음

# rclone 설정 (옵션: 최신 버전 설치)
RUN curl https://rclone.org/install.sh | bash

# 백업 스크립트 복사
COPY backup.sh /scripts/backup.sh
COPY backup_cron /etc/crontabs/root

# 실행 권한 부여
RUN chmod +x /scripts/backup.sh && \
    chmod 0644 /etc/crontabs/root

# 크론 데몬 실행
CMD ["crond", "-f"]
