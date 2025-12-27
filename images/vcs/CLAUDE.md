# CLAUDE.md - Version Control Systems

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Version Control & Code Hosting
**Projects**: 1 (Gitea)
**Focus**: Self-hosted Git service

## Projects

1. **Gitea** - Lightweight Git hosting (GitHub/GitLab alternative)
   - Git repositories
   - Issue tracking
   - Pull requests
   - CI/CD integration

## Configuration

```bash
# Gitea
GITEA_DB_TYPE=postgres
GITEA_DB_HOST=db
GITEA_DB_NAME=gitea
GITEA_ADMIN_USER=gitea_admin
GITEA_ADMIN_PASSWORD=change_me
```

## Features

- Repository management
- Organization & teams
- Issue & project boards
- Wiki & pages
- Webhooks & API

---

**Category**: vcs
**Last Updated**: 2025-12-28
