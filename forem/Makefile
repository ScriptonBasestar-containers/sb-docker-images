.PHONY: help build build-dev build-prod up down logs shell db-setup db-migrate db-seed clean

help:
	@echo "Forem Docker Commands"
	@echo "====================="
	@echo "build        - Build development image"
	@echo "build-dev    - Build development image"
	@echo "build-prod   - Build production image"
	@echo "up           - Start all services"
	@echo "down         - Stop all services"
	@echo "logs         - Show logs"
	@echo "shell        - Enter web container shell"
	@echo "db-setup     - Create and migrate database"
	@echo "db-migrate   - Run database migrations"
	@echo "db-seed      - Seed database with sample data"
	@echo "clean        - Remove all containers, volumes, and images"

build: build-dev

build-dev:
	docker compose build --target development

build-prod:
	docker compose build --target production

up:
	docker compose up -d

down:
	docker compose down

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
	docker rmi -f forem:latest forem:development 2>/dev/null || true
