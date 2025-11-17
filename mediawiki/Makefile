.PHONY: help prepare up down logs restart ps clean shell

# Compose file configuration
COMPOSE_FILES=-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml

help:
	@echo "MediaWiki - Collaborative Wiki Software"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone MediaWiki repository"
	@echo "  make up       - Start MediaWiki"
	@echo "  make down     - Stop MediaWiki"
	@echo "  make restart  - Restart MediaWiki"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access MediaWiki container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access URL:"
	@echo "  MediaWiki: http://localhost:8080"
	@echo ""
	@echo "Dependencies: Redis, MariaDB (from buildbox)"

prepare:
	@if [ ! -d "app" ]; then \
		git clone https://github.com/wikimedia/mediawiki.git --depth 1 app; \
		echo "✅ MediaWiki repository cloned"; \
	else \
		echo "✅ MediaWiki repository already exists"; \
	fi

up:
	docker compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✅ MediaWiki is starting..."
	@echo "   Access at: http://localhost:8080"
	@echo "   Make sure Redis and MariaDB are running (buildbox)"

down:
	docker compose $(COMPOSE_FILES) down

logs:
	docker compose $(COMPOSE_FILES) logs -f

restart:
	docker compose $(COMPOSE_FILES) restart

ps:
	docker compose $(COMPOSE_FILES) ps

clean:
	@echo "⚠️  This will remove all MediaWiki data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose $(COMPOSE_FILES) down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose $(COMPOSE_FILES) run mediawiki bash
