# Docker Hub Analytics Guide

## Overview

Comprehensive analytics and insights for Docker Hub repositories, including download statistics, star counts, multi-architecture support, and trend analysis.

## Features

- **Repository Statistics**: Pull counts, stars, last update dates
- **Multi-Architecture Analysis**: Track ARM64/AMD64 support
- **Trend Tracking**: Weekly analytics with historical comparison
- **Engagement Metrics**: Star-to-pull ratios, popular repositories
- **Recommendations**: Actionable insights for repository optimization

## Quick Start

### Manual Execution

```bash
# Basic usage
./scripts/docker-hub-analytics.sh --username scriptonbasestar

# With JSON report output
./scripts/docker-hub-analytics.sh \
  --username scriptonbasestar \
  --output analytics.json \
  --verbose

# View report
cat analytics.json | jq .
```

### GitHub Actions

Analytics run automatically:
- **Schedule**: Every Monday at 00:00 UTC
- **Manual**: Workflow dispatch in GitHub Actions UI

**Manual Trigger:**
1. Go to Actions → Docker Hub Analytics
2. Click "Run workflow"
3. Enter Docker Hub username (optional)
4. Click "Run workflow"

## Analytics Report Structure

### JSON Output Format

```json
{
  "timestamp": "2025-12-08T13:00:00Z",
  "username": "scriptonbasestar",
  "summary": {
    "total_repositories": 15,
    "total_pulls": 125000,
    "total_stars": 450
  },
  "repositories": [
    {
      "name": "postgres-exts",
      "pull_count": 50000,
      "star_count": 120,
      "last_updated": "2025-12-08",
      "description": "PostgreSQL with essential extensions",
      "is_private": false,
      "tag_count": 8,
      "architectures": ["amd64", "arm64"]
    }
  ]
}
```

### Key Metrics

#### Summary Statistics
- **Total Repositories**: Number of public repositories
- **Total Downloads**: Cumulative pull count across all images
- **Total Stars**: Total stars received

#### Repository Metrics
- **Pull Count**: Number of times image has been downloaded
- **Star Count**: Number of users who starred the repository
- **Tag Count**: Number of image tags/versions available
- **Architectures**: Supported CPU architectures (amd64, arm64, etc.)
- **Last Updated**: Most recent update timestamp

#### Derived Metrics
- **Average Pulls per Repository**: Total pulls / repository count
- **Average Stars per Repository**: Total stars / repository count
- **Engagement Ratio**: (Stars / Pulls) × 100
- **Multi-arch Coverage**: % of repositories with multiple architectures

## Understanding Analytics

### Download Trends

**High Downloads, Low Stars:**
- Indicates production usage but low community engagement
- **Action**: Improve documentation, add examples

**Low Downloads, High Stars:**
- Strong community interest but low adoption
- **Action**: Reduce barriers to entry, improve setup guides

**Balanced Growth:**
- Both downloads and stars increasing proportionally
- **Action**: Maintain current trajectory, focus on quality

### Multi-Architecture Support

**Why It Matters:**
- ARM64 adoption growing rapidly (AWS Graviton, Apple Silicon)
- Multi-arch images work seamlessly across platforms
- Better developer experience

**Current Industry Standards:**
- Popular images: 90%+ multi-arch support
- Enterprise images: 100% multi-arch expected

### Repository Health Indicators

#### Green Flags (Healthy)
- ✅ Regular updates (< 30 days)
- ✅ Multi-arch support
- ✅ Clear description
- ✅ Multiple tags available
- ✅ Growing download count

#### Yellow Flags (Needs Attention)
- ⚠️ Last update 30-90 days ago
- ⚠️ Single architecture only
- ⚠️ No description
- ⚠️ High downloads, no stars

#### Red Flags (Action Required)
- ❌ Last update > 90 days
- ❌ Security vulnerabilities (check security-scan.yml)
- ❌ Deprecated tags still in use
- ❌ No recent downloads

## Optimization Recommendations

### 1. Improve Multi-Arch Coverage

**Current single-arch images:**
```bash
# Identify single-arch repositories
jq -r '.repositories[] | select(.architectures | length == 1) | .name' analytics.json
```

**Action:**
- Implement ARM64 native runners (see: `arm64-native-runners.md`)
- Update Dockerfiles for multi-platform builds
- Test on both architectures

### 2. Update Stale Repositories

**Find repositories not updated in 90+ days:**
```bash
CUTOFF=$(date -d '90 days ago' +%Y-%m-%d)
jq -r --arg cutoff "$CUTOFF" \
  '.repositories[] | select(.last_updated < $cutoff) | .name' \
  analytics.json
```

**Action:**
- Review for security updates
- Update base images
- Test and rebuild

### 3. Enhance Repository Descriptions

**Find repositories without descriptions:**
```bash
jq -r '.repositories[] | select(.description == "N/A") | .name' analytics.json
```

**Action:**
- Add concise, clear descriptions
- Include key features and use cases
- Link to documentation

### 4. Increase Community Engagement

**High downloads, low stars:**
```bash
jq -r '.repositories[] |
  select(.pull_count > 100 and .star_count == 0) |
  .name' analytics.json
```

**Action:**
- Improve README with clear examples
- Add badges (build status, downloads, etc.)
- Create quick-start guides
- Respond to issues promptly

## Integration with CI/CD

### Workflow Integration

The analytics workflow integrates with your CI/CD:

```yaml
# .github/workflows/docker-hub-analytics.yml
on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday
  workflow_dispatch:      # Manual trigger
```

### Automatic Reports

Each run generates:
1. **JSON Report**: Detailed analytics data
2. **GitHub Summary**: Visual report in Actions UI
3. **Artifact Upload**: Historical data retention (90 days)

### Accessing Historical Data

**Download artifacts:**
```bash
# Using GitHub CLI
gh run download <run-id> -n docker-hub-analytics-<number>

# View historical trends
jq -s '[.[] | {date: .timestamp, pulls: .summary.total_pulls}]' *.json
```

## Advanced Analytics

### Trend Analysis

**Calculate weekly growth:**
```bash
# Compare current week with previous week
PREV_PULLS=$(jq '.summary.total_pulls' prev-week.json)
CURR_PULLS=$(jq '.summary.total_pulls' current-week.json)
GROWTH=$(( (CURR_PULLS - PREV_PULLS) * 100 / PREV_PULLS ))
echo "Weekly growth: ${GROWTH}%"
```

### Architecture Distribution

**Analyze architecture coverage:**
```bash
# Count images by architecture
jq '[.repositories[].architectures[]] |
  group_by(.) |
  map({arch: .[0], count: length})' analytics.json
```

### Engagement Scoring

**Calculate repository scores:**
```bash
# Score = (pulls * 0.6) + (stars * 0.3) + (multi_arch * 0.1)
jq '.repositories[] |
  {
    name,
    score: (
      (.pull_count * 0.6) +
      (.star_count * 0.3) +
      (if (.architectures | length) > 1 then 100 else 0 end)
    )
  } |
  select(.score > 0)' analytics.json |
  jq -s 'sort_by(.score) | reverse | .[:10]'
```

## API Rate Limits

Docker Hub API has rate limits:
- **Unauthenticated**: 100 requests/6 hours
- **Authenticated**: 200 requests/6 hours

**Current script usage:**
- Repository list: 1 request
- Per repository tags: 1 request per repo
- **Total**: 1 + N requests (N = number of repos)

**Optimization:**
- Script caches results
- Runs weekly (well within limits)
- No authentication needed for public repos

## Troubleshooting

### Common Issues

**1. jq not found**
```bash
# Ubuntu/Debian
sudo apt-get install jq

# macOS
brew install jq
```

**2. API rate limit exceeded**
```bash
# Wait 6 hours or use authenticated requests
# Add Docker Hub token to GitHub secrets
```

**3. Invalid username**
```bash
# Verify username exists on Docker Hub
curl -s https://hub.docker.com/v2/repositories/USERNAME/ | jq .
```

**4. No data returned**
- Check if repositories are public
- Verify username spelling
- Ensure network connectivity

## Best Practices

### Regular Monitoring

1. **Weekly Review**: Check automated reports
2. **Monthly Deep Dive**: Analyze trends and patterns
3. **Quarterly Planning**: Set goals based on insights

### Actionable Metrics

Focus on metrics that drive decisions:
- **Download trends**: Gauge adoption
- **Star growth**: Measure community satisfaction
- **Multi-arch coverage**: Track modernization progress
- **Update frequency**: Ensure maintenance

### Documentation

Keep analytics documentation updated:
- **README badges**: Show download counts, stars
- **Changelog**: Track version releases
- **Migration guides**: Help users upgrade

## Integration with Other Tools

### Prometheus/Grafana

Export metrics to monitoring systems:

```bash
# Convert to Prometheus format
cat analytics.json | jq -r '
  .repositories[] |
  "dockerhub_pulls{repo=\"\(.name)\"} \(.pull_count)\n" +
  "dockerhub_stars{repo=\"\(.name)\"} \(.star_count)"
'
```

### Status Page

Display current statistics:

```bash
# Generate markdown for status page
cat analytics.json | jq -r '
  "## Docker Hub Statistics\n\n" +
  "**Total Downloads:** \(.summary.total_pulls | tonumber | tostring)\n" +
  "**Total Stars:** \(.summary.total_stars | tonumber | tostring)\n" +
  "**Repositories:** \(.summary.total_repositories | tonumber | tostring)"
'
```

## Future Enhancements

Planned features:
- [ ] Trend visualization (charts)
- [ ] Automated alerts (download drops, stale repos)
- [ ] Compare with competitors
- [ ] Download source geography
- [ ] Tag-level analytics
- [ ] Vulnerability correlation

## References

- [Docker Hub API Documentation](https://docs.docker.com/docker-hub/api/latest/)
- [Multi-Arch Build Guide](./arm64-native-runners.md)
- [CI Validation Tests](./ci-validation-tests.md)
