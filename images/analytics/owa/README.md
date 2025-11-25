# Open Web Analytics (OWA)

Self-hosted web analytics platform - a lightweight alternative to Matomo/Google Analytics.

## Why This Image?

[OWA does not provide official Docker images](https://cwl.cc/2021/09/install-and-update-open-web-analytics-on-docker.html). Community images are outdated or poorly maintained. This project provides:

- **Alpine-based**: Minimal image size
- **PHP 8.2**: Modern PHP with OPcache
- **nginx + php-fpm**: Production-ready configuration
- **MariaDB included**: Complete stack in compose.yml
- **Health checks**: Built-in container health monitoring

## Quick Start

```bash
# Copy environment file
cp .env.example .env

# Update passwords in .env (IMPORTANT!)
# Edit OWA_DB_PASSWORD and MARIADB_ROOT_PASSWORD

# Start services
make up

# Access OWA
open http://localhost:8280
```

## Initial Setup

1. Navigate to `http://localhost:8090`
2. Follow the web-based installation wizard
3. Enter database credentials:
   - Host: `db`
   - Database: `owa`
   - User: `owa`
   - Password: (from your .env file)
4. Create admin account
5. Add your first site to track

## Tracking Code

After setup, add this JavaScript to your website:

```html
<script type="text/javascript">
var owa_baseUrl = 'http://your-owa-domain/';
var owa_cmds = owa_cmds || [];
owa_cmds.push(['setSiteId', 'YOUR_SITE_ID']);
owa_cmds.push(['trackPageView']);
owa_cmds.push(['trackClicks']);
(function() {
    var _owa = document.createElement('script');
    _owa.type = 'text/javascript'; _owa.async = true;
    _owa.src = owa_baseUrl + 'modules/base/js/owa.tracker-combined-min.js';
    var _owa_s = document.getElementsByTagName('script')[0];
    _owa_s.parentNode.insertBefore(_owa, _owa_s);
}());
</script>
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `OWA_VERSION` | 1.7.8 | OWA version |
| `PHP_VERSION` | 8.2 | PHP version |
| `OWA_PORT` | 8280 | Web interface port |
| `OWA_DB_HOST` | db | Database hostname |
| `OWA_DB_NAME` | owa | Database name |
| `OWA_DB_USER` | owa | Database user |
| `OWA_DB_PASSWORD` | owa_password | Database password |

## Commands

```bash
make up       # Start services
make down     # Stop services
make logs     # View logs
make shell    # Access container shell
make clean    # Remove all data (destructive!)
```

## With Traefik (Production)

```yaml
services:
  owa:
    # ... existing config ...
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.owa.rule=Host(`analytics.example.com`)"
      - "traefik.http.routers.owa.tls.certresolver=letsencrypt"
```

## Data Persistence

| Volume | Purpose |
|--------|---------|
| `owa-data` | OWA data files and cache |
| `owa-db` | MariaDB database files |

## Architecture

```
┌─────────────────────────────────────┐
│           OWA Container             │
│  ┌─────────────┐  ┌──────────────┐  │
│  │   nginx     │  │   php-fpm    │  │
│  │   :80       │──│   :9000      │  │
│  └─────────────┘  └──────────────┘  │
└─────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────┐
│         MariaDB Container           │
│            :3306                    │
└─────────────────────────────────────┘
```

## Comparison: OWA vs Matomo

| Feature | OWA | Matomo |
|---------|-----|--------|
| Resource usage | Lower | Higher |
| Features | Basic | Comprehensive |
| Setup complexity | Simple | Moderate |
| Best for | Small sites | Enterprise |

## References

- [OWA Official](https://www.openwebanalytics.com/)
- [OWA GitHub](https://github.com/Open-Web-Analytics/Open-Web-Analytics)
- [OWA Documentation](https://wiki.openwebanalytics.com/)
