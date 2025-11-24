.PHONY: help up down logs restart ps clean shell db-init db-upgrade

help:
	@echo "FlaskBB - Discussion Forum Software"
	@echo ""
	@echo "Available commands:"
	@echo "  make up          - Start FlaskBB"
	@echo "  make down        - Stop FlaskBB"
	@echo "  make restart     - Restart FlaskBB"
	@echo "  make logs        - View logs"
	@echo "  make ps          - Show running containers"
	@echo "  make shell       - Access FlaskBB container shell"
	@echo "  make db-init     - Initialize database"
	@echo "  make db-upgrade  - Run database migrations"
	@echo "  make clean       - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ FlaskBB is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all FlaskBB data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec flaskbb bash

db-init:
	docker compose exec flaskbb flaskbb install

db-upgrade:
	docker compose exec flaskbb flaskbb db upgrade
