.PHONY: help up down logs restart ps clean shell

help:
	@echo "Chef Development Environment"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Chef development environment"
	@echo "  make down     - Stop Chef development environment"
	@echo "  make restart  - Restart Chef development environment"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Chef container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Chef development environment is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Chef development data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec chef bash
