# CLAUDE.md - Team Collaboration Tools

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Team Collaboration & Communication
**Projects**: 3 (Mattermost, Rocket.Chat, BookStack)
**Focus**: Team chat, video calls, documentation collaboration

## Projects

1. **Mattermost** (8350) - Team collaboration (Slack alternative)
2. **Rocket.Chat** (8340) - Team communication (Slack/Teams alternative)
3. **BookStack** (8390) - Hierarchical wiki & documentation

## Technology Stack

- **Mattermost**: Go backend
- **Rocket.Chat**: Node.js, MongoDB
- **BookStack**: PHP, MySQL

## Configuration Patterns

```bash
# Team Chat
SITE_URL=https://chat.example.com
ADMIN_EMAIL=admin@example.com
SMTP_HOST=smtp.example.com

# Database
DB_HOST=db
DB_NAME=collaboration
```

## Security

- **E2E Encryption**: End-to-end encrypted messaging
- **SSO/SAML**: Enterprise authentication
- **Compliance**: GDPR, HIPAA compliance features
- **File Security**: Encrypted file storage

---

**Category**: collaboration
**Last Updated**: 2025-12-28
