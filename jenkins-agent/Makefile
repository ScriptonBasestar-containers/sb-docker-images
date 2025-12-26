REGISTRY ?= harbor.polypia.in
IMAGE_NAME ?= library/jenkins-agent
JENKINS_VERSION ?= 2.528.3-jdk21
JENKINS_AGENT_TAG ?= latest-jdk21
TAG ?= $(JENKINS_VERSION)

.PHONY: build push all clean

build:
	docker build \
		--build-arg JENKINS_AGENT_TAG=$(JENKINS_AGENT_TAG) \
		-t $(REGISTRY)/$(IMAGE_NAME):$(TAG) .
	docker tag $(REGISTRY)/$(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):latest

push:
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):latest

all: build push

clean:
	docker rmi $(REGISTRY)/$(IMAGE_NAME):$(TAG) || true
	docker rmi $(REGISTRY)/$(IMAGE_NAME):latest || true
