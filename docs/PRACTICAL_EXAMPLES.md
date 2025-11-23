# Practical Examples

Real-world examples for using sb-docker-images in common development scenarios.

## Table of Contents

- [Full Stack Applications](#full-stack-applications)
- [Microservices Architecture](#microservices-architecture)
- [Development Workflows](#development-workflows)
- [Production Deployment](#production-deployment)

---

## Full Stack Applications

### Example 1: Django Blog with Full Stack

**Scenario**: Create a blog application with Django, PostgreSQL, Redis, Celery, and Nginx.

**Architecture**:

```mermaid
graph TB
    Client[👤 User/Browser]

    subgraph frontend["Frontend Layer"]
        Nginx[Nginx<br/>Reverse Proxy<br/>:80]
    end

    subgraph backend["Backend Layer"]
        Django[Django/Gunicorn<br/>Web Application<br/>:8000]
        Celery[Celery Worker<br/>Background Tasks]
        CeleryBeat[Celery Beat<br/>Scheduler]
    end

    subgraph data["Data Layer"]
        PG[(PostgreSQL<br/>:5432)]
        Redis[(Redis<br/>:6379)]
    end

    subgraph storage["Storage"]
        Static[Static Files<br/>Volume]
        Media[Media Files<br/>Volume]
    end

    Client -->|HTTP| Nginx
    Nginx -->|Proxy Pass| Django
    Nginx -.->|Serve| Static
    Nginx -.->|Serve| Media

    Django -->|ORM| PG
    Django -->|Cache/Sessions| Redis
    Django -->|Enqueue Jobs| Redis

    Celery -->|Consume Jobs| Redis
    Celery -->|Store Results| PG

    CeleryBeat -->|Schedule Jobs| Redis

    Django -.->|Write| Static
    Django -.->|Upload| Media

    style Client fill:#e1f5fe
    style frontend fill:#fff3e0
    style backend fill:#f3e5f5
    style data fill:#e8f5e9
    style storage fill:#fff9c4
```

**Component Roles**:
- **Nginx**: Serves static files, proxies dynamic requests to Django
- **Django**: Handles HTTP requests, business logic, ORM
- **Celery Worker**: Processes background tasks (emails, reports, etc.)
- **Celery Beat**: Schedules periodic tasks
- **PostgreSQL**: Persistent data storage
- **Redis**: Caching, sessions, and message broker for Celery

**Project Structure**:
```
blog-project/
├── docker-compose.yml
├── .env
├── nginx/
│   └── nginx.conf
├── app/
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── manage.py
│   └── blog/
└── celery/
    └── tasks.py
```

**docker-compose.yml**:
```yaml
version: '3.9'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ${DB_NAME:-blogdb}
      POSTGRES_USER: ${DB_USER:-bloguser}
      POSTGRES_PASSWORD: ${DB_PASSWORD:-secret}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER:-bloguser}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  web:
    build: ./app
    command: gunicorn blog.wsgi:application --bind 0.0.0.0:8000 --workers 3
    environment:
      DATABASE_URL: postgresql://${DB_USER:-bloguser}:${DB_PASSWORD:-secret}@postgres:5432/${DB_NAME:-blogdb}
      REDIS_URL: redis://redis:6379/0
      DJANGO_SETTINGS_MODULE: blog.settings.production
    volumes:
      - ./app:/app
      - static-files:/app/staticfiles
      - media-files:/app/media
    networks:
      - backend
      - frontend
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

  celery:
    build: ./app
    command: celery -A blog worker -l info
    environment:
      DATABASE_URL: postgresql://${DB_USER:-bloguser}:${DB_PASSWORD:-secret}@postgres:5432/${DB_NAME:-blogdb}
      REDIS_URL: redis://redis:6379/0
    volumes:
      - ./app:/app
    networks:
      - backend
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy

  celery-beat:
    build: ./app
    command: celery -A blog beat -l info
    environment:
      DATABASE_URL: postgresql://${DB_USER:-bloguser}:${DB_PASSWORD:-secret}@postgres:5432/${DB_NAME:-blogdb}
      REDIS_URL: redis://redis:6379/0
    volumes:
      - ./app:/app
    networks:
      - backend
    depends_on:
      - redis

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - static-files:/static:ro
      - media-files:/media:ro
    networks:
      - frontend
    depends_on:
      - web

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge

volumes:
  postgres-data:
  redis-data:
  static-files:
  media-files:
```

**Usage**:
```bash
# 1. Setup
cp .env.example .env
# Edit .env with your configuration

# 2. Build and start
docker compose up -d

# 3. Run migrations
docker compose exec web python manage.py migrate

# 4. Create superuser
docker compose exec web python manage.py createsuperuser

# 5. Collect static files
docker compose exec web python manage.py collectstatic --noinput

# 6. Access
# - Application: http://localhost
# - Admin: http://localhost/admin
```

---

### Example 2: Rails E-commerce with Microservices

**Scenario**: E-commerce platform with Rails, PostgreSQL, Redis, Sidekiq, and Elasticsearch.

**Services**:
- **Web**: Rails application
- **API**: JSON API service
- **Worker**: Sidekiq background jobs
- **Search**: Elasticsearch full-text search
- **Cache**: Redis for sessions and caching

**docker-compose.yml**:
```yaml
version: '3.9'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: ecommerce_dev
      POSTGRES_USER: rails
      POSTGRES_PASSWORD: railspass
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - backend

  redis:
    image: redis:7-alpine
    networks:
      - backend

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    volumes:
      - es-data:/usr/share/elasticsearch/data
    networks:
      - backend

  web:
    build: .
    command: bundle exec rails server -b 0.0.0.0
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgresql://rails:railspass@postgres/ecommerce_dev
      REDIS_URL: redis://redis:6379/0
      ELASTICSEARCH_URL: http://elasticsearch:9200
    volumes:
      - .:/app
      - bundle-cache:/usr/local/bundle
    networks:
      - backend
      - frontend
    depends_on:
      - postgres
      - redis
      - elasticsearch

  sidekiq:
    build: .
    command: bundle exec sidekiq
    environment:
      DATABASE_URL: postgresql://rails:railspass@postgres/ecommerce_dev
      REDIS_URL: redis://redis:6379/0
    volumes:
      - .:/app
      - bundle-cache:/usr/local/bundle
    networks:
      - backend
    depends_on:
      - postgres
      - redis

networks:
  frontend:
  backend:

volumes:
  postgres-data:
  es-data:
  bundle-cache:
```

---

## Microservices Architecture

### Example 3: API Gateway + Microservices

**Scenario**: Modern microservices architecture with API gateway, multiple services, and shared infrastructure.

**Architecture**:

```mermaid
graph TB
    Client[👤 Client/Browser]

    subgraph gateway["API Gateway"]
        Nginx[Nginx<br/>Reverse Proxy<br/>:80]
    end

    subgraph services["Microservices Layer"]
        UserSvc[User Service<br/>:3000]
        ProductSvc[Product Service<br/>:3001]
        OrderSvc[Order Service<br/>:3002]
    end

    subgraph persistence["Data Layer"]
        PG_Users[(PostgreSQL<br/>users DB)]
        Mongo[(MongoDB<br/>products DB)]
        PG_Orders[(PostgreSQL<br/>orders DB)]
        Redis[(Redis<br/>Shared Cache)]
    end

    Client -->|HTTP/HTTPS| Nginx

    Nginx -->|/api/users| UserSvc
    Nginx -->|/api/products| ProductSvc
    Nginx -->|/api/orders| OrderSvc

    UserSvc --> PG_Users
    UserSvc -.->|Cache| Redis

    ProductSvc --> Mongo
    ProductSvc -.->|Cache| Redis

    OrderSvc --> PG_Orders
    OrderSvc -.->|Cache| Redis
    OrderSvc -.->|User Data| UserSvc
    OrderSvc -.->|Product Data| ProductSvc

    style Client fill:#e1f5fe
    style gateway fill:#fff3e0
    style services fill:#f3e5f5
    style persistence fill:#e8f5e9
```

**Key Features**:
- **API Gateway**: Single entry point for all client requests
- **Service Independence**: Each microservice has its own database
- **Shared Cache**: Redis for cross-service caching
- **Service Communication**: Inter-service API calls for data aggregation

**Project Structure**:
```
microservices/
├── api-gateway/
│   ├── nginx.conf
│   └── docker-compose.yml
├── user-service/
│   ├── Dockerfile
│   └── compose.yml
├── product-service/
│   ├── Dockerfile
│   └── compose.yml
├── order-service/
│   ├── Dockerfile
│   └── compose.yml
└── docker-compose.yml  # Main orchestration
```

**docker-compose.yml** (Main):
```yaml
version: '3.9'

services:
  # Infrastructure
  postgres-users:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: users
    networks:
      - data-tier

  postgres-orders:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: orders
    networks:
      - data-tier

  mongodb:
    image: mongo:7
    networks:
      - data-tier

  redis:
    image: redis:7-alpine
    networks:
      - data-tier

  # Microservices
  user-service:
    build: ./user-service
    environment:
      DATABASE_URL: postgresql://postgres@postgres-users/users
      REDIS_URL: redis://redis:6379/0
    networks:
      - api-tier
      - data-tier

  product-service:
    build: ./product-service
    environment:
      MONGODB_URI: mongodb://mongodb:27017/products
      REDIS_URL: redis://redis:6379/0
    networks:
      - api-tier
      - data-tier

  order-service:
    build: ./order-service
    environment:
      DATABASE_URL: postgresql://postgres@postgres-orders/orders
      REDIS_URL: redis://redis:6379/0
      USER_SERVICE_URL: http://user-service:3000
      PRODUCT_SERVICE_URL: http://product-service:3001
    networks:
      - api-tier
      - data-tier

  # API Gateway
  api-gateway:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./api-gateway/nginx.conf:/etc/nginx/nginx.conf:ro
    networks:
      - api-tier
    depends_on:
      - user-service
      - product-service
      - order-service

networks:
  api-tier:
  data-tier:
```

**nginx.conf** (API Gateway):
```nginx
upstream user-service {
    server user-service:3000;
}

upstream product-service {
    server product-service:3001;
}

upstream order-service {
    server order-service:3002;
}

server {
    listen 80;

    location /api/users {
        proxy_pass http://user-service;
    }

    location /api/products {
        proxy_pass http://product-service;
    }

    location /api/orders {
        proxy_pass http://order-service;
    }
}
```

---

## Development Workflows

### Example 4: Hot-Reload Development Environment

**Scenario**: Frontend (React) + Backend (Node.js) with hot-reload for rapid development.

**docker-compose.dev.yml**:
```yaml
version: '3.9'

services:
  frontend:
    build:
      context: ./frontend
      target: development
    command: npm run dev
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules  # Anonymous volume for node_modules
    environment:
      - NODE_ENV=development
      - WATCHPACK_POLLING=true  # For file watching in Docker
      - API_URL=http://backend:4000
    networks:
      - app-network

  backend:
    build:
      context: ./backend
      target: development
    command: npm run dev  # Uses nodemon for auto-reload
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://dev:dev@postgres/devdb
      - REDIS_URL=redis://redis:6379
    networks:
      - app-network
      - data-network
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
    volumes:
      - postgres-dev-data:/var/lib/postgresql/data
    networks:
      - data-network

  redis:
    image: redis:7-alpine
    networks:
      - data-network

networks:
  app-network:
  data-network:

volumes:
  postgres-dev-data:
```

**Usage**:
```bash
# Development
docker compose -f docker-compose.dev.yml up

# Production build
docker compose -f docker-compose.yml build
docker compose -f docker-compose.yml up -d
```

---

### Example 5: Testing Environment with Fixtures

**Scenario**: Automated testing with isolated database and pre-loaded test data.

**docker-compose.test.yml**:
```yaml
version: '3.9'

services:
  test-db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: test_db
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
    tmpfs:
      - /var/lib/postgresql/data  # In-memory for speed
    networks:
      - test-network

  test-redis:
    image: redis:7-alpine
    networks:
      - test-network

  test-runner:
    build:
      context: .
      target: test
    command: pytest tests/ -v --cov=app --cov-report=html
    environment:
      DATABASE_URL: postgresql://test:test@test-db/test_db
      REDIS_URL: redis://test-redis:6379/0
      TESTING: "true"
    volumes:
      - .:/app
      - ./htmlcov:/app/htmlcov
    networks:
      - test-network
    depends_on:
      - test-db
      - test-redis

networks:
  test-network:
```

**Usage**:
```bash
# Run tests
docker compose -f docker-compose.test.yml run --rm test-runner

# Run specific test
docker compose -f docker-compose.test.yml run --rm test-runner pytest tests/test_user.py

# Run with coverage
docker compose -f docker-compose.test.yml run --rm test-runner pytest --cov=app

# Cleanup
docker compose -f docker-compose.test.yml down -v
```

---

## Production Deployment

### Example 6: Production-Ready Stack with Monitoring

**Scenario**: Production deployment with monitoring, logging, and health checks.

**docker-compose.prod.yml**:
```yaml
version: '3.9'

services:
  app:
    image: myapp:${VERSION:-latest}
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
        max_attempts: 3
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
    environment:
      NODE_ENV: production
      DATABASE_URL: ${DATABASE_URL}
      REDIS_URL: ${REDIS_URL}
    networks:
      - app-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
      - nginx-logs:/var/log/nginx
    networks:
      - app-network
    deploy:
      restart_policy:
        condition: any

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    networks:
      - monitoring
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD}
    networks:
      - monitoring

networks:
  app-network:
  monitoring:

volumes:
  nginx-logs:
  prometheus-data:
  grafana-data:
```

---

## Quick Reference

### Common Patterns

**1. Database Initialization**:
```bash
# Run migrations
docker compose exec app python manage.py migrate
docker compose exec app bundle exec rails db:migrate
docker compose exec app npm run migrate

# Seed data
docker compose exec app python manage.py loaddata fixtures.json
docker compose exec app bundle exec rails db:seed
```

**2. Backup & Restore**:
```bash
# Backup
docker compose exec postgres pg_dump -U user dbname > backup.sql

# Restore
docker compose exec -T postgres psql -U user dbname < backup.sql
```

**3. Log Management**:
```bash
# View logs
docker compose logs -f app
docker compose logs --tail=100 app

# Export logs
docker compose logs app > app.log
```

---

**Related Documentation**:
- [Buildbox Integration Guide](./BUILDBOX_INTEGRATION.md)
- [Port Guide](../PORT_GUIDE.md)
- [Contributing Guide](../CONTRIBUTING.md)

**Last Updated:** 2025-11-23
