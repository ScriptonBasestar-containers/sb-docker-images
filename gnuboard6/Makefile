.PHONY: help prepare build up down logs restart ps clean shell

CONTAINER_NAME=gnuboard6

help:
	@echo "Gnuboard6 - Korean Community Board System"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare  - Clone Gnuboard6 repositories"
	@echo "  make build    - Build Docker image (Debian)"
	@echo "  make up       - Start Gnuboard6"
	@echo "  make down     - Stop Gnuboard6"
	@echo "  make restart  - Restart Gnuboard6"
	@echo "  make logs     - View logs"
	@echo "  make ps       - Show running containers"
	@echo "  make shell    - Access Gnuboard6 container shell"
	@echo "  make clean    - Stop and remove all data (⚠️  destructive)"
	@echo ""
	@echo "Access URL:"
	@echo "  Gnuboard6: http://localhost:8000"

prepare:
	@if [ ! -d "app" ]; then \
		git clone https://github.com/gnuboard/g6.git --depth 1 app; \
		echo "✅ Gnuboard6 repository cloned"; \
	else \
		echo "✅ Gnuboard6 repository already exists"; \
	fi
	@if [ ! -d "docker" ]; then \
		git clone https://github.com/gnuboard/docker.git --depth 1; \
		echo "✅ Gnuboard6 Docker repository cloned"; \
	else \
		echo "✅ Gnuboard6 Docker repository already exists"; \
	fi

build:
	docker build -f gnuboard6-debian.dockerfile -t gnuboard6 .

up:
	docker run -d --name ${CONTAINER_NAME} -p 8000:8000 gnuboard6
	@echo ""
	@echo "✅ Gnuboard6 is starting..."
	@echo "   Access at: http://localhost:8000"

down:
	docker stop ${CONTAINER_NAME}
	docker rm ${CONTAINER_NAME}

logs:
	docker logs -f ${CONTAINER_NAME}

restart:
	docker restart ${CONTAINER_NAME}

ps:
	docker ps -f name=${CONTAINER_NAME}

clean:
	@echo "⚠️  This will remove the Gnuboard6 container!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker stop ${CONTAINER_NAME} 2>/dev/null || true; \
		docker rm ${CONTAINER_NAME} 2>/dev/null || true; \
		echo "✅ Container removed"; \
	fi

shell:
	docker exec -it ${CONTAINER_NAME} bash
