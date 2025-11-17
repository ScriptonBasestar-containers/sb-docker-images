up:
	docker compose -f compose.apache.yml up -d

down:
	docker compose -f compose.apache.yml down

logs:
	docker compose -f compose.apache.yml logs -f

restart:
	docker compose -f compose.apache.yml restart

clean:
	docker compose -f compose.apache.yml down -v

logs-nextcloud:
	docker compose -f compose.apache.yml logs -f nextcloud

logs-mariadb:
	docker compose -f compose.apache.yml logs -f mariadb

logs-redis:
	docker compose -f compose.apache.yml logs -f redis

shell:
	docker compose -f compose.apache.yml exec nextcloud bash

occ:
	docker compose -f compose.apache.yml exec -u www-data nextcloud php occ
