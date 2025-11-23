# Versioning Strategy

## Overview

This repository contains 53+ independent Docker image projects. Each project has its own versioning lifecycle, independent of the repository's documentation/infrastructure versions.

## Version Types

### 1. Project Versions (Per-Image)

**Format**: `<project>-v<major>.<minor>.<patch>`

Each Docker image project has independent versioning:

```bash
# Examples
discourse-v1.2.3
wikijs-v2.1.0
postgres-exts-v16.2.1
wordpress-v1.0.5
```

**When to increment**:
- **Major**: Breaking changes, major upstream version jumps
- **Minor**: New features, significant compose changes
- **Patch**: Bug fixes, minor configuration updates

### 2. Phase Versions (Repository-Wide)

**Format**: `phase-<major>.<minor>`

Used for repository-wide improvements (documentation, infrastructure, automation):

```bash
# Examples
phase-11.7  # Documentation improvements
phase-12.0  # Major automation overhaul
```

**Not tied to specific image releases**.

## Git Tagging Convention

### Project Tags

```bash
# Tag specific project version
git tag discourse-v1.2.3
git tag wikijs-v2.0.0
git tag postgres-exts-v16.2.1

# Push tags
git push origin discourse-v1.2.3
git push origin --tags
```

### Phase Tags

```bash
# Repository milestone
git tag phase-11.7 -m "Phase 11.7: Complete documentation overhaul"
git push origin phase-11.7
```

## CD/CI Workflow

### Automatic Builds

CD workflow triggers on project-specific tags:

```yaml
on:
  push:
    tags:
      - '*-v*'              # All project tags
      - 'discourse-v*'      # Specific project
      - 'wikijs-v*'
      - 'postgres-exts-v*'
```

### Manual Dispatch

Manual builds available via workflow_dispatch:

```bash
# GitHub Actions → CD → Run workflow
# Select project from dropdown
```

## Docker Hub Tags

Each image uses semantic versioning on Docker Hub:

```
scriptonbasestar/discourse:1.2.3      # Specific version
scriptonbasestar/discourse:1.2        # Minor version alias
scriptonbasestar/discourse:1          # Major version alias
scriptonbasestar/discourse:latest     # Latest stable

scriptonbasestar/wikijs:2.0.0
scriptonbasestar/wikijs:2.0
scriptonbasestar/wikijs:2
scriptonbasestar/wikijs:latest

scriptonbasestar/postgres-exts:16.2.1
scriptonbasestar/postgres-exts:16.2
scriptonbasestar/postgres-exts:16
scriptonbasestar/postgres-exts:latest
```

## Project Types

### Custom Build Projects

Projects with Dockerfiles that build custom images:

- **ansible-dev**, **chef-dev**, **discourse**, **jupyter**, **ruby-dev**, **squid**
- Start at `v1.0.0`
- Version based on feature additions/changes

### Upstream Wrapper Projects

Projects using upstream images with custom compose configurations:

- **wikijs**, **wordpress**, **gitea**, **flarum**, **nextcloud**
- Start at `v1.0.0` (wrapper version)
- Version based on compose/configuration changes
- Upstream image version documented separately

### Special Cases

**postgres-exts**: Follows PostgreSQL major version
- Format: `postgres-exts-v16.x.x` for PostgreSQL 16
- Minor/patch versions for extension updates

## Version Inventory

See [tmp/VERSION_INVENTORY.md](../tmp/VERSION_INVENTORY.md) for:
- Current version status of all projects
- Proposed initial versions
- Priority rollout phases

## Tagging Workflow

### Using Helper Scripts

```bash
# Tag a new project version
./scripts/version-tag.sh discourse 1.2.3

# List all project versions
./scripts/list-versions.sh

# List versions for specific project
./scripts/list-versions.sh discourse
```

### Manual Tagging

```bash
# 1. Commit your changes
git add discourse/
git commit -m "feat(discourse): add Redis caching support"

# 2. Tag with project version
git tag discourse-v1.2.3

# 3. Push commit and tag
git push origin master
git push origin discourse-v1.2.3

# 4. CD workflow automatically builds and pushes to Docker Hub
```

## Migration from v11.7

### Current State

- Single repository tag: `v11.7`
- Only postgres-exts has project-specific versioning

### Migration Plan

1. **Rename existing tag**: `v11.7` → `phase-11.7`
2. **Initial project tagging**: Start with high-priority projects
3. **Update CD workflow**: Add per-project build jobs
4. **Document in CHANGELOG**: Track version history

### Backwards Compatibility

- Existing `v11.7` tag preserved as `phase-11.7`
- No breaking changes to current deployments
- New tagging adds capability, doesn't remove old structure

## Best Practices

### 1. Version Consistency

```bash
# Good
git tag discourse-v1.2.3
docker tag: scriptonbasestar/discourse:1.2.3

# Bad - version mismatch
git tag discourse-v1.2.3
docker tag: scriptonbasestar/discourse:1.3.0
```

### 2. Changelog Updates

Update project-specific or root CHANGELOG.md:

```markdown
## discourse-v1.2.3 (2025-01-15)

### Features
- Add Redis caching support
- Improve email configuration

### Bug Fixes
- Fix PostgreSQL connection timeout
```

### 3. Testing Before Tagging

```bash
# Build locally
cd discourse
docker compose build

# Test
docker compose up -d
docker compose ps
docker compose logs

# Tag only after successful test
git tag discourse-v1.2.3
```

### 4. Tag Naming Rules

- ✅ `discourse-v1.2.3` - Correct
- ✅ `postgres-exts-v16.2.1` - Correct
- ❌ `discourse-1.2.3` - Missing 'v'
- ❌ `discourse_v1.2.3` - Use hyphen, not underscore
- ❌ `v1.2.3` - Missing project name

## FAQ

### Why separate project versions?

Each project has independent:
- Upstream dependencies
- Feature lifecycles
- Update schedules
- User bases

Monolithic versioning (`v11.7`) doesn't reflect individual project states.

### Can I still use phase versions?

Yes! Phase versions track repository-wide improvements:
- Documentation overhauls
- CI/CD infrastructure
- Automation scripts
- Quality initiatives

### What about deprecated projects?

Deprecated projects (xe3, flaskbb, openNamu) won't receive new versions unless reactivated.

### How do I know which version to use?

Check:
1. `git tag | grep <project>` - Latest git tag
2. Docker Hub - Latest published image
3. Project README - Recommended version

## Related Documentation

- [CHANGELOG.md](../CHANGELOG.md) - Version history
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Development workflow
- [CI/CD Workflows](../.github/workflows/) - Automation
- [VERSION_INVENTORY.md](../tmp/VERSION_INVENTORY.md) - Current version status
