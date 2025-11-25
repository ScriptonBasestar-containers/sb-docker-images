# Base Image: nginx
# Version: 1.27-alpine3.20
# Last Verified: 2025-11-25
# Docker Hub: https://hub.docker.com/_/nginx/tags
ARG NGINX_VERSION=1.27-alpine3.20

FROM nginx:${NGINX_VERSION}

RUN apk update && apk upgrade && \
    apk add nginx-mod-rtmp

ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./10-rtmp.conf /etc/nginx/module.d/10-rtmp.conf
ADD ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
# HEALTHCHECK CMD /docker-healthcheck.shls
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:80 || exit 1

EXPOSE 80 443
EXPOSE 1935
CMD ["nginx", "-g", "daemon off;"]
