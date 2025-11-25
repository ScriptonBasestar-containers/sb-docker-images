.PHONY: help up down logs restart ps clean shell-back shell-front status

help:
	@echo "Taiga - Agile Project Management"
	@echo ""
	@echo "Available commands:"
	@echo "  make up          - Start all Taiga services"
	@echo "  make down        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo "  make logs        - View logs (all services)"
	@echo "  make ps          - Show running containers"
	@echo "  make status      - Show service health status"
	@echo "  make shell-back  - Access backend container shell"
	@echo "  make shell-front - Access frontend container shell"
	@echo "  make clean       - Stop and remove all data"
	@echo ""
	@echo "After starting, access Taiga at: http://localhost:$${TAIGA_PORT:-9000}"
	@echo "Default credentials: admin / 123123"

up:
	docker compose up -d
	@echo ""
	@echo "Taiga is starting... (may take 2-3 minutes)"
	@echo ""
	@echo "Check status with: make ps"
	@echo "Access at: http://localhost:$${TAIGA_PORT:-9000}"
	@echo "Default credentials: admin / 123123"

down:
	docker compose down

logs:
	docker compose logs -f

logs-back:
	docker compose logs -f taiga-back taiga-async

logs-front:
	docker compose logs -f taiga-front

restart:
	docker compose restart

ps:
	docker compose ps

status:
	@echo "=== Taiga Service Status ==="
	@docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

shell-back:
	docker compose exec taiga-back bash

shell-front:
	docker compose exec taiga-front sh

shell-db:
	docker compose exec taiga-db psql -U taiga -d taiga

clean:
	@echo "This will remove ALL Taiga data including:"
	@echo "  - Database (projects, users, etc.)"
	@echo "  - Media files (attachments, avatars)"
	@echo "  - RabbitMQ data"
	@echo ""
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "All Taiga data removed"; \
	fi

# Development helpers
migrate:
	docker compose exec taiga-back python manage.py migrate

createsuperuser:
	docker compose exec taiga-back python manage.py createsuperuser
