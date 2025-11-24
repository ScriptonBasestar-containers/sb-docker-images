ARG RUBY_VERSION


FROM ruby:${RUBY_VERSION}
LABEL maintainer="archmagece@gmail.com"

# ENV PORT 5000
ARG CUSTOM_USER=$CUSTOM_USER
#ENV RAILS_VERSION ${RAILS_VERSION}
# ENV NODE_VERSION ${NODE_VERSION}


ENV SECRET_KEY_BASE 129dd7504292e8e2f20356d4bfa4333d64ed5c936322829763ddd694b4e33ba79ddfa53cf3db5ac7a5fe909028c9f14fd3e4f4c32d4816388d169d2b59396149
RUN sed -i 's@http://deb.debian.org/@http://mirror.kakao.com/@g' /etc/apt/sources.list
RUN sed -i 's@http://security.debian.org/@http://mirror.kakao.com/@g' /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get update -qq && apt-get install -y nodejs
RUN npm -g install webpack yarn

RUN apt-get -y install sudo
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

# EXPOSE 5000