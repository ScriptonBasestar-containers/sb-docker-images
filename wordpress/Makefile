
server_up:
	docker compose \
	-f docker-compose.yml \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	up -d

server_down:
	docker compose \
	-f docker-compose.yml \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	down -v

server_enter_cli:
	docker compose \
	-f docker-compose.yml \
	-f ../common/compose/compose.base-network.yml \
	-f ../common/compose/compose.redis.yml \
	-f ../common/compose/compose.mariadb.yml \
	run wp-install bash
