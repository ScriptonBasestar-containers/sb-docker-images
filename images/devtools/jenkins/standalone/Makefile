.PHONY: help up down logs restart clean ps shell initial-password

help:
	@echo "Jenkins Standalone - CI/CD Automation Server"
	@echo ""
	@echo "Available commands:"
	@echo "  make up                - Start Jenkins"
	@echo "  make down              - Stop Jenkins"
	@echo "  make logs              - View logs"
	@echo "  make restart           - Restart Jenkins"
	@echo "  make ps                - Show running containers"
	@echo "  make clean             - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access commands:"
	@echo "  make shell             - Access Jenkins container shell"
	@echo "  make initial-password  - Show initial admin password"
	@echo ""
	@echo "Utility commands:"
	@echo "  make backup            - Backup Jenkins home directory"
	@echo "  make restore           - Restore Jenkins from backup"
	@echo ""
	@echo "Access URLs:"
	@echo "  Jenkins Web: http://localhost:8080"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Jenkins is starting..."
	@echo "This may take a few minutes on first run."
	@echo ""
	@echo "To get the initial admin password, run:"
	@echo "  make initial-password"
	@echo ""
	@echo "Then visit: http://localhost:8080"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all data including Jenkins configuration and jobs!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec jenkins /bin/bash

initial-password:
	@echo "Fetching initial admin password..."
	@docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || \
		echo "Jenkins is not running or not initialized yet. Run 'make up' first."

backup:
	@echo "Creating backup of Jenkins home..."
	@mkdir -p ./backups
	@docker compose exec jenkins tar czf /tmp/jenkins-backup-$$(date +%Y%m%d-%H%M%S).tar.gz /var/jenkins_home
	@docker compose cp jenkins:/tmp/jenkins-backup-*.tar.gz ./backups/
	@echo "✅ Backup created in ./backups/"

restore:
	@echo "Available backups:"
	@ls -1 ./backups/*.tar.gz 2>/dev/null || echo "No backups found"
	@echo ""
	@read -p "Enter backup filename to restore: " backup; \
	if [ -f "./backups/$$backup" ]; then \
		docker compose cp ./backups/$$backup jenkins:/tmp/restore.tar.gz; \
		docker compose exec jenkins tar xzf /tmp/restore.tar.gz -C /; \
		docker compose restart jenkins; \
		echo "✅ Backup restored. Jenkins is restarting..."; \
	else \
		echo "❌ Backup file not found"; \
	fi
