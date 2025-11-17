#!/bin/bash
# Verify health checks in Docker Compose files
# Usage: ./scripts/verify-health-checks.sh [directory]

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
echo "Health Check Verification"
echo "======================================"
echo ""

# Find all compose files
COMPOSE_FILES=$(find "$TARGET_DIR" -type f \( -name "compose.yml" -o -name "compose.*.yml" -o -name "docker-compose.yml" -o -name "docker-compose.*.yml" \) | sort)

if [ -z "$COMPOSE_FILES" ]; then
    echo -e "${YELLOW}No compose files found in $TARGET_DIR${NC}"
    exit 0
fi

# Services that should have health checks (data services)
SHOULD_HAVE_HEALTHCHECK=("postgres" "postgresql" "mariadb" "mysql" "redis" "mongodb" "elasticsearch" "rabbitmq")

TOTAL_FILES=0
TOTAL_SERVICES=0
SERVICES_WITH_HC=0
SERVICES_WITHOUT_HC=0
RECOMMENDATIONS=0

for file in $COMPOSE_FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    REL_PATH="${file#$ROOT_DIR/}"

    # Extract services from compose file
    SERVICES=$(grep -E "^  [a-z][a-z0-9_-]*:" "$file" 2>/dev/null | sed 's/^  //; s/://' || true)

    if [ -z "$SERVICES" ]; then
        continue
    fi

    echo -e "${BLUE}File: $REL_PATH${NC}"

    for service in $SERVICES; do
        # Skip if this is not a service (e.g., networks, volumes, configs)
        # Check if the line before this service name contains "services:"
        if ! grep -B 5 "^  $service:" "$file" 2>/dev/null | grep -q "^services:"; then
            continue
        fi

        TOTAL_SERVICES=$((TOTAL_SERVICES + 1))

        # Check if service has healthcheck
        HAS_HEALTHCHECK=false
        if grep -A 10 "^  $service:" "$file" 2>/dev/null | grep -q "healthcheck:"; then
            HAS_HEALTHCHECK=true
            SERVICES_WITH_HC=$((SERVICES_WITH_HC + 1))
        fi

        # Determine if this service should have a healthcheck
        SHOULD_HAVE=false
        for pattern in "${SHOULD_HAVE_HEALTHCHECK[@]}"; do
            if [[ "$service" == *"$pattern"* ]]; then
                SHOULD_HAVE=true
                break
            fi
        done

        # Output result
        if [ "$HAS_HEALTHCHECK" = true ]; then
            echo -e "  ${GREEN}✓${NC} $service (has healthcheck)"
        elif [ "$SHOULD_HAVE" = true ]; then
            echo -e "  ${RED}✗${NC} $service (recommended: healthcheck missing)"
            RECOMMENDATIONS=$((RECOMMENDATIONS + 1))
            SERVICES_WITHOUT_HC=$((SERVICES_WITHOUT_HC + 1))

            # Provide example healthcheck based on service type
            case "$service" in
                *postgres*|*postgresql*)
                    echo "      Example:"
                    echo "        healthcheck:"
                    echo "          test: [\"CMD-SHELL\", \"pg_isready -U \$\${POSTGRES_USER}\"]"
                    echo "          interval: 10s"
                    echo "          timeout: 5s"
                    echo "          retries: 5"
                    ;;
                *mariadb*|*mysql*)
                    echo "      Example:"
                    echo "        healthcheck:"
                    echo "          test: [\"CMD\", \"healthcheck.sh\", \"--connect\", \"--innodb_initialized\"]"
                    echo "          interval: 10s"
                    echo "          timeout: 5s"
                    echo "          retries: 5"
                    ;;
                *redis*)
                    echo "      Example:"
                    echo "        healthcheck:"
                    echo "          test: [\"CMD\", \"redis-cli\", \"--raw\", \"incr\", \"ping\"]"
                    echo "          interval: 10s"
                    echo "          timeout: 3s"
                    echo "          retries: 5"
                    ;;
            esac
        else
            echo -e "  ${BLUE}○${NC} $service (optional)"
            SERVICES_WITHOUT_HC=$((SERVICES_WITHOUT_HC + 1))
        fi
    done

    echo ""
done

echo "======================================"
echo "Summary"
echo "======================================"
echo "Files scanned:                 $TOTAL_FILES"
echo "Total services:                $TOTAL_SERVICES"
echo -e "Services with healthcheck:     ${GREEN}$SERVICES_WITH_HC${NC}"
echo "Services without healthcheck:  $SERVICES_WITHOUT_HC"

if [ $RECOMMENDATIONS -gt 0 ]; then
    echo -e "Recommendations:               ${YELLOW}$RECOMMENDATIONS${NC}"
    echo ""
    echo -e "${YELLOW}⚠ Some data services are missing health checks${NC}"
    echo ""
    echo "Benefits of health checks:"
    echo "1. Ensures dependencies are ready before dependent services start"
    echo "2. Improves container orchestration reliability"
    echo "3. Enables automatic container restart on health failures"
    echo "4. Provides better monitoring and debugging capabilities"
    echo ""
    echo "See individual service recommendations above for example configurations"
    echo ""
    exit 0  # Don't fail, just warn
else
    echo -e "Recommendations:               ${GREEN}0${NC}"
    echo ""
    echo -e "${GREEN}✅ All critical services have health checks${NC}"
    exit 0
fi
