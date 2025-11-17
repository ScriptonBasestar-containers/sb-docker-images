up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

clean:
	docker compose down -v

logs-mediawiki:
	docker compose logs -f mediawiki

logs-mariadb:
	docker compose logs -f mariadb

logs-redis:
	docker compose logs -f redis

shell:
	docker compose exec mediawiki bash

download-config:
	@echo "Downloading LocalSettings.php from container..."
	docker compose cp mediawiki:/var/www/html/LocalSettings.php ./LocalSettings.php
	@echo "LocalSettings.php downloaded. Uncomment the volume mount in compose.yml to use it."
