# Used to gather information about CPU and memory
#  reporting it back to statsd

# discourse_monitor
# version 0.0.3

# Base Image: ruby
# Version: 3.3-slim-bookworm
# Last Verified: 2025-11-25
# Docker Hub: https://hub.docker.com/_/ruby/tags
# Note: Migrated from deprecated samsaffron/discourse_base:1.0.7
ARG RUBY_VERSION=3.3-slim-bookworm
FROM ruby:${RUBY_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ADD src/monitor.rb src/monitor.rb
RUN gem install statsd-ruby docker-api

CMD ["ruby", "src/monitor.rb"]
