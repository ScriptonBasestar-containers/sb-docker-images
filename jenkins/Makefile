.PHONY: help build tag push up down logs restart ps clean shell

DOCKER_REGISTRY=ghcr.io/scriptonbasestar

help:
	@echo "Jenkins - Automation Server"
	@echo ""
	@echo "Available commands:"
	@echo "  make build    - Build Docker image"
	@echo "  make tag      - Tag Docker image"
	@echo "  make push     - Push Docker image to registry"
	@echo "  make up       - Start Jenkins"
	@echo "  make down     - Stop Jenkins"
	@echo "  make restart  - Restart Jenkins"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Jenkins container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

build:
	docker build . -t jenkins -f dockerfiles/jenkins-lts-jdk21-plugin.dockerfile

tag:
	docker tag jenkins:latest $(DOCKER_REGISTRY)/jenkins:latest

push:
	docker tag jenkins:latest $(DOCKER_REGISTRY)/jenkins:latest
	docker push $(DOCKER_REGISTRY)/jenkins:latest

up:
	docker compose up -d
	@echo ""
	@echo "✅ Jenkins is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Jenkins data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec jenkins bash
