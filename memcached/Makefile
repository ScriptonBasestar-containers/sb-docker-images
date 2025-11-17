.PHONY: help up down logs restart ps clean shell test

help:
	@echo "Memcached - Distributed Memory Caching System"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Memcached"
	@echo "  make down     - Stop Memcached"
	@echo "  make restart  - Restart Memcached"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Memcached container shell"
	@echo "  make test     - Test Memcached connection"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Connection info:"
	@echo "  Host: localhost"
	@echo "  Port: 11211"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Memcached is starting..."
	@echo "   Port: 11211"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Memcached data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec memcached sh

test:
	@echo "Testing Memcached connection..."
	@docker compose up -d
	@sleep 3
	@docker compose exec memcached sh -c "echo 'stats' | nc localhost 11211" && echo "✅ Memcached is working!" || echo "❌ Failed to connect to memcached"
	@docker compose down
