.PHONY: help build up down logs restart ps clean shell run-playbook

help:
	@echo "Ansible Development Environment"
	@echo ""
	@echo "Available commands:"
	@echo "  make build       - Build Ansible Docker image"
	@echo "  make up          - Start Ansible development environment"
	@echo "  make down        - Stop Ansible development environment"
	@echo "  make restart     - Restart Ansible development environment"
	@echo "  make logs        - View logs"
	@echo "  make ps          - Show running containers"
	@echo "  make shell       - Access Ansible container shell"
	@echo "  make run-playbook PLAYBOOK=<file> - Run a specific playbook"
	@echo "  make clean       - Stop and remove all data (⚠️  destructive)"

build:
	docker build -t ansible-dev:2.18 . -f alpine/Dockerfile
	@echo ""
	@echo "✅ Ansible image built successfully"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Ansible development environment is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Ansible development data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec ansible /bin/bash

run-playbook:
ifndef PLAYBOOK
	@echo "❌ Error: PLAYBOOK variable is required"
	@echo "Usage: make run-playbook PLAYBOOK=site.yml"
	@exit 1
endif
	docker compose run --rm ansible $(PLAYBOOK)
