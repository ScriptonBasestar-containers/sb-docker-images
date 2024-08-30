
setup:
	@echo "No setup required"
	git clone https://github.com/nextcloud/all-in-one.git
	git clone https://github.com/nextcloud/docker.git
	git clone https://github.com/nextcloud/server.git --depth 1

build-base:
	docker build -f image/base/slim.Dockerfile image/base -t discourse/base

build-app:
	@docker build -t snextcloud-app .
