.PHONY: help up down logs restart clean ps

help:
	@echo "n8n Docker Commands:"
	@echo "  make up      - Start n8n services"
	@echo "  make down    - Stop n8n services"
	@echo "  make logs    - View logs"
	@echo "  make restart - Restart services"
	@echo "  make clean   - Remove all resources"
	@echo "  make ps      - Show container status"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

clean:
	docker compose down -v
	docker system prune -f

ps:
	docker compose ps
