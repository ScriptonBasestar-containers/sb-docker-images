# CLAUDE.md - Databases & Cache

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Database Systems & Caching
**Projects**: 4 (PostgreSQL Extensions, MariaDB, Redis, Memcached)
**Focus**: Data persistence, caching, performance optimization

## Projects

1. **postgres-exts** - PostgreSQL with custom extensions
2. **mariadb** - MySQL-compatible relational database
3. **redis** - In-memory data store, cache, message broker
4. **memcached** - High-performance memory caching

## Configuration Patterns

```bash
# PostgreSQL
POSTGRES_USER=dbuser
POSTGRES_PASSWORD=secure_pass
POSTGRES_DB=app_db
POSTGRES_EXTENSIONS=pg_trgm,uuid-ossp

# MariaDB
MYSQL_ROOT_PASSWORD=root_pass
MYSQL_USER=app_user
MYSQL_PASSWORD=app_pass
MYSQL_DATABASE=app_db

# Redis
REDIS_PASSWORD=redis_pass
REDIS_MAXMEMORY=256mb
REDIS_MAXMEMORY_POLICY=allkeys-lru
```

## Performance Tuning

- **PostgreSQL**: Shared buffers, work_mem, max_connections
- **MariaDB**: InnoDB buffer pool, query cache
- **Redis**: Persistence mode (RDB vs AOF), eviction policies
- **Memcached**: Memory allocation, connection limits

## Backup Strategies

- **PostgreSQL**: pg_dump, WAL archiving, PITR
- **MariaDB**: mysqldump, binary logs, replication
- **Redis**: RDB snapshots, AOF persistence
- **Memcached**: No persistence (cache only)

---

**Category**: database
**Last Updated**: 2025-12-28
