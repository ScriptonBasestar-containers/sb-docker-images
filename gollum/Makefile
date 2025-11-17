.PHONY: help setup build tag push up down logs restart ps clean shell

DOCKER_REGISTRY=ghcr.io/scriptonbasestar

help:
	@echo "Gollum - Git-powered Wiki"
	@echo ""
	@echo "Available commands:"
	@echo "  make setup    - Initialize wiki directory"
	@echo "  make build    - Build Docker image"
	@echo "  make tag      - Tag Docker image"
	@echo "  make push     - Push Docker image to registry"
	@echo "  make up       - Start Gollum"
	@echo "  make down     - Stop Gollum"
	@echo "  make restart  - Restart Gollum"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Gollum container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

setup:
	@mkdir -p wiki/gollum
	@if [ ! -d "wiki/gollum/.git" ]; then \
		git init wiki/gollum; \
		echo "✅ Wiki directory initialized"; \
	else \
		echo "✅ Wiki directory already initialized"; \
	fi
	@chown -R 1000:1000 wiki/gollum 2>/dev/null || true

build:
	docker build . -t gollum -f dockerfiles/gollum-ruby-bookworm.dockerfile

tag:
	docker tag gollum:latest $(DOCKER_REGISTRY)/gollum:latest

push:
	docker tag gollum:latest $(DOCKER_REGISTRY)/gollum:latest
	docker push $(DOCKER_REGISTRY)/gollum:latest

up:
	docker compose up -d
	@echo ""
	@echo "✅ Gollum is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Gollum data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec gollum bash
