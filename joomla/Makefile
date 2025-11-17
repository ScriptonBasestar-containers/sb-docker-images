.PHONY: help up down logs restart ps clean shell

# Compose file configuration
COMPOSE_FILES=-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml

help:
	@echo "Joomla - Content Management System"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Joomla"
	@echo "  make down     - Stop Joomla"
	@echo "  make restart  - Restart Joomla"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Joomla container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Dependencies: Redis, MariaDB (from buildbox)"

up:
	docker compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✅ Joomla is starting..."
	@echo "   Make sure Redis and MariaDB are running (buildbox)"

down:
	docker compose $(COMPOSE_FILES) down

logs:
	docker compose $(COMPOSE_FILES) logs -f

restart:
	docker compose $(COMPOSE_FILES) restart

ps:
	docker compose $(COMPOSE_FILES) ps

clean:
	@echo "⚠️  This will remove all Joomla data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose $(COMPOSE_FILES) down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose $(COMPOSE_FILES) run wp-install bash
