# Buildbox Integration Guide

Complete guide for integrating Buildbox infrastructure services with your application projects.

## Table of Contents

- [Overview](#overview)
- [Integration Patterns](#integration-patterns)
- [Framework-Specific Guides](#framework-specific-guides)
- [Network Architecture](#network-architecture)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

Buildbox provides reusable infrastructure services that can be integrated with any application project. Instead of duplicating database and cache configurations across projects, use Buildbox as a shared infrastructure layer.

### Benefits

- ✅ **Consistency**: Same infrastructure across all projects
- ✅ **Efficiency**: Share resources between multiple applications
- ✅ **Simplicity**: No need to manage databases in each project
- ✅ **Flexibility**: Mix and match services as needed

### Architecture

```mermaid
graph TB
    subgraph "Your Application"
        App[Django/Rails/PHP App]
    end

    subgraph "Buildbox Infrastructure"
        DB[(PostgreSQL)]
        Cache[(Redis)]
        Queue[Message Queue]
    end

    App -->|Database Queries| DB
    App -->|Caching| Cache
    App -->|Background Jobs| Queue

    style App fill:#e1f5fe
    style DB fill:#c8e6c9
    style Cache fill:#fff9c4
    style Queue fill:#f8bbd0
```

**Simple Integration**: Your application connects to Buildbox services via Docker networks, avoiding the need to configure databases and caches in each project.

---

## Integration Patterns

### Pattern 1: Shared Network (Recommended)

Use Docker networks to connect your application to Buildbox services.

**Buildbox Side:**
```yaml
# buildbox/compose/compose.postgres.yml
services:
  postgres:
    networks:
      - data-network

networks:
  data-network:
    name: buildbox-data
    driver: bridge
```

**Application Side:**
```yaml
# your-app/compose.yml
services:
  web:
    environment:
      DATABASE_URL: postgresql://user:pass@postgres:5432/mydb
    networks:
      - buildbox-data

networks:
  buildbox-data:
    external: true
```

### Pattern 2: Docker Compose Override

Extend your application's compose file with Buildbox services.

```bash
# your-app/docker-compose.override.yml
services:
  web:
    depends_on:
      - postgres
      - redis

  postgres:
    extends:
      file: ../buildbox/compose/compose.postgres.yml
      service: postgres

  redis:
    extends:
      file: ../buildbox/compose/compose.redis.yml
      service: redis
```

### Pattern 3: External Services

Run Buildbox services separately and connect via host networking.

```yaml
# your-app/compose.yml
services:
  web:
    environment:
      DATABASE_HOST: host.docker.internal
      DATABASE_PORT: 5432
      REDIS_HOST: host.docker.internal
      REDIS_PORT: 6379
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

---

## Framework-Specific Guides

### Django + PostgreSQL + Redis + Celery

**Directory Structure:**
```
my-django-app/
├── compose.yml
├── .env
├── manage.py
└── requirements.txt

buildbox/
└── (running services)
```

**Step 1: Start Buildbox Django Stack**
```bash
cd buildbox
make django-stack
```

**Step 2: Configure Django Application**
```yaml
# my-django-app/compose.yml
services:
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    ports:
      - "8000:8000"
    environment:
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/django_db
      REDIS_URL: redis://redis:6379/0
    networks:
      - buildbox-data
    depends_on:
      - postgres
      - redis

  celery:
    build: .
    command: celery -A myapp worker -l info
    environment:
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/django_db
      REDIS_URL: redis://redis:6379/0
    networks:
      - buildbox-data
    depends_on:
      - redis

networks:
  buildbox-data:
    external: true
```

**Step 3: Django Settings**
```python
# settings.py
import dj_database_url
import environ

env = environ.Env()

DATABASES = {
    'default': dj_database_url.config(
        default='postgresql://postgres:postgres@postgres:5432/django_db'
    )
}

CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        'LOCATION': env('REDIS_URL', default='redis://redis:6379/0'),
    }
}

CELERY_BROKER_URL = env('REDIS_URL', default='redis://redis:6379/0')
```

**Step 4: Run Application**
```bash
cd my-django-app
docker compose up -d
```

---

### Rails + PostgreSQL + Redis + Sidekiq

**Step 1: Start Buildbox Rails Stack**
```bash
cd buildbox
make rails-stack
```

**Step 2: Configure Rails Application**
```yaml
# my-rails-app/compose.yml
services:
  web:
    build: .
    command: bundle exec rails server -b 0.0.0.0
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/rails_db
      REDIS_URL: redis://redis:6379/0
    networks:
      - buildbox-data

  sidekiq:
    build: .
    command: bundle exec sidekiq
    environment:
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/rails_db
      REDIS_URL: redis://redis:6379/0
    networks:
      - buildbox-data

networks:
  buildbox-data:
    external: true
```

**Step 3: Rails Database Configuration**
```yaml
# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  url: <%= ENV['DATABASE_URL'] %>

development:
  <<: *default

test:
  <<: *default
  database: rails_test

production:
  <<: *default
```

**Step 4: Sidekiq Configuration**
```ruby
# config/initializers/sidekiq.rb
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://redis:6379/0' }
end
```

---

### PHP (Laravel) + MariaDB + Redis

**Step 1: Start Buildbox PHP Stack**
```bash
cd buildbox
make php-stack
```

**Step 2: Configure Laravel Application**
```yaml
# my-laravel-app/compose.yml
services:
  app:
    build: .
    ports:
      - "8080:80"
    environment:
      DB_CONNECTION: mysql
      DB_HOST: mariadb
      DB_PORT: 3306
      DB_DATABASE: laravel
      DB_USERNAME: root
      DB_PASSWORD: rootpass
      REDIS_HOST: redis
      REDIS_PORT: 6379
    networks:
      - buildbox-data

  queue:
    build: .
    command: php artisan queue:work
    environment:
      DB_CONNECTION: mysql
      DB_HOST: mariadb
      REDIS_HOST: redis
    networks:
      - buildbox-data

networks:
  buildbox-data:
    external: true
```

**Step 3: Laravel Environment**
```env
# .env
APP_NAME=MyApp
DB_CONNECTION=mysql
DB_HOST=mariadb
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=rootpass

REDIS_HOST=redis
REDIS_PORT=6379
QUEUE_CONNECTION=redis
```

---

### Node.js (Express) + PostgreSQL + Redis

**Step 1: Start Buildbox Services**
```bash
cd buildbox
make postgres redis
```

**Step 2: Configure Node.js Application**
```yaml
# my-node-app/compose.yml
services:
  app:
    build: .
    command: npm start
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: development
      DATABASE_URL: postgresql://postgres:postgres@postgres:5432/nodeapp
      REDIS_URL: redis://redis:6379
    networks:
      - buildbox-data

networks:
  buildbox-data:
    external: true
```

**Step 3: Node.js Configuration**
```javascript
// config/database.js
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 
    'postgresql://postgres:postgres@postgres:5432/nodeapp'
});

module.exports = pool;
```

```javascript
// config/redis.js
const redis = require('redis');

const client = redis.createClient({
  url: process.env.REDIS_URL || 'redis://redis:6379'
});

client.connect();

module.exports = client;
```

---

## Network Architecture

### Network Layers

Buildbox uses three network layers for security and isolation:

```mermaid
graph TD
    subgraph app["🌐 app-network (Application Layer)"]
        Web[Nginx/Apache<br/>Web Servers]
        API[API Services<br/>REST/GraphQL]
        App[Application<br/>Django/Rails]
    end

    subgraph intra["🔧 intra-network (Service Layer)"]
        Auth[Auth Services<br/>Kratos/Authelia]
        Mail[Mail Services<br/>SMTP/MailHog]
        Internal[Internal APIs<br/>Microservices]
    end

    subgraph data["💾 data-network (Data Layer)"]
        DB[(PostgreSQL<br/>MariaDB)]
        Cache[(Redis<br/>Memcached)]
        Queue[(Message Queue<br/>RabbitMQ)]
    end

    App --> Auth
    App --> Mail
    App --> Internal

    Auth --> DB
    Internal --> DB
    App --> DB

    App --> Cache
    Internal --> Cache

    App --> Queue

    style app fill:#e3f2fd
    style intra fill:#fff3e0
    style data fill:#f1f8e9
```

**Security Benefits**:
- **app-network**: Public-facing services, can be exposed to internet
- **intra-network**: Internal services, isolated from direct external access
- **data-network**: Data storage, most restricted layer

### Network Configuration

**Create networks:**
```bash
docker network create buildbox-app
docker network create buildbox-intra
docker network create buildbox-data
```

**Use in compose files:**
```yaml
networks:
  buildbox-app:
    external: true
  buildbox-data:
    external: true
```

---

## Best Practices

### 1. Environment Variables

Use `.env` files for configuration:

```bash
# buildbox/.env
POSTGRES_PASSWORD=secure_password_here
POSTGRES_DB=myapp_db
REDIS_PASSWORD=redis_password_here
```

### 2. Health Checks

Always define health checks for reliability:

```yaml
services:
  postgres:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### 3. Volume Management

Use named volumes for persistence:

```yaml
volumes:
  postgres-data:
    name: buildbox-postgres-data
  redis-data:
    name: buildbox-redis-data
```

### 4. Resource Limits

Set resource limits for stability:

```yaml
services:
  postgres:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G
```

### 5. Backup Strategy

Regular backups for production data:

```bash
# PostgreSQL backup
docker compose exec postgres pg_dump -U postgres mydb > backup.sql

# Redis backup
docker compose exec redis redis-cli SAVE
docker cp buildbox-redis:/data/dump.rdb ./backup/
```

---

## Troubleshooting

### Connection Issues

**Problem**: "Connection refused" from application

**Solutions:**
```bash
# 1. Check if Buildbox services are running
cd buildbox && make ps

# 2. Verify network connectivity
docker network inspect buildbox-data

# 3. Test connection from application container
docker compose exec app ping postgres
docker compose exec app nc -zv postgres 5432
```

### Network Not Found

**Problem**: "network buildbox-data declared as external, but could not be found"

**Solution:**
```bash
# Create the network manually
docker network create buildbox-data

# Or use Buildbox Makefile
cd buildbox && make network-create
```

### Database Connection Errors

**Problem**: "FATAL: database does not exist"

**Solutions:**
```bash
# 1. Create database
docker compose exec postgres createdb -U postgres mydb

# 2. Or connect and create manually
docker compose exec postgres psql -U postgres
CREATE DATABASE mydb;
```

### Performance Issues

**Problem**: Slow database queries

**Solutions:**
```bash
# 1. Check resource usage
docker stats

# 2. Increase memory limits in compose file
# 3. Enable query logging for PostgreSQL
# Edit buildbox/compose/compose.postgres.yml
environment:
  POSTGRES_LOG_STATEMENT: all
  POSTGRES_LOG_DURATION: 'on'
```

---

## Quick Reference

### Common Commands

```bash
# Start specific services
make postgres redis        # Start PostgreSQL and Redis
make django-stack          # Start Django stack (PG + Redis + Mail)

# Check status
make ps                    # List running containers

# View logs
make postgres-logs         # PostgreSQL logs
make redis-logs            # Redis logs

# Stop services
make postgres-down         # Stop PostgreSQL
make django-stack-down     # Stop entire Django stack

# Clean up
make clean                 # Stop and remove all containers
make clean-volumes         # Also remove volumes (destructive!)
```

### Connection Strings

**PostgreSQL:**
```
postgresql://postgres:postgres@postgres:5432/mydb
```

**MariaDB:**
```
mysql://root:rootpass@mariadb:3306/mydb
```

**Redis:**
```
redis://redis:6379/0
```

**Redis with password:**
```
redis://:password@redis:6379/0
```

---

## Advanced Topics

### Multi-Project Setup

Run multiple applications sharing same Buildbox:

```
buildbox/          ← Shared infrastructure
├── compose/
└── .env

app1/             ← Application 1
└── compose.yml

app2/             ← Application 2
└── compose.yml

app3/             ← Application 3
└── compose.yml
```

Each app connects to `buildbox-data` network independently.

### CI/CD Integration

Use Buildbox in CI pipelines:

```yaml
# .github/workflows/test.yml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Start Buildbox services
        run: |
          cd buildbox
          make django-stack
      
      - name: Run tests
        run: |
          cd my-app
          docker compose run --rm web pytest
```

### Production Deployment

For production, use separate infrastructure:

```bash
# Development: Use Buildbox
cd buildbox && make django-stack

# Production: Use managed services
# - AWS RDS for PostgreSQL
# - AWS ElastiCache for Redis
# - Configure via environment variables
```

---

## Related Documentation

- [Buildbox README](../buildbox/README.md) - Main Buildbox documentation
- [PORT_STATUS.md](../PORT_STATUS.md) - Port allocation guide
- [ansible-dev](../ansible-dev/README.md) - Infrastructure automation
- [chef-dev](../chef-dev/README.md) - Configuration management

---

**Last Updated:** 2025-11-23  
**Maintained By:** ScriptonBasestar Containers Team
