.PHONY: help up down logs restart clean ps cli monitor info backup restore

help:
	@echo "Redis Standalone - In-Memory Data Store"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start Redis"
	@echo "  make down         - Stop Redis"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart Redis"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Redis commands:"
	@echo "  make cli          - Access Redis CLI"
	@echo "  make monitor      - Monitor Redis commands in real-time"
	@echo "  make info         - Show Redis info"
	@echo "  make ping         - Test Redis connection"
	@echo ""
	@echo "Utility commands:"
	@echo "  make backup       - Backup Redis data"
	@echo "  make restore      - Restore Redis from backup"
	@echo ""
	@echo "Access URLs:"
	@echo "  Redis: localhost:6379"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Redis is starting..."
	@echo ""
	@echo "Connection info:"
	@echo "  Host: localhost"
	@echo "  Port: 6379"
	@echo "  Password: (check .env file)"
	@echo ""
	@echo "Test connection: make ping"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data including Redis database!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

cli:
	@echo "Enter password when prompted (from .env file)"
	@docker compose exec redis redis-cli -a $$(grep REDIS_PASSWORD .env 2>/dev/null | cut -d'=' -f2 || echo "change-me-strong-password")

monitor:
	@echo "Monitoring Redis commands... (Ctrl+C to exit)"
	@docker compose exec redis redis-cli -a $$(grep REDIS_PASSWORD .env 2>/dev/null | cut -d'=' -f2 || echo "change-me-strong-password") MONITOR

info:
	@docker compose exec redis redis-cli -a $$(grep REDIS_PASSWORD .env 2>/dev/null | cut -d'=' -f2 || echo "change-me-strong-password") INFO

ping:
	@docker compose exec redis redis-cli -a $$(grep REDIS_PASSWORD .env 2>/dev/null | cut -d'=' -f2 || echo "change-me-strong-password") PING

backup:
	@echo "Creating backup of Redis data..."
	@mkdir -p ./backups
	@docker compose exec redis redis-cli -a $$(grep REDIS_PASSWORD .env 2>/dev/null | cut -d'=' -f2 || echo "change-me-strong-password") SAVE
	@docker compose exec redis tar czf /tmp/redis-backup-$$(date +%Y%m%d-%H%M%S).tar.gz /data
	@docker compose cp redis:/tmp/redis-backup-*.tar.gz ./backups/
	@echo "✅ Backup created in ./backups/"

restore:
	@echo "Available backups:"
	@ls -1 ./backups/*.tar.gz 2>/dev/null || echo "No backups found"
	@echo ""
	@read -p "Enter backup filename to restore: " backup; \
	if [ -f "./backups/$$backup" ]; then \
		docker compose stop redis; \
		docker compose cp ./backups/$$backup redis:/tmp/restore.tar.gz; \
		docker compose exec redis tar xzf /tmp/restore.tar.gz -C /; \
		docker compose start redis; \
		echo "✅ Backup restored. Redis is restarting..."; \
	else \
		echo "❌ Backup file not found"; \
	fi
