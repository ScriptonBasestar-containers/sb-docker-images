#!/bin/bash
# Check for required files in each image directory
# Usage: ./scripts/check-required-files.sh [directory]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="${1:-$ROOT_DIR}"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "Required Files Check"
echo "======================================"
echo ""

# Directories to skip
SKIP_DIRS=("scripts" "buildbox" ".git" ".github" ".vscode" "work" "tmp")

# Find all directories with compose files (images/category/project/ structure)
DIRS=$(find "$TARGET_DIR" -maxdepth 4 -type f \( -name "compose.yml" -o -name "docker-compose.yml" \) -exec dirname {} \; | sort -u)

if [ -z "$DIRS" ]; then
    echo -e "${YELLOW}No directories with compose files found${NC}"
    exit 0
fi

TOTAL_DIRS=0
COMPLETE_DIRS=0
INCOMPLETE_DIRS=0

for dir in $DIRS; do
    # Skip directories in SKIP_DIRS
    SKIP=false
    for skip_dir in "${SKIP_DIRS[@]}"; do
        if [[ "$dir" == *"/$skip_dir"* ]] || [[ "$dir" == *"/$skip_dir" ]]; then
            SKIP=true
            break
        fi
    done

    if [ "$SKIP" = true ]; then
        continue
    fi

    TOTAL_DIRS=$((TOTAL_DIRS + 1))
    REL_PATH="${dir#$ROOT_DIR/}"

    echo "Checking: $REL_PATH"

    MISSING_FILES=()
    WARNINGS=()

    # Check for compose file
    HAS_COMPOSE=false
    if [ -f "$dir/compose.yml" ]; then
        echo -e "  ${GREEN}✓${NC} compose.yml"
        HAS_COMPOSE=true
    elif [ -f "$dir/docker-compose.yml" ]; then
        echo -e "  ${GREEN}✓${NC} docker-compose.yml"
        HAS_COMPOSE=true
    fi

    # Check for README
    if [ -f "$dir/README.md" ]; then
        echo -e "  ${GREEN}✓${NC} README.md"
    else
        echo -e "  ${RED}✗${NC} README.md"
        MISSING_FILES+=("README.md")
    fi

    # Check for Makefile
    if [ -f "$dir/Makefile" ]; then
        echo -e "  ${GREEN}✓${NC} Makefile"
    else
        echo -e "  ${YELLOW}⚠${NC} Makefile (optional)"
        WARNINGS+=("Makefile")
    fi

    # Check for .env.example
    if [ -f "$dir/.env.example" ]; then
        echo -e "  ${GREEN}✓${NC} .env.example"
    else
        echo -e "  ${YELLOW}⚠${NC} .env.example (recommended)"
        WARNINGS+=(".env.example")
    fi

    # Check for .gitignore (optional)
    if [ -f "$dir/.gitignore" ]; then
        echo -e "  ${GREEN}✓${NC} .gitignore"
    fi

    # Summary for this directory
    if [ ${#MISSING_FILES[@]} -eq 0 ]; then
        if [ ${#WARNINGS[@]} -eq 0 ]; then
            echo -e "  ${GREEN}Status: Complete${NC}"
        else
            echo -e "  ${YELLOW}Status: Missing optional files: ${WARNINGS[*]}${NC}"
        fi
        COMPLETE_DIRS=$((COMPLETE_DIRS + 1))
    else
        echo -e "  ${RED}Status: Missing required files: ${MISSING_FILES[*]}${NC}"
        INCOMPLETE_DIRS=$((INCOMPLETE_DIRS + 1))
    fi

    echo ""
done

echo "======================================"
echo "Summary"
echo "======================================"
echo "Total directories: $TOTAL_DIRS"
echo -e "Complete:          ${GREEN}$COMPLETE_DIRS${NC}"
if [ $INCOMPLETE_DIRS -gt 0 ]; then
    echo -e "Incomplete:        ${RED}$INCOMPLETE_DIRS${NC}"
else
    echo -e "Incomplete:        $INCOMPLETE_DIRS"
fi
echo ""

if [ $INCOMPLETE_DIRS -gt 0 ]; then
    echo -e "${YELLOW}⚠ Some directories are missing required files${NC}"
    exit 0  # Don't fail, just warn
else
    echo -e "${GREEN}✅ All directories have required files${NC}"
    exit 0
fi
