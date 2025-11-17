.PHONY: help build up down logs restart ps clean shell

help:
	@echo "Ansible Development Environment"
	@echo ""
	@echo "Available commands:"
	@echo "  make build    - Build Ansible development Docker image"
	@echo "  make up       - Start Ansible development environment"
	@echo "  make down     - Stop Ansible development environment"
	@echo "  make restart  - Restart Ansible development environment"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Ansible container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

build:
	docker build -t ansible-dev . -f alpine/Dockerfile

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
	docker compose exec ansible bash
