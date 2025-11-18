.PHONY: help up down restart logs ps shell clean drush logs-drupal logs-mariadb logs-redis

help: ## Show this help message
	@echo '📝 Available commands:'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ''

up: ## Start all services
	@echo "🚀 Starting Drupal standalone..."
	docker compose up -d
	@echo "✅ Services started!"
	@echo ""
	@echo "📍 Access Drupal at: http://localhost:8120"
	@echo "   Database: mariadb"
	@echo "   User: user01"
	@echo "   Password: passw0rd (change in .env)"

down: ## Stop all services
	@echo "⏹️  Stopping services..."
	docker compose down
	@echo "✅ Stopped"

restart: ## Restart all services
	@echo "🔄 Restarting services..."
	docker compose restart
	@echo "✅ Restarted"

logs: ## View logs from all services
	docker compose logs -f

logs-drupal: ## View Drupal logs only
	docker compose logs -f drupal

logs-mariadb: ## View MariaDB logs only
	docker compose logs -f mariadb

logs-redis: ## View Redis logs only
	docker compose logs -f redis

ps: ## List running containers
	docker compose ps

shell: ## Access Drupal container shell
	docker compose exec drupal bash

drush: ## Run Drush CLI
	docker compose exec drupal drush

clean: ## Stop and remove all containers, networks, and volumes
	@echo "⚠️  WARNING: This will remove all containers, networks, and volumes!"
	@echo "⚠️  All data will be lost!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ Cleaned!"; \
	else \
		echo "❌ Cancelled"; \
	fi
