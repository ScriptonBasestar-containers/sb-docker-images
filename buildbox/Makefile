.PHONY: help network up down logs restart clean ps shell

# Default compose files directory
COMPOSE_DIR=compose

help:
	@echo "Buildbox - Reusable Docker Compose Templates"
	@echo ""
	@echo "Available commands:"
	@echo "  make network          - Create base networks (app/intra/data)"
	@echo "  make network-down     - Remove base networks"
	@echo ""
	@echo "Database services:"
	@echo "  make postgres         - Start PostgreSQL"
	@echo "  make postgres-down    - Stop PostgreSQL"
	@echo "  make mariadb          - Start MariaDB"
	@echo "  make mariadb-down     - Stop MariaDB"
	@echo ""
	@echo "Cache services:"
	@echo "  make redis            - Start Redis"
	@echo "  make redis-down       - Stop Redis"
	@echo ""
	@echo "Auth services:"
	@echo "  make kratos           - Start Ory Kratos"
	@echo "  make kratos-down      - Stop Ory Kratos"
	@echo "  make authelia         - Start Authelia"
	@echo "  make authelia-down    - Stop Authelia"
	@echo ""
	@echo "Dev tools:"
	@echo "  make mailslurper      - Start MailSlurper"
	@echo "  make mailslurper-down - Stop MailSlurper"
	@echo "  make mailhog          - Start MailHog"
	@echo "  make mailhog-down     - Stop MailHog"
	@echo ""
	@echo "Common stacks:"
	@echo "  make django-stack     - PostgreSQL + Redis + MailSlurper"
	@echo "  make rails-stack      - PostgreSQL + Redis"
	@echo "  make php-stack        - MariaDB + Redis"
	@echo ""
	@echo "Utility commands:"
	@echo "  make ps               - Show running containers"
	@echo "  make logs             - Show all logs"
	@echo "  make clean            - Stop all services and remove volumes"
	@echo "  make clean-all        - Clean everything including networks"

# Network management
network:
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml up -d

network-down:
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml down

# Database services
postgres:
	docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml up -d

postgres-down:
	docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml down

postgres-shell:
	docker exec -it postgres_container psql -U postgres

mariadb:
	docker-compose -f $(COMPOSE_DIR)/compose.mariadb.yml up -d

mariadb-down:
	docker-compose -f $(COMPOSE_DIR)/compose.mariadb.yml down

mariadb-shell:
	docker exec -it mariadb_container mysql -u root -p

# Cache services
redis:
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml up -d

redis-down:
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml down

redis-shell:
	docker exec -it redis_container redis-cli

# Auth services
kratos:
	@echo "Starting Ory Kratos with PostgreSQL..."
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.kratos-pg.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.kratos.yml up -d

kratos-down:
	docker-compose -f $(COMPOSE_DIR)/compose.kratos.yml down
	docker-compose -f $(COMPOSE_DIR)/compose.kratos-pg.yml down

authelia:
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.authelia.yml up -d

authelia-down:
	docker-compose -f $(COMPOSE_DIR)/compose.authelia.yml down

# Dev tools
mailslurper:
	docker-compose -f $(COMPOSE_DIR)/compose.mailslurper.yml up -d

mailslurper-down:
	docker-compose -f $(COMPOSE_DIR)/compose.mailslurper.yml down

mailhog:
	docker-compose -f $(COMPOSE_DIR)/compose.mailhog.yml up -d

mailhog-down:
	docker-compose -f $(COMPOSE_DIR)/compose.mailhog.yml down

# Common stacks
django-stack:
	@echo "Starting Django development stack (PostgreSQL + Redis + MailSlurper)..."
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.mailslurper.yml up -d
	@echo ""
	@echo "Stack started! Services:"
	@echo "  - PostgreSQL: localhost:5432"
	@echo "  - Redis: localhost:6379"
	@echo "  - MailSlurper: http://localhost:8080"

django-stack-down:
	docker-compose -f $(COMPOSE_DIR)/compose.mailslurper.yml down
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml down
	docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml down

rails-stack:
	@echo "Starting Rails development stack (PostgreSQL + Redis)..."
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml up -d
	@echo ""
	@echo "Stack started! Services:"
	@echo "  - PostgreSQL: localhost:5432"
	@echo "  - Redis: localhost:6379"

rails-stack-down:
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml down
	docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml down

php-stack:
	@echo "Starting PHP development stack (MariaDB + Redis)..."
	docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.mariadb.yml up -d
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml up -d
	@echo ""
	@echo "Stack started! Services:"
	@echo "  - MariaDB: localhost:3306"
	@echo "  - Redis: localhost:6379"

php-stack-down:
	docker-compose -f $(COMPOSE_DIR)/compose.redis.yml down
	docker-compose -f $(COMPOSE_DIR)/compose.mariadb.yml down

# Utility commands
ps:
	@docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "postgres_|mariadb_|redis_|kratos|authelia|mailslurper|mailhog|NAMES" || echo "No buildbox containers running"

logs:
	@echo "Use: docker-compose -f compose/compose.<service>.yml logs -f"
	@echo "Example: docker-compose -f compose/compose.postgres.yml logs -f"

clean:
	@echo "Stopping all buildbox services..."
	-docker-compose -f $(COMPOSE_DIR)/compose.mailslurper.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.mailhog.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.authelia.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.kratos.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.kratos-pg.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.redis.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.mariadb.yml down -v 2>/dev/null
	-docker-compose -f $(COMPOSE_DIR)/compose.postgres.yml down -v 2>/dev/null
	@echo "All services stopped and volumes removed."

clean-all: clean
	@echo "Removing networks..."
	-docker-compose -f $(COMPOSE_DIR)/compose.base-network.yml down 2>/dev/null
	@echo "Cleanup complete!"
