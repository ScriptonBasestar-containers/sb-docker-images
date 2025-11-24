.PHONY: help up down logs restart ps clean shell rails-console

help:
	@echo "Mastodon - Decentralized Social Network"
	@echo ""
	@echo "Available commands:"
	@echo "  make up             - Start Mastodon"
	@echo "  make down           - Stop Mastodon"
	@echo "  make restart        - Restart Mastodon"
	@echo "  make logs           - View logs"
	@echo "  make ps             - Show running containers"
	@echo "  make shell          - Access Mastodon web container shell"
	@echo "  make rails-console  - Access Rails console"
	@echo "  make clean          - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Mastodon is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Mastodon data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec web bash

rails-console:
	docker compose exec web bin/rails console
