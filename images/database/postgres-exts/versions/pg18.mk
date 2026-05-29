# PostgreSQL 18 — extension version matrix
# Values are the exact upstream branch/tag names; cnpg.dockerfile uses them verbatim.
# PG18 needs newer pins than 15-17: pgvector >=0.8.1, PostGIS >=3.6.1 (3.6.0 has a
# postgis_topology corruption bug), TimescaleDB >=2.23, pg_partman >=5.3. pgaudit is
# locked to the PG major (18.x). pg_repack on PG18 also needs libcurl/libnuma at build
# time — see the pg_repack block in cnpg.dockerfile.
PGVECTOR_VERSION    := v0.8.2
POSTGIS_VERSION     := 3.6.1
TIMESCALEDB_VERSION := 2.27.1
PGCRON_VERSION      := v1.6.7
PGREPACK_VERSION    := 1.5.3
PGAUDIT_VERSION     := 18.0
PGPARTMAN_VERSION   := v5.4.3
