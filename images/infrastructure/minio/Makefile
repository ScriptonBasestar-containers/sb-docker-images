.PHONY: help up down logs ps clean restart test setup buckets

help:
	@echo "Minio Makefile Commands:"
	@echo "  make up       - Start Minio server"
	@echo "  make down     - Stop and remove containers"
	@echo "  make logs     - Show container logs"
	@echo "  make ps       - Show running containers"
	@echo "  make clean    - Remove all data (WARNING: destructive)"
	@echo "  make restart  - Restart all services"
	@echo "  make test     - Validate compose file"
	@echo "  make setup    - Run initial bucket setup"
	@echo "  make buckets  - List all buckets"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f minio

ps:
	docker compose ps

clean:
	@echo "WARNING: This will delete all Minio data!"
	@read -p "Are you sure? [y/N] " confirm && [ "$$confirm" = "y" ] || exit 1
	docker compose down -v
	rm -rf data

restart:
	docker compose restart minio

test:
	docker compose config

setup:
	docker compose up minio-setup

buckets:
	@docker exec minio mc ls myminio/
