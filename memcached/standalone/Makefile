.PHONY: help up down logs restart clean ps stats test

help:
	@echo "Memcached Standalone - Distributed Memory Cache"
	@echo ""
	@echo "Available commands:"
	@echo "  make up           - Start Memcached"
	@echo "  make down         - Stop Memcached"
	@echo "  make logs         - View logs"
	@echo "  make restart      - Restart Memcached"
	@echo "  make ps           - Show running containers"
	@echo "  make clean        - Stop and remove container"
	@echo ""
	@echo "Memcached commands:"
	@echo "  make stats        - Show Memcached statistics"
	@echo "  make test         - Test Memcached connection"
	@echo ""
	@echo "Access Info:"
	@echo "  Memcached: localhost:11211"

up:
	docker compose up -d
	@echo ""
	@echo "✅ Memcached is starting..."
	@echo ""
	@echo "Connection info:"
	@echo "  Host: localhost"
	@echo "  Port: 11211"
	@echo ""
	@echo "Test connection: make test"

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps

clean:
	docker compose down
	@echo "✅ Memcached stopped"

stats:
	@echo "Fetching Memcached statistics..."
	@echo "stats" | nc localhost 11211

test:
	@echo "Testing Memcached connection..."
	@echo "stats" | nc localhost 11211 | head -3
	@echo ""
	@echo "Setting test value..."
	@echo -e "set test_key 0 60 5\r\nhello\r\n" | nc localhost 11211
	@echo "Getting test value..."
	@echo -e "get test_key\r\n" | nc localhost 11211
