# Multi-Architecture Support Plan

**Date**: 2025-12-01
**Status**: Phase 1 Complete (Infrastructure Setup)
**Phase**: 15 - Multi-Architecture Support
**Target Completion**: Phase 15-16
**Last Updated**: 2025-12-01 (Infrastructure setup completed)

---

## 🎉 Phase 1 Status: COMPLETED (2025-12-01)

**Infrastructure Setup Complete**: All CD pipeline build steps now support multi-architecture (AMD64 + ARM64).

**What's Done**:
- ✅ CD workflow updated with `--platform linux/amd64,linux/arm64`
- ✅ 4 build pathways configured for multi-arch:
  1. postgres-exts essential build
  2. postgres-exts full build
  3. Custom Dockerfile projects (direct docker buildx)
  4. Makefile-based projects
- ✅ Build and push unified (single operation)
- ✅ QEMU and Docker Buildx already configured in GitHub Actions

**Next Steps**:
- Phase 2: Select and test pilot projects (5 recommended)
- Phase 3: Category-by-category rollout
- Phase 4: Validation and testing

**Testing Required**: Push a version tag to trigger multi-arch build (e.g., `git push origin node-pnpm-v1.0.0`)

---

## Executive Summary

**Goal**: Enable ARM64 (aarch64) support alongside existing AMD64 (x86_64) builds for Docker images, expanding deployment options to:
- 🍎 Apple Silicon (M1/M2/M3 Macs)
- 🥧 Raspberry Pi 4/5
- ☁️ AWS Graviton processors
- 📱 ARM-based cloud instances

**Current State**: All 56 projects build for AMD64 only
**Target State**: 80%+ projects support multi-arch (AMD64 + ARM64)
**Estimated Effort**: 15-25 hours over 2-3 weeks

---

## Current Architecture Analysis

### Project Breakdown by Build Type

**Total Projects**: 56 active

#### Custom Dockerfile Projects (38 projects)
Projects that build custom images requiring multi-arch updates:

| Category | Count | Projects | Priority |
|----------|-------|----------|----------|
| Development Tools | 8 | ansible-dev, chef-dev, ruby-dev, jupyter, jupyter2, node-pnpm, taiga | High |
| CMS | 6 | rhymix, gnuboard5, gnuboard6, django-cms | Medium |
| Community | 5 | discourse (5 images), tsboard, misago | Medium |
| Infrastructure | 4 | postgres-exts, devpi, rtmp-proxy, squid | High |
| Web Analytics | 3 | owa, koel, agendav | Low |
| Blockchain | 2 | docker-bitcoin, docker-ethereum | Low |
| Wiki | 1 | gollum | Low |
| **Total** | **38** | | |

#### Upstream-Only Projects (18 projects)
Already multi-arch via upstream (no changes needed):

- wikijs, wordpress, gitea, flarum, nextcloud, mediawiki, dokuwiki
- jenkins, mattermost, rocketchat, bookstack, n8n, uptime-kuma, metabase
- answer, supabase, kratos, home-assistant

**Status**: ✅ **Already multi-arch capable** (depends on upstream support)

---

## Base Image Compatibility Assessment

### Sample Analysis (Representative Projects)

```dockerfile
# node-pnpm (3 variants)
FROM node:22-bookworm-slim    # ✅ Multi-arch (official)
FROM node:22-alpine           # ✅ Multi-arch (official)
FROM node:22-bookworm         # ✅ Multi-arch (official)

# rhymix (PHP-based)
FROM php:8.2-fpm-alpine       # ✅ Multi-arch (official)

# ansible-dev
FROM alpine:3.20              # ✅ Multi-arch (official)

# postgres-exts
FROM postgres:16-alpine       # ✅ Multi-arch (official)
```

**Assessment**: ✅ **All sampled base images support multi-arch**

### High Confidence Categories
Base images with excellent multi-arch support:
- ✅ `node:*` (official Node.js)
- ✅ `python:*` (official Python)
- ✅ `php:*` (official PHP)
- ✅ `alpine:*` (official Alpine)
- ✅ `postgres:*` (official PostgreSQL)
- ✅ `ruby:*` (official Ruby)
- ✅ `golang:*` (official Go)

### Potential Issues
Projects needing careful review:
- ⚠️ **discourse**: Custom Rails stack, multiple images
- ⚠️ **docker-bitcoin**: Blockchain binaries (may not have ARM builds)
- ⚠️ **docker-ethereum**: Similar concerns
- ⚠️ **chef-dev**: Chef Workstation availability on ARM64

---

## Implementation Strategy

### Phase 1: Infrastructure Setup (Week 1)

#### 1.1 Update CD Workflow for Buildx

**File**: `.github/workflows/cd.yml`

**Changes**:
```yaml
# Already exists:
- name: Set up QEMU
  uses: docker/setup-qemu-action@v3

- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3

# Add platform specification to build steps:
- name: Build with Docker
  run: |
    docker buildx build \
      --platform linux/amd64,linux/arm64 \
      -t scriptonbasestar/${PROJECT}:${VERSION} \
      --push \
      .
```

**Status**: ✅ **COMPLETED (2025-12-01)**

**Completed Changes**:
- ✅ Added `--platform linux/amd64,linux/arm64` to all buildx commands
- ✅ Updated postgres-exts essential build (Essential + Full variants)
- ✅ Updated custom Dockerfile builds
- ✅ Updated Makefile-based builds
- ✅ Integrated `--push` flag for direct Docker Hub deployment
- ✅ Removed separate push steps (now unified in build)

#### 1.2 Local Testing Environment

**Requirements**:
- Docker Desktop with Buildx enabled
- QEMU for cross-platform emulation
- ARM64 test hardware (optional, for validation)

**Setup**:
```bash
# Verify buildx available
docker buildx version

# Create multi-arch builder
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap

# Test build
docker buildx build --platform linux/amd64,linux/arm64 -t test:latest .
```

#### 1.3 Testing Infrastructure

**Options**:
1. **QEMU Emulation** (Slow but works)
   - Test ARM64 builds on AMD64 hardware
   - ~10x slower than native
   - Good for CI/CD validation

2. **GitHub Actions ARM64 Runners** (Recommended)
   - Native ARM64 builds (fast)
   - Requires GitHub Actions configuration
   - Cost: Free for public repos

3. **Local ARM64 Hardware** (Optional)
   - Apple Silicon Mac or Raspberry Pi
   - Native speed testing
   - Manual validation

**Decision**: Use QEMU for CI/CD, optional ARM64 hardware for spot-checking

---

### Phase 2: Pilot Projects (Week 1-2)

#### 2.1 Select Pilot Projects

**Criteria**:
- Small Dockerfiles (fast iteration)
- Popular/high-impact projects
- Simple dependencies
- Easy to test

**Selected Pilots** (5 projects):

1. **node-pnpm** ⭐ **Best First Choice**
   - Simple Dockerfile
   - Official multi-arch base image
   - Easy to test (node --version)
   - 3 variants provide good coverage

2. **ansible-dev**
   - Alpine-based (lightweight)
   - Development tool (high demand on Mac)
   - Easy validation

3. **rhymix**
   - PHP-based CMS
   - Representative of CMS category
   - Good test case for web apps

4. **postgres-exts**
   - Infrastructure project
   - High value for ARM64 users
   - Database extensions testable

5. **devpi**
   - Python registry
   - Simple Dockerfile
   - Critical for Python developers

#### 2.2 Pilot Implementation Steps

**For each pilot project**:

```bash
# 1. Update Dockerfile (if needed)
# Most won't need changes - just platform-aware builds

# 2. Test local multi-arch build
cd images/<category>/<project>
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t test:multiarch \
  --load \  # For local testing
  .

# 3. Run on both architectures (QEMU)
docker run --platform linux/amd64 test:multiarch <validation-command>
docker run --platform linux/arm64 test:multiarch <validation-command>

# 4. Update VERSION file (bump patch)
# Example: 1.0.0 → 1.0.1 (multi-arch support)

# 5. Create git tag
git tag <project>-v1.0.1

# 6. Push tag (triggers multi-arch CD build)
git push origin <project>-v1.0.1
```

#### 2.3 Success Criteria for Pilots

- ✅ Build completes on both architectures
- ✅ Images run successfully on both platforms
- ✅ No platform-specific bugs
- ✅ CI/CD pipeline handles multi-arch correctly
- ✅ Docker Hub shows both arch manifests

---

### Phase 3: Category Rollout (Week 2-3)

#### 3.1 Rollout by Category

**Order** (by priority and risk):

1. **Development Tools** (Week 2)
   - High demand on Apple Silicon
   - 8 projects
   - Mostly simple Dockerfiles

2. **Infrastructure** (Week 2)
   - Critical services
   - 4 projects
   - Database-related (high value)

3. **CMS** (Week 3)
   - Web applications
   - 6 projects
   - Moderate complexity

4. **Community** (Week 3)
   - Forum software
   - 5 projects
   - May have platform-specific dependencies

5. **Remaining** (Week 3)
   - Web analytics, blockchain, etc.
   - 15 projects
   - Lower priority

#### 3.2 Dockerfile Modifications Needed

**Most Common Changes**:

```dockerfile
# Before (architecture-specific packages)
RUN apt-get install -y some-amd64-only-package

# After (platform-aware)
RUN apt-get install -y \
    $(dpkg --print-architecture | \
      grep -q "amd64" && echo "some-amd64-package" || echo "some-arm64-package")

# Or: Use multi-arch packages only
RUN apt-get install -y some-multiarch-package
```

**Platform-Specific Build Args**:

```dockerfile
# Detect architecture
ARG TARGETARCH
RUN echo "Building for ${TARGETARCH}"

# Conditional logic
RUN if [ "$TARGETARCH" = "arm64" ]; then \
      echo "ARM64 specific setup"; \
    else \
      echo "AMD64 specific setup"; \
    fi
```

#### 3.3 Known Issues to Watch

**Blockchain Projects**:
- `docker-bitcoin`: Bitcoin Core may not have ARM64 builds
- `docker-ethereum`: Geth ARM64 support needs verification
- **Mitigation**: Check upstream binaries first, skip if unavailable

**Chef-dev**:
- Chef Workstation ARM64 availability uncertain
- **Mitigation**: Check chef/chefworkstation Docker Hub tags

**Custom Binaries**:
- Any project downloading pre-compiled binaries
- **Mitigation**: Use package managers instead, or check for ARM64 releases

---

### Phase 4: Validation & Testing (Ongoing)

#### 4.1 Automated Testing

**CI/CD Validation**:
```yaml
# .github/workflows/ci.yml
jobs:
  test-multiarch:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        platform: [linux/amd64, linux/arm64]
    steps:
      - uses: docker/setup-qemu-action@v3
      - uses: docker/setup-buildx-action@v3
      - name: Build and test
        run: |
          docker buildx build \
            --platform ${{ matrix.platform }} \
            --load \
            -t test:${{ matrix.platform }} .
          docker run --platform ${{ matrix.platform }} \
            test:${{ matrix.platform }} <validation-command>
```

#### 4.2 Manual Testing Checklist

For each multi-arch project:

- [ ] AMD64 build succeeds
- [ ] ARM64 build succeeds
- [ ] AMD64 image runs correctly
- [ ] ARM64 image runs correctly (QEMU or native)
- [ ] Both images produce same behavior
- [ ] Docker Hub manifest shows both architectures
- [ ] Image tags are correct (`:latest`, `:version`)
- [ ] Documentation updated (README mentions multi-arch)

#### 4.3 Docker Hub Verification

```bash
# Check manifest
docker manifest inspect scriptonbasestar/<project>:latest

# Should show:
# - linux/amd64
# - linux/arm64

# Pull and verify
docker pull --platform linux/arm64 scriptonbasestar/<project>:latest
docker inspect scriptonbasestar/<project>:latest | grep Architecture
# Should output: "Architecture": "arm64"
```

---

## Documentation Updates

### 4.1 README.md Updates

Add multi-arch badge and info:

```markdown
## Multi-Architecture Support

This image supports the following architectures:

- ✅ `linux/amd64` (Intel/AMD 64-bit)
- ✅ `linux/arm64` (ARM 64-bit - Apple Silicon, Raspberry Pi, AWS Graviton)

Docker will automatically pull the correct image for your platform.

### Manual Platform Selection

```bash
# Force AMD64
docker pull --platform linux/amd64 scriptonbasestar/<project>:latest

# Force ARM64
docker pull --platform linux/arm64 scriptonbasestar/<project>:latest
```
```

### 4.2 VERSIONING.md Update

Add multi-arch versioning strategy:

```markdown
## Multi-Architecture Versioning

Projects with multi-arch support use the same version tags for both architectures:

- `scriptonbasestar/<project>:1.0.0` - Multi-platform manifest
  - `linux/amd64` - AMD64 image
  - `linux/arm64` - ARM64 image

Docker automatically selects the correct architecture.
```

### 4.3 QUALITY_REPORT.md Metric

Add new quality metric:

```markdown
| 지표 | 커버리지 | 상태 |
|------|---------|------|
| Multi-Arch Support | XX/56 (XX%) | 🔄 |
```

---

## Resource Requirements

### Time Estimates

| Phase | Task | Estimated Time |
|-------|------|----------------|
| 1 | Infrastructure setup | 2-3 hours |
| 2 | Pilot projects (5) | 5-7 hours |
| 3 | Category rollout (33) | 10-15 hours |
| 4 | Testing & validation | 3-5 hours |
| - | Documentation | 2-3 hours |
| **Total** | | **22-33 hours** |

### Infrastructure Costs

| Resource | Cost | Notes |
|----------|------|-------|
| GitHub Actions | Free | Public repo |
| Docker Hub | Free | Community tier sufficient |
| ARM64 hardware | Optional | $0-500 (if purchasing) |
| Developer time | ~3 weeks | Part-time effort |

### Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Multi-arch coverage | 80%+ (45/56) | Projects with ARM64 support |
| Build success rate | 95%+ | Successful ARM64 builds |
| Image size increase | <10% | ARM64 vs AMD64 size |
| Build time increase | <50% | Multi-arch vs single-arch |
| User adoption | 20%+ ARM64 pulls | Docker Hub analytics |

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Base image incompatibility | Low | Medium | Pre-validate base images |
| Architecture-specific bugs | Medium | Medium | Thorough testing on both platforms |
| Increased build time | High | Low | Optimize build caching |
| Docker Hub rate limits | Low | Medium | Use authenticated pulls |
| Blockchain binary availability | Medium | Low | Skip if unavailable, document |
| Increased maintenance | Low | Low | Automated testing catches issues |

---

## Decision Points

### Must Decide Before Starting

1. **ARM64 Hardware for Testing**
   - [ ] Use QEMU only
   - [ ] Purchase ARM64 test device
   - [ ] Use cloud ARM64 instances

2. **Rollout Strategy**
   - [ ] All projects at once (risky, fast)
   - [ ] Category-by-category (recommended)
   - [ ] On-demand (reactive, slow)

3. **Version Bump Strategy**
   - [ ] Patch version (1.0.0 → 1.0.1)
   - [ ] Minor version (1.0.0 → 1.1.0)
   - [ ] Major version (1.0.0 → 2.0.0)

**Recommendation**:
- ✅ QEMU for testing (cost-effective)
- ✅ Category-by-category rollout (balanced risk)
- ✅ Patch version bump (non-breaking change)

---

## Next Steps (When Ready to Execute)

### Immediate Actions (Phase 1)

1. **Week 1, Day 1-2**: Infrastructure Setup
   ```bash
   # Update CD workflow
   git checkout -b feature/multi-arch-support

   # Modify .github/workflows/cd.yml
   # Add --platform linux/amd64,linux/arm64 to builds

   # Test locally
   docker buildx create --name multiarch --use
   ```

2. **Week 1, Day 3-5**: Pilot Projects
   ```bash
   # Start with node-pnpm
   cd images/devtools/node-pnpm

   # Test multi-arch build
   docker buildx build --platform linux/amd64,linux/arm64 .

   # Validate both platforms
   docker run --platform linux/amd64 ... node --version
   docker run --platform linux/arm64 ... node --version
   ```

3. **Week 2+**: Category Rollout
   - Development tools (8 projects)
   - Infrastructure (4 projects)
   - Continue with remaining categories

### Monitoring Success

Track progress in a dashboard:
```markdown
## Multi-Arch Rollout Progress

| Category | Total | Completed | %Complete |
|----------|-------|-----------|-----------|
| Development | 8 | 0 | 0% |
| Infrastructure | 4 | 0 | 0% |
| CMS | 6 | 0 | 0% |
| Community | 5 | 0 | 0% |
| Other | 15 | 0 | 0% |
| **Total** | **38** | **0** | **0%** |
```

---

## Conclusion

**Feasibility**: ✅ **High** - Most base images already support multi-arch

**Complexity**: ⚠️ **Medium** - Requires systematic testing but changes are minimal

**Value**: ✅ **High** - Enables Apple Silicon, Raspberry Pi, AWS Graviton users

**Recommendation**: **Proceed with phased rollout starting Q1 2025**

**Prerequisite Completion**:
- ✅ Version tag system (Phase 12 - Complete)
- ✅ CD pipeline (Phase 11 - Complete)
- ✅ Documentation (Phase 14 - Complete)

**Status**: Ready to execute when prioritized (Phase 15-16 candidate)

---

**Document Version**: 1.0
**Last Updated**: 2025-12-01
**Owner**: Infrastructure Team
**Next Review**: Before Phase 15 planning
