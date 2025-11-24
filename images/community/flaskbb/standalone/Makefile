.PHONY: help up down logs restart clean ps shell db-shell redis-shell

help:
	@echo "FlaskBB Standalone - Flask Forum Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start all services"
	@echo "  make down         - Stop all services"
	@echo "  make logs         - View logs (all services)"
	@echo "  make logs-app     - View FlaskBB logs only"
	@echo "  make restart      - Restart all services"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access services:"
	@echo "  make shell        - Access FlaskBB container shell"
	@echo "  make db-shell     - Access PostgreSQL shell"
	@echo "  make redis-shell  - Access Redis CLI"
	@echo ""
	@echo "Database management:"
	@echo "  make db-upgrade   - Run database migrations"
	@echo "  make db-init      - Initialize database"
	@echo "  make create-admin - Create admin user"
	@echo ""
	@echo "Access URLs:"
	@echo "  FlaskBB: http://localhost:8250"

up:
	docker compose up -d
	@echo ""
	@echo "✅ FlaskBB is starting..."
	@echo "Wait a few seconds for initialization, then visit:"
	@echo "  http://localhost:8250"

down:
	docker compose down

logs:
	docker compose logs -f

logs-app:
	docker compose logs -f flaskbb

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data including database and uploads!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec flaskbb /bin/sh

db-shell:
	docker compose exec postgres psql -U user01 -d db01

redis-shell:
	docker compose exec redis redis-cli

# Database management
db-upgrade:
	docker compose exec flaskbb flask db upgrade

db-init:
	docker compose exec flaskbb flask flaskbb install

create-admin:
	@echo "Creating admin user..."
	docker compose exec flaskbb flask flaskbb create-admin
