# Security Policy

## Supported Versions

We release patches for security vulnerabilities for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < Latest| :x:                |

**Note**: This repository contains Docker Compose configurations and custom Docker images. Security updates are applied to:
- Base Docker images (updated regularly)
- Custom Dockerfile configurations
- Compose file configurations
- CI/CD workflows

## Reporting a Vulnerability

We take the security of our Docker images and configurations seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do Not** Open a Public Issue

Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.

### 2. Report Privately

**Preferred Method**: Use GitHub Security Advisories
- Go to the [Security tab](https://github.com/scriptonbasestar/sb-docker-images/security/advisories)
- Click "Report a vulnerability"
- Fill in the details

**Alternative Method**: Email
- Send details to: [your-security-email@example.com]
- Include "SECURITY" in the subject line

### 3. Include These Details

Please include as much information as possible:

- **Type of vulnerability** (e.g., exposed secrets, vulnerable dependency, insecure configuration)
- **Affected components**:
  - Which Docker image(s) or project(s)
  - Which version(s)
  - Which file(s)
- **Steps to reproduce** the vulnerability
- **Potential impact** of the vulnerability
- **Suggested fix** (if you have one)

### Example Report Template

```
**Vulnerability Type**: [e.g., Exposed API Key]

**Affected Component**:
- Project: [e.g., images/cms/wordpress]
- File: [e.g., compose.yml]
- Versions: [e.g., all versions]

**Description**:
[Clear description of the vulnerability]

**Steps to Reproduce**:
1. [First step]
2. [Second step]
3. [etc.]

**Impact**:
[What could an attacker do with this vulnerability?]

**Suggested Fix**:
[Optional - your suggestion for fixing it]
```

## What to Expect

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 5 business days
- **Resolution**: Depends on severity and complexity

### Severity Levels

We assess vulnerabilities using the following severity levels:

| Severity | Description | Response Time |
|----------|-------------|---------------|
| **Critical** | Immediate threat, active exploitation possible | 24-48 hours |
| **High** | Significant threat, high impact | 5-7 days |
| **Medium** | Moderate threat, limited impact | 10-14 days |
| **Low** | Minor threat, minimal impact | 30 days |

### Our Process

1. **Acknowledge** receipt of your report
2. **Validate** the vulnerability
3. **Develop** a fix
4. **Test** the fix thoroughly
5. **Release** the fix
6. **Notify** affected users (if applicable)
7. **Credit** you in our security advisory (if desired)

## Security Best Practices

When using images from this repository:

### For Docker Images

1. **Always use specific version tags** instead of `latest`
   ```yaml
   # Good
   image: scriptonbasestar/postgres-exts:16-essential-1.0.0

   # Avoid
   image: scriptonbasestar/postgres-exts:latest
   ```

2. **Regularly update base images**
   - Check for security advisories
   - Rebuild images with latest base versions
   - Test thoroughly before deploying

3. **Scan for vulnerabilities**
   ```bash
   # Use Trivy or similar tools
   trivy image scriptonbasestar/postgres-exts:16-essential
   ```

4. **Review Dockerfiles before building**
   - Check for hardcoded secrets
   - Verify base image sources
   - Review installed packages

### For Docker Compose

1. **Never commit `.env` files with secrets**
   - Use `.env.example` as templates
   - Keep actual `.env` files local only
   - Add `.env` to `.gitignore`

2. **Use Docker secrets for production**
   ```yaml
   # Instead of environment variables
   secrets:
     db_password:
       file: ./secrets/db_password.txt
   ```

3. **Restrict network access**
   ```yaml
   # Only expose necessary ports
   ports:
     - "127.0.0.1:5432:5432"  # Localhost only
   ```

4. **Use read-only volumes when possible**
   ```yaml
   volumes:
     - ./config:/app/config:ro  # Read-only
   ```

### For CI/CD

1. **Protect secrets in GitHub Actions**
   - Use GitHub Secrets for sensitive data
   - Never log secrets
   - Use `::add-mask::` for dynamic secrets

2. **Scan in CI pipeline**
   - We use Trivy in our workflows
   - Automatically scan all images
   - Fail builds on critical vulnerabilities

3. **Review workflow permissions**
   - Use minimal required permissions
   - Avoid `contents: write` unless necessary

## Known Security Considerations

### Base Images

All images in this repository are based on official upstream images:
- PostgreSQL: Official PostgreSQL images
- Node.js: Official Node images
- Alpine: Official Alpine images

We regularly update to the latest versions and monitor security advisories.

### Multi-Architecture Builds

Our ARM64 builds use the same security standards as AMD64:
- Same base images
- Same build process
- Same security scanning

### Archived Projects

Projects in `images-archived/` are **not maintained** and may contain security vulnerabilities. Use at your own risk.

## Security Updates

### How We Handle Updates

1. **Monitoring**: We monitor security advisories for all base images
2. **Assessment**: Evaluate impact on our images
3. **Updates**: Rebuild affected images with patches
4. **Testing**: Run automated tests
5. **Release**: Push updated images to Docker Hub
6. **Notification**: Update CHANGELOG.md

### Notification Channels

- **GitHub Releases**: Security patches are tagged
- **CHANGELOG.md**: All security updates documented
- **Security Advisories**: Critical issues published

## Automated Security

We use automated tools to maintain security:

### Trivy Scanner
- Scans all Docker images
- Runs on every pull request
- Configured in `.github/workflows/security-scan.yml`

### Dependabot
- Monitors dependencies in Dockerfiles
- Automated pull requests for updates
- Enabled for this repository

### GitHub Advanced Security
- Secret scanning enabled
- Dependency graph enabled
- Security advisories enabled

## Compliance

This project follows security best practices from:
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Docker Security Best Practices](https://docs.docker.com/develop/security-best-practices/)

## Security Hall of Fame

We appreciate security researchers who help improve our security. Contributors who report valid vulnerabilities will be acknowledged here (with their permission):

<!-- Security researchers will be listed here -->

*No security vulnerabilities reported yet.*

## Questions?

If you have questions about security but don't have a vulnerability to report:
- Open a [Discussion](https://github.com/scriptonbasestar/sb-docker-images/discussions)
- Tag it with `security` label

## Additional Resources

- [Docker Security Documentation](https://docs.docker.com/engine/security/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

**Last Updated**: 2025-12-08
**Version**: 1.0

Thank you for helping keep this project and our users safe!
