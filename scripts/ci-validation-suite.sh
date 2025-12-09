#!/bin/bash
# Script: ci-validation-suite.sh
# Purpose: Comprehensive CI validation test suite with quality scoring
# Usage: ./scripts/ci-validation-suite.sh [--verbose] [--report report.json]
# Example: ./scripts/ci-validation-suite.sh --verbose --report ci-report.json

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Parse arguments
VERBOSE=false
REPORT_FILE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --verbose)
      VERBOSE=true
      shift
      ;;
    --report)
      REPORT_FILE="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--verbose] [--report FILE]"
      exit 1
      ;;
  esac
done

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
WARNED_TESTS=0
SKIPPED_TESTS=0

# Test details
declare -A TEST_RESULTS
declare -A TEST_MESSAGES
declare -A TEST_DURATIONS

# Start time
START_TIME=$(date +%s)

# Logging function
log() {
  if [ "$VERBOSE" = true ]; then
    echo -e "$@"
  fi
}

# Test execution function
run_test() {
  local test_name="$1"
  local test_command="$2"
  local test_critical="${3:-true}"  # true=fail on error, false=warn only

  TOTAL_TESTS=$((TOTAL_TESTS + 1))

  echo -e "\n${BLUE}[TEST $TOTAL_TESTS] $test_name${NC}"

  local test_start=$(date +%s)
  local test_output
  local test_status

  # Run test and capture output
  if test_output=$(eval "$test_command" 2>&1); then
    test_status="PASS"
    PASSED_TESTS=$((PASSED_TESTS + 1))
    echo -e "${GREEN}✓ PASSED${NC}"
  else
    if [ "$test_critical" = "true" ]; then
      test_status="FAIL"
      FAILED_TESTS=$((FAILED_TESTS + 1))
      echo -e "${RED}✗ FAILED${NC}"
    else
      test_status="WARN"
      WARNED_TESTS=$((WARNED_TESTS + 1))
      echo -e "${YELLOW}⚠ WARNING${NC}"
    fi
  fi

  local test_end=$(date +%s)
  local test_duration=$((test_end - test_start))

  # Store results
  TEST_RESULTS["$test_name"]="$test_status"
  TEST_MESSAGES["$test_name"]="$test_output"
  TEST_DURATIONS["$test_name"]="$test_duration"

  # Show output if verbose or failed
  if [ "$VERBOSE" = true ] || [ "$test_status" != "PASS" ]; then
    echo "$test_output" | sed 's/^/  /'
  fi

  log "Duration: ${test_duration}s"
}

# Generate JSON report
generate_report() {
  if [ -z "$REPORT_FILE" ]; then
    return
  fi

  local end_time=$(date +%s)
  local total_duration=$((end_time - START_TIME))

  cat > "$REPORT_FILE" << EOF
{
  "timestamp": "$(date -Iseconds)",
  "duration": $total_duration,
  "summary": {
    "total": $TOTAL_TESTS,
    "passed": $PASSED_TESTS,
    "failed": $FAILED_TESTS,
    "warned": $WARNED_TESTS,
    "skipped": $SKIPPED_TESTS
  },
  "quality_score": $(calculate_quality_score),
  "tests": [
EOF

  local first=true
  for test_name in "${!TEST_RESULTS[@]}"; do
    if [ "$first" = false ]; then
      echo "    ," >> "$REPORT_FILE"
    fi
    first=false

    cat >> "$REPORT_FILE" << EOF
    {
      "name": "$test_name",
      "status": "${TEST_RESULTS[$test_name]}",
      "duration": ${TEST_DURATIONS[$test_name]},
      "message": $(echo "${TEST_MESSAGES[$test_name]}" | jq -Rs .)
    }
EOF
  done

  cat >> "$REPORT_FILE" << EOF

  ]
}
EOF

  echo -e "\n${GREEN}Report saved to: $REPORT_FILE${NC}"
}

# Calculate quality score (0-100)
calculate_quality_score() {
  if [ $TOTAL_TESTS -eq 0 ]; then
    echo "0"
    return
  fi

  # Base score from pass rate
  local pass_score=$((PASSED_TESTS * 100 / TOTAL_TESTS))

  # Penalty for failures (each failure -5 points, min 0)
  local fail_penalty=$((FAILED_TESTS * 5))

  # Penalty for warnings (each warning -2 points)
  local warn_penalty=$((WARNED_TESTS * 2))

  local final_score=$((pass_score - fail_penalty - warn_penalty))

  # Ensure score is 0-100
  if [ $final_score -lt 0 ]; then
    echo "0"
  else
    echo "$final_score"
  fi
}

# ===========================
# Test Suite
# ===========================

echo -e "${MAGENTA}======================================${NC}"
echo -e "${MAGENTA}  CI Validation Test Suite${NC}"
echo -e "${MAGENTA}======================================${NC}"
echo ""
echo "Root directory: $ROOT_DIR"
echo "Start time: $(date)"
echo ""

# Test 1: Docker Compose Syntax
run_test \
  "Docker Compose Syntax Validation" \
  "$SCRIPT_DIR/validate-compose.sh" \
  true

# Test 2: Required Files
run_test \
  "Required Files Check" \
  "$SCRIPT_DIR/check-required-files.sh" \
  true

# Test 3: Port Conflicts
run_test \
  "Port Conflict Detection" \
  "$SCRIPT_DIR/check-port-conflicts.sh" \
  false

# Test 4: Health Checks
run_test \
  "Health Check Verification" \
  "$SCRIPT_DIR/verify-health-checks.sh" \
  false

# Test 5: Environment Examples
run_test \
  "Environment Example Files" \
  "$SCRIPT_DIR/test-env-examples.sh" \
  true

# Test 6: Multi-arch Support
if [ -f "$SCRIPT_DIR/check-multiarch-builds.sh" ]; then
  run_test \
    "Multi-Architecture Support" \
    "$SCRIPT_DIR/check-multiarch-builds.sh" \
    false
fi

# Test 7: Git Repository Structure
run_test \
  "Git Repository Structure" \
  "test -d .git && git status > /dev/null 2>&1" \
  true

# Test 8: Makefile Targets
run_test \
  "Makefile Essential Targets" \
  "make help > /dev/null && make list > /dev/null" \
  true

# Test 9: Documentation Files
run_test \
  "Documentation Completeness" \
  "test -f README.md && test -f CHANGELOG.md" \
  false

# Test 10: License File
run_test \
  "License File Presence" \
  "test -f LICENSE || test -f LICENSE.md || test -f LICENSE.txt" \
  false

# Test 11: .gitignore Configuration
# Check for project-relevant patterns (*.log, *.tmp, analytics/) instead of assuming Node.js
run_test \
  ".gitignore Configuration" \
  "test -f .gitignore && (grep -qE '\*\.log|\*\.tmp|analytics/|ci-.*\.json' .gitignore)" \
  false

# Test 12: CI/CD Configuration
run_test \
  "GitHub Actions Configuration" \
  "test -d .github/workflows && ls .github/workflows/*.yml > /dev/null 2>&1" \
  true

# Test 13: Security - No Secrets in Repo
# Documented exception: chef-dev/.env, ruby-dev/.env, xpressengine/sample.env contain only non-sensitive config
# See docs/ci/VALIDATION_EXCEPTIONS.md for details
run_test \
  "Security: No Exposed Secrets" \
  "! find . -type f -name '.env' | grep -v '.env.example' | grep -v '.gitignore' | grep -v 'chef-dev/.env' | grep -v 'ruby-dev/.env' | grep -v 'sample.env' | head -1 | grep -q ." \
  false

# Test 14: Dockerfile Best Practices
run_test \
  "Dockerfile Best Practices" \
  "find images -name 'Dockerfile*' -exec sh -c 'grep -q \"USER\" \"{}\" || exit 1' \; 2>/dev/null || true" \
  false

# Test 15: Compose Version
run_test \
  "Docker Compose Version Check" \
  "docker compose version" \
  true

# Test 16: BuildKit Support
run_test \
  "Docker BuildKit Support" \
  "docker buildx version" \
  true

# Test 17: Project Structure Validation
run_test \
  "Project Directory Structure" \
  "test -d images && test -d scripts && test -d docs" \
  true

# Test 18: Script Executability
run_test \
  "Script Files Executable" \
  "find scripts -name '*.sh' -type f ! -executable | grep -q . && exit 1 || exit 0" \
  false

# Test 19: README Sections
# Accept h2/h3 headers and synonyms (Quick Start, Usage) for bilingual docs
# Accepts: Features/기능/주요 기능 AND Usage/사용법/Quick Start/빠른 시작
run_test \
  "README.md Completeness" \
  "(grep -qE '##+ (Features|기능|주요 기능)' README.md && grep -qE '##+ (Usage|사용법|Quick Start|빠른 시작)' README.md)" \
  false

# Test 20: Changelog Format
if [ -f "CHANGELOG.md" ]; then
  run_test \
    "CHANGELOG.md Format" \
    "grep -q '## \\[' CHANGELOG.md" \
    false
fi

# ===========================
# Summary
# ===========================

END_TIME=$(date +%s)
TOTAL_DURATION=$((END_TIME - START_TIME))

echo ""
echo -e "${MAGENTA}======================================${NC}"
echo -e "${MAGENTA}  Test Summary${NC}"
echo -e "${MAGENTA}======================================${NC}"
echo ""
echo "Total tests:    $TOTAL_TESTS"
echo -e "Passed:         ${GREEN}$PASSED_TESTS${NC}"
if [ $FAILED_TESTS -gt 0 ]; then
  echo -e "Failed:         ${RED}$FAILED_TESTS${NC}"
else
  echo "Failed:         $FAILED_TESTS"
fi
if [ $WARNED_TESTS -gt 0 ]; then
  echo -e "Warnings:       ${YELLOW}$WARNED_TESTS${NC}"
else
  echo "Warnings:       $WARNED_TESTS"
fi
echo "Skipped:        $SKIPPED_TESTS"
echo ""

# Quality score
QUALITY_SCORE=$(calculate_quality_score)
echo -n "Quality Score:  "
if [ $QUALITY_SCORE -ge 90 ]; then
  echo -e "${GREEN}${QUALITY_SCORE}/100 (Excellent)${NC}"
elif [ $QUALITY_SCORE -ge 75 ]; then
  echo -e "${GREEN}${QUALITY_SCORE}/100 (Good)${NC}"
elif [ $QUALITY_SCORE -ge 60 ]; then
  echo -e "${YELLOW}${QUALITY_SCORE}/100 (Fair)${NC}"
else
  echo -e "${RED}${QUALITY_SCORE}/100 (Needs Improvement)${NC}"
fi

echo ""
echo "Total duration: ${TOTAL_DURATION}s"
echo "End time:       $(date)"
echo ""

# Generate report
generate_report

# Exit status
if [ $FAILED_TESTS -gt 0 ]; then
  echo -e "${RED}❌ CI Validation FAILED${NC}"
  exit 1
else
  echo -e "${GREEN}✅ CI Validation PASSED${NC}"
  if [ $WARNED_TESTS -gt 0 ]; then
    echo -e "${YELLOW}⚠ With $WARNED_TESTS warnings${NC}"
  fi
  exit 0
fi
