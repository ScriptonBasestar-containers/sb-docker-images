# CLAUDE.md - sb-docker-images

## Project Overview

**Type**: Docker Images Monorepo
**Purpose**: Development/testing Docker images and Docker Compose templates
**Structure**: 58 active projects across 19 categories + 6 archived
**License**: MIT-oriented (follows upstream for GPL/AGPL images)

## Repository Structure

```
sb-docker-images/
├── images/              # Categorized Docker projects (19 categories)
│   ├── analytics/       # Web analytics & BI (2 projects)
│   ├── auth/            # Authentication & security (2 projects)
│   ├── automation/      # Workflow automation (1 project)
│   ├── blockchain/      # Blockchain platforms (3 projects)
│   ├── cms/             # CMS & content platforms (9 projects)
│   ├── collaboration/   # Team collaboration tools (3 projects)
│   ├── community/       # Community & forums (6 projects)
│   ├── database/        # Databases & cache (4 projects)
│   ├── devtools/        # Development tools (8 projects)
│   ├── feed/            # RSS & feeds (1 project)
│   ├── groupware/       # Groupware (1 project)
│   ├── infrastructure/  # Infrastructure services (5 projects)
│   ├── media/           # Media streaming (1 project)
│   ├── monitoring/      # Monitoring & alerting (1 project)
│   ├── registry/        # Package registry (1 project)
│   ├── social/          # Social networks (4 projects)
│   ├── vcs/             # Version control (1 project)
│   ├── wiki/            # Wiki systems (5 projects)
│   └── archive/         # Deprecated projects (6 projects)
├── .github/workflows/   # CI/CD automation
├── scripts/             # Quality automation scripts
├── docs/                # Documentation
└── Makefile             # Root orchestration

Each project:
  ├── Makefile           # Standard commands (up/down/logs/clean)
  ├── compose.yml        # Docker Compose configuration
  ├── .env.example       # Environment variables template
  ├── VERSION            # Semantic version (MAJOR.MINOR.PATCH)
  ├── README.md          # Project documentation
  └── standalone/        # Production-ready stack (optional, 23 projects)
```

## Key Characteristics

### Standardized Project Structure
- **100% Coverage**: All 58 projects have Makefile, compose.yml, .env.example, VERSION
- **Consistent Commands**: `make up/down/logs/restart/ps/clean/shell`
- **Environment Templates**: Detailed .env.example with descriptions
- **Version Management**: Semantic versioning with Git tags

### Multi-Architecture Support
- **Platforms**: AMD64 + ARM64 (Apple Silicon M1/M2/M3, Raspberry Pi 4/5, AWS Graviton)
- **Coverage**: 60/62 projects (97%) support multi-arch
- **Build System**: Docker Buildx with QEMU emulation

### CI/CD Pipeline
- **CI** (`.github/workflows/ci.yml`): Compose validation, Makefile tests, security scans
- **CD** (`.github/workflows/cd.yml`): Tag-triggered builds, Docker Hub deployment
- **Versioning**: Project-specific tags (`wikijs-v2.0.0`, `discourse-v1.5.0`)
- **Automation**: 20 quality tests via `scripts/ci-validation-suite.sh`

### Quality Metrics
- README.md: 56/56 (100%)
- .env.example: 56/56 (100%)
- VERSION files: 56/56 (100%)
- Git version tags: 62/64 (98%)
- Multi-arch deployment: 60/62 (97%)

## Development Guidelines

### Docker Best Practices

**Image Naming**:
```
scriptonbasestar/<project>:latest
scriptonbasestar/<project>:1.2.3
scriptonbasestar/<project>:1.2
scriptonbasestar/<project>:1
```

**Dockerfile Standards**:
- Multi-stage builds for size optimization
- Non-root user execution
- Health checks for production readiness
- `.dockerignore` for build efficiency

**Compose Standards**:
- Health checks with retries
- Restart policies (`unless-stopped` for services)
- Volume management (named volumes preferred)
- Network isolation (custom networks)
- Environment variable injection

### Version Management

**Semantic Versioning**:
- **MAJOR**: Breaking changes, incompatible updates
- **MINOR**: New features, backwards-compatible
- **PATCH**: Bug fixes, security patches

**Workflow**:
```bash
# 1. Update VERSION file
echo "1.2.3" > images/wiki/wikijs/VERSION

# 2. Create Git tag
git tag wikijs-v1.2.3
git push origin wikijs-v1.2.3

# 3. CD pipeline auto-triggers
# - Builds Docker image
# - Runs tests
# - Deploys to Docker Hub with :latest, :1.2.3, :1.2, :1 tags
```

### Adding New Projects

**Checklist** (see `CONTRIBUTING.md#0-이미지-추가-기준-확인`):
1. ✅ Active upstream development
2. ✅ Official Docker support OR no official image
3. ✅ Production deployment value
4. ✅ Unique purpose (no duplicates)

**Required Files**:
- `Makefile` - Standard targets
- `compose.yml` - Docker Compose stack
- `.env.example` - Environment template
- `VERSION` - Initial version (0.1.0)
- `README.md` - Setup & usage guide

**Categories**:
- Choose existing category or propose new
- Update category `INDEX.md`
- Follow naming conventions

### Automation Scripts

**Quality Validation** (`scripts/`):
- `check-port-conflicts.sh` - Port collision detection
- `validate-compose.sh` - Compose file syntax
- `test-env-examples.sh` - Environment templates
- `verify-health-checks.sh` - Health check validation
- `verify-multiarch-manifest.sh` - Multi-arch verification
- `ci-validation-suite.sh` - 20 comprehensive tests (0-100 score)
- `docker-hub-analytics.sh` - Usage insights & multi-arch tracking

**Usage**:
```bash
# Full CI validation
./scripts/ci-validation-suite.sh --verbose --report ci-report.json

# Port conflicts
./scripts/check-port-conflicts.sh

# Multi-arch verification (sample mode for speed)
./scripts/verify-multiarch-manifest.sh --sample
```

## Port Management

**Allocation Strategy**:
- Systematic port ranges by category
- Documented in `PORT_STATUS.md`
- Automated conflict detection

**Common Ports**:
- Web apps: 3000-3999, 8000-8999
- Databases: 5432 (PostgreSQL), 3306 (MariaDB), 6379 (Redis)
- Development: 4000-4999
- Special: Host network for Home Assistant

## File Locations

### Configuration Files
- **Root**: `Makefile`, `.gitignore`, `README.md`, `CHANGELOG.md`
- **CI/CD**: `.github/workflows/*.yml`
- **Documentation**: `docs/*.md`, `PORT_STATUS.md`, `QUALITY_REPORT.md`

### Build Artifacts
- **Allowed**: `tmp/`, `build/`, `dist/` (gitignored)
- **Forbidden**: Project root, `bin/` (conflicts with system binaries)

### Temporary Files
- **Location**: `tmp/`, `tmp/scripts/` only
- **Git**: Must be in `.gitignore`
- **Cleanup**: Automatic on `make clean`

## Common Tasks

### Working with Projects

```bash
# Navigate to project
cd images/wiki/wikijs

# Setup environment
cp .env.example .env
# Edit .env as needed

# Start services
make up

# View logs
make logs

# Check status
make ps

# Stop services
make down

# Remove all data (destructive!)
make clean
```

### Standalone Deployments

For production-ready stacks (DB + Cache + Application):

```bash
cd images/cms/nextcloud/standalone
cp .env.example .env
docker compose up -d
```

### Version Commands

```bash
# List all versions
make version-list

# Show specific project version
make version-show PROJECT=wikijs

# Validate VERSION files
make version-check

# Create version tag
make version-tag PROJECT=wikijs VERSION=2.5.0
```

## Documentation

### Essential Docs
- `README.md` - This file, project overview
- `CONTRIBUTING.md` - Contribution guidelines & image criteria
- `CHANGELOG.md` - Change history
- `PORT_STATUS.md` - Port allocation & conflicts
- `QUALITY_REPORT.md` - Validation results

### Guides
- `docs/VERSIONING.md` - Version management strategy
- `docs/MULTI_ARCH_GUIDE.md` - Multi-architecture usage
- `docs/DOCKER_CACHING_GUIDE.md` - Build optimization (20-30% faster)
- `docs/SECURITY_SCANNING_GUIDE.md` - Vulnerability scanning
- `docs/BUILDBOX_INTEGRATION.md` - Framework integration patterns
- `docs/PRACTICAL_EXAMPLES.md` - Real-world usage examples
- `docs/PERFORMANCE.md` - Benchmarks & optimization
- `docs/UPDATE_STRATEGY.md` - Project update management

### CI/CD Docs
- `docs/ci/arm64-native-runners.md` - ARM64 runner setup (5-10x faster)
- `docs/ci/docker-hub-analytics.md` - Usage insights & tracking

## AI Editing Guidelines

### Project Type Recognition
- This is a **Docker template collection**, not an application codebase
- Projects contain **configuration** (Dockerfile, compose.yml), not application code
- Focus on **infrastructure** and **standardization**

### Editing Scope
**DO**:
- Improve Dockerfile/compose.yml configurations
- Enhance automation scripts (`scripts/`)
- Update documentation
- Optimize CI/CD workflows
- Standardize patterns across projects

**DON'T**:
- Modify application source code (projects are deployment templates)
- Change upstream software behavior
- Introduce project-specific exceptions (maintain standardization)
- Create files outside `tmp/` without approval

### File Modification Rules
- **Makefiles**: Preserve standard targets (up/down/logs/restart/ps/clean)
- **Compose files**: Maintain health checks, restart policies, network patterns
- **Documentation**: Follow Korean for policies, English for technical docs
- **Scripts**: Add shebang headers with usage examples

### Testing Requirements
- Validate compose files: `./scripts/validate-compose.sh`
- Check port conflicts: `./scripts/check-port-conflicts.sh`
- Run CI suite: `./scripts/ci-validation-suite.sh`
- Verify changes in `tmp/` before applying to projects

## Category-Specific Context

Each category has specialized CLAUDE.md at `images/<category>/CLAUDE.md`:
- Category purpose & patterns
- Technology stack specifics
- Common configurations
- Best practices for that domain

Refer to category CLAUDE.md when working on projects within that category.

---

**Last Updated**: 2025-12-28
**Repository**: https://github.com/scriptonbasestar/sb-docker-images
**Maintainer**: scriptonbasestar
