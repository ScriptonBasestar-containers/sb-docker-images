FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y bitcoind

VOLUME [ "/data" ]

ENTRYPOINT [ "bitcoind -daemon -datadir=/data" ]