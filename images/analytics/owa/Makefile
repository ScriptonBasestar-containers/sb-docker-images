.PHONY: help build up down logs restart ps clean shell

help:
	@echo "Open Web Analytics"
	@echo ""
	@echo "Available commands:"
	@echo "  make build    - Build OWA Docker image"
	@echo "  make up       - Start OWA and database"
	@echo "  make down     - Stop all services"
	@echo "  make restart  - Restart all services"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access OWA container shell"
	@echo "  make clean    - Stop and remove all data"
	@echo ""
	@echo "After starting, access OWA at: http://localhost:$${OWA_PORT:-8280}"

build:
	docker compose build
	@echo ""
	@echo "OWA image built successfully!"

up:
	docker compose up -d
	@echo ""
	@echo "OWA is starting..."
	@echo "Access at: http://localhost:$${OWA_PORT:-8280}"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

shell:
	docker compose exec owa sh

clean:
	@echo "This will remove all OWA data including database!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All data removed"; \
	fi
