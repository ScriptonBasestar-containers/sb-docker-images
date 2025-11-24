.PHONY: help up down logs restart ps clean shell

help:
	@echo "Wiki.js - Modern Wiki Software"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Wiki.js"
	@echo "  make down     - Stop Wiki.js"
	@echo "  make restart  - Restart Wiki.js"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Wiki.js container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access URL:"
	@echo "  Wiki.js: http://localhost:3000"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Wiki.js is starting..."
	@echo "   Access at: http://localhost:3000"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data including wiki content!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec wiki sh
