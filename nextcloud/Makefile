.PHONY: help prepare build-base build-app up down logs restart ps clean shell

# Compose file configuration
COMPOSE_FILES=-f compose.yml \
	-f ../buildbox/compose/compose.kratos.yml \
	-f ../buildbox/compose/compose.kratos-pg.yml \
	-f ../buildbox/compose/compose.kratos-standalone.yml \
	-f ../buildbox/compose/compose.bn-pg15.yml \
	-f ../buildbox/compose/compose.bn-redis.yml \
	-f ../buildbox/compose/compose.mariadb.yml

help:
	@echo "Nextcloud - Self-hosted Cloud Storage and Collaboration Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare    - Clone Nextcloud repositories"
	@echo "  make build-base - Build base Docker image"
	@echo "  make build-app  - Build application Docker image"
	@echo "  make up         - Start Nextcloud"
	@echo "  make down       - Stop Nextcloud"
	@echo "  make restart    - Restart Nextcloud"
	@echo "  make logs       - View logs"
	@echo "  make ps         - Show running containers"
	@echo "  make shell      - Access Nextcloud container shell"
	@echo "  make clean      - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Dependencies: PostgreSQL, Redis, MariaDB, Kratos (from buildbox)"

prepare:
	@echo "Cloning Nextcloud repositories..."
	@if [ ! -d "all-in-one" ]; then \
		git clone https://github.com/nextcloud/all-in-one.git; \
		echo "✅ Nextcloud all-in-one cloned"; \
	fi
	@if [ ! -d "docker" ]; then \
		git clone https://github.com/nextcloud/docker.git; \
		echo "✅ Nextcloud docker cloned"; \
	fi
	@if [ ! -d "server" ]; then \
		git clone https://github.com/nextcloud/server.git --depth 1; \
		echo "✅ Nextcloud server cloned"; \
	fi

build-base:
	docker build -f image/base/slim.Dockerfile image/base -t discourse/base

build-app:
	docker build -t nextcloud-app .

up:
	docker compose $(COMPOSE_FILES) up -d
	@echo ""
	@echo "✅ Nextcloud is starting..."
	@echo "   Make sure PostgreSQL, Redis, MariaDB, and Kratos are running (buildbox)"

down:
	docker compose $(COMPOSE_FILES) down

logs:
	docker compose $(COMPOSE_FILES) logs -f

restart:
	docker compose $(COMPOSE_FILES) restart

ps:
	docker compose $(COMPOSE_FILES) ps

clean:
	@echo "⚠️  This will remove all Nextcloud data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose $(COMPOSE_FILES) down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose $(COMPOSE_FILES) run wp-install bash

