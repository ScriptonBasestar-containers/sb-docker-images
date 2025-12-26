CONTAINER_NAME=gnuboard6

setup:
	@echo "Setting up"
	git clone https://github.com/gnuboard/g6.git --depth 1 app
	git clone https://github.com/gnuboard/docker.git --depth 1

build_debian:
	@echo "Building Debian"
	docker build -f gnuboard6-debian.dockerfile -t gnuboard6 .

run_debian:
	@echo "Running Debian"
	docker run -d --name ${CONTAINER_NAME} -p 8000:8000 gnuboard6
