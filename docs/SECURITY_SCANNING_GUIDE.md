# Security Scanning Guide

**Last Updated**: 2025-12-08
**Status**: Production Ready
**Scanner**: Trivy (Aqua Security)

---

## 🎯 Overview

Automated security vulnerability scanning for all Docker images in the sb-docker-images project. Scans run weekly and on every release, covering both AMD64 and ARM64 architectures.

### Scanner: Trivy

[Trivy](https://github.com/aquasecurity/trivy) is a comprehensive open-source security scanner that detects:

- 🔒 CVEs (Common Vulnerabilities and Exposures)
- 📦 Vulnerable packages in OS and language dependencies
- 🐳 Docker image misconfigurations
- 🔐 Secrets and sensitive data
- 📋 IaC (Infrastructure as Code) issues

---

## 🚀 Quick Start

### View Security Scan Results

**GitHub Security Tab**:
https://github.com/scriptonbasestar/sb-docker-images/security

**Scan Artifacts** (detailed reports):
https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/security-scan.yml

### Manual Scan Trigger

1. Go to [Actions → Security Scan](https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/security-scan.yml)
2. Click "Run workflow"
3. (Optional) Specify project and severity level
4. Click "Run workflow" button

### Local Scanning

```bash
# Scan a specific image
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image \
  scriptonbasestar/node-pnpm:latest

# Scan with severity filter
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image \
  --severity CRITICAL,HIGH \
  scriptonbasestar/node-pnpm:latest

# Scan Dockerfile
docker run --rm \
  -v $(pwd):/workspace \
  aquasec/trivy:latest config \
  /workspace/images/devtools/node-pnpm/Dockerfile
```

---

## 📋 Automated Scanning

### Schedule

**Weekly Scans**: Every Sunday at 00:00 UTC

Scans all high-priority projects:
- node-pnpm
- ansible-dev
- rhymix
- discourse
- devpi

**On Release**: Automatic scan when version tags are pushed

```bash
# Triggers scan for node-pnpm
git push origin node-pnpm-v1.0.1
```

### Multi-Architecture Coverage

All scans run on **both** architectures:
- ✅ linux/amd64
- ✅ linux/arm64

This ensures platform-specific vulnerabilities are detected.

---

## 🔍 Understanding Scan Results

### Severity Levels

| Level | Description | Action Required |
|-------|-------------|-----------------|
| 🔴 **CRITICAL** | Actively exploited, remote code execution | **Immediate fix** |
| 🟠 **HIGH** | Significant risk, potential exploitation | Fix within 7 days |
| 🟡 **MEDIUM** | Moderate risk, limited impact | Fix within 30 days |
| 🟢 **LOW** | Minor risk, minimal impact | Fix when convenient |

### Sample Report

```
Total: 5 (CRITICAL: 1, HIGH: 2, MEDIUM: 1, LOW: 1)

┌────────────────┬──────────────────┬──────────┬───────────────────┬───────────────┐
│   Library      │  Vulnerability   │ Severity │ Installed Version │ Fixed Version │
├────────────────┼──────────────────┼──────────┼───────────────────┼───────────────┤
│ openssl        │ CVE-2024-XXXXX   │ CRITICAL │ 3.0.2-1           │ 3.0.2-2       │
│ curl           │ CVE-2024-YYYYY   │ HIGH     │ 7.88.1-1          │ 7.88.1-2      │
│ libxml2        │ CVE-2024-ZZZZZ   │ HIGH     │ 2.11.4-1          │ 2.11.5-1      │
└────────────────┴──────────────────┴──────────┴───────────────────┴───────────────┘
```

### GitHub Security Tab Integration

Scan results automatically appear in the GitHub Security tab:

1. Navigate to **Security** → **Code scanning**
2. Filter by **Tool: Trivy**
3. Review findings by severity
4. Click on alerts for remediation guidance

---

## 🛠️ Responding to Vulnerabilities

### Critical/High Severity

**Immediate Action Required**:

1. **Review the vulnerability**:
   ```bash
   # Get detailed CVE information
   docker run --rm aquasec/trivy:latest image \
     --format json \
     scriptonbasestar/node-pnpm:latest | \
     jq '.Results[].Vulnerabilities[] | select(.Severity=="CRITICAL")'
   ```

2. **Update base image** (if vulnerability in base):
   ```dockerfile
   # Before
   FROM node:22-alpine

   # After (with updated digest)
   FROM node:22-alpine@sha256:new-digest
   ```

3. **Update dependencies** (if vulnerability in packages):
   ```dockerfile
   # Alpine
   RUN apk upgrade --no-cache openssl curl

   # Debian
   RUN apt-get update && apt-get upgrade -y openssl curl
   ```

4. **Rebuild and test**:
   ```bash
   DOCKER_BUILDKIT=1 docker build -t test:latest .
   docker run --rm aquasec/trivy:latest image test:latest
   ```

5. **Create new version tag**:
   ```bash
   # Update VERSION file
   echo "VERSION=1.0.1" > images/devtools/node-pnpm/VERSION

   # Create and push tag
   git add images/devtools/node-pnpm/VERSION
   git commit -m "security(node-pnpm): update to fix CVE-2024-XXXXX"
   git tag node-pnpm-v1.0.1
   git push origin node-pnpm-v1.0.1
   ```

### Medium/Low Severity

**Scheduled Maintenance**:

1. Group multiple fixes together
2. Update during regular maintenance windows
3. Document in CHANGELOG.md

---

## 📊 Vulnerability Workflow

```
Weekly Scan → Detect Vulnerabilities → GitHub Security Alert
                                              ↓
                        Review Severity and Impact
                                              ↓
                    ┌─────────────────────────┴────────────────────────┐
                    ↓                                                  ↓
              CRITICAL/HIGH                                    MEDIUM/LOW
                    ↓                                                  ↓
            Immediate Fix                                  Schedule Maintenance
                    ↓                                                  ↓
         Update Dependencies                               Group Multiple Fixes
                    ↓                                                  ↓
          Test and Validate                                Test and Validate
                    ↓                                                  ↓
          Create New Release                              Create New Release
                    ↓                                                  ↓
              Push Tag                                          Push Tag
                    ↓                                                  ↓
            Auto Re-scan                                       Auto Re-scan
```

---

## 🎓 Best Practices

### 1. Pin Base Image Versions

**Bad** (Unpredictable):
```dockerfile
FROM node:latest
```

**Good** (Reproducible):
```dockerfile
FROM node:22-alpine3.19
```

**Better** (Immutable):
```dockerfile
FROM node:22-alpine@sha256:abc123...
```

### 2. Minimal Base Images

**Use Alpine when possible**:
```dockerfile
# Alpine: ~100MB, fewer packages = smaller attack surface
FROM node:22-alpine

# vs. Debian: ~400MB, more packages
FROM node:22-bookworm
```

### 3. Multi-Stage Builds

**Separate build and runtime**:
```dockerfile
# Build stage (includes build tools)
FROM node:22-alpine AS builder
RUN apk add python3 make g++
COPY . .
RUN npm run build

# Runtime stage (minimal dependencies)
FROM node:22-alpine
COPY --from=builder /app/dist ./dist
# Build tools not included → smaller attack surface
```

### 4. Regular Updates

**Update base images monthly**:
```bash
# Check for newer base images
docker pull node:22-alpine
docker images --digests | grep node

# Rebuild with latest base
DOCKER_BUILDKIT=1 docker build --pull -t test:latest .
```

### 5. Avoid Running as Root

```dockerfile
# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Switch to non-root user
USER nodejs
```

---

## 🔧 Advanced Configuration

### Custom Scan Targets

Edit `.github/workflows/security-scan.yml`:

```yaml
strategy:
  matrix:
    project:
      - node-pnpm
      - ansible-dev
      - rhymix
      - your-new-project  # Add here
```

### Ignore Specific Vulnerabilities

Create `.trivyignore` file:

```
# Ignore CVE-2024-12345 (false positive)
CVE-2024-12345

# Ignore all vulnerabilities in test images
CVE-2024-* test/*

# Temporary ignore until fix available
CVE-2024-67890 # Remove after 2025-01-15
```

### Custom Severity Levels

```bash
# Scan only critical
trivy image --severity CRITICAL myimage:latest

# Scan critical, high, and medium
trivy image --severity CRITICAL,HIGH,MEDIUM myimage:latest

# Scan everything
trivy image --severity UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL myimage:latest
```

---

## 📈 Monitoring and Metrics

### Weekly Reports

GitHub automatically generates weekly security reports:

**Location**: Security → Security overview → Vulnerabilities

**Metrics**:
- Total vulnerabilities by severity
- Trends over time
- Time to remediation
- Most vulnerable images

### Alert Notifications

**Configure GitHub notifications**:

1. Go to Settings → Notifications
2. Enable "Security alerts"
3. Choose notification method (email, web, mobile)

### Dashboard Integration

Export scan results for external dashboards:

```bash
# Export to JSON
docker run --rm \
  aquasec/trivy:latest image \
  --format json \
  --output results.json \
  scriptonbasestar/node-pnpm:latest

# Parse with jq
cat results.json | jq '.Results[].Vulnerabilities | length'
```

---

## 🧪 Testing Security Fixes

### Before and After Comparison

```bash
# Scan before fix
docker run --rm aquasec/trivy:latest image \
  scriptonbasestar/node-pnpm:1.0.0 > before.txt

# Apply fix and rebuild
# ...

# Scan after fix
docker run --rm aquasec/trivy:latest image \
  scriptonbasestar/node-pnpm:1.0.1 > after.txt

# Compare
diff before.txt after.txt
```

### Verify Fix Effectiveness

```bash
# Check if specific CVE is resolved
docker run --rm aquasec/trivy:latest image \
  --severity CRITICAL \
  --vuln-type os \
  --ignore-unfixed \
  scriptonbasestar/node-pnpm:1.0.1 | grep CVE-2024-XXXXX

# Should return empty (CVE fixed)
```

---

## 🔗 Additional Resources

### Documentation
- [Trivy Official Docs](https://aquasecurity.github.io/trivy/)
- [CVE Database](https://cve.mitre.org/)
- [NVD (National Vulnerability Database)](https://nvd.nist.gov/)

### Security Tools
- [Trivy GitHub Action](https://github.com/aquasecurity/trivy-action)
- [Docker Scout](https://docs.docker.com/scout/)
- [Grype](https://github.com/anchore/grype)

### Project-Specific
- [Multi-Arch Guide](./MULTI_ARCH_GUIDE.md)
- [Docker Caching Guide](./DOCKER_CACHING_GUIDE.md)
- [CI/CD Workflows](../.github/workflows/)

---

## 📝 Maintenance Checklist

### Weekly
- [ ] Review security scan results
- [ ] Triage new vulnerabilities
- [ ] Create issues for CRITICAL/HIGH findings

### Monthly
- [ ] Update all base images
- [ ] Review and update `.trivyignore`
- [ ] Check for Trivy scanner updates

### Quarterly
- [ ] Review security scanning effectiveness
- [ ] Update security response procedures
- [ ] Audit ignored vulnerabilities

---

## 🎯 Success Metrics

**Target Goals**:
- ✅ Zero CRITICAL vulnerabilities in production images
- ✅ Fix HIGH vulnerabilities within 7 days
- ✅ 100% multi-arch scan coverage
- ✅ Weekly scan completion rate > 95%

**Current Status**: See [GitHub Security Tab](https://github.com/scriptonbasestar/sb-docker-images/security)

---

## 💡 Quick Tips

1. **Subscribe to CVE alerts** for base images you use
2. **Enable Dependabot** for automated dependency updates
3. **Test fixes in staging** before production deployment
4. **Document all ignored vulnerabilities** with justification
5. **Review scan results weekly** even if no alerts

---

**Document Version**: 1.0
**Maintained by**: Security Team
**License**: MIT
**Next Review**: 2025-03-08
