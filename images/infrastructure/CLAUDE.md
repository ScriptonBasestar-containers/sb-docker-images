# CLAUDE.md - Infrastructure Services

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Infrastructure & Utility Services
**Projects**: 5 (Minio, Squid, RTMP Proxy, Mailslurper, Supabase)
**Focus**: Object storage, proxy, streaming, email testing

## Projects

1. **Minio** - S3-compatible object storage
2. **Squid** - HTTP caching proxy
3. **RTMP Proxy** - RTMP streaming proxy
4. **Mailslurper** - Email testing tool
5. **Supabase** - Firebase alternative (PostgreSQL, Auth, Storage)

## Configuration Patterns

```bash
# Minio
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin
MINIO_BROWSER=on

# Squid
SQUID_CACHE_SIZE=1024
SQUID_MAX_OBJECT_SIZE=4096

# Mailslurper
SMTP_PORT=2500
WEB_PORT=8080
```

## Use Cases

- **Minio**: File storage, backups, CDN
- **Squid**: Caching, bandwidth saving
- **RTMP**: Live streaming relay
- **Mailslurper**: Development email testing
- **Supabase**: Backend-as-a-Service

---

**Category**: infrastructure
**Last Updated**: 2025-12-28
