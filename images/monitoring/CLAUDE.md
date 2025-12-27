# CLAUDE.md - Monitoring & Alerting

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: System Monitoring & Uptime Tracking
**Projects**: 1 (Uptime Kuma)
**Focus**: Service monitoring, alerting, status pages

## Projects

1. **Uptime Kuma** (3011) - Self-hosted monitoring
   - Uptime Robot alternative
   - 60+ notification channels
   - Status pages
   - Multi-language support

## Configuration

```bash
# Uptime Kuma
UPTIME_KUMA_PORT=3011
DATA_DIR=/app/data
```

## Features

- HTTP/HTTPS monitoring
- TCP port checks
- Ping monitoring
- Docker container monitoring
- Keyword monitoring
- Certificate expiry alerts

---

**Category**: monitoring
**Last Updated**: 2025-12-28
