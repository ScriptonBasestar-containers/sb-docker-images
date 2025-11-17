.PHONY: help prepare build reset up down logs restart ps clean shell

help:
	@echo "NodeBB - Modern Forum Software"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone NodeBB repository"
	@echo "  make build    - Install NodeBB dependencies"
	@echo "  make reset    - Reset NodeBB to clean state"
	@echo "  make up       - Start NodeBB"
	@echo "  make down     - Stop NodeBB"
	@echo "  make restart  - Restart NodeBB"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access NodeBB container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"

prepare:
	@if [ ! -d "nodebb" ]; then \
		git clone https://github.com/NodeBB/NodeBB.git nodebb; \
		chown -R 1001:1001 nodebb/.docker 2>/dev/null || true; \
		rm -r nodebb/.docker/database/postgresql/data/.gitkeep 2>/dev/null || true; \
		echo "✅ NodeBB repository cloned"; \
	else \
		echo "✅ NodeBB repository already exists"; \
	fi

build:
	@echo "Installing NodeBB dependencies..."
	cd nodebb && npm install

reset:
	@echo "⚠️  Resetting NodeBB to clean state..."
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		cd nodebb && docker compose down -v; \
		rm -rf nodebb/.docker/; \
		git -C nodebb clean -fd nodebb; \
		git -C nodebb reset --hard HEAD; \
		echo "✅ NodeBB reset complete"; \
	fi

up:
	cd nodebb && docker compose up -d
	@echo ""
	@echo "✅ NodeBB is starting..."

down:
	cd nodebb && docker compose down

logs:
	cd nodebb && docker compose logs -f

restart:
	cd nodebb && docker compose restart

ps:
	cd nodebb && docker compose ps

clean:
	@echo "⚠️  This will remove all NodeBB data and the repository!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf nodebb; \
		echo "✅ All data removed"; \
	fi

shell:
	cd nodebb && docker compose exec nodebb bash
