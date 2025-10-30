# PostgreSQL with pgvector for CloudNativePG

CloudNativePG-compatible PostgreSQL 16 image with pgvector extension and extensible architecture for additional PostgreSQL extensions.

## Features

- **Base**: Official PostgreSQL 16
- **Extensions Included**:
  - `pgvector` v0.7.4 - Vector similarity search
- **Optional Extensions** (commented in Dockerfile):
  - `pg_cron` - Job scheduler
  - `timescaledb` - Time-series database
- **CloudNativePG Utilities**:
  - barman-cli
  - pgbackrest
  - postgresql-client
- **Health Check**: Built-in pg_isready monitoring

## Why CloudNativePG?

Migrated from Bitnami PostgreSQL Helm Chart to CloudNativePG for:

-  Native Kubernetes operator with CRD-based management
-  Built-in backup/restore with Barman
-  Declarative configuration
-  Better HA/failover support
-  Official PostgreSQL base image compatibility
-  Easier extension management

## Build

```bash
# Build with default pgvector version
docker build -f cnpg-vector.dockerfile -t postgres-vector:16 .

# Build with specific pgvector version
docker build \
  --build-arg PGVECTOR_VERSION=v0.7.4 \
  -f cnpg-vector.dockerfile \
  -t postgres-vector:16-v0.7.4 .

# Push to registry
docker tag postgres-vector:16 scriptonbasestar/postgres-vector:16
docker push scriptonbasestar/postgres-vector:16
```

## Adding More Extensions

### Method 1: Edit Dockerfile (Recommended)

Uncomment or add extension build blocks in [`cnpg-vector.dockerfile`](cnpg-vector.dockerfile):

```dockerfile
# Example: Enable pg_cron
ARG PGCRON_VERSION=v1.6.2
RUN cd /tmp && \
    git clone --branch ${PGCRON_VERSION} https://github.com/citusdata/pg_cron.git && \
    cd pg_cron && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pg_cron
```

### Method 2: Layer on Top

```dockerfile
FROM scriptonbasestar/postgres-vector:16

RUN apt-get update && \
    apt-get install -y postgresql-16-postgis-3 && \
    rm -rf /var/lib/apt/lists/*
```

## Usage with CloudNativePG

### 1. Install CloudNativePG Operator

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.22/releases/cnpg-1.22.0.yaml
```

### 2. Create Cluster

```yaml
# cluster.yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgres-vector
spec:
  instances: 1

  # Use custom image with pgvector
  imageName: scriptonbasestar/postgres-vector:16

  postgresql:
    parameters:
      shared_preload_libraries: "vector"
      max_connections: "200"
      shared_buffers: "256MB"

  bootstrap:
    initdb:
      database: app
      owner: app
      postInitSQL:
        - CREATE EXTENSION IF NOT EXISTS vector;

  storage:
    size: 10Gi
    storageClass: local-path

  backup:
    barmanObjectStore:
      destinationPath: s3://postgres-backups/
      s3Credentials:
        accessKeyId:
          name: backup-creds
          key: ACCESS_KEY_ID
        secretAccessKey:
          name: backup-creds
          key: ACCESS_SECRET_KEY
      wal:
        compression: gzip
    retentionPolicy: "30d"

  monitoring:
    enablePodMonitor: true
```

### 3. Deploy

```bash
kubectl apply -f cluster.yaml

# Check status
kubectl get cluster postgres-vector
kubectl get pods -l cnpg.io/cluster=postgres-vector

# Get connection details
kubectl get secret postgres-vector-app -o jsonpath='{.data.password}' | base64 -d
```

## Enable pgvector Extension

```sql
-- Connect to database
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify installation
SELECT * FROM pg_available_extensions WHERE name = 'vector';

-- Test vector operations
CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));
INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');
SELECT * FROM items ORDER BY embedding <-> '[3,1,2]' LIMIT 1;
```

## Configuration Examples

### High-Performance Vector Search

```yaml
postgresql:
  parameters:
    shared_preload_libraries: "vector"
    shared_buffers: "4GB"
    effective_cache_size: "12GB"
    maintenance_work_mem: "1GB"
    max_parallel_workers_per_gather: "4"
```

### Enable Additional Extensions

```yaml
bootstrap:
  initdb:
    postInitSQL:
      - CREATE EXTENSION IF NOT EXISTS vector;
      - CREATE EXTENSION IF NOT EXISTS pg_cron;
      - CREATE EXTENSION IF NOT EXISTS timescaledb;
```

## Migration from Bitnami

### Data Migration

```bash
# Export from Bitnami PostgreSQL
kubectl exec -it bitnami-postgresql-0 -- \
  pg_dump -U postgres -d mydb > backup.sql

# Import to CloudNativePG
kubectl exec -it postgres-vector-1 -- \
  psql -U app -d app < backup.sql
```

### Values Comparison

| Bitnami Feature | CloudNativePG Equivalent |
|----------------|--------------------------|
| `metrics.enabled` | `monitoring.enablePodMonitor` |
| `backup.cronjob` | `backup.barmanObjectStore` |
| `volumePermissions` | Handled by operator |
| `initdb.scripts` | `bootstrap.initdb.postInitSQL` |
| `primary.persistence` | `storage.size` |

## Troubleshooting

### Extension Not Found

```bash
# Verify extension files exist in pod
kubectl exec -it postgres-vector-1 -- \
  ls -lh /usr/lib/postgresql/16/lib/vector.so

# Check extension availability
kubectl exec -it postgres-vector-1 -- \
  psql -U postgres -c "SELECT * FROM pg_available_extensions WHERE name = 'vector';"
```

### Build Issues

```bash
# Check build logs
docker build --progress=plain -f cnpg-vector.dockerfile .

# Verify PostgreSQL version
docker run --rm postgres-vector:16 postgres --version
```

## Available Extensions

| Extension | Version | Status | Use Case |
|-----------|---------|--------|----------|
| pgvector | v0.7.4 |  Enabled | Vector similarity search |
| pg_cron | v1.6.2 | =� Commented | Job scheduling |
| timescaledb | 2.14.2 | =� Commented | Time-series data |
| PostGIS | - | =� Not included | Geospatial data |
| pg_partman | - | =� Not included | Partition management |

To enable commented extensions, edit [`cnpg-vector.dockerfile`](cnpg-vector.dockerfile) and uncomment the relevant build blocks.

## Related Files

- [`cnpg-vector.dockerfile`](cnpg-vector.dockerfile) - Main Dockerfile for CloudNativePG
- [`bitnami-vector.dockerfile`](bitnami-vector.dockerfile) - Legacy Bitnami-based image
- [`cluster-example.yaml`](cluster-example.yaml) - CloudNativePG cluster example

## References

- [CloudNativePG Documentation](https://cloudnative-pg.io/documentation/)
- [pgvector GitHub](https://github.com/pgvector/pgvector)
- [PostgreSQL Official Images](https://hub.docker.com/_/postgres)
- [Barman Backup](https://www.pgbarman.org/)
