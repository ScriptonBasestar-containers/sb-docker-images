# Buildbox

Reusable Docker Compose templates collection for common infrastructure services in development and testing environments.

## Overview

Buildbox provides modular, pre-configured Docker Compose templates that you can combine to create custom
development stacks. Instead of writing compose files from scratch, select and combine the services you need.

**Key Features:**
- ✅ Modular compose templates (mix and match)
- ✅ Pre-configured common stacks (Django, Rails, PHP)
- ✅ Network isolation (app/intra/data layers)
- ✅ Production-ready defaults
- ✅ Makefile shortcuts for common operations
- ✅ Multi-language support ready

---

## Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose V2+

### Basic Usage

**1. Clone and configure:**
```bash
cd buildbox
cp .env.example .env
# Edit .env to customize passwords and ports
```

**2. Start a service:**
```bash
# Single service
make postgres

# Or using docker compose directly
docker compose -f compose/compose.postgres.yml up -d
```

**3. Start a complete stack:**
```bash
# Django stack (PostgreSQL + Redis + MailSlurper)
make django-stack

# Rails stack (PostgreSQL + Redis)
make rails-stack

# PHP stack (MariaDB + Redis)
make php-stack
```

**4. Check status:**
```bash
make ps
```

**5. Stop services:**
```bash
make postgres-down
# Or for stacks:
make django-stack-down
```

---

## Available Services

### Databases

| Service | Command | Port | Image |
|---------|---------|------|-------|
| **PostgreSQL** | `make postgres` | 5432 | postgres:15 |
| **MariaDB** | `make mariadb` | 3306 | mariadb:11.8 |

### Cache & Storage

| Service | Command | Port | Image |
|---------|---------|------|-------|
| **Redis** | `make redis` | 6379 | redis:8.2-alpine |

### Authentication

| Service | Command | Ports | Description |
|---------|---------|-------|-------------|
| **Ory Kratos** | `make kratos` | 4433, 4434, 4455 | Identity & user management |
| **Authelia** | `make authelia` | 9091 | SSO & 2FA authentication |

### Development Tools

| Service | Command | Ports | Description |
|---------|---------|-------|-------------|
| **MailSlurper** | `make mailslurper` | 2500, 8080, 8085 | SMTP mail testing |
| **MailHog** | `make mailhog` | 1025, 8025 | SMTP mail testing |

---

## Pre-configured Stacks

### Django Stack

**Services:** PostgreSQL + Redis + MailSlurper

```bash
# Start
make django-stack

# Access
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379
# - MailSlurper: http://localhost:8080

# Stop
make django-stack-down
```

**Use Case:** Django applications with Celery tasks and email testing.

### Rails Stack

**Services:** PostgreSQL + Redis

```bash
# Start
make rails-stack

# Access
# - PostgreSQL: localhost:5432
# - Redis: localhost:6379

# Stop
make rails-stack-down
```

**Use Case:** Ruby on Rails applications with Sidekiq background jobs.

### PHP Stack

**Services:** MariaDB + Redis

```bash
# Start
make php-stack

# Access
# - MariaDB: localhost:3306
# - Redis: localhost:6379

# Stop
make php-stack-down
```

**Use Case:** Laravel, Symfony, or WordPress development.

---

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize:

```bash
cp .env.example .env
```

**Key configuration sections:**

#### PostgreSQL
```bash
POSTGRES_VERSION=15-alpine
POSTGRES_DB=app_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=change-me-strong-password
POSTGRES_PORT=5432
```

#### MariaDB
```bash
MARIADB_VERSION=11.8
MYSQL_ROOT_PASSWORD=change-me-root-password
MYSQL_DATABASE=app_db
MYSQL_USER=app_user
MYSQL_PASSWORD=change-me-strong-password
MYSQL_PORT=3306
```

#### Redis
```bash
REDIS_VERSION=8.2-alpine
REDIS_PORT=6379
# REDIS_PASSWORD=change-me-redis-password  # Optional
```

#### Ory Kratos
```bash
KRATOS_PUBLIC_PORT=4433
KRATOS_ADMIN_PORT=4434
KRATOS_UI_PORT=4455
KRATOS_SECRETS_DEFAULT=change-me-secret-min-32-chars
KRATOS_SECRETS_COOKIE=change-me-cookie-secret-32
```

#### Authelia
```bash
AUTHELIA_PORT=9091
AUTHELIA_JWT_SECRET=change-me-jwt-secret-min-32-chars
AUTHELIA_SESSION_SECRET=change-me-session-secret-32
AUTHELIA_ENCRYPTION_KEY=change-me-encryption-key-32
```

### Network Architecture

Buildbox provides three-tier network isolation:

| Network | Purpose | Services |
|---------|---------|----------|
| **app-network** | Application layer | Frontend, backend APIs |
| **intra-network** | Internal services | Microservices communication |
| **data-network** | Data layer | Databases, cache |

**Create networks first:**
```bash
make network

# Or manually
docker compose -f compose/compose.base-network.yml up -d
```

---

## Usage Patterns

### Pattern 1: Single Service

Start one service independently:

```bash
# PostgreSQL only
docker compose -f compose/compose.postgres.yml up -d

# Redis only
docker compose -f compose/compose.redis.yml up -d
```

### Pattern 2: Multiple Services

Combine multiple templates:

```bash
docker compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  up -d
```

### Pattern 3: With Your Application

Integrate with your app's compose file:

**your-app-compose.yml:**
```yaml
services:
  backend:
    build: .
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://postgres:passw0rd@postgres_dev:5432/app_db
      REDIS_URL: redis://:passw0rd@redis_dev:6379/0
    networks:
      - data-network
    depends_on:
      - postgres
      - redis

networks:
  data-network:
    external: true
    name: buildbox_data-network
```

**Start everything:**
```bash
# Start buildbox services first
docker compose -f compose/compose.postgres.yml up -d
docker compose -f compose/compose.redis.yml up -d

# Then start your app
docker compose -f your-app-compose.yml up -d
```

### Pattern 4: External Network Reference

Reference buildbox networks from your project:

```yaml
# In your project's docker-compose.yml
networks:
  app-network:
    external: true
    name: buildbox_app-network
  data-network:
    external: true
    name: buildbox_data-network
```

---

## Service Details

### PostgreSQL

**Quick access:**
```bash
# Start
make postgres

# Connect via psql
docker exec -it postgres_dev psql -U postgres -d app_db

# Backup
docker exec postgres_dev pg_dump -U postgres app_db > backup.sql

# Restore
docker exec -i postgres_dev psql -U postgres app_db < backup.sql
```

**Connection string:**
```
postgresql://postgres:passw0rd@localhost:5432/app_db
```

### MariaDB

**Quick access:**
```bash
# Start
make mariadb

# Connect via mysql
docker exec -it mariadb_dev mysql -u app_user -p app_db

# Backup
docker exec mariadb_dev mysqldump -u root -p app_db > backup.sql

# Restore
docker exec -i mariadb_dev mysql -u root -p app_db < backup.sql
```

**Connection string:**
```
mysql://app_user:passw0rd@localhost:3306/app_db
```

### Redis

**Quick access:**
```bash
# Start
make redis

# Connect via redis-cli
docker exec -it redis_dev redis-cli -a passw0rd

# Test connection
docker exec -it redis_dev redis-cli -a passw0rd PING
# Output: PONG
```

**Connection string:**
```
redis://:passw0rd@localhost:6379/0
```

### Ory Kratos

**Authentication and identity management:**

```bash
# Start (includes PostgreSQL)
make kratos

# Access points:
# - Public API: http://localhost:4433
# - Admin API: http://localhost:4434
# - UI: http://localhost:4455

# Stop
make kratos-down
```

**Configuration files:** `config/kratos/`

**Use cases:**
- User registration and login
- Password reset flows
- Email verification
- Session management
- OAuth2/OIDC integration

### Authelia

**SSO and 2FA authentication:**

```bash
# Start
make authelia

# Access: http://localhost:9091

# Stop
make authelia-down
```

**Configuration files:** `config/authelia/`

**Use cases:**
- Single Sign-On (SSO)
- Two-Factor Authentication (2FA)
- Access control policies
- LDAP/Active Directory integration

### MailSlurper

**SMTP mail testing (lightweight):**

```bash
# Start
make mailslurper

# Access web UI: http://localhost:8080

# SMTP config in your app:
SMTP_HOST=localhost
SMTP_PORT=2500
```

**Features:**
- Lightweight (single binary)
- Simple web UI
- REST API (port 8085)
- No authentication required

### MailHog

**SMTP mail testing (feature-rich):**

```bash
# Start
make mailhog

# Access web UI: http://localhost:8025

# SMTP config in your app:
SMTP_HOST=localhost
SMTP_PORT=1025
```

**Features:**
- Web and API UI
- Message search
- Email release (forward to real SMTP)
- Jim Chaos Monkey testing

---

## Common Operations

### Show Running Containers

```bash
make ps

# Or detailed view
docker ps --filter "name=buildbox"
```

### View Logs

```bash
# Single service
docker compose -f compose/compose.postgres.yml logs -f

# Multiple services
docker compose \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  logs -f

# Specific container
docker logs -f postgres_dev
```

### Shell Access

```bash
# PostgreSQL
docker exec -it postgres_dev bash

# MariaDB
docker exec -it mariadb_dev bash

# Redis
docker exec -it redis_dev sh
```

### Clean Up

```bash
# Stop all services and remove volumes
make clean

# Also remove networks
make clean-all

# Selective cleanup
make postgres-down
make redis-down
```

---

## Advanced Usage

### Custom Compose File

Create your own template:

**compose/compose.custom.yml:**
```yaml
services:
  myservice:
    image: myapp:latest
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://postgres:passw0rd@postgres_dev:5432/app_db
    networks:
      - app-network
      - data-network
    depends_on:
      - postgres

networks:
  app-network:
    external: true
    name: buildbox_app-network
  data-network:
    external: true
    name: buildbox_data-network
```

**Use it:**
```bash
docker compose \
  -f compose/compose.postgres.yml \
  -f compose/compose.custom.yml \
  up -d
```

### Override Configuration

Create `compose.override.yml` to customize:

```yaml
services:
  postgres:
    ports:
      - "15432:5432"  # Use different port
    environment:
      POSTGRES_DB: my_custom_db
```

### Persistent Data Volumes

Buildbox creates named volumes for persistence:

```bash
# List volumes
docker volume ls | grep buildbox

# Inspect volume
docker volume inspect buildbox_postgres-data

# Backup volume
docker run --rm \
  -v buildbox_postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/postgres-backup.tar.gz /data

# Restore volume
docker run --rm \
  -v buildbox_postgres-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/postgres-backup.tar.gz -C /
```

---

## Security Best Practices

### Production Deployment Checklist

- [ ] **Change all default passwords**: Use strong, random passwords (32+ characters)
  ```bash
  # Generate secure passwords
  openssl rand -base64 32
  ```

- [ ] **Enable TLS/SSL**: Configure encrypted connections for databases
  ```yaml
  # PostgreSQL with SSL
  command: postgres -c ssl=on -c ssl_cert_file=/var/lib/postgresql/server.crt
  ```

- [ ] **Network isolation**: Use Docker networks, don't expose unnecessary ports
  ```yaml
  # Internal only (no ports mapping)
  services:
    postgres:
      # ports: - Remove this in production
      networks:
        - data-network  # Internal only
  ```

- [ ] **Secrets management**: Use Docker secrets or external secret stores
  ```yaml
  secrets:
    postgres_password:
      external: true
  ```

- [ ] **Regular backups**: Automated backup schedule
  ```bash
  # Cron job for daily backups
  0 2 * * * /usr/local/bin/backup-buildbox.sh
  ```

- [ ] **Resource limits**: Set memory and CPU limits
  ```yaml
  services:
    postgres:
      deploy:
        resources:
          limits:
            cpus: '2'
            memory: 2G
  ```

- [ ] **Security updates**: Keep images up to date
  ```bash
  # Update images regularly
  docker compose pull
  docker compose up -d
  ```

- [ ] **Firewall rules**: Restrict access to trusted IPs only

- [ ] **Monitoring**: Set up monitoring and alerting (Prometheus, Grafana)

- [ ] **Audit logs**: Enable and review access logs

### Network Security

**Development (less restrictive):**
```yaml
ports:
  - "5432:5432"  # Exposed to host
```

**Production (more secure):**
```yaml
# No ports mapping - internal network only
networks:
  - data-network
```

**External access via reverse proxy:**
```yaml
services:
  nginx:
    ports:
      - "443:443"
    networks:
      - app-network

  backend:
    # No direct port exposure
    networks:
      - app-network
      - data-network
```

---

## Troubleshooting

### Port Already in Use

**Symptom:** `Error starting userland proxy: listen tcp 0.0.0.0:5432: bind: address already in use`

**Solutions:**

1. Check what's using the port:
   ```bash
   lsof -i :5432
   # Or
   netstat -tulpn | grep 5432
   ```

2. Stop conflicting service:
   ```bash
   sudo systemctl stop postgresql  # System PostgreSQL
   ```

3. Change port in `.env`:
   ```bash
   POSTGRES_PORT=15432
   ```

### Container Fails to Start

**Symptom:** Container exits immediately after starting

**Solutions:**

1. Check logs:
   ```bash
   docker compose -f compose/compose.postgres.yml logs
   ```

2. Verify environment variables:
   ```bash
   docker compose -f compose/compose.postgres.yml config
   ```

3. Check volume permissions:
   ```bash
   docker volume inspect buildbox_postgres-data
   ```

4. Remove and recreate volume:
   ```bash
   make postgres-down
   docker volume rm buildbox_postgres-data
   make postgres
   ```

### Network Not Found

**Symptom:** `network buildbox_app-network declared as external, but could not be found`

**Solution:** Create networks first:
```bash
make network
# Or
docker compose -f compose/compose.base-network.yml up -d
```

### Connection Refused

**Symptom:** Application can't connect to database

**Solutions:**

1. Verify service is running:
   ```bash
   make ps
   docker compose -f compose/compose.postgres.yml ps
   ```

2. Check network connectivity:
   ```bash
   # From your app container
   docker exec your-app ping postgres_dev
   ```

3. Verify credentials in `.env` match your app configuration

4. Check if using correct hostname:
   - **From host:** `localhost:5432`
   - **From container (same network):** `postgres_dev:5432`

### Data Not Persisting

**Symptom:** Data lost after container restart

**Solution:** Ensure volumes are configured:

```bash
# Check if volume exists
docker volume ls | grep postgres

# Verify volume is mounted
docker inspect postgres_dev | grep -A 10 Mounts
```

### Permission Denied

**Symptom:** `Permission denied` when accessing data directories

**Solution:** Fix volume permissions:

```bash
# For PostgreSQL
docker exec postgres_dev chown -R postgres:postgres /var/lib/postgresql/data

# For MariaDB
docker exec mariadb_dev chown -R mysql:mysql /var/lib/mysql
```

---

## Use Cases

### 1. Microservices Development

**Scenario:** Developing multiple microservices that share infrastructure

```bash
# Start shared infrastructure
make network
make postgres
make redis

# Each microservice references external networks
# Service A, B, C can all connect to same DB/Redis
```

### 2. Integration Testing

**Scenario:** Run integration tests against real databases

```bash
# test-stack.yml
services:
  test-runner:
    build: .
    command: pytest tests/integration
    environment:
      DATABASE_URL: postgresql://postgres:passw0rd@postgres_dev:5432/test_db
    networks:
      - data-network
    depends_on:
      - postgres

# Run tests
docker compose -f compose/compose.postgres.yml up -d
docker compose -f test-stack.yml run --rm test-runner
```

### 3. Training/Workshop Environment

**Scenario:** Quickly spin up consistent environments for students

```bash
# Each student runs:
make django-stack

# Everyone has identical:
# - PostgreSQL on localhost:5432
# - Redis on localhost:6379
# - MailSlurper on localhost:8080
```

### 4. CI/CD Pipeline

**Scenario:** Use in GitHub Actions or GitLab CI

```yaml
# .github/workflows/test.yml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Start services
        run: |
          cd buildbox
          docker compose -f compose/compose.postgres.yml up -d
          docker compose -f compose/compose.redis.yml up -d

      - name: Run tests
        run: pytest tests/
        env:
          DATABASE_URL: postgresql://postgres:passw0rd@localhost:5432/test_db
```

### 5. Demo/POC Applications

**Scenario:** Quickly demo application with authentication

```bash
# Full stack with auth
make network
make kratos
make mailslurper

# Now you have:
# - User registration/login (Kratos)
# - Email testing (MailSlurper)
# - Database (PostgreSQL via Kratos)
```

---

## Makefile Commands Reference

### Services

| Command | Description |
|---------|-------------|
| `make postgres` | Start PostgreSQL |
| `make postgres-down` | Stop PostgreSQL |
| `make mariadb` | Start MariaDB |
| `make mariadb-down` | Stop MariaDB |
| `make redis` | Start Redis |
| `make redis-down` | Stop Redis |
| `make kratos` | Start Ory Kratos (with PostgreSQL) |
| `make kratos-down` | Stop Ory Kratos |
| `make authelia` | Start Authelia |
| `make authelia-down` | Stop Authelia |
| `make mailslurper` | Start MailSlurper |
| `make mailslurper-down` | Stop MailSlurper |
| `make mailhog` | Start MailHog |
| `make mailhog-down` | Stop MailHog |

### Stacks

| Command | Description |
|---------|-------------|
| `make django-stack` | PostgreSQL + Redis + MailSlurper |
| `make django-stack-down` | Stop Django stack |
| `make rails-stack` | PostgreSQL + Redis |
| `make rails-stack-down` | Stop Rails stack |
| `make php-stack` | MariaDB + Redis |
| `make php-stack-down` | Stop PHP stack |

### Utilities

| Command | Description |
|---------|-------------|
| `make network` | Create base networks |
| `make network-down` | Remove base networks |
| `make ps` | Show running buildbox containers |
| `make logs` | Show help for viewing logs |
| `make clean` | Stop all services, remove volumes |
| `make clean-all` | Clean everything including networks |
| `make help` | Show all available commands |

---

## Template Files Reference

### Core Templates

| File | Description | Networks | Volumes |
|------|-------------|----------|---------|
| `compose.base-network.yml` | Network definitions | app, intra, data | - |
| `compose.postgres.yml` | PostgreSQL 15 | data-network | postgres |
| `compose.mariadb.yml` | MariaDB 11.8 | data-network | mariadb |
| `compose.redis.yml` | Redis 8.2 | data-network | redis |

### Integration Templates

| File | Description | Depends On |
|------|-------------|------------|
| `compose.bn-pg15.yml` | PostgreSQL with base-network | base-network |
| `compose.bn-redis.yml` | Redis with base-network | base-network |
| `compose.kratos-pg.yml` | Kratos with PostgreSQL | base-network, postgres |
| `compose.kratos.yml` | Kratos full setup | kratos-pg |
| `compose.ory-kratos.yml` | Complete Kratos + UI | base-network |

### Standalone Templates

| File | Description | Networks |
|------|-------------|----------|
| `compose.authelia.yml` | Authelia SSO | app-network |
| `compose.mailslurper.yml` | MailSlurper (standalone) | - |
| `compose.mailhog.yml` | MailHog (standalone) | - |
| `compose.kratos-standalone.yml` | Kratos (no DB) | - |

---

## Comparison with Alternatives

### Buildbox vs Docker Compose Alone

| Aspect | Buildbox | Plain Docker Compose |
|--------|----------|----------------------|
| **Setup time** | Minutes | Hours |
| **Configuration** | Pre-configured | Manual setup |
| **Network isolation** | Built-in 3-tier | Manual configuration |
| **Security defaults** | Production-ready | Varies |
| **Modularity** | Mix and match templates | Single file or manual split |
| **Learning curve** | Low (Makefile commands) | Medium (compose syntax) |

### Buildbox vs Docker Desktop

| Aspect | Buildbox | Docker Desktop |
|--------|----------|----------------|
| **Platform** | Any Docker environment | Desktop only |
| **Customization** | Full control | Limited |
| **CI/CD integration** | Excellent | Limited |
| **Resource usage** | Minimal | Higher (GUI overhead) |
| **Versioning** | Git-tracked configs | GUI settings |

### Buildbox vs Kubernetes

| Aspect | Buildbox | Kubernetes |
|--------|----------|------------|
| **Complexity** | Simple | High |
| **Use case** | Dev/test | Production |
| **Setup time** | Minutes | Hours/days |
| **Overhead** | Minimal | Significant |
| **Orchestration** | Basic | Advanced |

**When to use Buildbox:**
- ✅ Local development
- ✅ Integration testing
- ✅ CI/CD pipelines
- ✅ Training/workshops
- ✅ Quick POCs

**When NOT to use Buildbox:**
- ❌ Production deployments (use Kubernetes, Nomad, or cloud services)
- ❌ Large-scale orchestration (100+ containers)
- ❌ Advanced scheduling requirements
- ❌ Multi-datacenter deployments

---

## Contributing to Buildbox

### Adding a New Service Template

1. Create compose file: `compose/compose.newservice.yml`
2. Add configuration to `.env.example`
3. Add Makefile targets:
   ```makefile
   newservice:
       docker-compose -f $(COMPOSE_DIR)/compose.newservice.yml up -d

   newservice-down:
       docker-compose -f $(COMPOSE_DIR)/compose.newservice.yml down
   ```
4. Update this README with service details

### Template Guidelines

- Use environment variables from `.env`
- Include health checks where applicable
- Use named volumes for persistence
- Follow naming convention: `<service>_dev` for containers
- Include networks: `app-network`, `intra-network`, or `data-network`

---

## See Also

### 📚 Advanced Guides

For comprehensive integration guides and real-world examples, see our advanced documentation:

- **[Buildbox Integration Guide](../docs/BUILDBOX_INTEGRATION.md)** ⭐ **RECOMMENDED**
  - Complete integration patterns for Django, Rails, PHP/Laravel, and Node.js
  - Network architecture and multi-layer security setup
  - Framework-specific configuration examples
  - Troubleshooting common integration issues

- **[Practical Examples](../docs/PRACTICAL_EXAMPLES.md)**
  - Full-stack application examples (Django blog, Rails e-commerce)
  - Microservices architecture patterns
  - Development workflows with hot-reload
  - Production deployment configurations

- **[Performance Guide](../docs/PERFORMANCE.md)**
  - System requirements and resource allocation
  - Database and cache optimization
  - Real-world benchmarks and metrics
  - Monitoring setup (Prometheus, Grafana)

---

## References

### Official Documentation

- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Networks](https://docs.docker.com/network/)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [MariaDB](https://mariadb.org/documentation/)
- [Redis](https://redis.io/documentation)
- [Ory Kratos](https://www.ory.sh/docs/kratos/)
- [Authelia](https://www.authelia.com/overview/prologue/introduction/)
- [MailSlurper](https://github.com/mailslurper/mailslurper)
- [MailHog](https://github.com/mailhog/MailHog)

### Related Projects

- [Docker Awesome Compose](https://github.com/docker/awesome-compose) - Official sample compose files
- [Laradock](https://github.com/laradock/laradock) - PHP/Laravel focused
- [Docksal](https://github.com/docksal/docksal) - Drupal/WordPress focused

### Community Resources

- [Docker Compose Best Practices](https://docs.docker.com/compose/production/)
- [12 Factor App](https://12factor.net/) - Application architecture principles
- [Database CI/CD Patterns](https://www.liquibase.org/get-started/best-practices)

---

## License

This Docker Compose configuration collection is provided for development and testing purposes.
All included software (PostgreSQL, MariaDB, Redis, etc.) is subject to their respective licenses.

---

## Support

For issues, questions, or contributions:

1. Check existing issues in the repository
2. Review troubleshooting section above
3. Check official documentation for specific services
4. Create a new issue with detailed information:
   - Output of `docker compose config`
   - Output of `docker compose logs`
   - Output of `make ps`
   - Your `.env` file (remove sensitive data)
