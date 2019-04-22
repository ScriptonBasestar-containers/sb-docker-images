FROM ubuntu:18.04


RUN apt-get update
RUN sudo apt-get install software-properties-common
RUN sudo add-apt-repository -y ppa:ethereum/ethereum
RUN sudo apt-get update
RUN sudo apt-get install -y ethereum


ENTRYPOINT []
ENTRYPOINT [/usr/bin/rungeth]

# use non-standard ports so don't accidently connect to real servers
# XXX Docker inheritance doesn't override, it extends the port      list...
EXPOSE 8110
EXPOSE 30310
EXPOSE 6110