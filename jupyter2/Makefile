.PHONY: help up down logs restart ps clean shell token

help:
	@echo "Jupyter 2 - Interactive Computing Environment"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Jupyter"
	@echo "  make down     - Stop Jupyter"
	@echo "  make restart  - Restart Jupyter"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Jupyter container shell"
	@echo "  make token    - Display Jupyter access token"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Jupyter is starting..."
	@echo "   Run 'make token' to get access token"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Jupyter notebooks and data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec jupyter bash

token:
	@echo "Jupyter access tokens:"
	@docker compose exec jupyter jupyter server list
