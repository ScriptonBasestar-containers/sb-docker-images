#!/bin/bash
# Check for port conflicts across compose files
# Usage: ./scripts/check-port-conflicts.sh [directory]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
TARGET_DIR="${1:-$ROOT_DIR}"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "======================================"
echo "Port Conflict Detection"
echo "======================================"
echo ""

# Find all compose files
COMPOSE_FILES=$(find "$TARGET_DIR" -type f \( -name "compose.yml" -o -name "compose.*.yml" -o -name "docker-compose.yml" -o -name "docker-compose.*.yml" \) | grep -v "buildbox/compose" | sort)

if [ -z "$COMPOSE_FILES" ]; then
    echo -e "${YELLOW}No compose files found in $TARGET_DIR${NC}"
    exit 0
fi

# Array to store port mappings: "port:file:service"
declare -A PORT_MAP

TOTAL_FILES=0
TOTAL_PORTS=0
CONFLICTS=0

for file in $COMPOSE_FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    REL_PATH="${file#$ROOT_DIR/}"

    # Extract port mappings using grep and sed
    # Format: "PORT:CONTAINER_PORT" or "PORT" or "${VAR:-PORT}:CONTAINER_PORT"
    PORTS=$(grep -E '^\s*-\s*["'"'"']?[0-9$][^:]*:[0-9]+' "$file" 2>/dev/null | sed 's/^[[:space:]]*-[[:space:]]*["'"'"']\?//; s/["'"'"'].*//; s/:.*//; s/\${[^}]*:-\?//; s/}//g' || true)

    if [ -z "$PORTS" ]; then
        continue
    fi

    for port in $PORTS; do
        # Skip if port is a variable or not a number
        if ! [[ "$port" =~ ^[0-9]+$ ]]; then
            continue
        fi

        # Skip if port is > 65535
        if [ "$port" -gt 65535 ]; then
            continue
        fi

        TOTAL_PORTS=$((TOTAL_PORTS + 1))

        # Extract service name from context
        SERVICE=$(grep -B 20 "$port:" "$file" 2>/dev/null | grep -E "^  [a-z]" | tail -1 | sed 's/^  //; s/://; s/ .*//' || echo "unknown")

        # Check if port is already mapped
        if [ -n "${PORT_MAP[$port]}" ]; then
            EXISTING="${PORT_MAP[$port]}"
            EXISTING_FILE=$(echo "$EXISTING" | cut -d'|' -f1)

            # Skip if it's the same file (e.g., TCP and UDP on same port)
            if [ "$EXISTING_FILE" != "$REL_PATH" ]; then
                echo -e "${RED}⚠ CONFLICT: Port $port${NC}"
                echo "  Already used:"
                echo "    File: $EXISTING_FILE"
                echo "    Service: $(echo "$EXISTING" | cut -d'|' -f2)"
                echo "  Also used in:"
                echo "    File: $REL_PATH"
                echo "    Service: $SERVICE"
                echo ""
                CONFLICTS=$((CONFLICTS + 1))
            fi
        else
            PORT_MAP[$port]="$REL_PATH|$SERVICE"
            echo -e "${GREEN}✓${NC} Port $port → $REL_PATH ($SERVICE)"
        fi
    done
done

echo ""
echo "======================================"
echo "Summary"
echo "======================================"
echo "Files scanned:      $TOTAL_FILES"
echo "Total ports found:  $TOTAL_PORTS"
echo "Unique ports:       ${#PORT_MAP[@]}"

if [ $CONFLICTS -gt 0 ]; then
    echo -e "Port conflicts:     ${RED}$CONFLICTS${NC}"
    echo ""
    echo -e "${YELLOW}⚠ Port conflicts detected${NC}"
    echo ""
    echo "Recommendations:"
    echo "1. Review PORT_GUIDE.md for recommended port assignments"
    echo "2. Use environment variables for flexible port configuration"
    echo "3. Update conflicting services to use different ports"
    echo ""
    exit 0  # Don't fail, just warn
else
    echo -e "Port conflicts:     ${GREEN}0${NC}"
    echo ""
    echo -e "${GREEN}✅ No port conflicts detected${NC}"
    exit 0
fi
