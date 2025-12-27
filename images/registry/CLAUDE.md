# CLAUDE.md - Package Registry

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Package Registry & Distribution
**Projects**: 1 (Devpi)
**Focus**: Python package index, PyPI mirror

## Projects

1. **Devpi** - Python package index server
   - PyPI mirror & cache
   - Private package hosting
   - Staging & testing indices
   - Upload & release management

## Configuration

```bash
# Devpi
DEVPI_PORT=3141
DEVPI_ROOT_PASSWORD=change_me
DEVPI_DATA=/data
```

## Use Cases

- Private Python package hosting
- PyPI mirroring (offline development)
- Package staging & testing
- Release management

---

**Category**: registry
**Last Updated**: 2025-12-28
