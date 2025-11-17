.PHONY: help prepare build up down logs restart ps clean shell

help:
	@echo "TSBoard - TypeScript-based Board System"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone TSBoard repositories"
	@echo "  make build    - Build Docker images"
	@echo "  make up       - Start TSBoard"
	@echo "  make down     - Stop TSBoard"
	@echo "  make restart  - Restart TSBoard"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access TSBoard container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@echo "Cloning TSBoard repositories..."
	@if [ ! -d "repos/tsboard" ]; then \
		mkdir -p repos; \
		git clone https://github.com/sirini/tsboard.git repos/tsboard; \
		echo "✅ TSBoard repository cloned"; \
	fi
	@if [ ! -d "repos/goapi" ]; then \
		mkdir -p repos; \
		git clone https://github.com/sirini/goapi.git repos/goapi; \
		echo "✅ GoAPI repository cloned"; \
	fi

build:
	docker build . -t goapi -f dockerfiles/backend-goapi.dockerfile

up:
	docker compose up -d
	@echo ""
	@echo "✅ TSBoard is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all TSBoard data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec tsboard sh
