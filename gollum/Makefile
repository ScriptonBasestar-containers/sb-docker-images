DOCKER_REGISTRY=ghcr.io/scriptonbasestar

setup:
	mkdir -p wiki/gollum
	git init wiki/gollum
	chown -R 1000:1000 wiki/gollum

gollum-build:
	docker build . \
	-t gollum \
	-f dockerfiles/gollum-ruby-bookworm.dockerfile

gollum-tag:
	docker tag gollum:latest $(DOCKER_REGISTRY)/gollum:latest

gollum-push:
	docker tag gollum:latest $(DOCKER_REGISTRY)/gollum:latest
	docker push $(DOCKER_REGISTRY)/gollum:latest
