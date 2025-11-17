.PHONY: help build push up up-cache down logs restart ps clean shell

ROOT_DIR=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
DOCKER_REPO=scriptonbasestar/sb-docker-squid
DOCKER_VERSION=latest
APP_VERSION=4.10
CONTAINER_NAME=squid

help:
	@echo "Squid - Caching and Forwarding HTTP Web Proxy"
	@echo ""
	@echo "Available commands:"
	@echo "  make build     - Build Docker image"
	@echo "  make push      - Push Docker image to registry"
	@echo "  make up        - Start Squid"
	@echo "  make up-cache  - Start Squid with custom cache config"
	@echo "  make down      - Stop Squid"
	@echo "  make restart   - Restart Squid"
	@echo "  make logs      - View logs"
	@echo "  make ps        - Show running containers"
	@echo "  make shell     - Access Squid container shell"
	@echo "  make clean     - Stop and remove container"
	@echo ""
	@echo "Access:"
	@echo "  Proxy: http://localhost:3128"

build:
	docker build . -t ${DOCKER_REPO}:${DOCKER_VERSION}

push:
	docker push ${DOCKER_REPO}:${DOCKER_VERSION}

up:
	docker run -d --name ${CONTAINER_NAME} -p 3128:3128 squid
	@echo ""
	@echo "✅ Squid is starting..."
	@echo "   Proxy available at: http://localhost:3128"

up-cache:
	docker run -d --name ${CONTAINER_NAME} \
		-v $(ROOT_DIR)/files/sample.conf:/etc/squid/conf.d/sample.conf \
		-p 3128:3128 squid
	@echo ""
	@echo "✅ Squid is starting with custom cache config..."
	@echo "   Proxy available at: http://localhost:3128"

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
	@echo "⚠️  This will remove the Squid container!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker stop ${CONTAINER_NAME} 2>/dev/null || true; \
		docker rm ${CONTAINER_NAME} 2>/dev/null || true; \
		echo "✅ Container removed"; \
	fi

shell:
	docker exec -it ${CONTAINER_NAME} bash
