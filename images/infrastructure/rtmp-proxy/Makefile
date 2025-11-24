.PHONY: help up down logs restart ps clean shell

help:
	@echo "RTMP Proxy - Real-Time Messaging Protocol Proxy"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start RTMP proxy"
	@echo "  make down     - Stop RTMP proxy"
	@echo "  make restart  - Restart RTMP proxy"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access RTMP proxy container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ RTMP proxy is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all RTMP proxy data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec rtmp sh
