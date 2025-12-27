# CLAUDE.md - Wiki & Documentation Systems

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Wiki Systems & Documentation Platforms
**Projects**: 5 (Wiki.js, MediaWiki, Gollum, DokuWiki, Outline)
**Focus**: Knowledge management, documentation, collaborative editing

## Projects

1. **Wiki.js** - Modern wiki, Node.js-based
2. **MediaWiki** - Wikipedia's platform, PHP-based
3. **Gollum** - Git-backed wiki, Ruby-based
4. **DokuWiki** - Flat-file wiki, PHP-based
5. **Outline** - Modern knowledge base

## Category Standards

### Technology Stack
- **Node.js**: Wiki.js, Outline
- **PHP**: MediaWiki, DokuWiki
- **Ruby**: Gollum
- **Storage**: Database (Wiki.js), Git (Gollum), Flat-file (DokuWiki)

### Configuration Patterns

```bash
# Wiki Configuration
WIKI_TITLE=Company Wiki
WIKI_ADMIN_EMAIL=admin@example.com
WIKI_DB_TYPE=postgres
WIKI_DB_HOST=db
```

## Security

- **Authentication**: LDAP/OAuth integration
- **Permissions**: Role-based access control
- **Backups**: Git-based (Gollum) or DB backups
- **Versioning**: Full edit history

## Performance

- **Search**: Full-text search indexing
- **Caching**: Page caching for read-heavy loads
- **Assets**: CDN for images/attachments

---

**Category**: wiki
**Last Updated**: 2025-12-28
