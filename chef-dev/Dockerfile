ARG CHEF_VERSION=3.4.28


FROM chef/chefdk:${CHEF_VERSION}
LABEL maintainer="archmagece@gmail.com"

ARG CUSTOM_USER=$CUSTOM_USER

RUN gem install knife-solo --pre

RUN sed -i 's@http://archive.ubuntu.com/@http://mirror.kakao.com/@g' /etc/apt/sources.list
RUN sed -i 's@http://security.ubuntu.com/@http://mirror.kakao.com/@g' /etc/apt/sources.list
RUN apt-get update -qq && apt-get -y upgrade

RUN apt-get -y install sudo tree nano build-essential
RUN apt-get clean

RUN mkdir -p /docker-entrypoint.d
COPY docker-entrypoint.sh /
RUN ln -s /docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

#sudo chown 1000:1000 /work -R
RUN useradd -ms /bin/bash ${CUSTOM_USER} && echo ${CUSTOM_USER}:${CUSTOM_USER} | chpasswd && adduser ${CUSTOM_USER} sudo
#usermod -aG sudo ${CUSTOM_USER}
RUN echo "${CUSTOM_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /work
RUN chown ${CUSTOM_USER}:${CUSTOM_USER} /work -R
WORKDIR /work
USER ${CUSTOM_USER}

CMD ["/bin/bash"]
