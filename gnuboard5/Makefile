.PHONY: help prepare build install up down logs restart ps clean shell

CONTAINER_NAME=gnuboard5

help:
	@echo "Gnuboard5 - Korean Community Board System"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone Gnuboard5 repository"
	@echo "  make build    - Build Docker images"
	@echo "  make install  - Configure Gnuboard5"
	@echo "  make up       - Start Gnuboard5"
	@echo "  make down     - Stop Gnuboard5"
	@echo "  make restart  - Restart Gnuboard5"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Gnuboard5 container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access URL:"
	@echo "  Gnuboard5: http://localhost:8080"

prepare:
	@if [ ! -d "app" ]; then \
		git clone https://github.com/gnuboard/gnuboard5.git --depth 1 app; \
		echo "✅ Gnuboard5 repository cloned"; \
	else \
		echo "✅ Gnuboard5 repository already exists"; \
	fi

build:
	docker compose build --no-cache

install:
	@echo "Configuring Gnuboard5..."
	@mkdir -p app/data
	@if [ -f app/config.php ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			sed -i '' "s|define('G5_DOMAIN', '');|define('G5_DOMAIN', 'http://localhost:8080');|" app/config.php; \
		else \
			sed -i "s|define('G5_DOMAIN', '');|define('G5_DOMAIN', 'http://localhost:8080');|" app/config.php; \
		fi; \
		echo "✅ Configuration updated"; \
	fi

up:
	docker compose up -d
	@echo ""
	@echo "✅ Gnuboard5 is starting..."
	@echo "   Access at: http://localhost:8080"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Gnuboard5 data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec ${CONTAINER_NAME} bash
