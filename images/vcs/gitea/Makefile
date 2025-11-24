.PHONY: help up down logs ps clean restart test

help:
	@echo "Gitea Makefile Commands:"
	@echo "  make up       - Start Gitea and PostgreSQL"
	@echo "  make down     - Stop and remove containers"
	@echo "  make logs     - Show container logs"
	@echo "  make ps       - Show running containers"
	@echo "  make clean    - Remove all data (WARNING: destructive)"
	@echo "  make restart  - Restart all services"
	@echo "  make test     - Validate compose file"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

ps:
	docker compose ps

clean:
	@echo "WARNING: This will delete all Gitea data!"
	@read -p "Are you sure? [y/N] " confirm && [ "$$confirm" = "y" ] || exit 1
	docker compose down -v
	rm -rf data postgres

restart:
	docker compose restart

test:
	docker compose config
