#!/bin/bash
# Script: verify-multiarch-manifest.sh
# Purpose: Verify multi-architecture Docker image manifests on Docker Hub
# Usage: ./scripts/verify-multiarch-manifest.sh [OPTIONS]
# Options:
#   --project <name>    Check specific project only
#   --all               Check all projects (default)
#   --sample            Check 5 sample projects
#   --json              Output results in JSON format
#   --verbose           Show detailed manifest information

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOCKER_ORG="scriptonbasestar"
REQUIRED_ARCHITECTURES=("linux/amd64" "linux/arm64")
SAMPLE_PROJECTS=("node-pnpm" "postgres-exts" "discourse" "rhymix" "ansible-dev")

# Counters
TOTAL_CHECKED=0
PASSED=0
FAILED=0
MISSING_ARCHITECTURES=0

# Output mode
OUTPUT_JSON=false
VERBOSE=false
CHECK_MODE="all"
SPECIFIC_PROJECT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            CHECK_MODE="specific"
            SPECIFIC_PROJECT="$2"
            shift 2
            ;;
        --all)
            CHECK_MODE="all"
            shift
            ;;
        --sample)
            CHECK_MODE="sample"
            shift
            ;;
        --json)
            OUTPUT_JSON=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --project <name>    Check specific project only"
            echo "  --all               Check all projects (default)"
            echo "  --sample            Check 5 sample projects"
            echo "  --json              Output results in JSON format"
            echo "  --verbose, -v       Show detailed manifest information"
            echo "  --help, -h          Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 --sample                    # Quick check with 5 projects"
            echo "  $0 --project node-pnpm         # Check specific project"
            echo "  $0 --all --verbose             # Check all with details"
            echo "  $0 --all --json > results.json # Export to JSON"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to verify manifest for a single image
verify_manifest() {
    local project=$1
    local version=$2
    local image="${DOCKER_ORG}/${project}:${version}"

    TOTAL_CHECKED=$((TOTAL_CHECKED + 1))

    # Try to inspect manifest
    local manifest
    if ! manifest=$(docker manifest inspect "$image" 2>&1); then
        echo -e "${RED}✗${NC} $project:$version - Image not found or manifest unavailable"
        FAILED=$((FAILED + 1))
        return 1
    fi

    # Check for required architectures
    local found_architectures=()
    local missing_architectures=()

    for arch in "${REQUIRED_ARCHITECTURES[@]}"; do
        if echo "$manifest" | grep -q "\"architecture\": \"${arch#linux/}\""; then
            found_architectures+=("$arch")
        else
            missing_architectures+=("$arch")
        fi
    done

    # Determine result
    if [ ${#missing_architectures[@]} -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $project:$version - Multi-arch verified (${found_architectures[*]})"
        PASSED=$((PASSED + 1))

        if [ "$VERBOSE" = true ]; then
            echo "  Manifest details:"
            echo "$manifest" | jq -r '.manifests[] | "    - \(.platform.os)/\(.platform.architecture)"' 2>/dev/null || \
            echo "$manifest" | grep -A 2 '"platform"' | sed 's/^/    /'
        fi
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $project:$version - Missing architectures: ${missing_architectures[*]}"
        echo "  Found: ${found_architectures[*]}"
        MISSING_ARCHITECTURES=$((MISSING_ARCHITECTURES + 1))
        FAILED=$((FAILED + 1))
        return 1
    fi
}

# Get project list based on mode
get_project_list() {
    case $CHECK_MODE in
        specific)
            echo "$SPECIFIC_PROJECT"
            ;;
        sample)
            printf "%s\n" "${SAMPLE_PROJECTS[@]}"
            ;;
        all)
            # Extract project names from git tags
            git tag | grep -E ".*-v[0-9]+\.[0-9]+\.[0-9]+$" | sed 's/-v.*//' | sort -u
            ;;
    esac
}

# Get version for a project
get_project_version() {
    local project=$1

    # Try to get version from git tag
    local tag
    tag=$(git tag | grep "^${project}-v" | sort -V | tail -1 | sed 's/.*-v//')

    if [ -n "$tag" ]; then
        echo "$tag"
    else
        # Fallback to VERSION file
        local version_file
        version_file=$(find images -name VERSION -type f | grep "/${project}/VERSION" | head -1)

        if [ -n "$version_file" ]; then
            grep "^VERSION=" "$version_file" | cut -d= -f2
        else
            echo "1.0.0"  # Default fallback
        fi
    fi
}

# Main execution
main() {
    if [ "$OUTPUT_JSON" = false ]; then
        echo "=== Multi-Architecture Manifest Verification ==="
        echo ""
        echo "Docker Hub Organization: $DOCKER_ORG"
        echo "Required Architectures: ${REQUIRED_ARCHITECTURES[*]}"
        echo "Check Mode: $CHECK_MODE"
        echo ""
    fi

    # Check Docker CLI availability
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}Error: Docker CLI not found${NC}"
        echo "Please install Docker to use this script"
        exit 1
    fi

    # Get project list
    local projects
    projects=$(get_project_list)

    if [ -z "$projects" ]; then
        echo -e "${RED}Error: No projects found${NC}"
        exit 1
    fi

    if [ "$OUTPUT_JSON" = false ]; then
        echo "Checking manifests..."
        echo ""
    fi

    # Check each project
    while IFS= read -r project; do
        [ -z "$project" ] && continue

        local version
        version=$(get_project_version "$project")

        verify_manifest "$project" "$version"
    done <<< "$projects"

    # Output results
    if [ "$OUTPUT_JSON" = true ]; then
        cat <<EOF
{
  "total_checked": $TOTAL_CHECKED,
  "passed": $PASSED,
  "failed": $FAILED,
  "missing_architectures": $MISSING_ARCHITECTURES,
  "success_rate": $(awk "BEGIN {printf \"%.2f\", ($PASSED/$TOTAL_CHECKED)*100}"),
  "required_architectures": $(printf '%s\n' "${REQUIRED_ARCHITECTURES[@]}" | jq -R . | jq -s .),
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
    else
        echo ""
        echo "=== Summary ==="
        echo "Total checked: $TOTAL_CHECKED"
        echo -e "Passed: ${GREEN}$PASSED${NC}"
        echo -e "Failed: ${RED}$FAILED${NC}"
        echo -e "Missing architectures: ${YELLOW}$MISSING_ARCHITECTURES${NC}"

        if [ $TOTAL_CHECKED -gt 0 ]; then
            local success_rate
            success_rate=$(awk "BEGIN {printf \"%.1f\", ($PASSED/$TOTAL_CHECKED)*100}")
            echo ""
            echo "Success Rate: ${success_rate}%"

            if [ "$success_rate" = "100.0" ]; then
                echo -e "${GREEN}✓ All images have multi-arch support!${NC}"
            elif (( $(echo "$success_rate >= 90" | bc -l) )); then
                echo -e "${YELLOW}⚠ Most images verified, some issues found${NC}"
            else
                echo -e "${RED}✗ Significant multi-arch issues detected${NC}"
            fi
        fi

        echo ""
        echo "=== Next Steps ==="
        if [ $FAILED -gt 0 ]; then
            echo "1. Review failed images above"
            echo "2. Check GitHub Actions workflows: https://github.com/scriptonbasestar/sb-docker-images/actions"
            echo "3. Verify Docker Hub builds: https://hub.docker.com/r/$DOCKER_ORG/"
            echo "4. Re-run failed builds if necessary"
        else
            echo "✓ All manifests verified successfully"
            echo "✓ Multi-arch deployment is complete"
        fi
    fi

    # Exit with appropriate code
    if [ $FAILED -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Run main function
main
