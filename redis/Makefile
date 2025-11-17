.PHONY: help up down logs restart ps clean test cli

help:
	@echo "Redis - In-Memory Data Store"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Redis"
	@echo "  make down     - Stop Redis"
	@echo "  make restart  - Restart Redis"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make cli      - Connect to Redis CLI"
	@echo "  make test     - Test Redis connection"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Connection info:"
	@echo "  Host: localhost"
	@echo "  Port: 6379"
	@echo "  Password: (check .env file)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Redis is starting..."
	@echo "   Port: 6379"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all cached data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

test:
	docker compose up -d
	@echo "Waiting for Redis to be ready..."
	@sleep 3
	@docker compose exec redis redis-cli -a passw0rd ping || echo "Failed to connect to Redis"
	@docker compose down

cli:
	docker compose exec redis redis-cli -a passw0rd
