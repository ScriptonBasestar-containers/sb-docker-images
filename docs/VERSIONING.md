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

### Quick Reference

```bash
# Create tag locally
git tag <project>-v<version>

# Verify tag before pushing
git tag | grep <project>

# Push tag to trigger CD pipeline
git push origin <project>-v<version>

# Monitor build on GitHub Actions
# https://github.com/scriptonbasestar/sb-docker-images/actions
```

### Using Helper Scripts

```bash
# Tag a new project version
./scripts/version-tag.sh discourse 1.2.3

# Dry-run to preview (recommended first)
./scripts/version-tag.sh discourse 1.2.3 --dry-run

# List all project versions
./scripts/list-versions.sh

# List versions for specific project
./scripts/list-versions.sh discourse

# Show only latest versions
./scripts/list-versions.sh --latest
```

### Manual Tagging (Complete Workflow)

#### Step 1: Commit Changes

```bash
# 1a. Stage your changes
git add images/<category>/<project>/

# 1b. Commit with descriptive message
git commit -m "feat(<project>): add Redis caching support"

# 1c. Push commits first (recommended)
git push origin master
```

#### Step 2: Create and Verify Tag

```bash
# 2a. Create lightweight tag
git tag discourse-v1.2.3

# OR: Create annotated tag (recommended for releases)
git tag -a discourse-v1.2.3 -m "Release v1.2.3: Redis caching support"

# 2b. Verify tag was created correctly
git tag | grep discourse
# Expected output: discourse-v1.2.3

# 2c. Check tag points to correct commit
git show discourse-v1.2.3 --stat
```

#### Step 3: Push Tag (Triggers CD Pipeline)

```bash
# 3a. Push single tag
git push origin discourse-v1.2.3

# OR: Push all new tags (use with caution!)
# git push origin --tags

# 3b. Verify tag was pushed
git ls-remote --tags origin | grep discourse
```

#### Step 4: Monitor CD Pipeline

```bash
# 4a. Open GitHub Actions page
# https://github.com/scriptonbasestar/sb-docker-images/actions

# 4b. Look for workflow run with tag name
# Workflow: "CD - Continuous Deployment"
# Trigger: "push of tag discourse-v1.2.3"

# 4c. Wait for completion (typically 5-15 minutes)
# - Build steps
# - Test steps
# - Docker Hub push

# 4d. Verify image on Docker Hub
# https://hub.docker.com/r/scriptonbasestar/discourse/tags
```

#### Step 5: Verify Deployment

```bash
# 5a. Pull the new image
docker pull scriptonbasestar/discourse:1.2.3

# 5b. Verify image tags
docker images | grep scriptonbasestar/discourse

# Expected output:
# scriptonbasestar/discourse  1.2.3   <image-id>  <timestamp>
# scriptonbasestar/discourse  1.2     <image-id>  <timestamp>
# scriptonbasestar/discourse  1       <image-id>  <timestamp>
# scriptonbasestar/discourse  latest  <image-id>  <timestamp>
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

### Batch Tagging (Multiple Projects)

For releasing multiple projects at once (e.g., Phase completion):

```bash
# Create all tags locally first
git tag metabase-v1.0.0
git tag owa-v1.0.0
git tag n8n-v1.0.0
git tag bookstack-v1.0.0
git tag answer-v1.0.0

# Verify all tags created
git tag | grep -E "(metabase|owa|n8n|bookstack|answer)-v1.0.0"

# Push tags one by one (recommended for monitoring)
git push origin metabase-v1.0.0
# Wait for CD completion, verify success
git push origin owa-v1.0.0
# Repeat...

# OR: Push all at once (only if confident)
git push origin --tags
# Note: This triggers CD for ALL new tags simultaneously
# May cause resource contention on GitHub Actions runners
```

### Troubleshooting

#### Tag Already Exists

```bash
# Error: tag 'discourse-v1.2.3' already exists
git tag | grep discourse-v1.2.3

# Solution 1: Use next version
git tag discourse-v1.2.4

# Solution 2: Delete and recreate (local only, before push)
git tag -d discourse-v1.2.3
git tag discourse-v1.2.3

# Solution 3: Force overwrite (use with extreme caution!)
git tag -f discourse-v1.2.3
git push origin discourse-v1.2.3 --force
```

#### Tag Pushed But CD Not Triggering

```bash
# Check tag format matches pattern
git tag | grep discourse
# Must match: <project>-v<MAJOR>.<MINOR>.<PATCH>

# Common issues:
# ❌ discourse-1.2.3     (missing 'v')
# ❌ discourse_v1.2.3    (underscore instead of hyphen)
# ❌ v1.2.3              (missing project name)
# ✅ discourse-v1.2.3    (correct)

# Verify CD workflow pattern
cat .github/workflows/cd.yml | grep "tags:"
# Should include: '*-v*.*.*'
```

#### CD Build Failed

```bash
# 1. Check GitHub Actions logs
# https://github.com/scriptonbasestar/sb-docker-images/actions

# 2. Common failures:
# - Dockerfile syntax error → Fix and re-tag with patch version
# - Missing dependencies → Update Dockerfile
# - Test failures → Fix tests and re-tag
# - Docker Hub auth → Check repository secrets

# 3. Delete failed tag (if needed)
git tag -d discourse-v1.2.3
git push origin :refs/tags/discourse-v1.2.3  # Delete remote tag

# 4. Fix issue and create new tag
git tag discourse-v1.2.4
git push origin discourse-v1.2.4
```

#### Wrong Tag Pushed

```bash
# Delete remote tag immediately
git push origin :refs/tags/discourse-v1.2.3

# Delete local tag
git tag -d discourse-v1.2.3

# Create correct tag
git tag discourse-v1.2.3
git push origin discourse-v1.2.3
```

#### Docker Hub Image Not Updating

```bash
# 1. Verify CD workflow completed successfully
# Check GitHub Actions for green checkmark

# 2. Check CD logs for push step
# Look for: "docker push scriptonbasestar/discourse:1.2.3"

# 3. Verify Docker Hub credentials
# Repository Settings → Secrets → DOCKER_USERNAME, DOCKER_PASSWORD

# 4. Check Docker Hub API rate limits
# https://hub.docker.com/settings/general

# 5. Manual verification
docker pull scriptonbasestar/discourse:1.2.3
# If fails: Image wasn't pushed (check CD logs)
# If succeeds: Image exists (may be cache issue)
```

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
- [UPDATE_STRATEGY.md](./UPDATE_STRATEGY.md) - Long-term update strategy ⭐ **NEW**
- [CI/CD Workflows](../.github/workflows/) - Automation
- [VERSION_INVENTORY.md](../tmp/VERSION_INVENTORY.md) - Current version status
