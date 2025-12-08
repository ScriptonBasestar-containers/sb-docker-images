## Description

<!-- Provide a brief description of the changes in this PR -->

## Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] CI/CD improvement
- [ ] Refactoring (no functional changes)
- [ ] Performance improvement
- [ ] Other (please describe):

## Related Issue

<!-- If this PR addresses an issue, link it here -->

Fixes #(issue number)

## Changes Made

<!-- List the specific changes made in this PR -->

-
-
-

## Project/Service Affected

<!-- Which projects or services does this PR affect? -->

- [ ] PostgreSQL Extensions
- [ ] Discourse
- [ ] Wiki.js
- [ ] WordPress
- [ ] Gitea
- [ ] Flarum
- [ ] CI/CD Workflows
- [ ] Scripts
- [ ] Documentation
- [ ] Other:

## Testing

<!-- Describe the tests you ran to verify your changes -->

### Test Environment
- OS:
- Architecture:
- Docker Version:
- Docker Compose Version:

### Test Results

<!-- Paste test output or describe test results -->

```bash
# Example test commands run
docker compose up -d
docker compose ps
docker compose logs
```

**Test Status**:
- [ ] All tests passed
- [ ] Some tests failed (explain below)
- [ ] No tests were run (explain why)

## Checklist

<!-- Mark completed items with an 'x' -->

### Code Quality
- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] My changes generate no new warnings
- [ ] I have checked for and removed any debug code or console logs

### Documentation
- [ ] I have updated the README.md (if needed)
- [ ] I have updated the CHANGELOG.md
- [ ] I have added/updated .env.example files (if needed)
- [ ] I have added/updated relevant documentation in docs/

### Docker Best Practices
- [ ] Dockerfile uses specific base image tags (not `latest`)
- [ ] Multi-stage builds are used where appropriate
- [ ] Images are optimized for size
- [ ] Health checks are configured (if applicable)
- [ ] No secrets or sensitive data in images/configs

### Security
- [ ] I have checked for security vulnerabilities
- [ ] No sensitive information is committed (passwords, API keys, etc.)
- [ ] I have run security scans (Trivy or similar)
- [ ] Dependencies are up-to-date

### Multi-Architecture Support
- [ ] Changes support both AMD64 and ARM64 (if applicable)
- [ ] I have tested on both architectures (or explained why not needed)
- [ ] Multi-arch manifest is properly configured

### Testing
- [ ] I have added tests that prove my fix is effective or feature works
- [ ] New and existing unit tests pass locally
- [ ] I have tested the Docker Compose configuration
- [ ] I have verified health checks work correctly

### CI/CD
- [ ] My changes pass all CI checks
- [ ] I have validated GitHub Actions workflows (if modified)
- [ ] Build times are reasonable

## Screenshots (if applicable)

<!-- Add screenshots to help explain your changes -->

## Breaking Changes

<!-- If this PR includes breaking changes, describe them and the migration path -->

**Does this PR introduce breaking changes?**
- [ ] Yes (describe below)
- [ ] No

<!-- If yes, describe:
- What breaks
- Why the change was necessary
- How users should migrate
- Example migration steps
-->

## Performance Impact

<!-- Describe any performance implications -->

- Build time: <!-- e.g., +2 min, -30 sec, no change -->
- Image size: <!-- e.g., +50MB, -10MB, no change -->
- Runtime performance: <!-- e.g., improved, degraded, no change -->

## Additional Notes

<!-- Any additional information that reviewers should know -->

## Post-Merge Tasks

<!-- Tasks to be completed after this PR is merged -->

- [ ] Update Docker Hub images
- [ ] Create release notes
- [ ] Notify users of breaking changes
- [ ] Update external documentation
- [ ] Other:

---

## For Reviewers

### Review Checklist

- [ ] Code quality is acceptable
- [ ] Documentation is complete and accurate
- [ ] Tests are adequate
- [ ] Security considerations are addressed
- [ ] Breaking changes are documented
- [ ] CI/CD passes

### Questions for Author

<!-- Reviewers: add any questions or concerns here -->

