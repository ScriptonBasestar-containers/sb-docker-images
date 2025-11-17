.PHONY: help prepare build up down logs restart ps clean shell

help:
	@echo "Misago - Modern Forum Software"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone Misago repository"
	@echo "  make build    - Build Docker image"
	@echo "  make up       - Start Misago"
	@echo "  make down     - Stop Misago"
	@echo "  make restart  - Restart Misago"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Misago container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@echo "Preparing Misago..."
	@rm -rf discourse discourse_docker 2>/dev/null || true
	@if [ ! -d "Misago" ]; then \
		git clone https://github.com/rafalp/Misago.git --depth 1; \
		echo "✅ Misago repository cloned"; \
	else \
		echo "✅ Misago repository already exists"; \
	fi

build:
	docker build Misago -f Misago/Dockerfile -t misago/app

up:
	docker compose up -d
	@echo ""
	@echo "✅ Misago is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Misago data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec misago bash
