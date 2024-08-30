REPO=scriptonbasestar/sb-flarum
VERSION=3.0.11
FILES_APACHE=-f compose.yml -f compose.apache.yml
FILES_NGINX=-f compose.yml -f compose.nginx.yml
DOCKER_BASE_IMAGE=local_dev/flarum-base

setup:
	# git clone https://github.com/flarum/flarum --depth 1 app
	# docker run --rm -it -v ./app:/app composer composer install

teardown:
	rm -rf app
	docker compose down -v

build-base:
	docker build -f flarum-composer.dockerfile -t ${DOCKER_BASE_IMAGE} --no-cache .

build-apache:
	docker compose ${FILES_APACHE} build --no-cache

build-nginx:
	docker compose ${FILES_NGINX} build --no-cache

run-apache:
	docker compose ${FILES_APACHE} up

run-nginx:
	docker compose ${FILES_NGINX} up

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)
