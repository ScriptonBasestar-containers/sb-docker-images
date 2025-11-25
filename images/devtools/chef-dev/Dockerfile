# Chef Workstation Development Environment
# Migrated from deprecated ChefDK to Chef Workstation (2024)
ARG CHEF_VERSION=latest

FROM chef/chefworkstation:${CHEF_VERSION}
LABEL maintainer="archmagece@gmail.com"

ARG CUSTOM_USER=${CUSTOM_USER:-developer}

# Install additional tools
RUN apt-get update -qq && \
    apt-get -y install --no-install-recommends \
    sudo tree nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create entrypoint directory
RUN mkdir -p /docker-entrypoint.d
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh && \
    ln -sf /docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Create non-root user with sudo access
RUN useradd -ms /bin/bash ${CUSTOM_USER} && \
    echo "${CUSTOM_USER}:${CUSTOM_USER}" | chpasswd && \
    usermod -aG sudo ${CUSTOM_USER} && \
    echo "${CUSTOM_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers

# Setup workspace
RUN mkdir -p /work && \
    chown ${CUSTOM_USER}:${CUSTOM_USER} /work -R
WORKDIR /work
USER ${CUSTOM_USER}

CMD ["/bin/bash"]
