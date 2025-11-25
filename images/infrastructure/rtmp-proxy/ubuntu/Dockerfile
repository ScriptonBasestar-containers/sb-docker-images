# Base Image: ubuntu
# Version: 24.04 (Noble Numbat LTS)
# Last Verified: 2025-11-25
# Docker Hub: https://hub.docker.com/_/ubuntu/tags
ARG OS_VERSION=24.04

FROM ubuntu:${OS_VERSION}

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        build-essential libpcre3 libpcre3-dev libssl-dev unzip \
        nginx libnginx-mod-rtmp \
        ffmpeg curl \
    && rm -rf /var/lib/apt/lists/*

ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./10-rtmp.conf /etc/nginx/module.d/10-rtmp.conf
ADD ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
# HEALTHCHECK CMD /docker-healthcheck.shls
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:80 || exit 1

EXPOSE 80 443
EXPOSE 1935
CMD ["nginx", "-g", "daemon off;"]
