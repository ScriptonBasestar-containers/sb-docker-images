# CLAUDE.md - Groupware & Calendaring

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Groupware & Calendar Management
**Projects**: 1 (AgenDAV)
**Focus**: CalDAV web client

## Projects

1. **AgenDAV** (8300) - CalDAV web client
   - Calendar management web interface
   - Radicale, Baikal, Nextcloud compatible
   - Shared calendars support

## Configuration

```bash
# AgenDAV
CALDAV_SERVER=http://radicale:5232
TIMEZONE=Asia/Seoul
DB_TYPE=mysql
DB_HOST=db
```

## Features

- CalDAV protocol support
- Multiple calendar sources
- Event management
- Recurring events
- Sharing & permissions

---

**Category**: groupware
**Last Updated**: 2025-12-28
