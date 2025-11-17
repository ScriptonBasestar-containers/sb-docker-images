.PHONY: help prepare build build-debian up down logs restart ps clean shell

REPO=scriptonbasestar/sb-docker-xpressengine3
VERSION=3.0.11

help:
	@echo "XpressEngine - Content Management System"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare       - Clone XpressEngine repository"
	@echo "  make build         - Build Docker image (composer)"
	@echo "  make build-debian  - Build Docker image (Debian)"
	@echo "  make up            - Start XpressEngine"
	@echo "  make down          - Stop XpressEngine"
	@echo "  make restart       - Restart XpressEngine"
	@echo "  make logs          - View logs"
	@echo "  make ps            - Show running containers"
	@echo "  make shell         - Access XpressEngine container shell"
	@echo "  make clean         - Stop and remove all data (⚠️  destructive)"

prepare:
	@if [ ! -d "app" ]; then \
		git clone https://github.com/xpressengine/xpressengine.git --depth 1 app; \
		echo "✅ XpressEngine repository cloned"; \
	else \
		echo "✅ XpressEngine repository already exists"; \
	fi

build:
	docker build . -f xe-composer.dockerfile -t ${REPO}:${VERSION}

build-debian:
	docker build . -f debian-buster/Dockerfile -t ${REPO}:${VERSION}
	docker build . -f debian-buster/Dockerfile -t test

up:
	docker compose up -d
	@echo ""
	@echo "✅ XpressEngine is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all XpressEngine data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec xpressengine bash