#!/bin/bash
# Script: list-versions.sh
# Purpose: List and display project version tags
# Usage: ./scripts/list-versions.sh [project] [options]
# Example: ./scripts/list-versions.sh discourse --all

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Usage information
usage() {
    cat << EOF
Usage: $0 [project] [options]

List version tags for projects.

Arguments:
  project     (Optional) Specific project name to filter

Options:
  --all       Show all tags including phase versions
  --latest    Show only latest version for each project
  --summary   Show summary statistics
  -h, --help  Show this help message

Examples:
  $0                    # List all project versions
  $0 discourse          # List discourse versions only
  $0 --latest           # Show latest version per project
  $0 --summary          # Show version statistics

EOF
    exit 0
}

# Error handling
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

info() {
    echo -e "${BLUE}$1${NC}"
}

header() {
    echo -e "${CYAN}$1${NC}"
}

# List all project versions
list_all_versions() {
    local filter=$1

    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    header "  Project Version Tags"
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Get all project tags (format: project-vX.Y.Z)
    local tags
    if [ -n "$filter" ]; then
        tags=$(git tag -l "${filter}-v*" | sort -V)
        if [ -z "$tags" ]; then
            echo "No versions found for project: $filter"
            return
        fi
    else
        tags=$(git tag -l "*-v*" | grep -v "^v" | sort -V)
    fi

    if [ -z "$tags" ]; then
        echo "No project version tags found"
        echo ""
        echo "Create your first tag with:"
        echo "  ./scripts/version-tag.sh <project> <version>"
        return
    fi

    # Group by project
    local current_project=""
    while IFS= read -r tag; do
        # Extract project and version
        local project="${tag%-v*}"
        local version="${tag#*-v}"

        if [ "$project" != "$current_project" ]; then
            if [ -n "$current_project" ]; then
                echo ""
            fi
            echo -e "${GREEN}$project${NC}"
            current_project="$project"
        fi

        # Get tag date and commit
        local tag_date=$(git log -1 --format=%ai "$tag" 2>/dev/null | cut -d' ' -f1)
        local commit_hash=$(git rev-list -n 1 "$tag" 2>/dev/null | cut -c1-7)

        echo "  v$version  [$tag_date] ($commit_hash)"
    done <<< "$tags"

    echo ""
}

# Show latest version for each project
list_latest_versions() {
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    header "  Latest Project Versions"
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Get all project tags
    local tags=$(git tag -l "*-v*" | grep -v "^v" | sort -V)

    if [ -z "$tags" ]; then
        echo "No project version tags found"
        return
    fi

    # Extract unique projects
    local projects=$(echo "$tags" | sed 's/-v.*//' | sort -u)

    printf "%-25s %-12s %-12s %s\n" "Project" "Latest" "Date" "Commit"
    echo "────────────────────────────────────────────────────────────────"

    while IFS= read -r project; do
        # Get latest version for this project
        local latest_tag=$(git tag -l "${project}-v*" | sort -V | tail -1)

        if [ -n "$latest_tag" ]; then
            local version="${latest_tag#*-v}"
            local tag_date=$(git log -1 --format=%ai "$latest_tag" 2>/dev/null | cut -d' ' -f1)
            local commit_hash=$(git rev-list -n 1 "$latest_tag" 2>/dev/null | cut -c1-7)

            printf "%-25s %-12s %-12s %s\n" "$project" "v$version" "$tag_date" "$commit_hash"
        fi
    done <<< "$projects"

    echo ""
}

# Show version summary statistics
show_summary() {
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    header "  Version Summary"
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Count project tags
    local project_tags=$(git tag -l "*-v*" | grep -v "^v" | wc -l | tr -d ' ')
    local phase_tags=$(git tag -l "v*" | wc -l | tr -d ' ')
    local phase_tags_new=$(git tag -l "phase-*" | wc -l | tr -d ' ')

    # Count unique projects with versions
    local projects_with_versions=$(git tag -l "*-v*" | grep -v "^v" | sed 's/-v.*//' | sort -u | wc -l | tr -d ' ')

    # Total directories (potential projects) - now in images/*/
    local total_projects=$(find ./images -maxdepth 2 -mindepth 2 -type d | wc -l | tr -d ' ')
    # Already counting only projects in images/*/, no need to subtract

    echo "Total Projects (directories):     $total_projects"
    echo "Projects with Versions:           $projects_with_versions"
    echo "Projects without Versions:        $((total_projects - projects_with_versions))"
    echo ""
    echo "Total Project Version Tags:       $project_tags"
    echo "Phase Tags (v*):                  $phase_tags"
    echo "Phase Tags (phase-*):             $phase_tags_new"
    echo ""

    # Coverage percentage
    if [ "$total_projects" -gt 0 ]; then
        local coverage=$((projects_with_versions * 100 / total_projects))
        echo "Version Coverage:                 ${coverage}%"
    fi

    echo ""

    # Show projects without versions
    if [ "$projects_with_versions" -lt "$total_projects" ]; then
        header "Projects without versions:"
        echo ""

        # Get all directories - now in images/*/
        local all_dirs=$(find ./images -maxdepth 2 -mindepth 2 -type d -exec basename {} \;)

        # Get projects with versions
        local versioned=$(git tag -l "*-v*" | grep -v "^v" | sed 's/-v.*//' | sort -u)

        # Find difference
        while IFS= read -r dir; do
            if ! echo "$versioned" | grep -q "^${dir}$"; then
                echo "  • $dir"
            fi
        done <<< "$all_dirs"

        echo ""
    fi
}

# Show all tags including phase
list_all_tags() {
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    header "  All Tags"
    header "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Phase tags
    local phase_tags=$(git tag -l "v*" "phase-*" | sort -V)
    if [ -n "$phase_tags" ]; then
        echo -e "${YELLOW}Phase Tags:${NC}"
        while IFS= read -r tag; do
            local tag_date=$(git log -1 --format=%ai "$tag" 2>/dev/null | cut -d' ' -f1)
            local commit_hash=$(git rev-list -n 1 "$tag" 2>/dev/null | cut -c1-7)
            echo "  $tag  [$tag_date] ($commit_hash)"
        done <<< "$phase_tags"
        echo ""
    fi

    # Project tags
    list_all_versions ""
}

# Main function
main() {
    local project=""
    local show_all=false
    local show_latest=false
    local show_summary=false

    # Parse arguments
    while [ $# -gt 0 ]; do
        case $1 in
            --all)
                show_all=true
                shift
                ;;
            --latest)
                show_latest=true
                shift
                ;;
            --summary)
                show_summary=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            -*)
                error "Unknown option: $1"
                ;;
            *)
                project=$1
                shift
                ;;
        esac
    done

    # Check if in git repo
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "Not in a git repository"
    fi

    # Execute based on options
    if [ "$show_summary" = true ]; then
        show_summary
    elif [ "$show_latest" = true ]; then
        list_latest_versions
    elif [ "$show_all" = true ]; then
        list_all_tags
    else
        list_all_versions "$project"
    fi
}

# Run main function
main "$@"
