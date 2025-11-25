.PHONY: help build up down logs restart ps clean shell init

help:
	@echo "AgenDAV - CalDAV Web Client"
	@echo ""
	@echo "Setup commands:"
	@echo "  make init     - Initialize database (run once after first start)"
	@echo ""
	@echo "Runtime commands:"
	@echo "  make build    - Build AgenDAV Docker image"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make restart  - Restart all services"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access AgenDAV container shell"
	@echo "  make clean    - Stop and remove all data"
	@echo ""
	@echo "After starting, access AgenDAV at: http://localhost:$${AGENDAV_PORT:-8300}"

build:
	docker compose build
	@echo ""
	@echo "AgenDAV image built successfully!"

up:
	docker compose up -d
	@echo ""
	@echo "AgenDAV is starting..."
	@echo "Access at: http://localhost:$${AGENDAV_PORT:-8300}"
	@echo ""
	@echo "If this is first run, execute:"
	@echo "  make init"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

shell:
	docker compose exec agendav sh

init:
	@echo "Initializing AgenDAV database..."
	docker compose exec agendav php bin/agendavcli dbupdate
	@echo ""
	@echo "Database initialized!"
	@echo "Login with your CalDAV server credentials"

clean:
	@echo "This will remove all AgenDAV data including database!"
	@echo ""
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All AgenDAV data removed"; \
	fi
