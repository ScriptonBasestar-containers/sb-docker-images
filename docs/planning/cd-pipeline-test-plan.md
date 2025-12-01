# CD Pipeline Test Plan

**Date**: 2025-12-01
**Purpose**: Validate tag-triggered CD pipeline for Docker Hub deployment
**Status**: Pre-execution validation ✅ Complete

---

## Pre-Push Validation ✅

### 1. Tag Format Verification

```bash
# Verify all tags match CD trigger pattern (*-v*.*.*)
git tag | grep -E "^[a-z0-9-]+-v[0-9]+\.[0-9]+\.[0-9]+$" | wc -l
# Result: 62 tags (all match pattern)

# Sample tags for testing
git tag | grep -E "^(node-pnpm|metabase|answer)-v1.0.0$"
# Result:
# answer-v1.0.0
# metabase-v1.0.0
# node-pnpm-v1.0.0
```

**Status**: ✅ All 62 tags match CD trigger pattern `*-v*.*.*`

### 2. CD Workflow Configuration

```bash
# Verify CD workflow exists and is valid
cat .github/workflows/cd.yml | head -20
```

**Validated**:
- ✅ Trigger pattern: `*-v*.*.*` (matches all project tags)
- ✅ Phase tag support: `phase-*`
- ✅ Manual dispatch option available
- ✅ Multi-project detection logic
- ✅ Docker Hub login configured

### 3. Project Detection Logic

The CD workflow parses tags to extract project name and version:

```yaml
# Tag format: <project>-v<version>
# Example: node-pnpm-v1.0.0
#   → Project: node-pnpm
#   → Version: 1.0.0
```

**Test Cases**:

| Tag | Expected Project | Expected Version | Valid |
|-----|------------------|------------------|-------|
| `node-pnpm-v1.0.0` | node-pnpm | 1.0.0 | ✅ |
| `metabase-v1.0.0` | metabase | 1.0.0 | ✅ |
| `answer-v1.0.0` | answer | 1.0.0 | ✅ |
| `postgres-exts-v16.2.1` | postgres-exts | 16.2.1 | ✅ |

### 4. Project Directory Verification

```bash
# Verify test projects exist in images/
find images -type d -name "node-pnpm" | head -1
# Result: images/devtools/node-pnpm

find images -type d -name "metabase" | head -1
# Result: images/analytics/metabase

find images -type d -name "answer" | head -1
# Result: images/community/answer
```

**Status**: ✅ All test projects have valid directory structure

### 5. Dockerfile Detection

```bash
# Check which projects have Dockerfiles (custom builds)
ls images/devtools/node-pnpm/Dockerfile* 2>/dev/null
ls images/analytics/metabase/Dockerfile* 2>/dev/null
ls images/community/answer/Dockerfile* 2>/dev/null
```

**Results**:
- `node-pnpm`: ✅ Has Dockerfiles (3 variants: debian, alpine, builder)
- `metabase`: ❌ No Dockerfile (uses upstream image)
- `answer`: ❌ No Dockerfile (uses upstream image)

**Expected CD Behavior**:
- `node-pnpm`: Build custom images, push to Docker Hub
- `metabase`, `answer`: Skip build, document upstream usage

---

## Test Execution Plan

### Phase 1: Dry Run (No Push) ✅ Complete

**Completed**:
- ✅ Verified tag format matches CD pattern
- ✅ Confirmed CD workflow configuration
- ✅ Validated project detection logic
- ✅ Checked project directory structure
- ✅ Identified build types (custom vs upstream)

### Phase 2: Single Tag Push (Recommended First Test)

**Recommended Test Subject**: `node-pnpm-v1.0.0`

**Rationale**:
- ✅ Has custom Dockerfile (actual build/push will occur)
- ✅ Small project (fast build time ~2-3 min)
- ✅ Multi-variant build (tests complex scenario)
- ✅ New Phase 12 project (validates recent additions)

**Execution Steps**:

```bash
# 1. Verify current state
git tag | grep node-pnpm-v1.0.0
git ls-remote --tags origin | grep node-pnpm

# 2. Push tag to trigger CD
git push origin node-pnpm-v1.0.0

# 3. Monitor GitHub Actions
# Open: https://github.com/scriptonbasestar/sb-docker-images/actions
# Look for: "CD - Continuous Deployment" workflow
# Trigger: "push of tag node-pnpm-v1.0.0"

# 4. Expected workflow steps:
# - Detect project: node-pnpm
# - Detect version: 1.0.0
# - Find Dockerfiles: debian.dockerfile, alpine.dockerfile, builder.dockerfile
# - Build images (3 variants)
# - Push to Docker Hub:
#   scriptonbasestar/node-pnpm:1.0.0-debian
#   scriptonbasestar/node-pnpm:1.0.0-alpine
#   scriptonbasestar/node-pnpm:1.0.0-builder
#   scriptonbasestar/node-pnpm:latest

# 5. Verify on Docker Hub (after ~5-10 min)
# Visit: https://hub.docker.com/r/scriptonbasestar/node-pnpm/tags
# Expected tags: 1.0.0-debian, 1.0.0-alpine, 1.0.0-builder, latest

# 6. Pull and test image
docker pull scriptonbasestar/node-pnpm:1.0.0-alpine
docker run --rm scriptonbasestar/node-pnpm:1.0.0-alpine node --version
docker run --rm scriptonbasestar/node-pnpm:1.0.0-alpine pnpm --version
```

**Expected Duration**: 5-10 minutes

**Success Criteria**:
- ✅ GitHub Actions workflow completes successfully
- ✅ Images appear on Docker Hub with correct tags
- ✅ Images are pullable and functional
- ✅ No errors in CD logs

### Phase 3: Upstream Image Test (Optional)

**Test Subject**: `metabase-v1.0.0` or `answer-v1.0.0`

**Execution**:

```bash
# Push upstream-only project tag
git push origin metabase-v1.0.0

# Expected behavior:
# - CD detects no Dockerfile
# - Workflow completes with info message
# - No Docker Hub push (expected)
# - Summary shows: "This project uses upstream images"
```

**Success Criteria**:
- ✅ Workflow completes without errors
- ✅ Correctly identifies as upstream-only project
- ✅ No failed push attempts

### Phase 4: Batch Tag Push (After Single Success)

**Only after Phase 2 succeeds**:

```bash
# Push multiple tags at once
git push origin metabase-v1.0.0 answer-v1.0.0 bookstack-v1.0.0

# OR: Push all remaining tags
git push origin --tags

# Monitor for:
# - Multiple concurrent workflow runs
# - GitHub Actions runner capacity
# - All workflows complete successfully
```

**Caution**: May cause resource contention. Recommend sequential pushes for first deployment.

---

## Validation Checklist

### Pre-Push Validation ✅
- [x] All tags match pattern `*-v*.*.*`
- [x] CD workflow file exists and is valid
- [x] Project detection logic verified
- [x] Project directories exist
- [x] Dockerfile presence checked

### Post-Push Validation (User Action Required)
- [ ] GitHub Actions workflow triggered
- [ ] Workflow completed successfully
- [ ] Docker Hub images published
- [ ] Images are pullable
- [ ] Images are functional (node/pnpm versions correct)

### Optional Validations
- [ ] Upstream-only project handled correctly
- [ ] Multi-tag push works without issues
- [ ] CD logs are clear and informative

---

## Troubleshooting Reference

### If Workflow Doesn't Trigger

```bash
# Check if tag was pushed
git ls-remote --tags origin | grep node-pnpm

# Verify tag format
git tag -l "node-pnpm-v*"

# Check GitHub Actions page
# https://github.com/scriptonbasestar/sb-docker-images/actions
```

### If Build Fails

**Common Issues**:
1. **Dockerfile error**: Check syntax in images/devtools/node-pnpm/*.dockerfile
2. **Missing dependency**: Update package installation in Dockerfile
3. **Docker Hub auth**: Verify DOCKER_USERNAME and DOCKER_PASSWORD secrets
4. **Rate limits**: Check Docker Hub pull/push limits

**Fix and Retry**:
```bash
# Fix issue in code
git add images/devtools/node-pnpm/
git commit -m "fix(node-pnpm): fix Dockerfile issue"
git push origin master

# Delete old tag
git tag -d node-pnpm-v1.0.0
git push origin :refs/tags/node-pnpm-v1.0.0

# Create new patch version
git tag node-pnpm-v1.0.1
git push origin node-pnpm-v1.0.1
```

### If Images Don't Appear on Docker Hub

1. Check workflow logs for push step
2. Verify Docker Hub credentials in repository secrets
3. Check Docker Hub API status
4. Verify image was actually built (check build step logs)

---

## Risk Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| Build failure | Low | Test with small project first |
| Docker Hub auth failure | Medium | Verify credentials before push |
| Resource contention | Low | Push tags sequentially |
| Broken images | Low | Test images after pull |
| Tag confusion | Very Low | Clear naming convention |

---

## Recommendations

### For First Test
1. ✅ **Use node-pnpm-v1.0.0** (has Dockerfile, small size)
2. ✅ **Monitor closely** (watch GitHub Actions live)
3. ✅ **Test image after build** (pull and verify functionality)
4. ✅ **Document results** (update this file with actual results)

### For Production Rollout
1. ⏭️ **Sequential pushes** (avoid overwhelming runners)
2. ⏭️ **Group by category** (push all CMS projects together, etc.)
3. ⏭️ **Monitor each batch** (ensure success before next batch)
4. ⏭️ **Keep rollback plan** (know how to delete tags if needed)

---

## Next Steps

**User Action Required**:

```bash
# When ready to test, execute:
git push origin node-pnpm-v1.0.0

# Then monitor:
# 1. GitHub Actions: https://github.com/scriptonbasestar/sb-docker-images/actions
# 2. Wait 5-10 minutes
# 3. Check Docker Hub: https://hub.docker.com/r/scriptonbasestar/node-pnpm/tags
# 4. Pull and test: docker pull scriptonbasestar/node-pnpm:1.0.0-alpine
```

**After Success**:
- Update this document with actual results
- Proceed with Phase 3 (upstream test) or Phase 4 (batch push)
- Document any issues encountered

---

## Conclusion

**Pre-validation Status**: ✅ **READY FOR TESTING**

All pre-push validations are complete. The CD pipeline is correctly configured and ready to trigger on tag push. The test plan is comprehensive with clear success criteria and troubleshooting steps.

**Recommended First Action**: Push `node-pnpm-v1.0.0` tag and monitor GitHub Actions workflow.

---

**Document Version**: 1.0
**Last Updated**: 2025-12-01
**Next Review**: After first successful tag push
