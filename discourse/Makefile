


prepare:
	@echo "Preparing Discourse"
	rm -rf discourse
	rm -rf discourse_docker
	git clone https://github.com/discourse/discourse.git --depth 1
	git clone https://github.com/discourse/discourse_docker.git --depth 1
	
setup:
	@echo "No setup required"

build-base:
	docker build -f image/base/slim.Dockerfile image/base -t discourse/base

build-app:
	docker build . -t discourse-app
