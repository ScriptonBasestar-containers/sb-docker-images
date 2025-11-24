.PHONY: help up down logs restart ps clean backup restore

help:
	@echo "Mattermost Docker Compose Commands"
	@echo ""
	@echo "  make up        - Start all services"
	@echo "  make down      - Stop all services"
	@echo "  make logs      - View logs"
	@echo "  make restart   - Restart all services"
	@echo "  make ps        - Show service status"
	@echo "  make clean     - Remove all containers and volumes"
	@echo "  make backup    - Backup database and files"
	@echo "  make restore   - Restore from backup"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data. Are you sure? [y/N]"
	@read -r response; \
	if [ "$$response" = "y" ] || [ "$$response" = "Y" ]; then \
		docker compose down -v; \
	fi

backup:
	@mkdir -p backups
	@echo "Backing up database..."
	@docker compose exec -T postgres pg_dump -U mattermost mattermost > backups/mattermost-db-$$(date +%Y%m%d-%H%M%S).sql
	@echo "Backing up data..."
	@docker compose exec -T mattermost tar czf - /mattermost/data > backups/mattermost-data-$$(date +%Y%m%d-%H%M%S).tar.gz
	@echo "Backing up config..."
	@docker compose exec -T mattermost tar czf - /mattermost/config > backups/mattermost-config-$$(date +%Y%m%d-%H%M%S).tar.gz
	@echo "✅ Backup completed in backups/"

restore:
	@echo "Available backups:"
	@ls -1 backups/mattermost-db-*.sql 2>/dev/null || echo "No database backups found"
	@echo ""
	@echo "Enter database backup filename:"
	@read db_file; \
	if [ -f "backups/$$db_file" ]; then \
		docker compose exec -T postgres psql -U mattermost mattermost < "backups/$$db_file"; \
		echo "✅ Database restored"; \
	else \
		echo "❌ File not found"; \
	fi
