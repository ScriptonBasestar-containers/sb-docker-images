#!/usr/bin/env bash
# Script: check-update-status.sh
# Purpose: Check project update status and display dashboard
# Usage: ./scripts/check-update-status.sh [options]
# Example: ./scripts/check-update-status.sh --stale-days 60

set -euo pipefail

# Check bash version (need 4.0+ for associative arrays)
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
  echo "Error: Bash 4.0 or higher required for associative arrays"
  echo "Current version: $BASH_VERSION"
  echo ""
  echo "On macOS, install via: brew install bash"
  echo "Then run with: /usr/local/bin/bash $0"
  exit 1
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Default settings
STALE_DAYS=60
SHOW_ALL=false

# Parse options
while [[ $# -gt 0 ]]; do
  case $1 in
    --stale-days)
      STALE_DAYS="$2"
      shift 2
      ;;
    --all)
      SHOW_ALL=true
      shift
      ;;
    -h|--help)
      cat << EOF
Usage: $0 [options]

Check update status for all projects

Options:
  --stale-days N    Consider projects stale after N days (default: 60)
  --all            Show all projects including up-to-date
  -h, --help       Show this help

Examples:
  $0
  $0 --stale-days 30
  $0 --all
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}  Project Update Status Dashboard${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Get current date
CURRENT_DATE=$(date +%s)

# Counters
TOTAL=0
OK=0
STALE=0
VERY_STALE=0

# Temporary storage
declare -A PROJECT_STATUS

# Collect data
while IFS= read -r tag; do
  if [[ ! "$tag" =~ ^(.+)-v([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
    continue
  fi

  PROJECT="${BASH_REMATCH[1]}"
  VERSION="${BASH_REMATCH[2]}"

  # Get tag date
  TAG_DATE=$(git log -1 --format=%at "$tag" 2>/dev/null || echo 0)
  TAG_DATE_HUMAN=$(git log -1 --format=%ai "$tag" 2>/dev/null | cut -d' ' -f1)

  if [ "$TAG_DATE" -eq 0 ]; then
    continue
  fi

  # Calculate days since update
  DAYS_AGO=$(( (CURRENT_DATE - TAG_DATE) / 86400 ))

  # Determine status
  if [ $DAYS_AGO -lt 30 ]; then
    STATUS="✅ OK"
    COLOR="$GREEN"
    ((OK++))
  elif [ $DAYS_AGO -lt $STALE_DAYS ]; then
    STATUS="⚠️  Stale"
    COLOR="$YELLOW"
    ((STALE++))
  else
    STATUS="❌ Very Stale"
    COLOR="$RED"
    ((VERY_STALE++))
  fi

  ((TOTAL++))

  # Store data
  PROJECT_STATUS["$PROJECT"]="$VERSION|$TAG_DATE_HUMAN|$DAYS_AGO|$STATUS|$COLOR"
done < <(git tag -l '*-v*' | sort -V)

# Display results
echo -e "${BLUE}Summary:${NC}"
echo "  Total Projects: $TOTAL"
echo -e "  ${GREEN}✅ OK (< 30 days):     $OK${NC}"
echo -e "  ${YELLOW}⚠️  Stale (< $STALE_DAYS days): $STALE${NC}"
echo -e "  ${RED}❌ Very Stale (> $STALE_DAYS):  $VERY_STALE${NC}"
echo ""

# Display project details
echo -e "${BLUE}Project Details:${NC}"
echo ""
printf "%-25s %-12s %-12s %-10s %s\n" "Project" "Version" "Last Update" "Days Ago" "Status"
echo "────────────────────────────────────────────────────────────────────────────"

# Sort by days ago (descending)
for project in "${!PROJECT_STATUS[@]}"; do
  IFS='|' read -r version date days status color <<< "${PROJECT_STATUS[$project]}"

  # Filter if not showing all
  if [ "$SHOW_ALL" = false ] && [ "${status:0:1}" = "✅" ]; then
    continue
  fi

  echo "$days|$project|$version|$date|$status|$color"
done | sort -rn | while IFS='|' read -r days project version date status color; do
  printf "${color}%-25s %-12s %-12s %-10s %s${NC}\n" \
    "$project" "$version" "$date" "$days" "$status"
done

echo ""

# Category breakdown
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Category Recommendations:${NC}"
echo ""

# High Priority (should update frequently)
HIGH_PRIORITY=(postgres-exts discourse wikijs wordpress flarum gitea nextcloud)
echo -e "${YELLOW}High Priority Projects (should update monthly):${NC}"
for project in "${HIGH_PRIORITY[@]}"; do
  if [[ -v PROJECT_STATUS[$project] ]]; then
    IFS='|' read -r version date days status color <<< "${PROJECT_STATUS[$project]}"
    if [ "$days" -gt 30 ]; then
      echo -e "  ${RED}⚠️  $project (v$version): $days days - NEEDS UPDATE${NC}"
    else
      echo -e "  ${GREEN}✓ $project (v$version): $days days${NC}"
    fi
  fi
done
echo ""

# Deprecated projects
DEPRECATED=(flaskbb openNamu spree solidus home-assistant)
DEPRECATED_COUNT=0
for project in "${DEPRECATED[@]}"; do
  if [[ -v PROJECT_STATUS[$project] ]]; then
    ((DEPRECATED_COUNT++))
  fi
done

if [ $DEPRECATED_COUNT -gt 0 ]; then
  echo -e "${YELLOW}Deprecated Projects (no regular updates needed):${NC}"
  for project in "${DEPRECATED[@]}"; do
    if [[ -v PROJECT_STATUS[$project] ]]; then
      IFS='|' read -r version date days status color <<< "${PROJECT_STATUS[$project]}"
      echo "  ℹ️  $project (v$version): $days days - OK (deprecated)"
    fi
  done
  echo ""
fi

# Recommendations
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Recommendations:${NC}"
echo ""

if [ $VERY_STALE -gt 0 ]; then
  echo -e "${RED}⚠️  $VERY_STALE projects are very stale (> $STALE_DAYS days)${NC}"
  echo "  → Run quarterly update sprint"
  echo "  → Check for upstream security updates"
  echo ""
fi

if [ $STALE -gt 0 ]; then
  echo -e "${YELLOW}ℹ️  $STALE projects are getting stale${NC}"
  echo "  → Consider batch update in next sprint"
  echo ""
fi

if [ $OK -eq $TOTAL ]; then
  echo -e "${GREEN}✅ All projects are up-to-date!${NC}"
  echo ""
fi

echo "Next steps:"
echo "  1. Review stale projects and check upstream releases"
echo "  2. Plan update sprint for very stale projects"
echo "  3. See docs/UPDATE_STRATEGY.md for detailed workflow"
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
