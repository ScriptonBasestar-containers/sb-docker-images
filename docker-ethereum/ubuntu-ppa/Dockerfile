FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get update
RUN apt-get install -y ethereum

RUN mkdir /data
VOLUME [ "/data" ]

# ENTRYPOINT [ "/usr/bin/geth" ]
ENTRYPOINT [ "/usr/bin/geth", "-datadir=/data" ]
# ENTRYPOINT [ "/usr/bin/geth", "-datadir=/data", "--rpc" ]

# use non-standard ports so don't accidently connect to real servers
# XXX Docker inheritance doesn't override, it extends the port      list...
EXPOSE 8110
EXPOSE 30310
EXPOSE 6110