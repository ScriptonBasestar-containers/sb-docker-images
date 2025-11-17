.PHONY: help build up down restart logs ps shell clean

# Compose file configuration
COMPOSE_FILES=-f ./standalone/compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml

help:
	@echo "Drupal - Enterprise Content Management System"
	@echo ""
	@echo "Available commands:"
	@echo "  make build    - Build Drupal Docker image"
	@echo "  make up       - Start Drupal"
	@echo "  make down     - Stop Drupal"
	@echo "  make restart  - Restart Drupal"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Drupal container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Dependencies: MariaDB, Redis (from buildbox)"

build:
	docker build . -f Dockerfile-apache -t sb-drupal-apache
	@echo "✅ Drupal image built"

up:
	docker compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✅ Drupal is starting..."
	@echo "   Make sure MariaDB and Redis are running (buildbox)"

down:
	docker compose $(COMPOSE_FILES) down

restart:
	docker compose $(COMPOSE_FILES) restart

logs:
	docker compose $(COMPOSE_FILES) logs -f

ps:
	docker compose $(COMPOSE_FILES) ps

shell:
	docker compose $(COMPOSE_FILES) exec drupal bash

clean:
	@echo "⚠️  This will remove all Drupal data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose $(COMPOSE_FILES) down -v; \
		echo "✅ All data removed"; \
	fi
