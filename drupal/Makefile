docker-build:
	docker build . -f Dockerfile-apache -t sb-drupal-apache

docker_up:
	docker compose \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	up -d

docker_enter:
	docker compose \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	exec drupal bash

docker_down:
	docker compose \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	down -v
