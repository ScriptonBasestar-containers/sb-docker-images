.PHONY: help up down logs restart ps clean shell

help:
	@echo "Bitcoin Node - Cryptocurrency Node"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Bitcoin node"
	@echo "  make down     - Stop Bitcoin node"
	@echo "  make restart  - Restart Bitcoin node"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Bitcoin container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Bitcoin node is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Bitcoin blockchain data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec bitcoin bash
