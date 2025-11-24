# PostgreSQL Extensions for CloudNativePG

CloudNativePG-compatible PostgreSQL 16 images with essential production extensions.

## 🎯 Available Images

### 1. **Essential** (Lightweight) - `cnpg-essential.dockerfile`
**Size**: ~400MB | **Build Time**: ~2min

Minimal image with most commonly used extensions:
- ✅ **pgvector** v0.7.4 - AI/ML vector embeddings
- ✅ **pg_stat_statements** - Query performance monitoring (built-in)
- ✅ **pg_trgm** - Fuzzy search, similarity matching (built-in)
- ✅ **hstore** - Key-value store (built-in)
- ✅ **btree_gin/btree_gist** - Advanced indexing (built-in)

**Best for**: General purpose, AI apps, most web applications

### 2. **Full Extensions** - `cnpg-extensions.dockerfile`
**Size**: ~800MB | **Build Time**: ~15min

Comprehensive image with all production-ready extensions:
- ⭐ **pgvector** v0.7.4 - AI/ML vector embeddings
- 🗺️ **PostGIS** v3.5.1 - Geospatial data (GIS, maps, location)
- 📈 **TimescaleDB** v2.17.2 - Time-series data (IoT, metrics, logs)
- ⏰ **pg_cron** v1.6.4 - Database job scheduler
- ⚡ **pg_repack** v1.5.1 - Online table reorganization
- 🔒 **pgAudit** v16.0 - Security audit logging (GDPR, HIPAA)
- 📊 **pg_partman** v5.2.1 - Automatic partition management

**Best for**: Enterprise apps, data analytics, compliance requirements

### 3. **Vector Only** (Legacy) - `cnpg-vector.dockerfile`
**Size**: ~350MB | **Build Time**: ~1min

Original pgvector-only image (maintained for backward compatibility):
- pgvector v0.7.4
- CloudNativePG utilities

---

## 🚀 Quick Start

### Build Images

```bash
# Essential (Recommended for most cases)
make essential-build

# Full extensions (For production/enterprise)
make full-build

# Legacy vector-only
make vector-build
```

### Test Locally

```bash
# Test essential image
make essential-test

# Test full extensions
make full-test
```

### Push to Registry

```bash
# Tag and push essential
docker tag postgres-exts:essential scriptonbasestar/postgres-exts:16-essential
docker push scriptonbasestar/postgres-exts:16-essential

# Tag and push full
docker tag postgres-exts:full scriptonbasestar/postgres-exts:16-full
docker push scriptonbasestar/postgres-exts:16-full
```

---

## 📦 Extension Details

### 🔥 Most Popular (Included in Essential)

#### pgvector ⭐
```sql
CREATE EXTENSION vector;
CREATE TABLE items (id SERIAL, embedding vector(1536));
CREATE INDEX ON items USING ivfflat (embedding vector_cosine_ops);
```
**Use Cases**: ChatGPT embeddings, semantic search, recommendation systems

#### pg_stat_statements 📊
```sql
CREATE EXTENSION pg_stat_statements;
SELECT query, calls, total_exec_time, mean_exec_time
FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 10;
```
**Use Cases**: Performance monitoring, slow query detection, query optimization

#### pg_trgm 🔍
```sql
CREATE EXTENSION pg_trgm;
CREATE INDEX trgm_idx ON items USING gin (name gin_trgm_ops);
SELECT * FROM items WHERE name % 'searchterm';  -- Fuzzy search
```
**Use Cases**: Autocomplete, typo-tolerant search, similarity matching

### 🏢 Enterprise Extensions (Full Image Only)

#### PostGIS 🗺️
```sql
CREATE EXTENSION postgis;
CREATE TABLE locations (id SERIAL, point GEOMETRY(Point, 4326));
SELECT * FROM locations WHERE ST_DWithin(point, ST_MakePoint(lng, lat), 1000);
```
**Use Cases**: Delivery apps, real estate, ride-sharing, mapping

#### TimescaleDB 📈
```sql
CREATE EXTENSION timescaledb;
SELECT create_hypertable('metrics', 'time');
INSERT INTO metrics VALUES (NOW(), 'cpu', 75.5);
SELECT time_bucket('1 hour', time), avg(value) FROM metrics GROUP BY 1;
```
**Use Cases**: IoT sensor data, application metrics, financial tick data

#### pg_cron ⏰
```sql
CREATE EXTENSION pg_cron;
SELECT cron.schedule('cleanup', '0 3 * * *', $$DELETE FROM logs WHERE created < NOW() - INTERVAL '30 days'$$);
```
**Use Cases**: Periodic cleanup, data aggregation, scheduled reports

#### pgAudit 🔒
```sql
-- Configuration in postgresql.conf
-- pgaudit.log = 'write, ddl'
CREATE EXTENSION pgaudit;
-- All writes/DDL are automatically logged
```
**Use Cases**: Compliance (GDPR, HIPAA, SOX), security auditing

#### pg_repack ⚡
```bash
# Run outside database (no downtime)
pg_repack -d mydb -t mytable
```
**Use Cases**: Bloat removal, table reorganization, index optimization

---

## 🔧 Usage with CloudNativePG

### 1. Install CloudNativePG Operator

```bash
kubectl apply -f \
  https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.24/releases/cnpg-1.24.0.yaml
```

### 2. Create Cluster with Essential Extensions

```yaml
# cluster-essential.yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgres-ai
spec:
  instances: 3
  imageName: scriptonbasestar/postgres-exts:16-essential

  postgresql:
    parameters:
      shared_preload_libraries: "vector,pg_stat_statements"
      pg_stat_statements.track: "all"
      pg_stat_statements.max: "10000"

  bootstrap:
    initdb:
      database: appdb
      owner: appuser
      postInitSQL:
        - CREATE EXTENSION vector;
        - CREATE EXTENSION pg_stat_statements;
        - CREATE EXTENSION pg_trgm;
        - CREATE EXTENSION hstore;

  storage:
    size: 20Gi
    storageClass: standard
```

### 3. Create Cluster with Full Extensions

```yaml
# cluster-full.yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgres-enterprise
spec:
  instances: 3
  imageName: scriptonbasestar/postgres-exts:16-full

  postgresql:
    parameters:
      shared_preload_libraries: "vector,timescaledb,pg_cron,pg_stat_statements,pgaudit"
      cron.database_name: "postgres"
      timescaledb.max_background_workers: "8"
      pgaudit.log: "write, ddl"

  bootstrap:
    initdb:
      database: appdb
      owner: appuser
      postInitSQL:
        - CREATE EXTENSION vector;
        - CREATE EXTENSION postgis;
        - CREATE EXTENSION timescaledb;
        - CREATE EXTENSION pg_cron;
        - CREATE EXTENSION pgaudit;
        - CREATE EXTENSION pg_stat_statements;

  storage:
    size: 100Gi
    storageClass: premium-ssd
```

---

## 🎯 Which Image Should I Use?

| Use Case | Recommended Image | Why |
|----------|-------------------|-----|
| **AI/ML App** | Essential | pgvector + performance monitoring |
| **General Web App** | Essential | Lightweight, fast startup |
| **Location Services** | Full | Needs PostGIS |
| **IoT/Metrics** | Full | Needs TimescaleDB |
| **Enterprise/Compliance** | Full | Needs pgAudit, advanced features |
| **Microservices** | Essential | Minimal footprint |
| **Data Analytics** | Full | All extensions available |

---

## 🛠️ Development

### Build with Custom Versions

```bash
# Custom pgvector version
docker build \
  --build-arg PGVECTOR_VERSION=v0.8.0 \
  -f cnpg-essential.dockerfile \
  -t postgres-exts:essential-custom .

# Custom all versions
docker build \
  --build-arg PGVECTOR_VERSION=v0.8.0 \
  --build-arg POSTGIS_VERSION=3.5.2 \
  --build-arg TIMESCALEDB_VERSION=2.18.0 \
  -f cnpg-extensions.dockerfile \
  -t postgres-exts:full-custom .
```

### Verify Extensions

```bash
# Start container
docker run -d --name pg-test -e POSTGRES_PASSWORD=test postgres-exts:full

# Check installed extensions
docker exec pg-test psql -U postgres -c "SELECT * FROM pg_available_extensions WHERE name LIKE 'pg%' OR name IN ('vector', 'postgis', 'timescaledb');"

# Create all extensions
docker exec pg-test psql -U postgres -c "
CREATE EXTENSION vector;
CREATE EXTENSION postgis;
CREATE EXTENSION timescaledb;
CREATE EXTENSION pg_cron;
CREATE EXTENSION pgaudit;
CREATE EXTENSION pg_stat_statements;
SELECT * FROM pg_extension;
"
```

---

## 📊 Image Comparison

| Feature | Essential | Full | Vector-Only |
|---------|-----------|------|-------------|
| **Size** | 400MB | 800MB | 350MB |
| **Build Time** | 2min | 15min | 1min |
| **pgvector** | ✅ | ✅ | ✅ |
| **PostGIS** | ❌ | ✅ | ❌ |
| **TimescaleDB** | ❌ | ✅ | ❌ |
| **pg_cron** | ❌ | ✅ | ❌ |
| **pg_repack** | ❌ | ✅ | ❌ |
| **pgAudit** | ❌ | ✅ | ❌ |
| **Built-in Exts** | ✅ | ✅ | ✅ |

---

## 🔗 References

- [pgvector](https://github.com/pgvector/pgvector) - Vector similarity search
- [PostGIS](https://postgis.net/) - Spatial database
- [TimescaleDB](https://www.timescale.com/) - Time-series database
- [pg_cron](https://github.com/citusdata/pg_cron) - Job scheduler
- [pgAudit](https://www.pgaudit.org/) - Audit logging
- [CloudNativePG](https://cloudnative-pg.io/) - Kubernetes operator

---

## 📝 License

MIT

## 🤝 Contributing

Contributions welcome! Please open an issue or PR.
