# PostgreSQL 15 — extension version matrix
# Values are the exact upstream branch/tag names; cnpg.dockerfile uses them verbatim.
# pgaudit is locked to the PG major (1.7.x for PG15); the rest are PG-version-range tolerant.
PGVECTOR_VERSION    := v0.7.4
POSTGIS_VERSION     := 3.5.1
TIMESCALEDB_VERSION := 2.17.2
PGCRON_VERSION      := v1.6.7
PGREPACK_VERSION    := 1.5.3
PGAUDIT_VERSION     := 1.7.1
PGPARTMAN_VERSION   := v5.2.1
