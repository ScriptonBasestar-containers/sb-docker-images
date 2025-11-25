# Base Image: discourse/base
# Version: 2.0.20241022-0018
# Last Verified: 2025-11-25
# Docker Hub: https://hub.docker.com/r/discourse/base/tags
#ARG RUBY_VERSION=3.3
#ARG DEBIAN_RELEASE=bookworm
#FROM ruby:${RUBY_VERSION}-${DEBIAN_RELEASE}
ARG DISCOURSE_BASE_VERSION=2.0.20241022-0018
FROM discourse/base:${DISCOURSE_BASE_VERSION}

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

ENV DOCKER_USE_HOSTNAME=true \
    DISCOURSE_HOSTNAME=test.googoo.com \
    DISCOURSE_DB_PORT=5432 \
    DISCOURSE_DB_HOST=postgres \
    DISCOURSE_DB_NAME=db01 \
    DISCOURSE_DB_USERNAME=user01 \
#    DISCOURSE_DB_PASSWORD=passw0rd \
    DISCOURSE_REDIS_DB=0 \
    DISCOURSE_REDIS_HOST=redis \
#    DISCOURSE_REDIS_PASSWORD=passw0rd \
    DISCOURSE_REDIS_PORT=6379 \
    DISCOURSE_REDIS_USE_SSL=false


WORKDIR /var/www/discourse
#COPY Gemfile* package.json yarn.lock ./
COPY discourse/ /var/www/discourse

RUN install -dm 0755 -o discourse -g discourse /var/www/discourse
RUN chown -R discourse /var/www/discourse
#RUN gem install bundler --conservative -v $(awk '/BUNDLED WITH/ { getline; gsub(/ /,""); print $0 }' /var/www/discourse/Gemfile.lock)

# Discourse specific bits
#RUN install -dm 0755 -o discourse -g discourse /var/www/discourse &&\
#    sudo -u discourse git clone --filter=tree:0 https://github.com/discourse/discourse.git /var/www/discourse &&\
#    gem install bundler --conservative -v $(awk '/BUNDLED WITH/ { getline; gsub(/ /,""); print $0 }' /var/www/discourse/Gemfile.lock)


RUN gem install --force bundler
RUN bundle config set deployment true
RUN bundle config set without development test
RUN bundle install --jobs=8
RUN yarn install --frozen-lockfile
RUN yarn cache clean
# RUN find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +
# RUN bin/rails assets:precompile

EXPOSE 80
EXPOSE 443
EXPOSE 3000

# COPY entryscript/ /entryscript
# ENTRYPOINT ["/entryscript/entry.sh"]

#CMD ["rails", "-s"]
