FROM ruby:3.3-bullseye

RUN apt-get -y update && apt-get -y install libicu-dev cmake git && rm -rf /var/lib/apt/lists/*

RUN gem install github-linguist
RUN gem install gollum
RUN gem install org-ruby asciidoctor wikicloth RedCloth

WORKDIR /wiki

COPY docker-entrypoint.sh /entrypoint.sh
# COPY healthcheck.sh /healthcheck.sh

ENTRYPOINT ["/entrypoint.sh"]
# HEALTHCHECK CMD /healthcheck.sh
EXPOSE 8081
CMD ["gollum", "--port", "8081"]
