.PHONY: help build up down logs restart ps clean shell init sync admin

help:
	@echo "Koel - Personal Music Streaming Server"
	@echo ""
	@echo "Setup commands:"
	@echo "  make init     - Initialize database (run once after first start)"
	@echo "  make admin    - Create admin user"
	@echo "  make sync     - Scan music library"
	@echo ""
	@echo "Runtime commands:"
	@echo "  make build    - Build Koel Docker image"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make restart  - Restart all services"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Koel container shell"
	@echo "  make clean    - Stop and remove all data"
	@echo ""
	@echo "After starting, access Koel at: http://localhost:$${KOEL_PORT:-8290}"

build:
	docker compose build
	@echo ""
	@echo "Koel image built successfully!"

up:
	docker compose up -d
	@echo ""
	@echo "Koel is starting..."
	@echo "Access at: http://localhost:$${KOEL_PORT:-8290}"
	@echo ""
	@echo "If this is first run, execute:"
	@echo "  make init"
	@echo "  make admin"
	@echo "  make sync"

down:
	docker compose down

logs:
	docker compose logs -f

logs-koel:
	docker compose logs -f koel

restart:
	docker compose restart

ps:
	docker compose ps

shell:
	docker compose exec koel sh

init:
	@echo "Initializing Koel database..."
	docker compose exec koel php artisan koel:init --no-interaction
	@echo ""
	@echo "Database initialized! Now run: make admin"

admin:
	@echo "Creating admin user..."
	docker compose exec koel php artisan koel:admin:create
	@echo ""
	@echo "Admin created! Now run: make sync"

sync:
	@echo "Scanning music library..."
	docker compose exec koel php artisan koel:sync
	@echo ""
	@echo "Music library synced!"

key:
	@echo "Generating APP_KEY..."
	@docker compose run --rm koel php artisan key:generate --show

clean:
	@echo "This will remove all Koel data including:"
	@echo "  - Database (playlists, users, etc.)"
	@echo "  - Album covers"
	@echo "  - Redis cache"
	@echo "  - (Music files are NOT deleted)"
	@echo ""
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All Koel data removed"; \
	fi
