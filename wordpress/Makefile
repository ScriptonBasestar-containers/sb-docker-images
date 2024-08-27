REPO=scriptonbasestar/sb-docker-xpressengine3
VERSION=3.0.11

setup:
	git clone https://github.com/xpressengine/xpressengine.git --depth 1 app

build-composer:
	docker build . -f xe-composer.dockerfile -t ${REPO}:${VERSION}

debian:
	docker build . -f debian-buster/Dockerfile -t ${REPO}:${VERSION}
	docker build . -f debian-buster/Dockerfile -t test

run:
	docker-compose up

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)