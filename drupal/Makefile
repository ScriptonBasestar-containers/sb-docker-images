docker-build:
	docker build . -f Dockerfile-apache -t sb-drupal-apache

docker_up:
	docker compose \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	up -d

docker_down:
	docker compose \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	-f ./standalone/compose.yml \
	down -v
