# Archive (Deprecated Projects)

This directory contains projects that are no longer actively maintained.

## Warning

These projects are archived for reference purposes only. They should NOT be used in production.

## Archived Projects (8)

### Community/Forum

#### [FlaskBB](flaskbb/)
- **Status:** DEPRECATED
- **Reason:** Upstream development discontinued
- **Alternatives:** Discourse, Flarum, NodeBB

### Wiki

#### [openNamu](openNamu/)
- **Status:** DEPRECATED
- **Reason:** Upstream development discontinued
- **Alternatives:** MediaWiki, Wiki.js, DokuWiki

### E-commerce

#### [Spree](spree/)
- **Status:** DEPRECATED
- **Reason:** Test-only configuration
- **Alternatives:** Shopify, Medusa, Saleor

#### [Solidus](solidus/)
- **Status:** DEPRECATED
- **Reason:** Test-only configuration
- **Alternatives:** Shopify, Medusa, Saleor

### Discourse (Legacy Images)

#### [discourse_fast_switch](discourse_fast_switch/)
- **Status:** DEPRECATED
- **Reason:** 7+ years old, uses EOL Ruby 2.4/2.5
- **Base Image:** `discourse/base:2.0.20180608` (2018)
- **Alternatives:** Use modern `discourse/base` images

#### [discourse_bench](discourse_bench/)
- **Status:** DEPRECATED
- **Reason:** 7+ years old, uses EOL PostgreSQL 9.5
- **Base Image:** `discourse/discourse_test:1.4.0`
- **Alternatives:** Use modern Discourse Docker setup

### Reverse Proxy (Legacy Test Stacks)

#### [traefik_v1.7-test](traefik_v1.7-test/)
- **Status:** DEPRECATED
- **Reason:** Traefik v1.7 is EOL; test-only Compose configs (Consul, WordPress, Portainer)
- **Alternatives:** Traefik v3.x, Caddy, nginx-proxy

#### [traefik_v2.1-test](traefik_v2.1-test/)
- **Status:** DEPRECATED
- **Reason:** Traefik v2.1 superseded; test-only HTTPS redirect/dynamic config samples
- **Alternatives:** Traefik v3.x, Caddy, nginx-proxy

## Migration Guide

If you were using any of these projects, please refer to the README files within each project directory for recommended alternatives.

## Ports Released

The following ports are now available for reuse:
- 8240 (was openNamu)
- 8250 (was FlaskBB)
- 8260 (was Solidus)
- 8400 (was Spree)
