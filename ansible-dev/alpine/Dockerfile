FROM alpine:3.11

ENV ANSIBLE_VERSION=2.9.2

ENV BUILD_PACKAGES \
        bash \
        curl \
        tar \
        nano \
        openssh-client \
        sshpass \
        git \
        python3 \
        py3-boto \
        py3-dateutil \
        py3-httplib2 \
        py3-jinja2 \
        py3-paramiko \
        py3-pip \
        py3-setuptools \
        py3-yaml \
        ca-certificates

RUN apk --update add --virtual build-dependencies \
        gcc \
        musl-dev \
        libffi-dev \
        openssl-dev \
        python3-dev && \
    set -x && \
    apk update && apk upgrade && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    pip3 install --upgrade pip && \
    pip3 install python3-keyczar docker-py boto3 botocore && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    mkdir -p /etc/ansible/ /ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts && \
    curl -fsSL https://releases.ansible.com/ansible/ansible-${ANSIBLE_VERSION}.tar.gz -o ansible.tar.gz && \
    tar -xzf ansible.tar.gz -C /ansible --strip-components 1 && \
    rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

ENV ANSIBLE_GATHERING=smart \
    ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_ROLES_PATH=/ansible/playbooks/roles \
    ANSIBLE_SSH_PIPELINING=True \
    PYTHONPATH=/ansible/lib \
    PATH=/ansible/bin:$PATH \
    ANSIBLE_LIBRARY=/ansible/library \
    EDITOR=nano

# RUN ln -s /usr/bin/python3 /usr/bin/python && \
#     ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN mkdir -p /playbooks
WORKDIR /playbooks

ENTRYPOINT ["ansible-playbook"]