ARG RUBY_VERSION=3.3
ARG DEBIAN_RELEASE=bookworm
FROM ruby:${RUBY_VERSION}-${DEBIAN_RELEASE}

ARG DEBIAN_RELEASE
ARG RUBY_VERSION
ENV PG_MAJOR=15 \
    RUBY_ALLOCATOR=/usr/lib/libjemalloc.so \
    RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    LEFTHOOK=0 \
    RUBY_VERSION=${RUBY_VERSION} \
    DEBIAN_RELEASE=${DEBIAN_RELEASE}

RUN curl --silent --location https://deb.nodesource.com/setup_18.x | sudo bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get -y update

RUN echo 2.0.`date +%Y%m%d` > /VERSION
RUN echo "deb http://deb.debian.org/debian ${DEBIAN_RELEASE}-backports main" > "/etc/apt/sources.list.d/${DEBIAN_RELEASE}-backports.list"
RUN echo "debconf debconf/frontend select Teletype" | debconf-set-selections
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg sudo curl fping
RUN sh -c "fping proxy && echo 'Acquire { Retries \"0\"; HTTP { Proxy \"http://proxy:3128\";}; };' > /etc/apt/apt.conf.d/40proxy && apt-get update || true"
RUN apt-mark hold initscripts
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ENV DOCKER_USE_HOSTNAME=true \
    DISCOURSE_HOSTNAME=test.googoo.com \
    DISCOURSE_DB_PORT=5432 \
    DISCOURSE_DB_HOST=postgres \
    DISCOURSE_DB_NAME=db01 \
    DISCOURSE_DB_USERNAME=user01 \
    DISCOURSE_DB_PASSWORD=passw0rd \
    DISCOURSE_REDIS_DB=0 \
    DISCOURSE_REDIS_HOST=redis \
    DISCOURSE_REDIS_PASSWORD=passw0rd \
    DISCOURSE_REDIS_PORT=6379 \
    DISCOURSE_REDIS_USE_SSL=false


WORKDIR /app
COPY discourse/ /app
RUN bundle install

# COPY entryscript/ /entryscript
# ENTRYPOINT ["/entryscript/entry.sh"]

CMD ["rails", "-s"]
