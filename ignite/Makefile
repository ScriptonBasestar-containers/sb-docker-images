.PHONY: help up down logs restart ps clean shell test sqlline

help:
	@echo "Apache Ignite - Distributed Database and Caching Platform"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start Apache Ignite"
	@echo "  make down     - Stop Apache Ignite"
	@echo "  make restart  - Restart Apache Ignite"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Ignite container shell"
	@echo "  make sqlline  - Access Ignite SQL shell"
	@echo "  make test     - Test Ignite startup"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Apache Ignite is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Apache Ignite data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec ignite bash

sqlline:
	docker compose exec ignite /opt/ignite/apache-ignite/bin/sqlline.sh -u jdbc:ignite:thin://127.0.0.1

test:
	@echo "Testing Apache Ignite startup..."
	@docker compose up -d
	@sleep 10
	@docker compose logs ignite | grep -q "Topology snapshot" && echo "✅ Apache Ignite is running!" || echo "❌ Failed to start Apache Ignite"
	@docker compose down
