# Project Update Strategy

## Overview

This document defines the long-term strategy for maintaining and updating 46 Docker image projects with independent versioning. Each project has different update requirements based on its category, stability, and maintenance status.

## Project Categories

### 1. High Priority (Active Production) - 15 projects

**Update Frequency**: Monthly or on security updates

| Project | Current | Upstream | Update Driver |
|---------|---------|----------|---------------|
| postgres-exts | v16.1.0 | PostgreSQL 16.x | PostgreSQL releases |
| discourse | v1.0.0 | Latest stable | Security + Features |
| wikijs | v1.0.0 | v2.x | Security + Features |
| wordpress | v1.0.0 | 6.x | Security (critical) |
| flarum | v1.0.0 | stable | Security + Features |
| gitea | v1.0.0 | 1.22+ | Security + Features |
| nextcloud | v1.0.0 | Latest | Security (critical) |
| mediawiki | v1.0.0 | LTS | Security |
| drupal | v1.0.0 | 10.x | Security (critical) |
| joomla | v1.0.0 | 5.x | Security (critical) |
| jenkins | v1.0.0 | LTS | Security + Plugins |
| minio | v1.0.0 | Latest | Features + Security |
| redis | v1.0.0 | 7.x | Stable updates |
| gnuboard5 | v1.0.0 | Latest | Security |
| gnuboard6 | v1.0.0 | Latest | Security |

**Update Process**:
1. Monitor upstream releases weekly
2. Test in development environment
3. Update compose files and documentation
4. Tag new version: `<project>-vX.Y.Z`
5. CD automatically builds and deploys

### 2. Development Tools - 4 projects

**Update Frequency**: Quarterly or on major version bumps

| Project | Current | Upstream | Update Driver |
|---------|---------|----------|---------------|
| ansible-dev | v1.0.0 | Ansible 2.18+ | Major releases |
| chef-dev | v1.0.0 | Chef DK 3.4+ | Major releases |
| ruby-dev | v1.0.0 | Ruby 3.x | Major releases |
| buildbox | v1.0.0 | N/A (templates) | Template improvements |

**Update Process**:
1. Track major upstream releases
2. Update base images and dependencies
3. Test all tooling workflows
4. Update documentation
5. Tag new version

### 3. Stable/Low-Maintenance - 12 projects

**Update Frequency**: Quarterly or on security issues only

| Project | Current | Update Trigger |
|---------|---------|----------------|
| nodebb | v1.0.0 | Major releases |
| misago | v1.0.0 | Security |
| gollum | v1.0.0 | Rare updates |
| devpi | v1.0.0 | Stable |
| memcached | v1.0.0 | Stable |
| xpressengine | v1.0.0 | Community updates |
| tsboard | v1.0.0 | Community updates |
| dokuwiki | v1.0.0 | Security |
| django-cms | v1.0.0 | Django LTS updates |
| kratos | v1.0.0 | Ory releases |
| ignite | v1.0.0 | Apache releases |
| mariadb | v1.0.0 | LTS updates |

**Update Process**:
1. Monitor security advisories
2. Update on major releases only
3. Minimal testing required
4. Tag new version

### 4. Specialized Tools - 5 projects

**Update Frequency**: As needed

| Project | Current | Update Trigger |
|---------|---------|----------------|
| jupyter | v1.0.0 | User request |
| jupyter2 | v1.0.0 | User request |
| squid | v1.0.0 | Security |
| rsshub | v1.0.0 | Features |
| rtmp-proxy | v1.0.0 | Rare |
| mailslurper | v1.0.0 | Stable |

### 5. Deprecated/Archive - 5 projects

**Update Frequency**: No regular updates

| Project | Current | Status |
|---------|---------|--------|
| flaskbb | v0.9.0 | Development stopped |
| openNamu | v0.9.0 | Abandoned |
| spree | v0.9.0 | Experimental only |
| solidus | v0.9.0 | Experimental only |
| home-assistant | v0.9.0 | Reference only (use HA OS) |

**Policy**:
- No proactive updates
- Security patches only if critical
- Document deprecation in README

### 6. Experimental - 4 projects

**Update Frequency**: Community driven

| Project | Current | Status |
|---------|---------|--------|
| docker-bitcoin | v0.1.0 | Testing only |
| docker-ethereum | v0.1.0 | Testing only |
| mastodon | v0.1.0 | Large scale setup |
| forem | v0.1.0 | Community platform |

**Policy**:
- Update when community requests
- No stability guarantees
- Document experimental status

## Update Workflow

### 1. Monitoring Upstream

**Automated Monitoring** (Recommended):
```yaml
# .github/workflows/upstream-check.yml
name: Check Upstream Updates

on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday

jobs:
  check-updates:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check Docker Hub
        run: ./scripts/check-upstream-versions.sh
      - name: Create Issue
        if: updates_found
        uses: actions/create-issue@v1
```

**Manual Monitoring**:
- Subscribe to upstream release announcements
- Monitor Docker Hub for new tags
- Track GitHub releases for custom builds

### 2. Version Increment Rules

**Major Version (X.0.0)**:
```
When to increment:
- Breaking changes in compose configuration
- Major upstream version jump (e.g., PostgreSQL 16 → 17)
- Incompatible changes requiring migration
- Architecture changes

Examples:
- postgres-exts: v16.1.0 → v17.0.0 (PostgreSQL 17)
- discourse: v1.5.0 → v2.0.0 (major compose refactor)
```

**Minor Version (0.X.0)**:
```
When to increment:
- New features added
- Upstream minor/patch updates
- Compose file improvements
- New environment variables
- Documentation enhancements

Examples:
- wikijs: v1.0.0 → v1.1.0 (add Redis caching)
- wordpress: v1.2.0 → v1.3.0 (upstream 6.4 → 6.5)
```

**Patch Version (0.0.X)**:
```
When to increment:
- Bug fixes only
- Security patches
- Documentation fixes
- Configuration tweaks
- .env.example updates

Examples:
- gitea: v1.0.0 → v1.0.1 (fix health check)
- flarum: v1.1.0 → v1.1.1 (update .env.example)
```

### 3. Update Testing Checklist

**Before Tagging**:
- [ ] Update compose files
- [ ] Update .env.example
- [ ] Update README if needed
- [ ] Test locally: `docker compose up -d`
- [ ] Verify all services healthy
- [ ] Check logs for errors
- [ ] Test basic functionality
- [ ] Run automated validation scripts

**Commands**:
```bash
# 1. Update files
cd <project>/
# ... make changes ...

# 2. Local testing
docker compose up -d
docker compose ps
docker compose logs -f

# 3. Health check
docker compose ps | grep -i healthy

# 4. Validation
../../scripts/validate-compose.sh .
../../scripts/test-env-examples.sh

# 5. Cleanup
docker compose down -v

# 6. Commit and tag
git add .
git commit -m "feat(project): update to upstream vX.Y.Z"
../../scripts/version-tag.sh <project> X.Y.Z --push
```

### 4. CD Automation

**Automatic Process** (after tag push):
1. GitHub Actions detects new tag
2. Parses project and version from tag
3. Checks for Dockerfile or compose-only
4. Builds Docker image (if applicable)
5. Pushes to Docker Hub with multiple tags:
   - `scriptonbasestar/<project>:X.Y.Z`
   - `scriptonbasestar/<project>:X.Y`
   - `scriptonbasestar/<project>:X`
   - `scriptonbasestar/<project>:latest`

**Manual Dispatch**:
```bash
# Trigger manual build via GitHub UI
# Actions → CD → Run workflow → Select project
```

## Upstream Tracking

### Docker Hub Images

**Check for updates**:
```bash
#!/bin/bash
# scripts/check-upstream-versions.sh

PROJECTS=(
  "wordpress:6-php8.3-apache"
  "postgres:15-alpine"
  "redis:7-alpine"
  "mariadb:11.8"
)

for image in "${PROJECTS[@]}"; do
  echo "Checking $image..."
  docker pull "$image" --quiet

  # Compare with current version
  # ... logic to detect updates ...
done
```

### GitHub Releases

**Monitor repositories**:
- discourse/discourse
- wikijs/wiki
- gitea/gitea
- And others with custom Dockerfiles

**Tools**:
- GitHub Watch → Releases only
- RSS feeds for releases
- GitHub CLI: `gh release list`

## Batch Update Strategy

### Quarterly Update Sprint

**Week 1: High Priority**
- Update critical security projects
- Test thoroughly
- Deploy immediately

**Week 2: Development Tools**
- Update all dev tool images
- Test workflows
- Deploy

**Week 3: Stable Projects**
- Batch update low-maintenance projects
- Basic testing
- Deploy

**Week 4: Experimental**
- Update if requested
- Community testing
- Deploy

### Update Command Template

```bash
#!/bin/bash
# scripts/quarterly-update.sh

# Phase 1: High Priority (Week 1)
PHASE1=(discourse wikijs wordpress gitea flarum nextcloud)

for project in "${PHASE1[@]}"; do
  echo "Updating $project..."

  # Check upstream version
  # Update compose files
  # Test locally
  # Commit and tag
  # Wait for CD
done

# Phase 2: Development Tools (Week 2)
# ... similar process ...

# Phase 3: Stable Projects (Week 3)
# ... similar process ...
```

## Rollback Strategy

### Version Rollback

**When to rollback**:
- Critical bugs discovered
- Security issues introduced
- Breaking changes
- Failed deployment

**Process**:
```bash
# 1. Identify last working version
git tag -l '<project>-v*' | sort -V | tail -5

# 2. Create rollback tag (patch increment)
./scripts/version-tag.sh <project> X.Y.Z+1

# 3. Revert compose files to previous version
git checkout <project>-vX.Y.Z-1 -- <project>/

# 4. Commit and push
git add <project>/
git commit -m "fix(project): rollback to vX.Y.Z-1"
git push origin master
git push origin <project>-vX.Y.Z+1

# 5. CD will rebuild previous version
```

### Tag Deletion (if needed)

```bash
# Delete local tag
git tag -d <project>-vX.Y.Z

# Delete remote tag
git push origin :refs/tags/<project>-vX.Y.Z

# Note: Docker Hub images remain (manual cleanup needed)
```

## Security Update Protocol

### Critical Security Updates (< 24 hours)

1. **Identify affected projects**
2. **Update immediately**:
   ```bash
   cd <project>/
   # Update base image version
   # Test quickly (smoke test)
   git add . && git commit -m "security: patch CVE-XXXX"
   ./scripts/version-tag.sh <project> X.Y.Z --push
   ```
3. **Monitor deployment**
4. **Notify users** (if public)

### Non-Critical Security Updates (< 1 week)

1. Include in regular update cycle
2. Test normally
3. Document in CHANGELOG

## Version History Tracking

### CHANGELOG Updates

**Per-Project** (recommended):
```markdown
# <project>/CHANGELOG.md

## [1.2.0] - 2025-12-01
### Changed
- Update upstream to version X.Y
- Improve health check configuration

## [1.1.0] - 2025-11-01
### Added
- Redis caching support
- New environment variables
```

**Repository-Level** (for Phase tags):
```markdown
# CHANGELOG.md

## [Phase 12.0] - 2026-01-01
### Updated Projects
- discourse: v1.5.0 → v2.0.0
- wikijs: v1.2.0 → v1.3.0
```

## Metrics and Monitoring

### Track Update Health

**Metrics to monitor**:
- Update frequency per project
- Time since last update
- Failed deployment rate
- Rollback frequency
- Security patch response time

**Dashboard** (future enhancement):
```bash
./scripts/update-dashboard.sh

Project            | Last Update | Days Ago | Status
-------------------|-------------|----------|--------
discourse          | 2025-11-15  | 8        | ✅ OK
wikijs             | 2025-10-01  | 53       | ⚠️ Stale
postgres-exts      | 2025-11-20  | 3        | ✅ OK
```

## Communication

### Update Announcements

**For Major Updates**:
- Create GitHub Release
- Update README badges
- Notify in discussions (if public)

**For Security Updates**:
- Create security advisory
- Update immediately
- Document in CHANGELOG

## Best Practices

### DO ✅

1. **Test before tagging**: Always verify locally
2. **Semantic versioning**: Follow rules strictly
3. **Document changes**: Update CHANGELOG
4. **Monitor deployments**: Check CD workflow success
5. **Track upstream**: Subscribe to release notifications
6. **Batch minor updates**: Group compatible projects
7. **Prioritize security**: Update critical vulnerabilities immediately

### DON'T ❌

1. **Skip testing**: Never tag without verification
2. **Force push tags**: Tags are immutable
3. **Delete tags casually**: Only for critical issues
4. **Update deprecated projects**: Unless security critical
5. **Ignore failures**: Always investigate failed deployments
6. **Update without documentation**: Always update relevant docs

## Tools and Automation

### Helper Scripts (Future)

```bash
# Check for upstream updates
./scripts/check-upstream-versions.sh [project]

# Batch update multiple projects
./scripts/batch-update.sh phase1

# Generate update report
./scripts/update-report.sh --last-30-days

# Test all projects
./scripts/test-all-projects.sh

# Generate version dashboard
./scripts/version-dashboard.sh
```

### GitHub Actions (Future)

- Weekly upstream version checks
- Automated security scanning (Trivy)
- Dependency update PRs (Dependabot)
- Quarterly update reminders

## Maintenance Calendar

### Monthly Tasks
- [ ] Review high-priority project updates
- [ ] Apply security patches
- [ ] Update documentation

### Quarterly Tasks
- [ ] Batch update stable projects
- [ ] Review deprecated projects (archive or remove?)
- [ ] Update development tools
- [ ] Generate update health report

### Yearly Tasks
- [ ] Major version planning
- [ ] Architecture review
- [ ] Deprecation decisions
- [ ] Strategy revision

## References

- [VERSIONING.md](./VERSIONING.md) - Version management strategy
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Release workflow
- [CHANGELOG.md](../CHANGELOG.md) - Version history
- [Semantic Versioning](https://semver.org/) - Version numbering

---

**Last Updated**: 2025-11-23
**Next Review**: 2026-01-23
