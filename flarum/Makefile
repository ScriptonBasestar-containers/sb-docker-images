.PHONY: help prepare build-base build-apache build-nginx up up-apache up-nginx down logs logs-flarum logs-mariadb restart ps clean shell

REPO=scriptonbasestar/sb-flarum
VERSION=3.0.11
FILES_APACHE=-f compose.yml -f compose.apache.yml
FILES_NGINX=-f compose.yml -f compose.nginx.yml
DOCKER_BASE_IMAGE=local_dev/flarum-base

help:
	@echo "Flarum - Modern Forum Software"
	@echo ""
	@echo "Available commands:"
	@echo "  make prepare       - Clone Flarum repository and install dependencies"
	@echo "  make build-base    - Build base Docker image"
	@echo "  make build-apache  - Build Apache variant"
	@echo "  make build-nginx   - Build Nginx variant"
	@echo "  make up            - Start Flarum (default)"
	@echo "  make up-apache     - Start Flarum with Apache"
	@echo "  make up-nginx      - Start Flarum with Nginx"
	@echo "  make down          - Stop Flarum"
	@echo "  make restart       - Restart Flarum"
	@echo "  make logs          - View all logs"
	@echo "  make logs-flarum   - View Flarum logs"
	@echo "  make logs-mariadb  - View MariaDB logs"
	@echo "  make ps            - Show running containers"
	@echo "  make shell         - Access Flarum container shell"
	@echo "  make clean         - Stop and remove all data (⚠️  destructive)"

prepare:
	@if [ ! -d "app" ]; then \
		git clone https://github.com/flarum/flarum --depth 1 app; \
		docker run --rm -it -v ./app:/app composer composer install; \
		echo "✅ Flarum repository cloned and dependencies installed"; \
	else \
		echo "✅ Flarum repository already exists"; \
	fi

build-base:
	docker build -f flarum-composer.dockerfile -t ${DOCKER_BASE_IMAGE} --no-cache .

build-apache:
	docker compose ${FILES_APACHE} build --no-cache

build-nginx:
	docker compose ${FILES_NGINX} build --no-cache

up:
	docker compose up -d
	@echo ""
	@echo "✅ Flarum is starting..."

up-apache:
	docker compose ${FILES_APACHE} up -d
	@echo ""
	@echo "✅ Flarum (Apache) is starting..."

up-nginx:
	docker compose ${FILES_NGINX} up -d
	@echo ""
	@echo "✅ Flarum (Nginx) is starting..."

down:
	docker compose down

logs:
	docker compose logs -f

logs-flarum:
	docker compose logs -f flarum

logs-mariadb:
	docker compose logs -f mariadb

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	@echo "⚠️  This will remove all Flarum data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down -v; \
		rm -rf app; \
		echo "✅ All data removed"; \
	fi

shell:
	docker compose exec flarum bash
