
server-up:
	docker compose \
	-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml \
	up -d

server-down:
	docker compose \
	-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml \
	down -v

server-enter:
	docker compose \
	-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml \
	run wp-install bash
