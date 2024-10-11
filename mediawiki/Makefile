
server_up:
	docker compose \
	-f docker-compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	up -d

server_down:
	docker compose \
	-f docker-compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	down -v


server_enter_cli:
	docker compose \
	-f docker-compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	run wp-install bash
