REGISTRY ?= harbor.polypia.in
IMAGE_NAME ?= library/jenkins-controller
JENKINS_VERSION ?= 2.528.3-jdk21
JENKINS_CORE ?= 2.528.3
TAG ?= $(JENKINS_VERSION)

.PHONY: build push all clean test test-stop list-plugins

# Build image
build:
	docker build \
		--build-arg JENKINS_VERSION=$(JENKINS_VERSION) \
		--build-arg JENKINS_CORE=$(JENKINS_CORE) \
		-t $(REGISTRY)/$(IMAGE_NAME):$(TAG) .
	docker tag $(REGISTRY)/$(IMAGE_NAME):$(TAG) $(REGISTRY)/$(IMAGE_NAME):latest

# Push to registry
push:
	docker push $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	docker push $(REGISTRY)/$(IMAGE_NAME):latest

# Build + push
all: build push

# Local test
test:
	docker run -d --name jenkins-test -p 8080:8080 -p 50000:50000 $(REGISTRY)/$(IMAGE_NAME):$(TAG)
	@echo "Jenkins running at http://localhost:8080"
	@echo "Wait 30-60 seconds for startup..."

test-stop:
	docker stop jenkins-test && docker rm jenkins-test

# Cleanup
clean:
	docker rmi $(REGISTRY)/$(IMAGE_NAME):$(TAG) || true
	docker rmi $(REGISTRY)/$(IMAGE_NAME):latest || true

# List installed plugins
list-plugins:
	docker run --rm $(REGISTRY)/$(IMAGE_NAME):$(TAG) ls /usr/share/jenkins/ref/plugins/
