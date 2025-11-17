.PHONY: help up down logs restart ps clean shell

help:
	@echo "openNamu - Korean Wiki Engine"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start openNamu"
	@echo "  make down     - Stop openNamu"
	@echo "  make restart  - Restart openNamu"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access openNamu container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ openNamu is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all openNamu data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec opennamu sh
