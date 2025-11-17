.PHONY: help up down logs restart ps clean test shell

help:
	@echo "DokuWiki - File-based Wiki System"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start DokuWiki"
	@echo "  make down     - Stop DokuWiki"
	@echo "  make restart  - Restart DokuWiki"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access DokuWiki container shell"
	@echo "  make test     - Test DokuWiki connection"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access URL:"
	@echo "  DokuWiki: http://localhost:8080"
	@echo ""
	@echo "Note: For standalone version with backup/restore, see standalone/Makefile"

up:
	docker compose up -d
	@echo ""
	@echo "✅ DokuWiki is starting..."
	@echo "   Access at: http://localhost:8080"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all wiki data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

test:
	docker compose up -d
	@echo "Waiting for DokuWiki to be ready..."
	@sleep 5
	@curl -f http://localhost:8080 > /dev/null 2>&1 && echo "✅ DokuWiki is running!" || echo "❌ Failed to connect to DokuWiki"
	@docker compose down

shell:
	docker compose exec dokuwiki sh
