.PHONY: help prepare up down logs restart ps clean shell source pypi-%

help:
	@echo "devpi - Python Package Index Server"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone devpi repository and plugins"
	@echo "  make up       - Start devpi server"
	@echo "  make down     - Stop devpi server"
	@echo "  make restart  - Restart devpi server"
	@echo "  make logs     - View server logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Enter running container"
	@echo "  make clean    - Clean up repositories and Docker resources (⚠️  destructive)"
	@echo ""
	@echo "Build commands:"
	@echo "  make source   - Build from source"
	@echo "  make pypi-*   - PyPI-related commands"

prepare:
	@echo "Preparing devpi environment..."
	@rm -rf devpi devpi-constrained devpi-findlinks devpi-jenkins devpi-lockdown 2>/dev/null || true
	@touch .env
	@if [ ! -d "devpi" ]; then \
		git clone https://github.com/devpi/devpi.git --depth 1; \
		git clone https://github.com/devpi/devpi-constrained.git --depth 1; \
		git clone https://github.com/devpi/devpi-findlinks.git --depth 1; \
		git clone https://github.com/devpi/devpi-jenkins.git --depth 1; \
		git clone https://github.com/devpi/devpi-lockdown.git --depth 1; \
		echo "✅ devpi repositories cloned successfully"; \
	else \
		echo "✅ devpi repositories already exist"; \
	fi

up:
	docker compose up -d
	@echo ""
	@echo "✅ devpi server is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all devpi data and repositories!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		rm -rf devpi devpi-constrained devpi-findlinks devpi-jenkins devpi-lockdown; \
		rm -rf data logs; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec devpi sh

source:
	@make -f Makefile.source.mk --no-print-directory $(REM_ARGS)

pypi-%:
	@make -f Makefile.pypi.mk --no-print-directory $*
