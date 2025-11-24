.PHONY: help up down logs restart clean ps shell stats cache-info test reconfigure

help:
	@echo "Squid Standalone - Caching Proxy Server"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start Squid proxy"
	@echo "  make down         - Stop Squid proxy"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart Squid"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Squid commands:"
	@echo "  make shell        - Access Squid container shell"
	@echo "  make stats        - Show proxy statistics"
	@echo "  make cache-info   - Show cache information"
	@echo "  make test         - Test proxy connection"
	@echo "  make reconfigure  - Reload configuration"
	@echo ""
	@echo "Access URLs:"
	@echo "  HTTP Proxy: localhost:3128"
	@echo "  Usage: export http_proxy=http://localhost:3128"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Squid Proxy is starting..."
	@echo ""
	@echo "Proxy URL:"
	@echo "  HTTP: http://localhost:3128"
	@echo ""
	@echo "Test connection:"
	@echo "  curl -x http://localhost:3128 http://example.com"

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

shell:
	docker compose exec squid /bin/bash

stats:
	@echo "Fetching Squid statistics..."
	@docker compose exec squid squidclient -h localhost mgr:info || echo "Squid not running"

cache-info:
	@echo "Fetching cache information..."
	@docker compose exec squid squidclient -h localhost mgr:storedir || echo "Squid not running"

test:
	@echo "Testing proxy connection..."
	@curl -x http://localhost:3128 -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://example.com || echo "Proxy connection failed"

reconfigure:
	@echo "Reloading Squid configuration..."
	@docker compose exec squid squid -k reconfigure
