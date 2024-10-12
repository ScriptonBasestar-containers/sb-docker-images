COMPOSE_BASE=-f ../buildbox/compose/compose.base-network.yml

COMPOSE_KRATOS=-f ../buildbox/compose/compose.kratos.yml \
	-f ../buildbox/compose/compose.kratos-pg.yml \
	-f ../buildbox/compose/compose.kratos-standalone.yml

COMPOSE_DATA=-f ../buildbox/compose/compose.bn-pg15.yml -f ../buildbox/compose/compose.bn-redis.yml -f ../buildbox/compose/compose.mariadb.yml

prepare:
	@echo "No setup required"
	#git clone https://github.com/nextcloud/server.git --depth 1

server-up:
	@docker compose -f compose.yml \
	${COMPOSE_BASE} \
	${COMPOSE_KRATOS} \
	${COMPOSE_DATA} \
	up -d

server-down:
	@docker compose -f compose.yml \
	${COMPOSE_BASE} \
	${COMPOSE_KRATOS} \
	${COMPOSE_DATA} \
	down -v

server-enter:
	@docker compose -f compose.yml \
	${COMPOSE_BASE} \
	${COMPOSE_KRATOS} \
	${COMPOSE_DATA} \
	run wp-install bash
