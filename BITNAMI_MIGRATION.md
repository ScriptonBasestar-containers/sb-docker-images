# Bitnami to Official Images Migration Guide

## Overview

This document tracks the migration from Bitnami images to official Docker images across the project. Bitnami images were removed in favor of official images for better compatibility, smaller image sizes, and simplified maintenance.

## Migration Summary

### Migrated Services

| Service | Bitnami Image | Official Image | Status |
|---------|---------------|----------------|--------|
| PostgreSQL | `bitnami/postgresql:15` | `postgres:15-alpine` | ✅ Complete |
| PostgreSQL | `bitnami/postgresql:16` | `postgres:16-alpine` | ✅ Complete |
| Redis | `bitnami/redis:5.0` | `redis:7-alpine` | ✅ Complete |
| Redis | `bitnami/redis:7.4` | `redis:7-alpine` | ✅ Complete |
| Redis | `bitnami/redis` | `redis:7-alpine` | ✅ Complete |

## Files Modified

### 1. postgres-vector/
- **cnpg-vector.dockerfile** (New): CloudNativePG-compatible PostgreSQL with pgvector
- **cluster-example.yaml** (New): CloudNativePG deployment examples
- **README.md**: Comprehensive documentation
- **Makefile**: Automated build/test/deploy workflow
- **Status**: ✅ Complete - Migrated to CloudNativePG

### 2. buildbox/compose/
#### compose.bn-pg15.yml
- **Before**: `bitnami/postgresql:15`
- **After**: `postgres:15-alpine`
- **Changes**:
  - Environment variables: `POSTGRESQL_*` → `POSTGRES_*`
  - Data path: `/bitnami/postgresql` → `/var/lib/postgresql/data`
  - Added healthcheck
  - Removed Bitnami-specific paths

#### compose.bn-redis.yml
- **Before**: `bitnami/redis:7.4`
- **After**: `redis:7-alpine`
- **Changes**:
  - Environment: `REDIS_PASSWORD` → command-line flag `--requirepass`
  - Added data volume `/data`
  - Added healthcheck
  - Enabled volume persistence

#### compose.redis.yml
- **Before**: `bitnami/redis:7.4`
- **After**: `redis:7-alpine`
- **Changes**:
  - Environment: `REDIS_PASSWORD` → command-line flag `--requirepass`
  - Added data volume `/data`
  - Added healthcheck
  - Enabled volume persistence

### 3. nextcloud/standalone/compose.fpm.yml
#### PostgreSQL
- **Before**: `bitnami/postgresql:15`
- **After**: `postgres:16-alpine`
- **Changes**:
  - Updated to PostgreSQL 16
  - Environment variables standardized
  - Data path corrected
  - Added healthcheck

#### Redis
- **Before**: `bitnami/redis`
- **After**: `redis:7-alpine`
- **Changes**:
  - Added password via command flag
  - Added data persistence
  - Added healthcheck

### 4. kratos/compose.yml
- **Before**: `bitnami/postgresql:16`
- **After**: `postgres:16-alpine`
- **Changes**:
  - Environment variables: `POSTGRESQL_*` → `POSTGRES_*`
  - Added data volume
  - Added healthcheck
  - Added postgres volume declaration

### 5. xpressengine/docker-compose.yml
- **Before**: `bitnami/redis:5.0`
- **After**: `redis:7-alpine`
- **Changes**:
  - Upgraded from Redis 5.0 to 7.x
  - Password via command flag
  - Added data persistence
  - Added healthcheck
  - Added volumes section

### 6. discourse/compose.yml
- **Status**: Comments cleaned up
- **Changes**:
  - Removed deprecated Bitnami sidekiq configuration
  - Added deprecation notice for legacy Bitnami paths
  - Updated to standard discourse paths

## Breaking Changes

### PostgreSQL

**Environment Variables:**
```yaml
# Bitnami
- POSTGRESQL_PASSWORD=passw0rd
- POSTGRESQL_POSTGRES_PASSWORD=passw0rd
- POSTGRESQL_USERNAME=user01
- POSTGRESQL_DATABASE=db01

# Official
- POSTGRES_PASSWORD=passw0rd
- POSTGRES_USER=user01        # Optional, defaults to 'postgres'
- POSTGRES_DB=db01            # Optional, defaults to 'postgres'
```

**Data Paths:**
```yaml
# Bitnami
volumes:
  - data:/bitnami/postgresql
  - data:/bitnami/postgresql/data

# Official
volumes:
  - data:/var/lib/postgresql/data
```

**Init Scripts:**
```yaml
# Both support the same init path
volumes:
  - ./init.sql:/docker-entrypoint-initdb.d/init.sql
```

### Redis

**Password Configuration:**
```yaml
# Bitnami
environment:
  - REDIS_PASSWORD=passw0rd

# Official
command: redis-server --requirepass passw0rd
```

**Data Paths:**
```yaml
# Bitnami
volumes:
  - redis:/bitnami/redis/data

# Official
volumes:
  - redis:/data
```

## New Features

### Health Checks

All migrated services now include health checks:

**PostgreSQL:**
```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U postgres"]
  interval: 10s
  timeout: 5s
  retries: 5
```

**Redis:**
```yaml
healthcheck:
  test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
  interval: 10s
  timeout: 3s
  retries: 5
```

### Image Size Reduction

| Image | Bitnami | Official Alpine | Savings |
|-------|---------|-----------------|---------|
| PostgreSQL 15 | ~280MB | ~238MB | ~15% |
| PostgreSQL 16 | ~280MB | ~238MB | ~15% |
| Redis 7 | ~120MB | ~40MB | ~67% |

## Migration Checklist

When migrating a service from Bitnami to official images:

- [ ] Update image name and tag
- [ ] Update environment variables (remove `POSTGRESQL_`, `REDIS_` prefixes where applicable)
- [ ] Update volume paths
- [ ] Add health checks
- [ ] Add data persistence volumes
- [ ] Test with existing data (if applicable)
- [ ] Update documentation
- [ ] Verify application connectivity

## Testing

### PostgreSQL Migration Test

```bash
# Start new container
docker-compose up -d postgres

# Wait for health check
docker-compose ps

# Test connection
docker-compose exec postgres psql -U postgres -c "SELECT version();"

# Test with application
# (Verify application connects successfully)
```

### Redis Migration Test

```bash
# Start new container
docker-compose up -d redis

# Test connection
docker-compose exec redis redis-cli -a password ping

# Test data persistence
docker-compose exec redis redis-cli -a password SET test "hello"
docker-compose restart redis
docker-compose exec redis redis-cli -a password GET test
```

## Rollback Plan

If issues occur, revert to Bitnami images:

```bash
# Stop services
docker-compose down

# Backup data
docker run --rm -v project_postgres:/source -v $(pwd):/backup alpine tar czf /backup/postgres-backup.tar.gz -C /source .

# Edit compose file to use Bitnami images
# Restart services
docker-compose up -d
```

## Benefits

1. **Smaller Images**: Alpine-based images are 15-67% smaller
2. **Official Support**: Direct support from Docker and PostgreSQL/Redis teams
3. **Better Security**: Official images have faster security updates
4. **Simplified Configuration**: Standard environment variables
5. **Wider Compatibility**: Works with more orchestrators (CloudNativePG, etc.)
6. **Health Checks**: Built-in health monitoring
7. **Data Persistence**: Proper volume configuration by default

## Known Issues

None reported as of migration completion.

## References

- [Official PostgreSQL Docker Images](https://hub.docker.com/_/postgres)
- [Official Redis Docker Images](https://hub.docker.com/_/redis)
- [CloudNativePG Documentation](https://cloudnative-pg.io/)
- [Docker Compose Health Checks](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)

## Support

For issues related to this migration:
1. Check this migration guide first
2. Review official Docker image documentation
3. Check application logs for connection errors
4. Verify environment variables match new format
