DOCKER_REGISTRY=ghcr.io/scriptonbasestar

jenkins-build:
	docker build . \
	-t jenkins \
	-f dockerfiles/jenkins-lts-jdk21-plugin.dockerfile

jenkins-tag:
	docker tag jenkins:latest $(DOCKER_REGISTRY)/jenkins:latest

jenkins-push:
	docker tag jenkins:latest $(DOCKER_REGISTRY)/jenkins:latest
	docker push $(DOCKER_REGISTRY)/jenkins:latest
