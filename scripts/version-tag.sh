#!/bin/bash
# 스크립트명: version-tag.sh
# 용도: 프로젝트별 버전 태그 생성 및 관리
# 사용법: ./scripts/version-tag.sh <project> <version> [options]
# 예시: ./scripts/version-tag.sh discourse 1.2.3
#        ./scripts/version-tag.sh discourse 1.2.3 --push
#        ./scripts/version-tag.sh discourse 1.2.3 --force

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Usage information
usage() {
    cat << EOF
Usage: $0 <project> <version> [options]

Create and manage project-specific version tags.

Arguments:
  project     Project name (e.g., discourse, wikijs, postgres-exts)
  version     Semantic version without 'v' prefix (e.g., 1.2.3)

Options:
  --push      Push tag to remote after creation
  --force     Force tag creation (overwrite existing)
  --dry-run   Show what would be done without making changes
  -h, --help  Show this help message

Examples:
  $0 discourse 1.2.3
  $0 wikijs 2.0.0 --push
  $0 postgres-exts 16.2.1 --force --push

Tag Format:
  <project>-v<version>
  Example: discourse-v1.2.3

EOF
    exit 0
}

# Error handling
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}WARNING: $1${NC}" >&2
}

info() {
    echo -e "${BLUE}INFO: $1${NC}"
}

success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
}

# Check if running from repository root
check_repo_root() {
    if [ ! -d ".git" ]; then
        error "Must be run from repository root"
    fi
}

# Validate project exists
validate_project() {
    local project=$1

    if [ ! -d "$project" ]; then
        error "Project directory '$project' does not exist"
    fi

    info "Project '$project' validated"
}

# Validate semantic version format
validate_version() {
    local version=$1

    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        error "Invalid version format: '$version'. Expected: X.Y.Z (e.g., 1.2.3)"
    fi

    info "Version '$version' validated"
}

# Check if tag already exists
check_tag_exists() {
    local tag=$1

    if git tag -l | grep -q "^${tag}$"; then
        return 0  # Tag exists
    else
        return 1  # Tag doesn't exist
    fi
}

# Create git tag
create_tag() {
    local tag=$1
    local force=$2

    if check_tag_exists "$tag"; then
        if [ "$force" = true ]; then
            warn "Tag '$tag' already exists. Overwriting with --force"
            git tag -f "$tag"
        else
            error "Tag '$tag' already exists. Use --force to overwrite"
        fi
    else
        git tag "$tag"
        success "Created tag: $tag"
    fi
}

# Push tag to remote
push_tag() {
    local tag=$1
    local force=$2

    info "Pushing tag to remote..."

    if [ "$force" = true ]; then
        git push origin "$tag" --force
    else
        git push origin "$tag"
    fi

    success "Pushed tag '$tag' to remote"
}

# Display tag information
show_tag_info() {
    local project=$1
    local version=$2
    local tag=$3

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Tag Information"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Project:     $project"
    echo "  Version:     $version"
    echo "  Git Tag:     $tag"
    echo "  Commit:      $(git rev-parse --short HEAD)"
    echo "  Branch:      $(git branch --show-current)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Main function
main() {
    # Parse arguments
    if [ $# -lt 2 ]; then
        usage
    fi

    local project=$1
    local version=$2
    shift 2

    local push=false
    local force=false
    local dry_run=false

    # Parse options
    while [ $# -gt 0 ]; do
        case $1 in
            --push)
                push=true
                shift
                ;;
            --force)
                force=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
    done

    # Construct tag name
    local tag="${project}-v${version}"

    # Validations
    check_repo_root
    validate_project "$project"
    validate_version "$version"

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        warn "You have uncommitted changes"
        echo "  Consider committing changes before tagging"
    fi

    # Dry run mode
    if [ "$dry_run" = true ]; then
        info "DRY RUN MODE - No changes will be made"
        show_tag_info "$project" "$version" "$tag"

        if check_tag_exists "$tag"; then
            echo "  Status:      Tag already exists"
            if [ "$force" = true ]; then
                echo "  Action:      Would overwrite with --force"
            else
                echo "  Action:      Would fail (use --force to overwrite)"
            fi
        else
            echo "  Status:      Tag does not exist"
            echo "  Action:      Would create tag"
        fi

        if [ "$push" = true ]; then
            echo "  Remote:      Would push to origin"
        fi

        exit 0
    fi

    # Show tag info
    show_tag_info "$project" "$version" "$tag"

    # Create tag
    create_tag "$tag" "$force"

    # Push if requested
    if [ "$push" = true ]; then
        push_tag "$tag" "$force"
    else
        info "Tag created locally. Use --push to push to remote"
        echo "  Or manually: git push origin $tag"
    fi

    echo ""
    success "Version tagging complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Verify tag: git tag -l '${project}-v*'"
    if [ "$push" = false ]; then
        echo "  2. Push tag: git push origin $tag"
    fi
    echo "  3. CD workflow will build and push Docker image"
    echo "  4. Update CHANGELOG.md with version notes"
    echo ""
}

# Run main function
main "$@"
