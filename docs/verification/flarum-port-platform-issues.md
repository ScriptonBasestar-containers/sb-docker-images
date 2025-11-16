# Flarum - Port Conflict and Platform Issues

## Problem 1: Port Conflict
Port 8025 is already allocated, preventing Mailhog from starting.

### Error Message
```
Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint flarum-mailhog-1: Bind for 127.0.0.1:8025 failed: port is already allocated
```

### Solution
Change the Mailhog port mapping in `flarum/compose.yml`:
```yaml
mailhog:
  image: mailhog/mailhog:latest
  ports:
    - "8026:8025"  # Changed from 8025:8025
  expose:
    - 1025
```

## Problem 2: Platform Mismatch
Images built for linux/amd64 running on linux/arm64/v8 (Apple Silicon).

### Warning Messages
```
mailhog: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)
phpmyadmin: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)
```

### Impact
- May cause performance issues due to emulation
- Some features might not work correctly

### Solution Options

#### Option 1: Use ARM64 Images (Recommended)
```yaml
mailhog:
  image: mailhog/mailhog:latest
  platform: linux/arm64  # Explicit platform

phpmyadmin:
  image: arm64v8/phpmyadmin:latest  # ARM-specific image
  # or
  platform: linux/arm64
```

#### Option 2: Use Multi-Platform Images
Keep current images but add platform specification:
```yaml
services:
  mailhog:
    platform: linux/amd64  # Explicit AMD64 with Rosetta emulation
```

## Successfully Created Components
- ✅ Networks: flarum_default, flarum_db-network
- ✅ Volumes: flarum_mariadb, flarum_flarum-data
- ✅ Containers created (not started):
  - flarum-mariadb-1
  - flarum
  - flarum-phpmyadmin-1
  - flarum-mailhog-1

## Status
- Configuration: ✅ Valid
- MariaDB: ✅ Healthy
- Flarum: ⚠️ Created but not started (waiting for dependencies)
- PHPMyAdmin: ⚠️ Platform mismatch warning
- Mailhog: ❌ Port conflict

## Recommendations
1. Change Mailhog port to 8026
2. Add explicit platform declarations for ARM64 compatibility
3. Consider using ARM64-native images where available
