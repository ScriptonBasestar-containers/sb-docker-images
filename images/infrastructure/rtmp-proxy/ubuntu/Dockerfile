ARG OS_VERSION=18.04


FROM ubuntu:${OS_VERSION}

RUN apt-get update && apt-get -y upgrade

RUN \
    apt-get install -y build-essential libpcre3 libpcre3-dev libssl-dev unzip && \
    apt-get install -y nginx libnginx-mod-rtmp && \
    apt-get install -y ffmpeg

ADD ./nginx.conf /etc/nginx/nginx.conf
ADD ./10-rtmp.conf /etc/nginx/module.d/10-rtmp.conf
ADD ./docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
# HEALTHCHECK CMD /docker-healthcheck.shls
HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:80 || exit 1

EXPOSE 80 443
EXPOSE 1935
CMD ["nginx", "-g", "daemon off;"]
