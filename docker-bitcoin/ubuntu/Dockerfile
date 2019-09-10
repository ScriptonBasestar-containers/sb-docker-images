FROM debian:stable-slim

MAINTAINER archmagece <archmagece@gmail.com>

ARG USER_ID
ARG GROUP_ID

ENV APP_DIR /application
WORKDIR $APP_DIR

ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# https://github.com/bitcoin/bitcoin/archive/v0.17.1.tar.gz
RUN apt-get update && \
    apt-get install -y curl

RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
RUN apt-get install -y libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev
RUN apt-get install -y libdb++-dev

RUN curl -L http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz | tar xz && \
    cd db-4.8.30.NC/build_unix/ && \
    ../dist/configure --prefix=/usr/local --enable-cxx && \
    make install

RUN BITCOIN_VER=$(curl --silent "https://api.github.com/repos/bitcoin/bitcoin/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') && \
    curl -L "https://github.com/bitcoin/bitcoin/archive/$BITCOIN_VER.tar.gz" | tar xz && \
    cd bitcoin-$(echo $BITCOIN_VER | cut -d'v' -f 2) && \
    ./autogen.sh && \
    ./configure LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/" && \
    make && make install

ENV BDB_PREFIX $APP_DIR/db-4.8.30.NC

#  && ./configure && make && make install

