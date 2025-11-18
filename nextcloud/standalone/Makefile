.PHONY: help up down restart logs ps shell clean occ logs-nextcloud logs-mariadb logs-redis

COMPOSE_FILE=compose.apache.yml

help: ## Show this help message
	@echo '📝 Available commands:'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ''

up: ## Start all services
	@echo "🚀 Starting Nextcloud standalone..."
	docker compose -f $(COMPOSE_FILE) up -d
	@echo "✅ Services started!"
	@echo ""
	@echo "📍 Access Nextcloud at: http://localhost:8210"

down: ## Stop all services
	@echo "⏹️  Stopping services..."
	docker compose -f $(COMPOSE_FILE) down
	@echo "✅ Stopped"

restart: ## Restart all services
	@echo "🔄 Restarting services..."
	docker compose -f $(COMPOSE_FILE) restart
	@echo "✅ Restarted"

logs: ## View logs from all services
	docker compose -f $(COMPOSE_FILE) logs -f

logs-nextcloud: ## View Nextcloud logs only
	docker compose -f $(COMPOSE_FILE) logs -f nextcloud

logs-mariadb: ## View MariaDB logs only
	docker compose -f $(COMPOSE_FILE) logs -f mariadb

logs-redis: ## View Redis logs only
	docker compose -f $(COMPOSE_FILE) logs -f redis

ps: ## List running containers
	docker compose -f $(COMPOSE_FILE) ps

shell: ## Access Nextcloud container shell
	docker compose -f $(COMPOSE_FILE) exec nextcloud bash

occ: ## Run Nextcloud OCC command
	docker compose -f $(COMPOSE_FILE) exec -u www-data nextcloud php occ

clean: ## Stop and remove all containers, networks, and volumes
	@echo "⚠️  WARNING: This will remove all containers, networks, and volumes!"
	@echo "⚠️  All data will be lost!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose -f $(COMPOSE_FILE) down -v; \
		echo "✅ Cleaned!"; \
	else \
		echo "❌ Cancelled"; \
	fi
