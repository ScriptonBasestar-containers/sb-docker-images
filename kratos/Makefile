.PHONY: help prepare build up down logs restart ps clean shell

help:
	@echo "Ory Kratos - Identity and User Management"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone Kratos repositories"
	@echo "  make build    - Build Docker images"
	@echo "  make up       - Start Kratos"
	@echo "  make down     - Stop Kratos"
	@echo "  make restart  - Restart Kratos"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Kratos container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@echo "Cloning Kratos repositories..."
	@if [ ! -d "kratos" ]; then \
		git clone https://github.com/ory/kratos.git; \
		echo "✅ Kratos repository cloned"; \
	fi
	@if [ ! -d "ory-kratos-selfservice-ui-node" ]; then \
		git clone https://github.com/ScriptonBasestar-containers/ory-kratos-selfservice-ui-node.git; \
		echo "✅ Kratos UI Node repository cloned"; \
	fi
	@if [ ! -d "ory-kratos-selfservice-ui-react-nextjs" ]; then \
		git clone https://github.com/ScriptonBasestar-containers/ory-kratos-selfservice-ui-react-nextjs.git; \
		echo "✅ Kratos UI React repository cloned"; \
	fi

build:
	@echo "Building containers..."
	(cd ./kratos; docker build -f .docker/Dockerfile-build -t oryd/kratos:latest .)
	(cd ./ory-kratos-selfservice-ui-node; make docker-dev-build)
	(cd ./ory-kratos-selfservice-ui-react-nextjs; make build)

up:
	docker compose up -d
	@echo ""
	@echo "✅ Kratos is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Kratos data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec kratos sh
