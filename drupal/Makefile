docker-build:
	docker build . -f Dockerfile-apache -t sb-drupal-apache

docker_up:
	docker compose \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	up -d

docker_enter:
	docker compose \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	exec drupal bash

docker_down:
	docker compose \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	down -v
