#!/bin/bash
# Validate Docker Compose files syntax
# Usage: ./scripts/validate-compose.sh [directory]

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
echo "Docker Compose File Validation"
echo "======================================"
echo ""

# Find all compose files
COMPOSE_FILES=$(find "$TARGET_DIR" -type f \( -name "compose.yml" -o -name "compose.*.yml" -o -name "docker-compose.yml" -o -name "docker-compose.*.yml" \) | sort)

if [ -z "$COMPOSE_FILES" ]; then
    echo -e "${YELLOW}No compose files found in $TARGET_DIR${NC}"
    exit 0
fi

TOTAL_FILES=0
VALID_FILES=0
INVALID_FILES=0

for file in $COMPOSE_FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    REL_PATH="${file#$ROOT_DIR/}"

    echo -n "Checking: $REL_PATH ... "

    # Check if docker compose command is available
    if command -v docker &> /dev/null; then
        # Use docker compose config to validate
        if docker compose -f "$file" config > /dev/null 2>&1; then
            echo -e "${GREEN}✓ VALID${NC}"
            VALID_FILES=$((VALID_FILES + 1))
        else
            echo -e "${RED}✗ INVALID${NC}"
            echo "  Error details:"
            docker compose -f "$file" config 2>&1 | sed 's/^/    /'
            INVALID_FILES=$((INVALID_FILES + 1))
        fi
    else
        # Fallback: Just check if it's valid YAML using Python
        if command -v python3 &> /dev/null; then
            if python3 -c "import yaml, sys; yaml.safe_load(open('$file'))" 2>/dev/null; then
                echo -e "${GREEN}✓ VALID (YAML syntax only)${NC}"
                VALID_FILES=$((VALID_FILES + 1))
            else
                echo -e "${RED}✗ INVALID${NC}"
                echo "  Error details:"
                python3 -c "import yaml, sys; yaml.safe_load(open('$file'))" 2>&1 | sed 's/^/    /'
                INVALID_FILES=$((INVALID_FILES + 1))
            fi
        else
            echo -e "${YELLOW}⊘ SKIPPED (docker and python3 not found)${NC}"
        fi
    fi
done

echo ""
echo "======================================"
echo "Summary"
echo "======================================"
echo "Total files:   $TOTAL_FILES"
echo -e "Valid files:   ${GREEN}$VALID_FILES${NC}"
if [ $INVALID_FILES -gt 0 ]; then
    echo -e "Invalid files: ${RED}$INVALID_FILES${NC}"
else
    echo -e "Invalid files: $INVALID_FILES"
fi
echo ""

if [ $INVALID_FILES -gt 0 ]; then
    echo -e "${RED}❌ Validation FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All compose files are valid${NC}"
    exit 0
fi
