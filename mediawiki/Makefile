
prepare:
	git clone https://github.com/wikimedia/mediawiki.git --depth 1 app

server-up:
	docker compose \
	-f compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	up -d
	@echo "Server is running at http://localhost:8080"

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
	run mediawiki bash

server-log:
	docker compose \
	-f compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	logs -f

clear:
	docker compose \
	-f compose.yml \
	-f ../composebox/compose/compose.base-network.yml \
	-f ../composebox/compose/compose.redis.yml \
	-f ../composebox/compose/compose.mariadb.yml \
	down -v
	docker rm -f $(shell docker ps -qa)
