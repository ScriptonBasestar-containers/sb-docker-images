.PHONY: help build up down logs restart ps clean shell

help:
	@echo "Rhymix - Korean Open Source CMS"
	@echo ""
	@echo "Commands:"
	@echo "  make build    - Build Rhymix Docker image"
	@echo "  make up       - Start all services"
	@echo "  make down     - Stop all services"
	@echo "  make restart  - Restart all services"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Rhymix container shell"
	@echo "  make clean    - Stop and remove all data"
	@echo ""
	@echo "After starting, access Rhymix at: http://localhost:$${RHYMIX_PORT:-8310}"

build:
	docker compose build
	@echo ""
	@echo "Rhymix image built successfully!"

up:
	docker compose up -d
	@echo ""
	@echo "Rhymix is starting..."
	@echo "Access at: http://localhost:$${RHYMIX_PORT:-8310}"
	@echo ""
	@echo "Database settings for installation:"
	@echo "  Host: db"
	@echo "  Database: rhymix"
	@echo "  Username: rhymix"
	@echo "  Password: rhymix_password"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

shell:
	docker compose exec rhymix sh

clean:
	@echo "This will remove all Rhymix data including database!"
	@echo ""
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All Rhymix data removed"; \
	fi
