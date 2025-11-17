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
	@echo "Waiting for DokuWiki to be ready..."
	@sleep 5
	@curl -f http://localhost:8080 > /dev/null 2>&1 && echo "DokuWiki is running!" || echo "Failed to connect to DokuWiki"
	@docker compose down

shell:
	docker compose exec dokuwiki sh
