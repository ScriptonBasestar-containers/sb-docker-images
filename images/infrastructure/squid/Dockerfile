FROM ubuntu:focal

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG SQUID_VERSION=4.10

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid

COPY ./files/apt-get-noninteractive.conf /etc/apt/apt.conf.d/apt-get-noninteractive.conf

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends apt-utils \
    # && DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::Options::=--force-confdef -q -y remove --purge squid squid3 \
    && DEBIAN_FRONTEND=noninteractive apt-get install -q -y squid \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives

COPY ./files/localnet.conf /etc/squid/sb-conf.d/localnet.conf
RUN echo 'include /etc/squid/sb-conf.d/*' >> /etc/squid/squid.conf \
    && mv /etc/squid/conf.d/debian.conf /etc/squid/sb-conf.d/debian.conf

EXPOSE 3128/tcp

VOLUME /etc/squid/conf.d
VOLUME /var/spool/squid

CMD ["squid", "--foreground", "-s"]
