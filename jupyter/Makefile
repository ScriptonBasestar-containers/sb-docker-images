.PHONY: up down logs restart clean shell token

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
	docker compose exec jupyter bash

token:
	docker compose exec jupyter jupyter server list
