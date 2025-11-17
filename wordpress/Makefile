.PHONY: help prepare up down logs restart ps clean shell

# Compose file configuration
COMPOSE_FILES=-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.kratos.yml \
	-f ../buildbox/compose/compose.kratos-pg.yml \
	-f ../buildbox/compose/compose.kratos-standalone.yml \
	-f ../buildbox/compose/compose.bn-pg15.yml \
	-f ../buildbox/compose/compose.bn-redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml

help:
	@echo "WordPress - Popular Content Management System"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Check setup (no action required)"
	@echo "  make up       - Start WordPress and all dependencies"
	@echo "  make down     - Stop WordPress"
	@echo "  make restart  - Restart WordPress"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access WordPress container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Dependencies: PostgreSQL, Redis, MariaDB, Kratos (from buildbox)"

prepare:
	@echo "No setup required"

up:
	docker compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✅ WordPress is starting..."
	@echo "   Make sure PostgreSQL, Redis, MariaDB, and Kratos are running (buildbox)"

down:
	docker compose $(COMPOSE_FILES) down

logs:
	docker compose $(COMPOSE_FILES) logs -f

restart:
	docker compose $(COMPOSE_FILES) restart

ps:
	docker compose $(COMPOSE_FILES) ps

clean:
	@echo "⚠️  This will remove all WordPress data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose $(COMPOSE_FILES) down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose $(COMPOSE_FILES) run wp-install bash
