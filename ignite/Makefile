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
	@echo "Waiting for Apache Ignite to be ready..."
	@sleep 10
	@docker compose logs ignite | grep -q "Topology snapshot" && echo "Apache Ignite is running!" || echo "Failed to start Apache Ignite"
	@docker compose down

shell:
	docker compose exec ignite bash

sqlline:
	docker compose exec ignite /opt/ignite/apache-ignite/bin/sqlline.sh -u jdbc:ignite:thin://127.0.0.1
