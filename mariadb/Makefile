.PHONY: up down logs restart clean shell

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

shell:
	docker compose exec mariadb bash

mysql:
	docker compose exec mariadb mysql -u root -p
