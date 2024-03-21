REPO=scriptonbasestar/sb-docker-xpressengine3
VERSION=3.0.11

alpine:
	docker build . -f alpine-3.11/Dockerfile -t ${REPO}:${VERSION}

debian:
	docker build . -f debian-buster/Dockerfile -t ${REPO}:${VERSION}
	docker build . -f debian-buster/Dockerfile -t test

run:
	docker-compose up

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)