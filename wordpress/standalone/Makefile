up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

clean:
	docker compose down -v

logs-wordpress:
	docker compose logs -f wordpress

logs-mariadb:
	docker compose logs -f mariadb

logs-redis:
	docker compose logs -f redis

shell:
	docker compose exec wordpress bash

wp-cli:
	docker compose exec wordpress wp
