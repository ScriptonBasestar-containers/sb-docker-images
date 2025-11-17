# 표준 서비스 템플릿 가이드

## 개요

이 문서는 Docker Compose에서 자주 사용되는 서비스(MariaDB, PostgreSQL, Redis, MongoDB 등)의 표준 템플릿과 재사용 가이드를 제공합니다.

## 목차

- [MariaDB/MySQL](#mariadbmysql)
- [PostgreSQL](#postgresql)
- [Redis](#redis)
- [MongoDB](#mongodb)
- [phpMyAdmin](#phpmyadmin)
- [Adminer](#adminer)
- [네트워크 구성](#네트워크-구성)
- [볼륨 관리](#볼륨-관리)

---

## MariaDB/MySQL

### 기본 템플릿

```yaml
services:
  mariadb:
    image: mariadb:11.8  # 또는 mysql:8.0
    container_name: ${PROJECT_NAME:-myapp}_mariadb
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-rootpass}
      MYSQL_DATABASE: ${MYSQL_DATABASE:-appdb}
      MYSQL_USER: ${MYSQL_USER:-appuser}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD:-apppass}
      TZ: ${TZ:-Asia/Seoul}
    volumes:
      - mariadb_data:/var/lib/mysql
      # 초기화 스크립트 (선택사항)
      - ./init-db:/docker-entrypoint-initdb.d
    ports:
      - "${MYSQL_PORT:-3306}:3306"  # 개발 환경에서만
    networks:
      - db-network
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  mariadb_data:
    driver: local

networks:
  db-network:
    driver: bridge
```

### 고급 설정 (성능 최적화)

```yaml
services:
  mariadb:
    image: mariadb:11.8
    command: >
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_unicode_ci
      --max_connections=200
      --innodb_buffer_pool_size=1G
      --innodb_log_file_size=256M
      --innodb_flush_log_at_trx_commit=2
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
    volumes:
      - mariadb_data:/var/lib/mysql
      - ./my.cnf:/etc/mysql/conf.d/custom.cnf:ro
```

### 예시 my.cnf

```ini
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
max_connections=200
innodb_buffer_pool_size=1G
innodb_log_file_size=256M
```

---

## PostgreSQL

### 기본 템플릿

```yaml
services:
  postgres:
    image: postgres:16-alpine  # 또는 확장 버전: scriptonbasestar/postgres-exts:16-essential
    container_name: ${PROJECT_NAME:-myapp}_postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB:-appdb}
      POSTGRES_USER: ${POSTGRES_USER:-appuser}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-apppass}
      TZ: ${TZ:-Asia/Seoul}
      # 성능 설정
      POSTGRES_SHARED_BUFFERS: ${POSTGRES_SHARED_BUFFERS:-256MB}
      POSTGRES_EFFECTIVE_CACHE_SIZE: ${POSTGRES_EFFECTIVE_CACHE_SIZE:-1GB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      # 초기화 스크립트 (선택사항)
      - ./init-db:/docker-entrypoint-initdb.d
    ports:
      - "${POSTGRES_PORT:-5432}:5432"  # 개발 환경에서만
    networks:
      - db-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-appuser}"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
    driver: local

networks:
  db-network:
    driver: bridge
```

### PostgreSQL + pgvector (AI/ML)

```yaml
services:
  postgres:
    image: scriptonbasestar/postgres-exts:16-essential
    environment:
      POSTGRES_DB: aidb
      POSTGRES_USER: aiuser
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    command: >
      postgres
      -c shared_preload_libraries=vector,pg_stat_statements
      -c max_connections=200
      -c shared_buffers=512MB
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-ai.sql:/docker-entrypoint-initdb.d/10-init.sql
```

### 예시 init-ai.sql

```sql
-- 확장 활성화
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 샘플 테이블
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    content TEXT,
    embedding vector(1536)  -- OpenAI embedding dimension
);

-- 벡터 인덱스
CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops);
```

---

## Redis

### 기본 템플릿

```yaml
services:
  redis:
    image: redis:8.2-alpine
    container_name: ${PROJECT_NAME:-myapp}_redis
    restart: unless-stopped
    command: >
      redis-server
      --appendonly yes
      --requirepass ${REDIS_PASSWORD:-redispass}
      --maxmemory 256mb
      --maxmemory-policy allkeys-lru
    volumes:
      - redis_data:/data
    ports:
      - "${REDIS_PORT:-6379}:6379"  # 개발 환경에서만
    networks:
      - cache-network
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

volumes:
  redis_data:
    driver: local

networks:
  cache-network:
    driver: bridge
```

### Redis Cluster (고가용성)

```yaml
services:
  redis-master:
    image: redis:8.2-alpine
    command: redis-server --appendonly yes --requirepass ${REDIS_PASSWORD}

  redis-replica-1:
    image: redis:8.2-alpine
    command: redis-server --replicaof redis-master 6379 --requirepass ${REDIS_PASSWORD}
    depends_on:
      - redis-master

  redis-replica-2:
    image: redis:8.2-alpine
    command: redis-server --replicaof redis-master 6379 --requirepass ${REDIS_PASSWORD}
    depends_on:
      - redis-master
```

---

## MongoDB

### 기본 템플릿

```yaml
services:
  mongodb:
    image: mongo:8
    container_name: ${PROJECT_NAME:-myapp}_mongodb
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_ROOT_USER:-root}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD:-rootpass}
      MONGO_INITDB_DATABASE: ${MONGO_DATABASE:-appdb}
      TZ: ${TZ:-Asia/Seoul}
    volumes:
      - mongodb_data:/data/db
      - mongodb_config:/data/configdb
      # 초기화 스크립트
      - ./init-mongo.js:/docker-entrypoint-initdb.d/init.js:ro
    ports:
      - "${MONGO_PORT:-27017}:27017"
    networks:
      - db-network
    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test --quiet
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  mongodb_data:
  mongodb_config:
```

---

## phpMyAdmin

### 기본 템플릿

```yaml
services:
  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: ${PROJECT_NAME:-myapp}_phpmyadmin
    restart: unless-stopped
    environment:
      PMA_HOST: mariadb  # MariaDB 서비스명
      PMA_PORT: 3306
      PMA_USER: ${MYSQL_USER:-root}
      PMA_PASSWORD: ${MYSQL_PASSWORD}
      UPLOAD_LIMIT: 100M
      MEMORY_LIMIT: 512M
    ports:
      - "${PMA_PORT:-9000}:80"
    networks:
      - db-network
    depends_on:
      - mariadb
```

### 여러 DB 서버 관리

```yaml
services:
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
      PMA_HOSTS: mariadb1,mariadb2,mariadb3
      PMA_PORTS: 3306,3306,3306
      PMA_VERBOSES: Production,Staging,Development
```

---

## Adminer

### 기본 템플릿 (다중 DB 지원)

```yaml
services:
  adminer:
    image: adminer:latest
    container_name: ${PROJECT_NAME:-myapp}_adminer
    restart: unless-stopped
    environment:
      ADMINER_DEFAULT_SERVER: mariadb  # 또는 postgres, mongodb
      ADMINER_DESIGN: nette  # 테마: nette, pepa-linha, price 등
    ports:
      - "${ADMINER_PORT:-9001}:8080"
    networks:
      - db-network
    depends_on:
      - mariadb
      - postgres
```

**Adminer 장점**: MySQL, PostgreSQL, SQLite, MongoDB, Elasticsearch 등 다양한 DB 지원

---

## 네트워크 구성

### 단일 네트워크 (간단한 앱)

```yaml
services:
  app:
    networks:
      - app-network

  db:
    networks:
      - app-network

networks:
  app-network:
    driver: bridge
```

### 다중 네트워크 (보안 분리)

```yaml
services:
  # 프론트엔드 (외부 접근)
  nginx:
    networks:
      - frontend

  # 백엔드 애플리케이션
  app:
    networks:
      - frontend  # nginx와 통신
      - backend   # DB와 통신

  # 데이터베이스 (내부만)
  db:
    networks:
      - backend

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # 외부 접근 차단
```

### 외부 네트워크 연결

```yaml
services:
  app:
    networks:
      - default
      - shared_network

networks:
  shared_network:
    external: true  # 다른 docker-compose에서 생성된 네트워크
```

---

## 볼륨 관리

### 명명된 볼륨 (Named Volumes)

```yaml
volumes:
  db_data:
    driver: local
  cache_data:
    driver: local
```

### 바인드 마운트 (개발 환경)

```yaml
services:
  app:
    volumes:
      - ./app:/var/www/html:rw  # 읽기/쓰기
      - ./config:/etc/app:ro    # 읽기 전용
```

### NFS 볼륨 (공유 스토리지)

```yaml
volumes:
  shared_data:
    driver: local
    driver_opts:
      type: nfs
      o: addr=192.168.1.100,rw
      device: ":/path/to/nfs/share"
```

### 볼륨 백업

```bash
# 볼륨 백업
docker run --rm \
  -v myapp_db_data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/db-backup-$(date +%Y%m%d).tar.gz /data

# 볼륨 복원
docker run --rm \
  -v myapp_db_data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/db-backup-20240101.tar.gz -C /
```

---

## 완전한 스택 예시

### LAMP 스택 (WordPress)

```yaml
services:
  wordpress:
    image: wordpress:latest
    environment:
      WORDPRESS_DB_HOST: mariadb
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "8100:80"
    networks:
      - frontend
      - backend
    depends_on:
      - mariadb

  mariadb:
    image: mariadb:11.8
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - mariadb_data:/var/lib/mysql
    networks:
      - backend

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
      PMA_HOST: mariadb
    ports:
      - "9100:80"
    networks:
      - backend
    depends_on:
      - mariadb

volumes:
  wordpress_data:
  mariadb_data:

networks:
  frontend:
  backend:
```

### MERN 스택 (Node.js + MongoDB + Redis)

```yaml
services:
  app:
    build: .
    environment:
      MONGO_URI: mongodb://mongodb:27017/appdb
      REDIS_URL: redis://redis:6379
    ports:
      - "3000:3000"
    networks:
      - app-network
    depends_on:
      - mongodb
      - redis

  mongodb:
    image: mongo:8
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
    volumes:
      - mongo_data:/data/db
    networks:
      - app-network

  redis:
    image: redis:8.2-alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - app-network

volumes:
  mongo_data:
  redis_data:

networks:
  app-network:
```

### Django + PostgreSQL + Redis

```yaml
services:
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:8000
    environment:
      DATABASE_URL: postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}
      REDIS_URL: redis://redis:6379/0
    volumes:
      - .:/app
    ports:
      - "8000:8000"
    networks:
      - app-network
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network

  redis:
    image: redis:8.2-alpine
    networks:
      - app-network

volumes:
  postgres_data:

networks:
  app-network:
```

---

## 환경 변수 템플릿

### .env 파일 예시

```bash
# 프로젝트 설정
PROJECT_NAME=myapp
TZ=Asia/Seoul

# MariaDB/MySQL
MYSQL_ROOT_PASSWORD=your-root-password-here
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=your-password-here
MYSQL_PORT=3306

# PostgreSQL
POSTGRES_DB=appdb
POSTGRES_USER=appuser
POSTGRES_PASSWORD=your-password-here
POSTGRES_PORT=5432

# Redis
REDIS_PASSWORD=your-redis-password
REDIS_PORT=6379

# MongoDB
MONGO_ROOT_USER=root
MONGO_ROOT_PASSWORD=your-mongo-password
MONGO_DATABASE=appdb
MONGO_PORT=27017

# 관리 도구
PMA_PORT=9000
ADMINER_PORT=9001
```

---

## 재사용 가이드

### 1. docker-compose.yml에서 참조

```yaml
# 기본 서비스 정의
x-mariadb-defaults: &mariadb-defaults
  image: mariadb:11.8
  restart: unless-stopped
  environment: &mariadb-env
    MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    TZ: Asia/Seoul

services:
  mariadb1:
    <<: *mariadb-defaults
    environment:
      <<: *mariadb-env
      MYSQL_DATABASE: db1

  mariadb2:
    <<: *mariadb-defaults
    environment:
      <<: *mariadb-env
      MYSQL_DATABASE: db2
```

### 2. 별도 파일로 분리

```bash
# docker-compose.base.yml
services:
  mariadb:
    image: mariadb:11.8
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}

# docker-compose.yml
services:
  app:
    build: .

# 사용
docker-compose -f docker-compose.base.yml -f docker-compose.yml up
```

### 3. 프로필 사용 (Docker Compose v2.20+)

```yaml
services:
  app:
    profiles: ["app"]

  mariadb:
    profiles: ["db", "full"]

  redis:
    profiles: ["cache", "full"]

# 사용
docker-compose --profile full up        # 모든 서비스
docker-compose --profile app up         # 앱만
docker-compose --profile db --profile cache up  # DB + 캐시
```

---

## 참고 자료

- [Docker Compose 공식 문서](https://docs.docker.com/compose/)
- [Docker Hub - 공식 이미지](https://hub.docker.com/search?q=&type=image&image_filter=official)
- [12 Factor App](https://12factor.net/)
- [Docker Compose Best Practices](https://docs.docker.com/compose/production/)
