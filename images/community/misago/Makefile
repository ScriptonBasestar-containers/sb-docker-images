


prepare:
	@echo "Preparing Discourse"
	rm -rf discourse
	rm -rf discourse_docker
	git clone https://github.com/rafalp/Misago.git --depth 1
	#git clone https://github.com/rafalp/misago_docker.git --depth 1

setup:
	@echo "No setup required"

#build-clear:
#	docker rmi -f discourse/base discourse/app
#
#build-base:
#	docker build -f image/base/slim.Dockerfile image/base -t discourse/base

build-app:
	docker build Misago -f Misago/Dockerfile -t misago/app
