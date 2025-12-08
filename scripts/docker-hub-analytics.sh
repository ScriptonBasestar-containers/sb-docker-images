#!/bin/bash
# Script: docker-hub-analytics.sh
# Purpose: Fetch and analyze Docker Hub repository statistics and usage insights
# Usage: ./scripts/docker-hub-analytics.sh --username USERNAME [--output report.json]
# Example: ./scripts/docker-hub-analytics.sh --username scriptonbasestar --output analytics.json

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Default values
DOCKER_USERNAME=""
OUTPUT_FILE=""
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --username)
      DOCKER_USERNAME="$2"
      shift 2
      ;;
    --output)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 --username USERNAME [--output FILE] [--verbose]"
      exit 1
      ;;
  esac
done

# Validate required parameters
if [ -z "$DOCKER_USERNAME" ]; then
  echo -e "${RED}Error: --username is required${NC}"
  echo "Usage: $0 --username USERNAME [--output FILE]"
  exit 1
fi

# Check for required tools
if ! command -v curl &> /dev/null; then
  echo -e "${RED}Error: curl is required but not installed${NC}"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo -e "${RED}Error: jq is required but not installed${NC}"
  echo "Install: sudo apt-get install jq"
  exit 1
fi

echo -e "${MAGENTA}======================================${NC}"
echo -e "${MAGENTA}  Docker Hub Analytics${NC}"
echo -e "${MAGENTA}======================================${NC}"
echo ""
echo "Username: $DOCKER_USERNAME"
echo "Timestamp: $(date -Iseconds)"
echo ""

# Temporary files
REPOS_FILE=$(mktemp)
ANALYTICS_FILE=$(mktemp)

# Cleanup on exit
cleanup() {
  rm -f "$REPOS_FILE" "$ANALYTICS_FILE"
}
trap cleanup EXIT

# Fetch repository list
echo -e "${BLUE}Fetching repository list...${NC}"
REPO_LIST_URL="https://hub.docker.com/v2/repositories/${DOCKER_USERNAME}/"

if ! curl -s "$REPO_LIST_URL" > "$REPOS_FILE"; then
  echo -e "${RED}Error: Failed to fetch repository list${NC}"
  exit 1
fi

# Check if username exists
if jq -e '.message' "$REPOS_FILE" &> /dev/null; then
  ERROR_MSG=$(jq -r '.message' "$REPOS_FILE")
  echo -e "${RED}Error: $ERROR_MSG${NC}"
  exit 1
fi

# Parse repositories
REPO_COUNT=$(jq '.count' "$REPOS_FILE")
echo -e "${GREEN}Found $REPO_COUNT repositories${NC}"
echo ""

# Initialize analytics data
cat > "$ANALYTICS_FILE" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "username": "$DOCKER_USERNAME",
  "summary": {
    "total_repositories": $REPO_COUNT,
    "total_pulls": 0,
    "total_stars": 0,
    "total_size_bytes": 0
  },
  "repositories": []
}
EOF

# Process each repository
TOTAL_PULLS=0
TOTAL_STARS=0
TOTAL_SIZE=0

echo -e "${BLUE}Repository Statistics:${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "%-30s %10s %8s %12s\n" "Repository" "Pulls" "Stars" "Last Update"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get repositories
REPOS=$(jq -r '.results[] | @json' "$REPOS_FILE")

while IFS= read -r repo; do
  REPO_NAME=$(echo "$repo" | jq -r '.name')
  PULL_COUNT=$(echo "$repo" | jq -r '.pull_count')
  STAR_COUNT=$(echo "$repo" | jq -r '.star_count')
  LAST_UPDATE=$(echo "$repo" | jq -r '.last_updated' | cut -d'T' -f1)
  DESCRIPTION=$(echo "$repo" | jq -r '.description // "N/A"')
  IS_PRIVATE=$(echo "$repo" | jq -r '.is_private')

  # Add to totals
  TOTAL_PULLS=$((TOTAL_PULLS + PULL_COUNT))
  TOTAL_STARS=$((TOTAL_STARS + STAR_COUNT))

  # Display
  printf "%-30s %10s %8s %12s\n" "$REPO_NAME" "$PULL_COUNT" "$STAR_COUNT" "$LAST_UPDATE"

  # Fetch tag information
  TAGS_URL="https://hub.docker.com/v2/repositories/${DOCKER_USERNAME}/${REPO_NAME}/tags/"
  TAGS_DATA=$(curl -s "$TAGS_URL")
  TAG_COUNT=$(echo "$TAGS_DATA" | jq '.count')

  # Get architectures from latest tag
  ARCHITECTURES=$(echo "$TAGS_DATA" | jq -r '.results[0].images[]?.architecture' 2>/dev/null | sort -u | tr '\n' ',' | sed 's/,$//')

  # Add to analytics
  REPO_DATA=$(cat <<REPO_JSON
{
  "name": "$REPO_NAME",
  "pull_count": $PULL_COUNT,
  "star_count": $STAR_COUNT,
  "last_updated": "$LAST_UPDATE",
  "description": $(echo "$DESCRIPTION" | jq -Rs .),
  "is_private": $IS_PRIVATE,
  "tag_count": $TAG_COUNT,
  "architectures": $(echo "$ARCHITECTURES" | jq -Rs 'split(",") | map(select(length > 0))')
}
REPO_JSON
)

  # Append to analytics file
  jq ".repositories += [$REPO_DATA]" "$ANALYTICS_FILE" > "${ANALYTICS_FILE}.tmp" && mv "${ANALYTICS_FILE}.tmp" "$ANALYTICS_FILE"

done <<< "$REPOS"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "%-30s %10s %8s\n" "TOTAL" "$TOTAL_PULLS" "$TOTAL_STARS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Update summary in analytics file
jq ".summary.total_pulls = $TOTAL_PULLS | .summary.total_stars = $TOTAL_STARS" "$ANALYTICS_FILE" > "${ANALYTICS_FILE}.tmp" && mv "${ANALYTICS_FILE}.tmp" "$ANALYTICS_FILE"

# Top repositories by pulls
echo -e "${BLUE}Top 5 Repositories by Downloads:${NC}"
TOP_BY_PULLS=$(jq -r '.repositories | sort_by(.pull_count) | reverse | .[:5] | .[] | "  \(.name): \(.pull_count) pulls"' "$ANALYTICS_FILE")
echo "$TOP_BY_PULLS"
echo ""

# Top repositories by stars
echo -e "${BLUE}Top 5 Repositories by Stars:${NC}"
TOP_BY_STARS=$(jq -r '.repositories | sort_by(.star_count) | reverse | .[:5] | .[] | "  \(.name): \(.star_count) stars"' "$ANALYTICS_FILE")
echo "$TOP_BY_STARS"
echo ""

# Multi-arch support analysis
echo -e "${BLUE}Multi-Architecture Support:${NC}"
MULTIARCH_COUNT=$(jq '[.repositories[] | select(.architectures | length > 1)] | length' "$ANALYTICS_FILE")
SINGLE_ARCH_COUNT=$(jq '[.repositories[] | select(.architectures | length == 1)] | length' "$ANALYTICS_FILE")
NO_ARCH_COUNT=$(jq '[.repositories[] | select(.architectures | length == 0)] | length' "$ANALYTICS_FILE")

echo "  Multi-arch images: $MULTIARCH_COUNT"
echo "  Single-arch images: $SINGLE_ARCH_COUNT"
echo "  No architecture info: $NO_ARCH_COUNT"
echo ""

# Architecture breakdown
echo -e "${BLUE}Architecture Distribution:${NC}"
ARCH_DIST=$(jq -r '[.repositories[].architectures[]] | group_by(.) | map({arch: .[0], count: length}) | sort_by(.count) | reverse | .[] | "  \(.arch): \(.count) images"' "$ANALYTICS_FILE")
echo "$ARCH_DIST"
echo ""

# Recent updates
echo -e "${BLUE}Recently Updated (Last 30 days):${NC}"
CUTOFF_DATE=$(date -d '30 days ago' +%Y-%m-%d 2>/dev/null || date -v-30d +%Y-%m-%d)
RECENT_UPDATES=$(jq -r --arg cutoff "$CUTOFF_DATE" '.repositories[] | select(.last_updated >= $cutoff) | "  \(.name) - \(.last_updated)"' "$ANALYTICS_FILE")
if [ -z "$RECENT_UPDATES" ]; then
  echo "  No updates in the last 30 days"
else
  echo "$RECENT_UPDATES"
fi
echo ""

# Growth insights
echo -e "${BLUE}Insights:${NC}"
AVG_PULLS=$(jq '[.repositories[].pull_count] | add / length | floor' "$ANALYTICS_FILE")
AVG_STARS=$(jq '[.repositories[].star_count] | add / length | floor' "$ANALYTICS_FILE")
echo "  Average pulls per repository: $AVG_PULLS"
echo "  Average stars per repository: $AVG_STARS"

# Identify trending repositories (high pull/star ratio)
TRENDING=$(jq -r '.repositories | map(select(.pull_count > 0) | {name, ratio: (.star_count / .pull_count * 100)}) | sort_by(.ratio) | reverse | .[:3] | .[] | "  \(.name) (engagement: \(.ratio | floor)%)"' "$ANALYTICS_FILE")
if [ -n "$TRENDING" ]; then
  echo ""
  echo "  Top engaging repositories:"
  echo "$TRENDING"
fi
echo ""

# Save output
if [ -n "$OUTPUT_FILE" ]; then
  cp "$ANALYTICS_FILE" "$OUTPUT_FILE"
  echo -e "${GREEN}Analytics saved to: $OUTPUT_FILE${NC}"
  echo ""
fi

# Recommendations
echo -e "${YELLOW}Recommendations:${NC}"

# Check for repositories without multi-arch
if [ $SINGLE_ARCH_COUNT -gt 0 ]; then
  echo "  • Consider adding multi-arch support to $SINGLE_ARCH_COUNT repositories"
fi

# Check for stale repositories
STALE_DATE=$(date -d '90 days ago' +%Y-%m-%d 2>/dev/null || date -v-90d +%Y-%m-%d)
STALE_REPOS=$(jq -r --arg cutoff "$STALE_DATE" '[.repositories[] | select(.last_updated < $cutoff)] | length' "$ANALYTICS_FILE")
if [ $STALE_REPOS -gt 0 ]; then
  echo "  • Review $STALE_REPOS repositories not updated in 90+ days"
fi

# Check for low engagement
LOW_ENGAGEMENT=$(jq -r '[.repositories[] | select(.pull_count > 100 and .star_count == 0)] | length' "$ANALYTICS_FILE")
if [ $LOW_ENGAGEMENT -gt 0 ]; then
  echo "  • $LOW_ENGAGEMENT repositories have high pulls but no stars - consider improving documentation"
fi

# Check for missing descriptions
NO_DESC=$(jq -r '[.repositories[] | select(.description == "N/A")] | length' "$ANALYTICS_FILE")
if [ $NO_DESC -gt 0 ]; then
  echo "  • Add descriptions to $NO_DESC repositories for better discoverability"
fi

echo ""
echo -e "${GREEN}✅ Analytics complete${NC}"
