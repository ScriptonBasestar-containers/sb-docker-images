.PHONY: help up down logs restart ps clean shell

help:
	@echo "Django CMS - Enterprise Content Management System"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Django CMS"
	@echo "  make down     - Stop Django CMS"
	@echo "  make restart  - Restart Django CMS"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Django CMS container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Django CMS is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Django CMS data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec django-cms bash
