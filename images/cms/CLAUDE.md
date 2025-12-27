# CLAUDE.md - Content Management Systems

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Content Management Systems & Content Platforms
**Projects**: 9 (WordPress, Drupal, Nextcloud, Joomla, Gnuboard5, Gnuboard6, Django CMS, Rhymix, XpressEngine)
**Focus**: Website management, content publishing, file sharing

## Projects

1. **WordPress** - Most popular CMS, PHP-based
2. **Drupal** - Enterprise CMS, highly customizable
3. **Nextcloud** - File sharing & collaboration
4. **Joomla** - Flexible CMS platform
5. **Gnuboard5** - Korean community CMS
6. **Gnuboard6** - Next-gen Korean CMS
7. **Django CMS** - Python-based CMS
8. **Rhymix** - Modern Korean CMS
9. **XpressEngine** - Legacy Korean CMS (deprecated)

## Category Standards

### Common Technology Stack
- **PHP-based**: WordPress, Drupal, Joomla, Gnuboard, Rhymix
- **Python-based**: Django CMS
- **Database**: MariaDB/MySQL (PHP), PostgreSQL (Python)
- **Web Server**: Apache, Nginx

### Configuration Patterns

```bash
# CMS Configuration
CMS_DOMAIN=example.com
CMS_ADMIN_EMAIL=admin@example.com
CMS_DB_HOST=db
CMS_DB_NAME=cms_db
CMS_DB_USER=cms_user
CMS_DB_PASS=secure_password

# File uploads
UPLOAD_MAX_SIZE=256M
PHP_MEMORY_LIMIT=512M
```

## Security Best Practices

- **Updates**: Regular security patches critical
- **Plugins**: Only trusted sources
- **Permissions**: Proper file/directory permissions
- **Backups**: Automated database + files backup
- **SSL**: HTTPS mandatory for admin access

## Performance Optimization

- **Caching**: Redis/Memcached for object cache
- **CDN**: Static assets via CDN
- **PHP**: OpCache enabled, PHP-FPM tuning
- **Database**: Query caching, connection pooling

---

**Category**: cms
**Last Updated**: 2025-12-28
