FROM alpine:3.20

ENV ANSIBLE_VERSION=2.18

ENV BUILD_PACKAGES="bash curl tar nano openssh-client sshpass git openssl ansible \
python3 py3-dateutil py3-httplib2 py3-jinja2 \
py3-paramiko py3-boto3 py3-pip py3-setuptools py3-yaml ca-certificates"
# py3-boto

RUN apk --update add --virtual build-dependencies \
        gcc \
        musl-dev \
        libffi-dev \
        openssl-dev \
        python3-dev && \
    set -x && \
    apk update && apk upgrade && \
    apk add --no-cache ${BUILD_PACKAGES} && \
    rm -rf /var/cache/apk/*

ENV ANSIBLE_GATHERING=smart \
    ANSIBLE_HOST_KEY_CHECKING=false \
    ANSIBLE_RETRY_FILES_ENABLED=false \
    ANSIBLE_ROLES_PATH=/ansible/playbooks/roles \
    ANSIBLE_SSH_PIPELINING=True \
    PYTHONPATH=/ansible/lib \
    PATH=/ansible/bin:$PATH \
    ANSIBLE_LIBRARY=/ansible/library \
    EDITOR=nano


RUN mkdir -p /playbooks
WORKDIR /playbooks

ENTRYPOINT ["ansible-playbook"]