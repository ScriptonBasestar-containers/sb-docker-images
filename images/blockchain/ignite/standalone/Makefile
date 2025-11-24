.PHONY: help up down logs restart clean ps shell version

help:
	@echo "Apache Ignite Standalone - In-Memory Computing Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start Ignite"
	@echo "  make down         - Stop Ignite"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart Ignite"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Ignite commands:"
	@echo "  make shell        - Access Ignite container shell"
	@echo "  make version      - Show Ignite version"
	@echo ""
	@echo "Access URLs:"
	@echo "  Thin Client: localhost:10800"
	@echo "  REST API: http://localhost:11211/ignite"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Apache Ignite is starting..."
	@echo "This may take a minute..."
	@echo ""
	@echo "Ports:"
	@echo "  Thin Client: localhost:10800"
	@echo "  REST API: http://localhost:11211/ignite"
	@echo "  Discovery: localhost:47100"
	@echo "  Communication: localhost:47500"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data including cache and persistence!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec ignite /bin/bash

version:
	@echo "Fetching Ignite version..."
	@curl -s http://localhost:11211/ignite?cmd=version | grep -o '"response":"[^"]*"' | cut -d'"' -f4 || echo "Ignite not running or REST API not available"
