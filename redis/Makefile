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

test:
	docker compose up -d
	@echo "Waiting for Redis to be ready..."
	@sleep 3
	@docker compose exec redis redis-cli -a passw0rd ping || echo "Failed to connect to Redis"
	@docker compose down

cli:
	docker compose exec redis redis-cli -a passw0rd
