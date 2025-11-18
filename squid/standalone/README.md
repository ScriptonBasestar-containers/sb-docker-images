# Squid Standalone - Caching Proxy Server

완전한 독립 실행 가능한 Squid 캐싱 프록시 서버 구성입니다.

## Overview

Squid는 웹 객체를 캐싱하고 네트워크 성능을 향상시키는 고성능 프록시 서버입니다. HTTP, HTTPS, FTP 프로토콜을 지원하며, 대역폭 절약과 응답 시간 단축에 효과적입니다.

### Features

- **Caching Proxy**: HTTP/HTTPS/FTP 프로토콜 지원
- **Access Control**: ACL 기반 접근 제어
- **High Performance**: 고성능 캐싱 및 대역폭 최적화
- **Flexible Configuration**: 사용자 정의 설정 지원
- **Logging**: 상세한 접근 로그 및 캐시 로그
- **Docker Optimized**: 컨테이너 환경에 최적화된 구성

## Quick Start

```bash
# 환경 변수 설정 (선택사항)
cp .env.example .env

# Squid 시작
make up

# 프록시 테스트
make test

# 통계 확인
make stats
```

## Access Information

| Service | URL | Description |
|---------|-----|-------------|
| HTTP Proxy | `http://localhost:3128` | Main proxy port |
| ICP | `localhost:3129` | Inter-Cache Protocol (optional) |

## Available Commands

### Service Management

```bash
make up          # Start Squid proxy
make down        # Stop Squid proxy
make restart     # Restart Squid
make logs        # View logs
make ps          # Show running containers
make clean       # Remove all data (destructive)
```

### Squid Operations

```bash
make shell       # Access container shell
make stats       # Show proxy statistics
make cache-info  # Show cache information
make test        # Test proxy connection
make reconfigure # Reload configuration
```

## Client Configuration

### Linux/Mac

```bash
# Environment variables
export http_proxy=http://localhost:3128
export https_proxy=http://localhost:3128
export ftp_proxy=http://localhost:3128
export no_proxy="localhost,127.0.0.1"

# Test with curl
curl -x http://localhost:3128 http://example.com

# Test with wget
wget http://example.com
```

### apt (Debian/Ubuntu)

```bash
# Create proxy configuration
sudo tee /etc/apt/apt.conf.d/proxy.conf <<EOF
Acquire::http::Proxy "http://localhost:3128";
Acquire::https::Proxy "http://localhost:3128";
EOF

# Update packages
sudo apt update
```

### yum (CentOS/RHEL)

```bash
# Add to /etc/yum.conf
sudo tee -a /etc/yum.conf <<EOF
proxy=http://localhost:3128
EOF

# Update packages
sudo yum update
```

### Docker Daemon

```bash
# Edit /etc/docker/daemon.json
sudo tee /etc/docker/daemon.json <<EOF
{
  "proxies": {
    "http-proxy": "http://localhost:3128",
    "https-proxy": "http://localhost:3128",
    "no-proxy": "localhost,127.0.0.1"
  }
}
EOF

# Restart Docker
sudo systemctl restart docker
```

### Browser Configuration

**Firefox:**
1. Settings → Network Settings → Manual proxy configuration
2. HTTP Proxy: `localhost`, Port: `3128`
3. Check "Use this proxy server for all protocols"

**Chrome:**
```bash
# Linux
google-chrome --proxy-server="http://localhost:3128"

# Mac
open -a "Google Chrome" --args --proxy-server="http://localhost:3128"
```

## Custom Configuration

### Adding Custom Config Files

Create configuration files in the mounted config volume:

```bash
# Access container to create config
docker compose exec squid bash

# Create custom config file
cat > /etc/squid/conf.d/custom.conf <<EOF
# Custom configuration here
EOF

# Reload configuration
exit
make reconfigure
```

### Cache Configuration Example

Create `cache.conf`:

```bash
# Cache memory settings
cache_mem 1024 MB
minimum_object_size 0 bytes
maximum_object_size_in_memory 512 KB
maximum_object_size 4096 MB

# Cache directory
cache_dir ufs /var/spool/squid 5000 16 256

# Refresh patterns
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
```

### Access Control Example

Create `acl.conf`:

```bash
# Allow specific networks
acl allowed_ips src 192.168.1.0/24 10.0.0.0/8
http_access allow allowed_ips

# Block specific domains
acl blocked_sites dstdomain .facebook.com .twitter.com
http_access deny blocked_sites

# Time-based access control
acl work_hours time MTWHF 09:00-18:00
http_access allow work_hours
http_access deny all
```

### Package Repository Caching

Optimize for package repositories:

```bash
# APT packages
refresh_pattern deb$   129600 100% 129600
refresh_pattern udeb$  129600 100% 129600

acl apt_packages urlpath_regex \.deb$
cache allow apt_packages

# Docker registry
maximum_object_size 1024 MB
refresh_pattern registry.hub.docker.com 10080 95% 43200
```

## Use Cases

### 1. Corporate Network Proxy

```yaml
# Features:
- Web content filtering
- Bandwidth optimization
- Access logging and monitoring
- Internet usage policies
```

### 2. Package Repository Cache

```yaml
# Benefits:
- Faster package installations
- Reduced bandwidth usage
- Offline package availability
- Multiple machines sharing cache
```

### 3. Development Environment

```yaml
# Advantages:
- Speed up repeated downloads
- Debug HTTP traffic
- Test proxy configurations
- Simulate corporate network
```

## Monitoring

### View Statistics

```bash
# General statistics
make stats

# Cache hit ratio
docker compose exec squid squidclient mgr:info | grep "Request Hit Ratios"

# Memory usage
docker compose exec squid squidclient mgr:mem
```

### View Logs

```bash
# All logs
make logs

# Access log only
docker compose exec squid tail -f /var/log/squid/access.log

# Cache log only
docker compose exec squid tail -f /var/log/squid/cache.log
```

### Cache Management

```bash
# View cache information
make cache-info

# Cache directory size
docker compose exec squid du -sh /var/spool/squid

# Rotate logs
docker compose exec squid squid -k rotate
```

## Performance Tuning

### Memory Settings

```bash
# Increase cache memory (in custom config)
cache_mem 2048 MB
memory_pools on
memory_pools_limit 512 MB
```

### Disk Cache

```bash
# Larger cache directory
# Format: cache_dir ufs <path> <size_mb> <L1_dirs> <L2_dirs>
cache_dir ufs /var/spool/squid 10000 16 256
```

### Worker Processes

```bash
# Use multiple CPU cores
workers 4
```

### DNS Optimization

```bash
# DNS caching
dns_nameservers 8.8.8.8 8.8.4.4
positive_dns_ttl 6 hours
negative_dns_ttl 1 minute
```

## Security

### Network Access Control

```bash
# Restrict to local networks only
acl localnet src 192.168.0.0/16
acl localnet src 10.0.0.0/8
http_access allow localnet
http_access deny all
```

### Authentication

```bash
# Basic authentication example
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm Squid Proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
http_access deny all
```

### Security Best Practices

1. **Never expose to public internet** without authentication
2. **Use firewall** to restrict access to trusted networks
3. **Monitor logs** regularly for suspicious activity
4. **Implement ACLs** to control access
5. **Keep image updated** for security patches
6. **Use HTTPS** for sensitive traffic when possible

## Troubleshooting

### Connection Issues

```bash
# Check if Squid is running
make ps

# View logs for errors
make logs

# Test proxy connection
make test
curl -x http://localhost:3128 -v http://example.com
```

### Access Denied Errors

```bash
# Check access logs
docker compose exec squid tail -100 /var/log/squid/access.log | grep DENIED

# Verify ACL configuration
docker compose exec squid grep -r "http_access" /etc/squid/

# Check client IP matches allowed networks
docker compose exec squid grep -r "localnet" /etc/squid/
```

### Cache Not Working

```bash
# Verify cache configuration
make cache-info

# Check cache directory
docker compose exec squid ls -la /var/spool/squid

# Initialize cache if needed
docker compose exec squid squid -z

# Check cache logs
docker compose exec squid tail -100 /var/log/squid/cache.log
```

### Performance Issues

```bash
# Check container resources
docker stats squid

# View cache hit ratio
make stats | grep -A 5 "Request Hit Ratios"

# Check memory usage
docker compose exec squid squidclient mgr:mem | grep "Total"
```

### Configuration Syntax Errors

```bash
# Parse configuration
docker compose exec squid squid -k parse

# Check configuration
docker compose exec squid squid -k check
```

## Backup and Restore

### Backup Cache

```bash
# Backup cache volume
docker run --rm \
  -v squid-cache:/source \
  -v $(pwd):/backup \
  alpine tar czf /backup/squid-cache-backup.tar.gz -C /source .
```

### Backup Configuration

```bash
# Backup config volume
docker run --rm \
  -v squid-config:/source \
  -v $(pwd):/backup \
  alpine tar czf /backup/squid-config-backup.tar.gz -C /source .
```

### Restore

```bash
# Stop services
make down

# Restore cache
docker run --rm \
  -v squid-cache:/target \
  -v $(pwd):/backup \
  alpine sh -c "cd /target && tar xzf /backup/squid-cache-backup.tar.gz"

# Restore config
docker run --rm \
  -v squid-config:/target \
  -v $(pwd):/backup \
  alpine sh -c "cd /target && tar xzf /backup/squid-config-backup.tar.gz"

# Start services
make up
```

## Architecture

```
┌─────────────────────┐
│   Client Apps       │
│  (Browser, curl,    │
│   apt, yum, etc.)   │
└──────────┬──────────┘
           │ HTTP/HTTPS
           │ Port 3128
           ▼
┌─────────────────────┐
│   Squid Proxy       │
│  ┌──────────────┐   │
│  │ Cache Memory │   │
│  └──────────────┘   │
│  ┌──────────────┐   │
│  │ Disk Cache   │   │
│  └──────────────┘   │
│  ┌──────────────┐   │
│  │ Access Log   │   │
│  └──────────────┘   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Internet          │
└─────────────────────┘
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SQUID_PORT` | `3128` | HTTP proxy port |
| `SQUID_ICP_PORT` | `3129` | Inter-Cache Protocol port |
| `SQUID_IMAGE` | `scriptonbasestar/sb-docker-squid:latest` | Docker image |
| `SQUID_CONTAINER_NAME` | `squid` | Container name |
| `TZ` | `Asia/Seoul` | Timezone |

## Volumes

| Volume | Path | Description |
|--------|------|-------------|
| `squid-cache` | `/var/spool/squid` | Cache storage |
| `squid-config` | `/etc/squid/conf.d` | Custom configuration |
| `squid-logs` | `/var/log/squid` | Log files |

## Network

| Network | Driver | Description |
|---------|--------|-------------|
| `proxy-network` | `bridge` | Proxy network |

## Image Information

This standalone configuration uses a custom-built image:
- **Base**: Ubuntu 20.04 (Focal)
- **Squid Version**: 4.10
- **Pre-configured**: localnet access enabled
- **Configuration**: /etc/squid/conf.d/ for custom configs

## References

- [Squid Official Site](http://www.squid-cache.org/)
- [Squid Documentation](http://www.squid-cache.org/Doc/)
- [Configuration Guide](https://wiki.squid-cache.org/SquidFaq/ConfiguringSquid)
- [ACL Guide](https://wiki.squid-cache.org/SquidFaq/SquidAcl)
- [Port Guide](../../PORT_GUIDE.md)
- [Main README](../README.md)
