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
	@echo "Waiting for memcached to be ready..."
	@sleep 3
	@docker compose exec memcached sh -c "echo 'stats' | nc localhost 11211" || echo "Failed to connect to memcached"
	@docker compose down
