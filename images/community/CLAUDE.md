# CLAUDE.md - Community & Forum Platforms

> **Parent Context**: See `../../CLAUDE.md` for repository-wide guidelines

## Category Overview

**Purpose**: Community Forums & Discussion Platforms
**Projects**: 6 (Discourse, Flarum, NodeBB, Misago, TSBoard, Answer)
**Focus**: Online communities, discussions, Q&A platforms

## Projects

1. **Discourse** - Modern forum platform (Ruby on Rails)
2. **Flarum** - Lightweight forum (PHP)
3. **NodeBB** - Real-time forum (Node.js)
4. **Misago** - Python forum (Django)
5. **TSBoard** - TypeScript-based forum
6. **Answer** - Q&A platform (Stack Overflow alternative)

## Category Standards

### Technology Stack
- **Ruby**: Discourse
- **PHP**: Flarum
- **Node.js**: NodeBB, TSBoard
- **Python**: Misago
- **Features**: Real-time notifications, rich text editing, moderation tools

### Configuration Patterns

```bash
# Forum Configuration
FORUM_TITLE=Community Forum
FORUM_URL=https://forum.example.com
SMTP_HOST=smtp.example.com
SMTP_USER=noreply@example.com

# Redis for real-time features
REDIS_HOST=redis
REDIS_PORT=6379
```

## Security

- **Spam Protection**: CAPTCHA, rate limiting
- **Moderation**: User reports, auto-moderation
- **Privacy**: GDPR compliance tools
- **Auth**: OAuth, SSO integration

## Performance

- **Redis**: Session storage, caching, job queues
- **CDN**: Avatar images, attachments
- **Search**: Elasticsearch integration
- **Scaling**: Horizontal scaling with load balancer

---

**Category**: community
**Last Updated**: 2025-12-28
