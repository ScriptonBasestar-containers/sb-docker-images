.PHONY: help prepare setup build-clear build-base build-app up down restart logs ps shell clean

# Compose file configuration
COMPOSE_FILES=-f compose.yml \
	-f ../buildbox/compose/compose.base-network.yml \
	-f ../buildbox/compose/compose.redis.yml \
	-f ../buildbox/compose/compose.postgres.yml

help:
	@echo "Discourse - Modern Forum and Community Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare      - Clone Discourse repositories"
	@echo "  make build-base   - Build base Docker image"
	@echo "  make build-app    - Build application Docker image"
	@echo "  make build-clear  - Remove built images"
	@echo "  make up           - Start Discourse"
	@echo "  make down         - Stop Discourse"
	@echo "  make restart      - Restart Discourse"
	@echo "  make logs         - View logs"
	@echo "  make ps           - Show running containers"
	@echo "  make shell        - Access Discourse container shell"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Dependencies: PostgreSQL, Redis (from buildbox)"

prepare:
	@echo "Preparing Discourse..."
	@if [ ! -d "discourse" ]; then \
		git clone https://github.com/discourse/discourse.git --depth 1; \
		echo "✅ Discourse repository cloned"; \
	else \
		echo "✅ Discourse repository already exists"; \
	fi
	@if [ ! -d "discourse_docker" ]; then \
		git clone https://github.com/discourse/discourse_docker.git --depth 1; \
		echo "✅ Discourse Docker repository cloned"; \
	else \
		echo "✅ Discourse Docker repository already exists"; \
	fi

setup:
	@echo "No additional setup required"

build-clear:
	docker rmi -f discourse/base discourse/app

build-base:
	docker build -f image/base/slim.Dockerfile image/base -t discourse/base

build-app:
	docker build . -f image/discourse_app/Dockerfile -t discourse/app

up:
	docker compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✅ Discourse is starting..."
	@echo "   Make sure PostgreSQL and Redis are running (buildbox)"

down:
	docker compose $(COMPOSE_FILES) down

restart:
	docker compose $(COMPOSE_FILES) restart

logs:
	docker compose $(COMPOSE_FILES) logs -f

ps:
	docker compose $(COMPOSE_FILES) ps

shell:
	docker compose $(COMPOSE_FILES) exec discourse bash

clean:
	@echo "⚠️  This will remove all Discourse data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose $(COMPOSE_FILES) down -v; \
		echo "✅ All data removed"; \
	fi
