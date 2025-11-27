.PHONY: help up down logs restart clean ps init-replica

help:
	@echo "Rocket.Chat Docker Commands:"
	@echo "  make up           - Start Rocket.Chat services"
	@echo "  make down         - Stop Rocket.Chat services"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart services"
	@echo "  make clean        - Remove all resources"
	@echo "  make ps           - Show container status"
	@echo "  make init-replica - Initialize MongoDB replica set (if needed)"

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

init-replica:
	docker compose up -d mongodb
	@echo "Waiting for MongoDB to be ready..."
	@sleep 10
	docker compose run --rm mongo-init-replica
