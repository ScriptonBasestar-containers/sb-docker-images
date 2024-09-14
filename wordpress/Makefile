COMPOSE_BASE=-f ../common/compose/compose.base-network.yml

COMPOSE_KRATOS=-f ../common/compose/compose.kratos.yml \
	-f ../common/compose/compose.kratos-pg.yml \
	-f ../common/compose/compose.kratos-standalone.yml

COMPOSE_DATA=-f ../common/compose/compose.bn-pg15.yml -f ../common/compose/compose.bn-redis.yml -f ../common/compose/compose.mariadb.yml

init:
	@echo "No setup required"
	#git clone https://github.com/nextcloud/server.git --depth 1

server_up:
	@docker compose -f compose.yml \
	${COMPOSE_BASE} \
	${COMPOSE_DATA} \
	up -d

server_down:
	@docker compose -f compose.yml \
	${COMPOSE_BASE} \
	${COMPOSE_DATA} \
	down -v

server_enter_cli:
	@docker compose -f compose.yml \
	${COMPOSE_BASE} \
	${COMPOSE_KRATOS} \
	${COMPOSE_DATA} \
	run wp-install bash
