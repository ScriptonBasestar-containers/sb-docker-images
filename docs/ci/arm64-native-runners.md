# ARM64 Native Runners Setup Guide

## Overview

This guide explains how to set up ARM64 native runners for GitHub Actions to achieve 5-10x faster build times compared to QEMU emulation.

## Performance Comparison

| Build Method | Build Time | Speed |
|-------------|-----------|-------|
| QEMU Emulation (current) | 20-30 min | 1x (baseline) |
| ARM64 Native Runner | 2-5 min | **5-10x faster** |

## Runner Options

### Option 1: GitHub-Hosted ARM64 Runners (Recommended)

GitHub now provides ARM64 runners for Team and Enterprise plans.

**Requirements:**
- GitHub Team or Enterprise plan
- Enable ARM64 runners in repository settings

**Availability:**
- `ubuntu-latest-arm64` (Ubuntu 22.04 ARM64)
- `macos-latest-xlarge` (Apple Silicon M1)

**Setup:**
1. Go to repository Settings → Actions → Runners
2. Enable "Use larger runners"
3. Select ARM64 runner types

**Pricing:**
- Team: $0.016/min
- Enterprise: Volume pricing available

### Option 2: Self-Hosted ARM64 Runners

Run your own ARM64 runners on cloud or local hardware.

#### Hardware Options

**Cloud Providers:**
- AWS Graviton2/Graviton3 (c7g, t4g instances)
- Oracle Cloud Ampere Altra (Always Free tier available)
- Azure Dv5/Ev5 ARM64 VMs
- Google Cloud Tau T2A instances

**Local Hardware:**
- Raspberry Pi 4/5 (8GB RAM minimum)
- Apple Silicon Mac mini/Mac Studio
- ARM-based servers

#### Setup Instructions

**1. Provision ARM64 Instance**

Example: Oracle Cloud Free Tier (4 ARM cores, 24GB RAM)
```bash
# Oracle Cloud: Create VM.Standard.A1.Flex instance
# - Shape: VM.Standard.A1.Flex
# - OCPU count: 4
# - Memory: 24 GB
# - Image: Ubuntu 22.04 ARM64
```

**2. Install Docker**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify Docker
docker run --rm hello-world
```

**3. Install GitHub Actions Runner**

```bash
# Create runner directory
mkdir -p ~/actions-runner && cd ~/actions-runner

# Download ARM64 runner
curl -o actions-runner-linux-arm64-2.311.0.tar.gz -L \
  https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-arm64-2.311.0.tar.gz

# Extract
tar xzf ./actions-runner-linux-arm64-2.311.0.tar.gz

# Configure runner
# Get token from: https://github.com/YOUR_ORG/YOUR_REPO/settings/actions/runners/new
./config.sh --url https://github.com/YOUR_ORG/YOUR_REPO --token YOUR_TOKEN --labels self-hosted,Linux,ARM64

# Install as service
sudo ./svc.sh install
sudo ./svc.sh start
```

**4. Configure Runner Labels**

Add labels to identify the runner:
- `self-hosted`
- `Linux`
- `ARM64`
- `ubuntu-latest-arm64` (for compatibility)

**5. Verify Runner**

```bash
# Check service status
sudo ./svc.sh status

# View logs
journalctl -u actions.runner.* -f
```

## Workflow Configuration

### Update Workflow to Use ARM64 Runners

**Before (QEMU emulation):**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: docker/setup-qemu-action@v3
      - name: Build multi-arch
        run: |
          docker buildx build \
            --platform linux/amd64,linux/arm64 \
            --push .
```

**After (Native builds):**
```yaml
jobs:
  build-amd64:
    runs-on: ubuntu-latest
    steps:
      - name: Build AMD64
        run: |
          docker buildx build \
            --platform linux/amd64 \
            --push .

  build-arm64:
    runs-on: ubuntu-latest-arm64  # Native ARM64
    steps:
      - name: Build ARM64
        run: |
          docker buildx build \
            --platform linux/arm64 \
            --push .

  merge:
    needs: [build-amd64, build-arm64]
    runs-on: ubuntu-latest
    steps:
      - name: Create manifest
        run: |
          docker buildx imagetools create \
            -t myimage:latest \
            myimage:latest-amd64 \
            myimage:latest-arm64
```

## Cost Analysis

### GitHub-Hosted Runners

**Monthly Cost Estimate:**
- Builds per day: 10
- ARM64 build time: 3 min
- AMD64 build time: 2 min
- Total minutes: (10 builds × (3 + 2) min) × 30 days = 1,500 min/month

**Cost:**
- GitHub Team: 1,500 min × $0.016 = $24/month
- Savings vs QEMU: ~70% time reduction

### Self-Hosted Runners

**Oracle Cloud Free Tier:**
- 4 ARM cores, 24GB RAM: **FREE**
- Bandwidth: 10TB/month: **FREE**
- Storage: 200GB: **FREE**

**AWS Graviton3 (c7g.large):**
- 2 vCPU, 4GB RAM: ~$50/month
- Reserved instance: ~$30/month

## Security Considerations

### Self-Hosted Runners

1. **Isolate runners** - Use dedicated VMs for each repository
2. **Network security** - Restrict inbound traffic, allow GitHub webhooks only
3. **Update regularly** - Keep runner software and OS updated
4. **Use ephemeral runners** - Rebuild runner VMs periodically
5. **Audit logs** - Monitor runner activity and build logs

### Firewall Configuration

```bash
# Allow SSH (change port if needed)
sudo ufw allow 22/tcp

# Allow HTTPS for GitHub webhooks
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw enable
```

## Monitoring and Maintenance

### Runner Health Checks

```bash
# Check runner status
sudo ./svc.sh status

# View recent logs
journalctl -u actions.runner.* -n 100

# Restart runner
sudo ./svc.sh stop
sudo ./svc.sh start
```

### Metrics to Monitor

- Build queue time
- Build duration per architecture
- Runner CPU/memory usage
- Disk space availability
- Network bandwidth usage

### Automated Monitoring Script

```bash
#!/bin/bash
# Save as: monitor-runner.sh

# Check runner service
if ! sudo ./svc.sh status | grep -q "active (running)"; then
  echo "Runner not running, restarting..."
  sudo ./svc.sh restart
fi

# Check disk space
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
  echo "WARNING: Disk usage at ${DISK_USAGE}%"
  docker system prune -af
fi

# Check memory
MEM_USAGE=$(free | grep Mem | awk '{print ($3/$2) * 100.0}' | cut -d. -f1)
if [ "$MEM_USAGE" -gt 90 ]; then
  echo "WARNING: Memory usage at ${MEM_USAGE}%"
fi
```

Add to cron:
```bash
crontab -e
# Add: */5 * * * * /home/ubuntu/actions-runner/monitor-runner.sh
```

## Troubleshooting

### Runner Not Appearing

1. Check service status: `sudo ./svc.sh status`
2. View logs: `journalctl -u actions.runner.* -f`
3. Verify network connectivity to GitHub
4. Check token expiration

### Build Failures

1. Verify Docker installation: `docker run --rm hello-world`
2. Check disk space: `df -h`
3. Review build logs in GitHub Actions UI
4. Test build locally on runner VM

### Performance Issues

1. Check CPU throttling: `cat /proc/cpuinfo | grep MHz`
2. Monitor memory: `free -h`
3. Check I/O wait: `iostat -x 1`
4. Review Docker daemon logs: `journalctl -u docker -f`

## Migration Checklist

- [ ] Choose runner option (GitHub-hosted vs self-hosted)
- [ ] Provision ARM64 infrastructure (if self-hosted)
- [ ] Install and configure GitHub Actions runner
- [ ] Update workflow files to use ARM64 runners
- [ ] Test builds on ARM64 runners
- [ ] Monitor build times and success rates
- [ ] Set up monitoring and alerts
- [ ] Document runner maintenance procedures
- [ ] Update team documentation

## Next Steps

1. **CI Validation Tests** - Add comprehensive testing (see: `ci-validation-tests.md`)
2. **Docker Hub Analytics** - Track image downloads and usage (see: `docker-hub-analytics.md`)
3. **Performance Benchmarking** - Measure actual speedup achieved

## References

- [GitHub Actions: Using larger runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-larger-runners)
- [Self-hosted runners documentation](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Docker multi-arch builds](https://docs.docker.com/build/building/multi-platform/)
- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
