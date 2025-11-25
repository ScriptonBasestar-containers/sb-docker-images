.PHONY: help up down logs restart ps clean shell rails-console

help:
	@echo "Spree - E-commerce Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make up             - Start Spree"
	@echo "  make down           - Stop Spree"
	@echo "  make restart        - Restart Spree"
	@echo "  make logs           - View logs"
	@echo "  make ps             - Show running containers"
	@echo "  make shell          - Access Spree container shell"
	@echo "  make rails-console  - Access Rails console"
	@echo "  make clean          - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Spree is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Spree data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec spree bash

rails-console:
	docker compose exec spree bin/rails console
