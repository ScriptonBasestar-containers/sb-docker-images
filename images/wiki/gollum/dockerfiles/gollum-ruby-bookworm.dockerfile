FROM ruby:3.3.6-slim-bookworm

RUN apt-get -yq update && \
    apt-get -y install build-essential cmake git pkg-config libicu-dev zlib1g-dev libcurl4-openssl-dev libssl-dev ruby-dev && \
    rm -rf /var/lib/apt/lists/*

RUN gem update --system
RUN gem install github-linguist \
    install gollum \
    install org-ruby asciidoctor wikicloth RedCloth

WORKDIR /wiki

ARG USER01=user01
ARG UID=1000
# 사용자 생성 (username: myuser, uid: 1001)
RUN useradd -u 1000 -m ${USER01}
    # && usermod -aG sudo ${USER01}

# 사용자 전환
USER ${USER01}

COPY --chmod=755 conf/docker-entrypoint.sh /usr/local/bin/entrypoint.sh
# COPY healthcheck.sh /healthcheck.sh

ENTRYPOINT ["entrypoint.sh"]
# HEALTHCHECK CMD /healthcheck.sh
EXPOSE 8081
CMD ["gollum", "--port", "8081"]
