docker-build:
	docker build . -f Dockerfile-apache -t sb-drupal-apache

server_up:
	docker compose \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	-f docker-compose.yml \
	up -d

server_down:
	docker compose \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	-f docker-compose.yml \
	down -v
