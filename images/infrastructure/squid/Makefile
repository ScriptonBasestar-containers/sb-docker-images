ROOT_DIR=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DOCKER_REPO=scriptonbasestar/sb-docker-squid
DOCKER_VERSION=latest
APP_VERSION=4.10

build:
	docker build . -t ${DOCKER_REPO}:${DOCKER_VERSION}
	docker push ${DOCKER_REPO}:${DOCKER_VERSION}

run:
	docker run --rm -p 3128:3128 squid
run-cache:
	docker run --rm -v $(ROOT_DIR)/files/sample.conf:/etc/squid/conf.d/sample.conf -p 3128:3128 squid
