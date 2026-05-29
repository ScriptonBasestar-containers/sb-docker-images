FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y bitcoind

RUN mkdir /data
VOLUME [ "/data" ]

# ENTRYPOINT [ "/usr/bin/bitcoind"]
ENTRYPOINT [ "/usr/bin/bitcoind", "-datadir=/data" ]

EXPOSE 8333
EXPOSE 8332