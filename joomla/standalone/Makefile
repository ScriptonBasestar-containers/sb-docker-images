.PHONY: help up down restart logs ps shell clean logs-joomla logs-mariadb logs-redis

help: ## Show this help message
	@echo '📝 Available commands:'
	@echo ''
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ''

up: ## Start all services
	@echo "🚀 Starting Joomla standalone..."
	docker compose up -d
	@echo "✅ Services started!"
	@echo ""
	@echo "📍 Access Joomla at: http://localhost:8110"

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

logs-joomla: ## View Joomla logs only
	docker compose logs -f joomla

logs-mariadb: ## View MariaDB logs only
	docker compose logs -f mariadb

logs-redis: ## View Redis logs only
	docker compose logs -f redis

ps: ## List running containers
	docker compose ps

shell: ## Access Joomla container shell
	docker compose exec joomla bash

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
