.PHONY: help build up down logs restart clean ps shell token kernels

help:
	@echo "Jupyter Standalone - Full Stack Data Science Environment"
	@echo ""
	@echo "Available commands:"
	@echo "  make build        - Build Jupyter image"
	@echo "  make up           - Start Jupyter"
	@echo "  make down         - Stop Jupyter"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart Jupyter"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Jupyter commands:"
	@echo "  make shell        - Access Jupyter container shell"
	@echo "  make token        - Show Jupyter access token/URL"
	@echo "  make kernels      - List available kernels"
	@echo ""
	@echo "Access URL:"
	@echo "  Jupyter: http://localhost:8888"
	@echo "  (Get token with: make token)"

build:
	docker compose build

up:
	docker compose up -d
	@echo ""
	@echo "✅ Jupyter Notebook is starting..."
	@echo "This may take a minute on first run..."
	@echo ""
	@echo "Access URL:"
	@echo "  http://localhost:8888"
	@echo ""
	@echo "Get access token:"
	@echo "  make token"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all notebooks and data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec jupyter bash

token:
	@echo "Fetching Jupyter access URL and token..."
	@docker compose exec jupyter jupyter server list 2>/dev/null || \
	docker compose logs jupyter | grep -o 'http://127.0.0.1:8888/.*token=[a-z0-9]*' | head -1 || \
	echo "Jupyter not running. Start with: make up"

kernels:
	@echo "Available Jupyter kernels:"
	@docker compose exec jupyter jupyter kernelspec list || echo "Jupyter not running"
