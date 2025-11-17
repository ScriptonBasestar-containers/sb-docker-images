.PHONY: help prepare setup build tag push up down logs restart ps clean shell

date_YYYYMMDD=$(shell date +%Y%m%d)

help:
	@echo "RSSHub - RSS Feed Generator"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone RSSHub repository"
	@echo "  make setup    - Install RSSHub dependencies"
	@echo "  make build    - Build Docker image"
	@echo "  make tag      - Tag Docker image"
	@echo "  make push     - Push Docker image to registry"
	@echo "  make up       - Start RSSHub"
	@echo "  make down     - Stop RSSHub"
	@echo "  make restart  - Restart RSSHub"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access RSSHub container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@if [ ! -d "RSSHub" ]; then \
		git clone --depth 1 https://github.com/DIYgod/RSSHub.git; \
		corepack enable pnpm; \
		echo "✅ RSSHub repository cloned"; \
	else \
		echo "✅ RSSHub repository already exists"; \
	fi

setup:
	@echo "Installing RSSHub dependencies..."
	cd RSSHub && pnpm i

build:
	docker build RSSHub/ -t rsshub:latest

tag:
	docker tag rsshub:latest ScriptonBasestar/rsshub:latest
	docker tag rsshub:latest ScriptonBasestar/rsshub:${date_YYYYMMDD}

push:
	docker push ScriptonBasestar/rsshub:latest
	docker push ScriptonBasestar/rsshub:${date_YYYYMMDD}

up:
	docker compose up -d
	@echo ""
	@echo "✅ RSSHub is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all RSSHub data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec rsshub sh
