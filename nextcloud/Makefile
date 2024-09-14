COMPOSE_KRATOS=-f ../common/compose/compose.kratos.yml \
	-f ../common/compose/compose.kratos-pg.yml \
	-f ../common/compose/compose.kratos-standalone.yml

COMPOSE_DATA=-f ../common/compose/compose.bn-pg15.yml -f ../common/compose/compose.bn-redis.yml -f ../common/compose/compose.mariadb.yml

init:
	@echo "No setup required"
	git clone https://github.com/nextcloud/all-in-one.git
	git clone https://github.com/nextcloud/docker.git
	git clone https://github.com/nextcloud/server.git --depth 1

build-base:
	docker build -f image/base/slim.Dockerfile image/base -t discourse/base

build-app:
	@docker build -t nextcloud-app .


server_up:
	docker compose -f compose.yml \
	${COMPOSE_KRATOS} \
	${COMPOSE_DATA} \
	up -d

#server_env:
#	docker compose -f compose.yml \
#	${COMPOSE_KRATOS} ${COMPOSE_DATA} \
#	exec postgres env

server_migrate:
	docker compose -f compose.yml \
	${COMPOSE_KRATOS} ${COMPOSE_DATA} \
	run discourse /var/www/discourse/bin/rake db:migrate

server_down:
	docker compose -f compose.yml \
	${COMPOSE_KRATOS} ${COMPOSE_DATA} \
	down -v

server_enter_cli:
	docker compose -f compose.yml \
	${COMPOSE_KRATOS} ${COMPOSE_DATA} \
	run wp-install bash

