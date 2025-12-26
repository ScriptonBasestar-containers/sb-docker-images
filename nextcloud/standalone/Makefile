COMPOSE_DATA=-f ../../devbox/compose.bn-pg15.yml -f ../../devbox/compose.bn-redis.yml -f ../../devbox/compose.mariadb.yml

server-up:
	docker compose -f compose.apache.yml \
	${COMPOSE_DATA} \
	up -d

#server_env:
#	docker compose -f compose.yml \
#	${COMPOSE_KRATOS} ${COMPOSE_DATA} \
#	exec postgres env

server_migrate:
	docker compose -f compose.apache.yml \
	${COMPOSE_DATA} \
	run discourse /var/www/discourse/bin/rake db:migrate

server-down:
	docker compose -f compose.apache.yml \
	${COMPOSE_DATA} \
	down -v

server-enter:
	docker compose -f compose.apache.yml \
	${COMPOSE_DATA} \
	run wp-install bash
