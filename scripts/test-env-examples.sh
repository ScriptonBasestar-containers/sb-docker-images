#!/bin/bash
# Test .env.example files for validity
# Usage: ./scripts/test-env-examples.sh [directory]

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
echo ".env.example File Validation"
echo "======================================"
echo ""

# Find all .env.example files
ENV_FILES=$(find "$TARGET_DIR" -type f -name ".env.example" | sort)

if [ -z "$ENV_FILES" ]; then
    echo -e "${YELLOW}No .env.example files found in $TARGET_DIR${NC}"
    exit 0
fi

TOTAL_FILES=0
VALID_FILES=0
INVALID_FILES=0

for file in $ENV_FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    REL_PATH="${file#$ROOT_DIR/}"
    DIR_NAME=$(dirname "$file")

    echo "Checking: $REL_PATH"

    # Check if file is not empty
    if [ ! -s "$file" ]; then
        echo -e "  ${RED}✗ File is empty${NC}"
        INVALID_FILES=$((INVALID_FILES + 1))
        continue
    fi

    # Check for valid env syntax (KEY=VALUE)
    INVALID_LINES=0
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Check if line matches KEY=VALUE pattern
        if ! [[ "$line" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; then
            echo -e "  ${RED}✗ Invalid line: $line${NC}"
            INVALID_LINES=$((INVALID_LINES + 1))
        fi
    done < "$file"

    if [ $INVALID_LINES -eq 0 ]; then
        echo -e "  ${GREEN}✓ Valid syntax${NC}"

        # Check if corresponding compose file exists
        COMPOSE_FOUND=false
        for compose_name in "compose.yml" "docker-compose.yml"; do
            if [ -f "$DIR_NAME/$compose_name" ]; then
                echo -e "  ${GREEN}✓ Found $compose_name${NC}"
                COMPOSE_FOUND=true
                break
            fi
        done

        if [ "$COMPOSE_FOUND" = false ]; then
            echo -e "  ${YELLOW}⚠ No compose file found in same directory${NC}"
        fi

        VALID_FILES=$((VALID_FILES + 1))
    else
        echo -e "  ${RED}✗ Found $INVALID_LINES invalid line(s)${NC}"
        INVALID_FILES=$((INVALID_FILES + 1))
    fi

    echo ""
done

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
    echo -e "${GREEN}✅ All .env.example files are valid${NC}"
    exit 0
fi
