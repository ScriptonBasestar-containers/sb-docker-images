# PostgreSQL Extensions for CloudNativePG

CloudNativePG-compatible PostgreSQL images (15 / 16 / 17 / 18) with selectable production extensions.

## 🧩 How It Works

A **single unified Dockerfile** (`cnpg.dockerfile`) builds **any combination** of
extensions through build-arg toggles (`--build-arg WITH_<ext>=true`). This avoids the
combinatorial explosion of maintaining one Dockerfile per combination (7 extensions =
128 possible combos × PG versions × architectures).

Two ways to use it:

1. **Curated bundles** — a small set of pre-built images published to the registry
   (`essential`, `full`, `vector`, `postgis`). Pull and run, no build needed.
2. **On-demand custom** — build exactly the extensions you need locally:
   `make build EXTS=pgvector,pg_cron`

> **Why not pre-build everything?** Building all 128 combos × multi-arch is infeasible
> (the `full` bundle alone compiles PostGIS + TimescaleDB from source, ~15 min). We
> pre-build only the common bundles and let everything else be built on demand.

## 🐘 PostgreSQL Versions

Every target accepts `PG_VERSION` (default `18`). Supported majors: **15, 16, 17, 18**.

```bash
make full-build                      # default: PG 18
make full-build PG_VERSION=16        # full bundle for PG 16
make versions PG_VERSION=17          # print the resolved extension pins
```

Local images are tagged `postgres-exts:<pg>-<bundle>` (e.g. `postgres-exts:17-full`),
so builds for different majors never overwrite each other.

### Compatibility Matrix

Extension pins live in `versions/pg<major>.mk` — the single source of truth the build
reads. Most extensions tolerate a range of PG majors; **pgAudit is locked to the PG
major**, and its versioning scheme even changes across releases
(`1.7.x` → `16.x` → `17.x` → `18.x`), which is the main reason a per-version matrix exists.

| Extension   | PG 15  | PG 16  | PG 17  | PG 18  | Notes                                |
|-------------|--------|--------|--------|--------|--------------------------------------|
| pgvector    | v0.7.4 | v0.7.4 | v0.7.4 | v0.8.2 | PG 18 needs ≥ 0.8.1                  |
| PostGIS     | 3.5.1  | 3.5.1  | 3.5.1  | 3.6.1  | PG 18 needs ≥ 3.6.1 (3.6.0 topology bug) |
| TimescaleDB | 2.17.2 | 2.17.2 | 2.17.2 | 2.27.1 | PG 18 since 2.23                     |
| pg_cron     | v1.6.7 | v1.6.7 | v1.6.7 | v1.6.7 | PG 18 since 1.6.6                    |
| pg_repack   | 1.5.3  | 1.5.3  | 1.5.3  | 1.5.3  | PG 18 also needs libcurl/libnuma at build time |
| pgAudit     | 1.7.1  | 16.1   | 17.1   | 18.0   | **locked to PG major**               |
| pg_partman  | v5.2.1 | v5.2.1 | v5.2.1 | v5.4.3 | PG 18 since 5.3                      |

To add a major, drop a `versions/pg<major>.mk` with the right pins — the Makefile
auto-discovers it and `make versions` will list it as supported.

## 🎯 Curated Bundles

### 1. **Essential** (Lightweight) — `make essential-build`
**Size**: ~400MB | **Build Time**: ~2min

Minimal image with most commonly used extensions:
- ✅ **pgvector** v0.8.2 - AI/ML vector embeddings
- ✅ **pg_stat_statements** - Query performance monitoring (built-in)
- ✅ **pg_trgm** - Fuzzy search, similarity matching (built-in)
- ✅ **hstore** - Key-value store (built-in)
- ✅ **btree_gin/btree_gist** - Advanced indexing (built-in)

**Best for**: General purpose, AI apps, most web applications

### 2. **Full Extensions** — `make full-build`
**Size**: ~800MB | **Build Time**: ~15min

Comprehensive image with all production-ready extensions (versions shown are the
PG 18 default — see the [Compatibility Matrix](#compatibility-matrix) for other majors):
- ⭐ **pgvector** v0.8.2 - AI/ML vector embeddings
- 🗺️ **PostGIS** v3.6.1 - Geospatial data (GIS, maps, location)
- 📈 **TimescaleDB** v2.27.1 - Time-series data (IoT, metrics, logs)
- ⏰ **pg_cron** v1.6.7 - Database job scheduler
- ⚡ **pg_repack** v1.5.3 - Online table reorganization
- 🔒 **pgAudit** v18.0 - Security audit logging (GDPR, HIPAA) — version tracks PG major
- 📊 **pg_partman** v5.4.3 - Automatic partition management

**Best for**: Enterprise apps, data analytics, compliance requirements

### 3. **Vector Only** (Legacy) — `make vector-build`
**Size**: ~350MB | **Build Time**: ~1min

Original pgvector-only image (maintained for backward compatibility):
- pgvector v0.8.2
- CloudNativePG utilities

### 4. **PostGIS Only** (Geospatial) — `make postgis-build`
**Size**: ~1GB | **Build Time**: ~10min

Single-extension image for geospatial workloads:
- 🗺️ **PostGIS** v3.6.1 - Full geospatial (geometry, geography, raster, topology)
- Built from GitHub source → native AMD64 + ARM64 (no reliance on prebuilt arch tags)

**Best for**: Standalone geospatial DB when you need PostGIS but not the other extensions

## 🎛️ Custom Combination (On-Demand)

Build only what you need — any subset of the 7 extensions:

```bash
# pgvector + pg_cron only
make build EXTS=pgvector,pg_cron

# geospatial + time-series, custom tag
make build EXTS=postgis,timescaledb CUSTOM_TAG=postgres-exts:geo-ts

# Available: pgvector postgis timescaledb pg_cron pg_repack pgaudit pg_partman
```

Or call the Dockerfile directly:

```bash
docker build \
  --build-arg WITH_PGVECTOR=true \
  --build-arg WITH_PG_CRON=true \
  -f cnpg.dockerfile -t postgres-exts:custom .
```

`shared_preload_libraries` and related settings are generated at build time to match
exactly the extensions you enabled.

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

# PostGIS only (geospatial)
make postgis-build
```

### Test Locally

```bash
# Test essential image
make essential-test

# Test full extensions
make full-test

# Test PostGIS only
make postgis-test
```

### Push to Registry

```bash
# Easiest: the push targets tag the version-qualified local image for you
make essential-push          # or full-push / postgis-push
make full-push PG_VERSION=17 # push the PG 17 build

# Manual equivalent (local images are already tagged <pg>-<bundle>)
docker tag postgres-exts:18-essential scriptonbasestar/postgres-exts:18-essential
docker push scriptonbasestar/postgres-exts:18-essential
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
  imageName: scriptonbasestar/postgres-exts:18-essential

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
  imageName: scriptonbasestar/postgres-exts:18-full

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
| **Location Services** | PostGIS-Only | Geospatial without extra extensions |
| **IoT/Metrics** | Full | Needs TimescaleDB |
| **Enterprise/Compliance** | Full | Needs pgAudit, advanced features |
| **Microservices** | Essential | Minimal footprint |
| **Data Analytics** | Full | All extensions available |

---

## 🛠️ Development

### Build with Custom Versions

```bash
# Custom pgvector version (essential-equivalent)
docker build \
  --build-arg PGVECTOR_VERSION=v0.8.0 \
  -f cnpg.dockerfile \
  -t postgres-exts:essential-custom .

# Full set with custom versions
docker build \
  --build-arg WITH_PGVECTOR=true \
  --build-arg WITH_POSTGIS=true \
  --build-arg WITH_TIMESCALEDB=true \
  --build-arg WITH_PG_CRON=true \
  --build-arg WITH_PG_REPACK=true \
  --build-arg WITH_PGAUDIT=true \
  --build-arg WITH_PG_PARTMAN=true \
  --build-arg PGVECTOR_VERSION=v0.8.0 \
  --build-arg POSTGIS_VERSION=3.5.2 \
  --build-arg TIMESCALEDB_VERSION=2.18.0 \
  -f cnpg.dockerfile \
  -t postgres-exts:full-custom .
```

### Verify Extensions

```bash
# Start container
docker run -d --name pg-test -e POSTGRES_PASSWORD=test postgres-exts:18-full

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

| Feature | Essential | Full | Vector-Only | PostGIS-Only |
|---------|-----------|------|-------------|--------------|
| **Size** | 400MB | 800MB | 350MB | 1GB |
| **Build Time** | 2min | 15min | 1min | 10min |
| **pgvector** | ✅ | ✅ | ✅ | ❌ |
| **PostGIS** | ❌ | ✅ | ❌ | ✅ |
| **TimescaleDB** | ❌ | ✅ | ❌ | ❌ |
| **pg_cron** | ❌ | ✅ | ❌ | ❌ |
| **pg_repack** | ❌ | ✅ | ❌ | ❌ |
| **pgAudit** | ❌ | ✅ | ❌ | ❌ |
| **Built-in Exts** | ✅ | ✅ | ✅ | ✅ |

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
