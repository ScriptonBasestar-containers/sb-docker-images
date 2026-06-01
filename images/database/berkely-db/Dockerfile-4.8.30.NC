FROM debian:bookworm-slim

ENV BDB_VERSION="db-4.8.30.NC" \
    BDB_HASH="12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef" \
    BDB_DIR="/usr/local/db4"

RUN BDB_FILE=$BDB_VERSION".tar.gz" \
    && BDB_URL="https://download.oracle.com/berkeley-db/"$BDB_FILE \
    && set -xe \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        g++ \
        make \
        autoconf \
        libtool \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q $BDB_URL \
    && echo "$BDB_HASH $BDB_FILE" | sha256sum -c - \
    && tar -xzf $BDB_FILE \
    && cd $BDB_VERSION"/build_unix/" \
    && ../dist/configure \
        --build=$(uname -m)-unknown-linux-gnu \
        --enable-cxx \
        --disable-shared \
        --with-pic \
        --prefix=$BDB_DIR \
        CFLAGS="-Wno-error=implicit-function-declaration" \
        CXXFLAGS="-std=gnu++11" \
    && mkdir -p $BDB_DIR \
    && make install \
    && cd ../../ \
    && rm $BDB_FILE \
    && rm -rf $BDB_VERSION

ENV BDB_INCLUDE_PATH="/usr/local/db4/include" \
    BDB_LIB_PATH="/usr/local/db4/lib"
