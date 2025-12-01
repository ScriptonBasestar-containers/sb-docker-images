#!/bin/bash
# Script: check-multiarch-builds.sh
# Purpose: Check multi-arch build status on GitHub Actions
# Usage: ./scripts/check-multiarch-builds.sh

set -euo pipefail

echo "=== Multi-Arch Build Status Checker ==="
echo ""
echo "Checking GitHub Actions workflows for multi-arch builds..."
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Count total tags
TOTAL_TAGS=$(git tag | grep -v -E "^(phase-|v[0-9])" | wc -l)
echo "Total project tags: $TOTAL_TAGS"

# Count pushed tags
PUSHED_TAGS=$(git ls-remote --tags origin 2>/dev/null | grep -v "\^{}" | grep -v "phase-\|^.*refs/tags/v[0-9]" | wc -l)
echo "Tags pushed to remote: $PUSHED_TAGS"

echo ""
echo "Multi-arch deployment coverage: ${PUSHED_TAGS}/${TOTAL_TAGS} ($(awk "BEGIN {printf \"%.0f\", (${PUSHED_TAGS}/${TOTAL_TAGS})*100}")%)"
echo ""

echo "=== Pilot Projects Status ==="

# Fetch remote tags once
REMOTE_TAGS=$(git ls-remote --tags origin 2>/dev/null || echo "")

check_tag() {
    local project=$1
    local tag_name="${project}-v1.0.0"

    if echo "$REMOTE_TAGS" | grep -q "$tag_name"; then
        echo -e "${GREEN}✓${NC} $project - tag pushed ($tag_name)"
    else
        echo -e "${RED}✗${NC} $project - tag not found ($tag_name)"
    fi
}

check_tag "node-pnpm"
check_tag "ansible-dev"
check_tag "rhymix"
check_tag "postgres-exts"
check_tag "devpi"

echo ""
echo "=== Recent Commits ==="
git log --oneline -5
echo ""

echo "=== GitHub Actions Links ==="
echo "Main Actions page: https://github.com/scriptonbasestar/sb-docker-images/actions"
echo "CD Workflows: https://github.com/scriptonbasestar/sb-docker-images/actions/workflows/cd.yml"
echo ""

echo "=== Docker Hub Verification ==="
echo "Organization: https://hub.docker.com/r/scriptonbasestar/"
echo ""
echo "Example manifests to check:"
echo "  docker manifest inspect scriptonbasestar/node-pnpm:1.0.0"
echo "  docker manifest inspect scriptonbasestar/ansible-dev:1.0.0"
echo "  docker manifest inspect scriptonbasestar/rhymix:1.0.0"
echo ""

echo "=== Expected Build Timeline ==="
echo "Workflows triggered: ~60"
echo "Build time per workflow: 10-15 minutes"
echo "Total time (parallel): 10-15 hours"
echo ""
echo -e "${YELLOW}Note: Check GitHub Actions after ~1 hour for initial results${NC}"
echo ""

echo "=== Manual Verification Commands ==="
echo ""
echo "1. Check if ARM64 image exists:"
echo "   docker pull --platform linux/arm64 scriptonbasestar/node-pnpm:1.0.0-alpine"
echo ""
echo "2. Test ARM64 image (via QEMU):"
echo "   docker run --rm --platform linux/arm64 scriptonbasestar/node-pnpm:1.0.0-alpine node --version"
echo ""
echo "3. Verify multi-platform manifest:"
echo "   docker manifest inspect scriptonbasestar/node-pnpm:1.0.0-alpine | grep -A 3 'platform'"
echo ""
echo "   Should show both:"
echo "     - linux/amd64"
echo "     - linux/arm64"
echo ""

echo "=== Status Check Complete ==="
