.PHONY: help prepare up down logs shell db-setup db-migrate db-seed clean restart

help:
	@echo "Forem Docker Compose Commands"
	@echo "=============================="
	@echo "prepare      - Clone Forem repository (if not exists)"
	@echo "up           - Start all services"
	@echo "down         - Stop all services"
	@echo "restart      - Restart all services"
	@echo "logs         - Show logs"
	@echo "shell        - Enter web container shell"
	@echo "db-setup     - Create and migrate database"
	@echo "db-migrate   - Run database migrations"
	@echo "db-seed      - Seed database with sample data"
	@echo "clean        - Remove all containers and volumes"

prepare:
	@if [ ! -d "forem-src" ]; then \
		echo "Cloning Forem repository..."; \
		git clone https://github.com/forem/forem.git forem-src --depth 1; \
		echo "Forem repository cloned to forem-src/"; \
	else \
		echo "Forem repository already exists in forem-src/"; \
	fi

up:
	docker compose up -d

down:
	docker compose down

restart: down up

logs:
	docker compose logs -f

shell:
	docker compose exec web /bin/bash

db-setup:
	docker compose exec web bundle exec rails db:create db:migrate

db-migrate:
	docker compose exec web bundle exec rails db:migrate

db-seed:
	docker compose exec web bundle exec rails db:seed

clean:
	docker compose down -v
