FROM debian:bookworm-slim

ENV BDB_VERSION="db-5.3.28.NC" \
    BDB_HASH="76a25560d9e52a198d37a31440fd07632b5f1f8f9f2b6d5438f4bc3e7c9013ef" \
    BDB_DIR="/usr/local/db5"

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

ENV BDB_INCLUDE_PATH="/usr/local/db5/include" \
    BDB_LIB_PATH="/usr/local/db5/lib"
