FROM ruby:3.3-bookworm

RUN apt-get -y update && apt-get -y install libicu-dev cmake git && rm -rf /var/lib/apt/lists/*
# RUN apt-get -y install build-essential cmake pkg-config libicu-dev zlib1g-dev libcurl4-openssl-dev libssl-dev ruby-dev

RUN gem install github-linguist
RUN gem install gollum
RUN gem install org-ruby asciidoctor wikicloth RedCloth

WORKDIR /wiki

ARG USER01=user01
ARG UID=1000
# 사용자 생성 (username: myuser, uid: 1001)
RUN useradd -u 1000 -m ${USER01}
    # && usermod -aG sudo ${USER01}

# 사용자 전환
USER ${USER01}

COPY docker-entrypoint.sh /entrypoint.sh
# COPY healthcheck.sh /healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]
# HEALTHCHECK CMD /healthcheck.sh
EXPOSE 8081
CMD ["gollum", "--port", "8081"]
