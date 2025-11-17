.PHONY: help prepare build up down logs restart ps clean shell

help:
	@echo "Solidus - E-commerce Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone Solidus repository"
	@echo "  make build    - Build Docker images"
	@echo "  make up       - Start Solidus"
	@echo "  make down     - Stop Solidus"
	@echo "  make restart  - Restart Solidus"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Solidus container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@if [ ! -d "solidus" ]; then \
		git clone https://github.com/solidusio/solidus.git; \
		cd solidus && git checkout v4.3; \
		echo "✅ Solidus repository cloned"; \
	else \
		echo "✅ Solidus repository already exists"; \
	fi

build:
	cd solidus && docker compose build --no-cache

up:
	cd solidus && docker compose up -d
	@echo ""
	@echo "✅ Solidus is starting..."

down:
	cd solidus && docker compose down

logs:
	cd solidus && docker compose logs -f

restart:
	cd solidus && docker compose restart

ps:
	cd solidus && docker compose ps

clean:
	@echo "⚠️  This will remove all Solidus data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd solidus && docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	cd solidus && docker compose exec solidus bash
