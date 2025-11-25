# Supabase Self-hosted Management
# Usage: make [target]

.PHONY: help up down restart logs status clean pull secrets
.DEFAULT_GOAL := help

# Include environment variables
-include .env

# Container prefix
COMPOSE_PROJECT_NAME ?= supabase

##@ Help

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Lifecycle

up: ## Start all services
	docker compose up -d

up-logs: ## Start all services with logs
	docker compose up

down: ## Stop all services
	docker compose down

restart: ## Restart all services
	docker compose restart

pull: ## Pull latest images
	docker compose pull

##@ Status

status: ## Show status of all services
	docker compose ps

logs: ## Show logs of all services
	docker compose logs -f

logs-db: ## Show database logs
	docker compose logs -f db

logs-kong: ## Show Kong API gateway logs
	docker compose logs -f kong

logs-auth: ## Show Auth (GoTrue) logs
	docker compose logs -f auth

logs-studio: ## Show Studio logs
	docker compose logs -f studio

logs-storage: ## Show Storage logs
	docker compose logs -f storage

##@ Database

db-shell: ## Open database shell
	docker compose exec db psql -U postgres

db-backup: ## Backup database
	@mkdir -p backups
	docker compose exec db pg_dump -U postgres -Fc > backups/supabase_$(shell date +%Y%m%d_%H%M%S).dump
	@echo "Backup saved to backups/supabase_$(shell date +%Y%m%d_%H%M%S).dump"

db-restore: ## Restore database from backup (usage: make db-restore BACKUP=filename)
	@if [ -z "$(BACKUP)" ]; then echo "Usage: make db-restore BACKUP=filename"; exit 1; fi
	docker compose exec -T db pg_restore -U postgres -d postgres < $(BACKUP)

##@ Maintenance

clean: ## Remove all containers, volumes, and networks
	docker compose down -v --remove-orphans

reset: clean up ## Clean and restart everything

update: down pull up ## Update all services to latest versions

##@ Secrets

secrets: ## Generate new secrets (JWT secret and API keys)
	@echo "=== Generating new secrets ==="
	@echo ""
	@echo "JWT_SECRET:"
	@openssl rand -base64 32
	@echo ""
	@echo "=== API Keys ==="
	@echo "Visit: https://supabase.com/docs/guides/self-hosting#api-keys"
	@echo "Use the JWT secret above to generate ANON_KEY and SERVICE_ROLE_KEY"

##@ Information

version: ## Show version of installed services
	@echo "Supabase Self-hosted Version: $(shell cat VERSION)"
	@echo ""
	@docker compose images

urls: ## Show service URLs
	@echo "=== Supabase Service URLs ==="
	@echo ""
	@echo "Studio Dashboard:  http://localhost:$(STUDIO_PORT:-3000)"
	@echo "API Gateway:       http://localhost:$(KONG_HTTP_PORT:-8000)"
	@echo "Database:          localhost:$(DB_HOST_PORT:-5432)"
	@echo ""
	@echo "API Endpoints:"
	@echo "  REST API:        http://localhost:$(KONG_HTTP_PORT:-8000)/rest/v1/"
	@echo "  Auth API:        http://localhost:$(KONG_HTTP_PORT:-8000)/auth/v1/"
	@echo "  Storage API:     http://localhost:$(KONG_HTTP_PORT:-8000)/storage/v1/"
	@echo "  Realtime:        ws://localhost:$(KONG_HTTP_PORT:-8000)/realtime/v1/"
	@echo "  Functions:       http://localhost:$(KONG_HTTP_PORT:-8000)/functions/v1/"
