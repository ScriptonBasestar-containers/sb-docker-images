.PHONY: help up down logs restart clean ps shell backup restore

help:
	@echo "DokuWiki Standalone - File-based Wiki System"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start DokuWiki"
	@echo "  make down         - Stop DokuWiki"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart DokuWiki"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access commands:"
	@echo "  make shell        - Access DokuWiki container shell"
	@echo ""
	@echo "Utility commands:"
	@echo "  make backup       - Backup DokuWiki data"
	@echo "  make restore      - Restore DokuWiki from backup"
	@echo ""
	@echo "Access URLs:"
	@echo "  DokuWiki: http://localhost:8080"

up:
	docker compose up -d
	@echo ""
	@echo "✅ DokuWiki is starting..."
	@echo ""
	@echo "Login credentials:"
	@echo "  URL: http://localhost:8080"
	@echo "  Username: admin (or check .env file)"
	@echo "  Password: (check .env file)"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data including wiki pages and uploads!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec dokuwiki /bin/sh

backup:
	@echo "Creating backup of DokuWiki data..."
	@mkdir -p ./backups
	@docker compose exec dokuwiki tar czf /tmp/dokuwiki-backup-$$(date +%Y%m%d-%H%M%S).tar.gz /dokuwiki/storage
	@docker compose cp dokuwiki:/tmp/dokuwiki-backup-*.tar.gz ./backups/
	@echo "✅ Backup created in ./backups/"

restore:
	@echo "Available backups:"
	@ls -1 ./backups/*.tar.gz 2>/dev/null || echo "No backups found"
	@echo ""
	@read -p "Enter backup filename to restore: " backup; \
	if [ -f "./backups/$$backup" ]; then \
		docker compose cp ./backups/$$backup dokuwiki:/tmp/restore.tar.gz; \
		docker compose exec dokuwiki tar xzf /tmp/restore.tar.gz -C /; \
		docker compose restart dokuwiki; \
		echo "✅ Backup restored. DokuWiki is restarting..."; \
	else \
		echo "❌ Backup file not found"; \
	fi
