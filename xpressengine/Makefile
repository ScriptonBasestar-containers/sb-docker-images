REPO=scriptonbasestar/sb-docker-xpressengine3
VERSION=3.0.11

prepare:
	git clone https://github.com/xpressengine/xpressengine.git --depth 1 app

docker-build:
	docker build . -f xe-composer.dockerfile -t ${REPO}:${VERSION}

docker-build-debian:
	docker build . -f debian-buster/Dockerfile -t ${REPO}:${VERSION}
	docker build . -f debian-buster/Dockerfile -t test

docker-up:
	docker-compose up

docker-clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)