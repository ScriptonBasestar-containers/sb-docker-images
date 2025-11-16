# Gitea - Port Conflict Issue

## Problem
Port 3000 is already allocated on the host system, preventing Gitea from starting.

## Error Message
```
Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint gitea (cd709da97f9e3386cae2a8faf502ab38ea97af0ed4882fe7d9d7424c77ad402e): Bind for 127.0.0.1:3000 failed: port is already allocated
```

## Solution Options

### Option 1: Change Port Mapping
Edit `gitea/compose.yml` and change the port mapping:

```yaml
ports:
  - "3001:3000"  # Changed from 3000:3000
  - "2222:22"
```

### Option 2: Stop Conflicting Service
Find and stop the service using port 3000:
```bash
lsof -i :3000
# or
netstat -anv | grep 3000
```

## Status
- Configuration: ✅ Valid
- Containers: ✅ Created successfully
- Network: ✅ Created successfully
- Runtime: ❌ Port conflict

## Recommendation
Use Option 1 (change port to 3001) to avoid conflicts with other services.
