.PHONY: help up down logs restart ps clean shell mysql \
        backup-rclone-build backup-restic-build backup-clean

REGISTRY ?= scriptonbasestar
BACKUP_RCLONE_IMAGE := $(REGISTRY)/mariadb-backup-rclone
BACKUP_RESTIC_IMAGE := $(REGISTRY)/mariadb-backup-restic

help:
	@echo "MariaDB - Relational Database Server + Backup Toolkit"
	@echo ""
	@echo "Server:"
	@echo "  make up       - Start MariaDB"
	@echo "  make down     - Stop MariaDB"
	@echo "  make restart  - Restart MariaDB"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access MariaDB container shell"
	@echo "  make mysql    - Connect to MariaDB CLI"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Backup (build images used by your own compose stacks):"
	@echo "  make backup-rclone-build  - Build $(BACKUP_RCLONE_IMAGE)"
	@echo "  make backup-restic-build  - Build $(BACKUP_RESTIC_IMAGE)"
	@echo "  make backup-clean         - Remove built backup images"
	@echo ""
	@echo "Connection info:"
	@echo "  Host: localhost"
	@echo "  Port: $${MYSQL_PORT:-3306}"
	@echo "  User: root (check .env file)"

up:
	docker compose up -d
	@echo ""
	@echo "✅ MariaDB is starting..."
	@echo "   Port: $${MYSQL_PORT:-3306}"

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
	docker compose exec mariadb mariadb -u root -p

# --- Backup images -----------------------------------------------------------
backup-rclone-build:
	docker build -t $(BACKUP_RCLONE_IMAGE) -f backup/rclone.dockerfile backup/
	@echo "✅ Built $(BACKUP_RCLONE_IMAGE)"

backup-restic-build:
	docker build -t $(BACKUP_RESTIC_IMAGE) -f backup/restic.dockerfile backup/
	@echo "✅ Built $(BACKUP_RESTIC_IMAGE)"

backup-clean:
	-docker rmi $(BACKUP_RCLONE_IMAGE) $(BACKUP_RESTIC_IMAGE) 2>/dev/null || true
	@echo "✅ Backup images removed"
