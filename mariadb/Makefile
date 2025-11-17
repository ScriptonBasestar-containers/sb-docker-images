.PHONY: help up down logs restart ps clean shell mysql

help:
	@echo "MariaDB - Relational Database Server"
	@echo ""
	@echo "Available commands:"
	@echo "  make up       - Start MariaDB"
	@echo "  make down     - Stop MariaDB"
	@echo "  make restart  - Restart MariaDB"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access MariaDB container shell"
	@echo "  make mysql    - Connect to MySQL/MariaDB CLI"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Connection info:"
	@echo "  Host: localhost"
	@echo "  Port: 3306"
	@echo "  User: root (or check .env file)"
	@echo "  Password: (check .env file)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ MariaDB is starting..."
	@echo "   Port: 3306"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all databases and data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec mariadb bash

mysql:
	docker compose exec mariadb mysql -u root -p
