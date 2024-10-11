
server-up:
	docker compose \
	-f compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	up -d

server-down:
	docker compose \
	-f compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	down -v

server-enter:
	docker compose \
	-f compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	run wp-install bash
