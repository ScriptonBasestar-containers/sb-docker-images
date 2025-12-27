# CLAUDE.md - Authentication & Security

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Identity Management & Security
**Projects**: 2 (Kratos, Home Assistant)
**Focus**: User authentication, authorization, smart home security

## Projects

1. **Kratos** (4433, 4434, 4455) - Identity & user management (Ory.sh)
2. **Home Assistant** (host network) - Smart home platform

## Technology Stack

- **Kratos**: Go-based identity server
- **Home Assistant**: Python, smart home integration

## Configuration Patterns

```bash
# Kratos
KRATOS_PUBLIC_URL=https://auth.example.com
KRATOS_ADMIN_URL=http://localhost:4434
DSN=postgres://user:pass@db/kratos

# Home Assistant
TZ=Asia/Seoul
PUID=1000
PGID=1000
```

## Security Best Practices

- **Kratos**:
  - Multi-factor authentication
  - Account recovery flows
  - Session management
  - GDPR compliance

- **Home Assistant**:
  - Network isolation recommended
  - SSL/TLS with reverse proxy
  - Regular updates critical
  - Note: HA OS preferred over Docker

---

**Category**: auth
**Last Updated**: 2025-12-28
