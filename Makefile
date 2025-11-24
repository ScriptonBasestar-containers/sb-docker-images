# sb-docker-images - Docker 이미지 테스트 및 개발용 저장소
#
# 주요 프로젝트별 빌드/테스트 자동화

# ============================================================================
# Variables
# ============================================================================

SHELL := /bin/bash
.DEFAULT_GOAL := help

# 주요 프로젝트 목록 (images/ 하위 경로)
PROJECTS := images/database/postgres-exts images/community/discourse images/community/flarum \
            images/cms/nextcloud images/cms/wordpress images/cms/drupal \
            images/cms/gnuboard5 images/cms/gnuboard6 images/wiki/mediawiki images/wiki/gollum \
            images/wiki/outline images/database/mariadb images/registry/devpi \
            images/devtools/jenkins images/infrastructure/squid images/social/mattermost \
            images/social/rocketchat

# ============================================================================
# Help
# ============================================================================

.PHONY: help
help:
	@echo "sb-docker-images Makefile"
	@echo ""
	@echo "주요 타겟:"
	@echo "  make help              - 이 도움말 표시"
	@echo "  make list              - 모든 프로젝트 목록 표시"
	@echo "  make check             - 프로젝트 구조 검증"
	@echo ""
	@echo "빌드 타겟:"
	@echo "  make build-all         - 모든 프로젝트 빌드"
	@echo "  make build-<project>   - 특정 프로젝트 빌드"
	@echo ""
	@echo "테스트 타겟:"
	@echo "  make test-all          - 모든 compose 파일 검증"
	@echo "  make test-<project>    - 특정 프로젝트 테스트"
	@echo ""
	@echo "정리 타겟:"
	@echo "  make clean             - 임시 파일 정리"
	@echo "  make clean-all         - 모든 컨테이너/이미지 정리 (주의!)"
	@echo ""
	@echo "CI/CD 타겟:"
	@echo "  make lint-workflows    - GitHub Actions 워크플로우 검증"
	@echo "  make ci-validate       - CI 전체 검증 (check + test + workflows)"
	@echo "  make ci-build          - CI 빌드 (주요 프로젝트)"
	@echo ""
	@echo "레거시 타겟 (호환성):"
	@echo "  make init0             - buildbox 테스트 환경 시작"
	@echo "  make teardown          - buildbox 환경 종료"
	@echo ""
	@echo "예시:"
	@echo "  make build-postgres-exts    # PostgreSQL 확장 이미지 빌드"
	@echo "  make test-discourse         # Discourse compose 검증"
	@echo "  make list                   # 전체 프로젝트 목록"
	@echo "  make lint-workflows         # 워크플로우 검증"

# ============================================================================
# Project Discovery
# ============================================================================

.PHONY: list
list:
	@echo "=== 프로젝트 목록 ==="
	@echo ""
	@echo "Compose 파일이 있는 프로젝트:"
	@find ./images -maxdepth 3 -type f \( -name "compose.yml" -o -name "docker-compose.yml" \) \
		-exec dirname {} \; | \
		sed 's|^\./images/||' | sort | nl
	@echo ""
	@echo "Makefile이 있는 프로젝트:"
	@find ./images -maxdepth 3 -name "Makefile" \
		-exec dirname {} \; | sed 's|^\./images/||' | sort | nl

.PHONY: check
check:
	@echo "=== 프로젝트 구조 검증 ==="
	@echo ""
	@echo "Compose 파일 검사..."
	@find ./images -maxdepth 3 -type f \( -name "compose.yml" -o -name "docker-compose.yml" \) | while read file; do \
		echo "  ✓ $$file"; \
		docker compose -f "$$file" config > /dev/null 2>&1 && echo "    ✅ Valid" || echo "    ❌ Invalid"; \
	done
	@echo ""
	@echo "README 파일 검사..."
	@find ./images -maxdepth 2 -mindepth 2 -type d | while read dir; do \
		if [ -f "$$dir/compose.yml" ] || [ -f "$$dir/docker-compose.yml" ]; then \
			if [ -f "$$dir/README.md" ]; then \
				echo "  ✅ $$dir - README 있음"; \
			else \
				echo "  ⚠️  $$dir - README 없음"; \
			fi; \
		fi; \
	done

# ============================================================================
# Build Targets
# ============================================================================

.PHONY: build-all
build-all:
	@echo "=== 전체 프로젝트 빌드 ==="
	@for project in $(PROJECTS); do \
		if [ -f "$$project/Makefile" ]; then \
			echo "Building $$project..."; \
			$(MAKE) -C $$project build 2>/dev/null || echo "  ⚠️  $$project: Makefile에 build 타겟 없음"; \
		elif [ -f "$$project/compose.yml" ]; then \
			echo "Building $$project (compose)..."; \
			docker compose -f $$project/compose.yml build || echo "  ⚠️  $$project: 빌드 실패"; \
		elif [ -f "$$project/docker-compose.yml" ]; then \
			echo "Building $$project (docker-compose)..."; \
			docker compose -f $$project/docker-compose.yml build || echo "  ⚠️  $$project: 빌드 실패"; \
		fi; \
	done

# 개별 프로젝트 빌드 타겟
.PHONY: build-postgres-exts
build-postgres-exts:
	@echo "=== Building PostgreSQL Extensions ==="
	$(MAKE) -C images/database/postgres-exts essential-build

.PHONY: build-discourse
build-discourse:
	@echo "=== Building Discourse ==="
	docker compose -f images/community/discourse/compose.yml build

.PHONY: build-nextcloud
build-nextcloud:
	@echo "=== Building Nextcloud ==="
	docker compose -f images/cms/nextcloud/standalone/compose.fpm.yml build

# ============================================================================
# Test Targets
# ============================================================================

.PHONY: test-all
test-all:
	@echo "=== Compose 파일 검증 ==="
	@count=0; failed=0; \
	for file in $$(find . -maxdepth 2 -type f \( -name "compose.yml" -o -name "docker-compose.yml" \) \
		! -path "./.git/*" ! -path "./buildbox/*"); do \
		count=$$((count + 1)); \
		echo "Testing $$file..."; \
		if docker compose -f "$$file" config > /dev/null 2>&1; then \
			echo "  ✅ Valid"; \
		else \
			echo "  ❌ Invalid"; \
			failed=$$((failed + 1)); \
		fi; \
	done; \
	echo ""; \
	echo "총 $$count개 파일 검사, $$failed개 실패"

.PHONY: test-postgres-exts
test-postgres-exts:
	@echo "=== Testing PostgreSQL Extensions ==="
	$(MAKE) -C images/database/postgres-exts essential-test

# ============================================================================
# Clean Targets
# ============================================================================

.PHONY: clean
clean:
	@echo "=== 임시 파일 정리 ==="
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	find . -name "*.pyc" -delete 2>/dev/null || true
	find . -name ".DS_Store" -delete 2>/dev/null || true
	find ./tmp -type f -delete 2>/dev/null || true
	@echo "✅ 정리 완료"

.PHONY: clean-all
clean-all:
	@echo "⚠️  경고: 모든 컨테이너와 이미지를 정리합니다!"
	@read -p "계속하시겠습니까? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker compose down --remove-orphans 2>/dev/null || true; \
		echo "✅ 정리 완료"; \
	else \
		echo "❌ 취소됨"; \
	fi

# ============================================================================
# Legacy Targets (호환성 유지)
# ============================================================================

.PHONY: init0
init0:
	@echo "=== buildbox 테스트 환경 시작 ==="
	docker compose up -d

.PHONY: init1
init1:
	@echo "=== buildbox 설정 복사 ==="
	docker compose cp ./buildbox/config/kratos/. busybox:/kratos-config

.PHONY: teardown
teardown:
	@echo "=== buildbox 환경 종료 ==="
	docker compose down

.PHONY: enter
enter:
	@echo "=== busybox 컨테이너 접속 ==="
	docker compose exec busybox sh

# ============================================================================
# CI/CD Targets
# ============================================================================

.PHONY: lint-workflows
lint-workflows:
	@echo "=== GitHub Actions 워크플로우 검증 ==="
	@command -v actionlint >/dev/null 2>&1 || { \
		echo "❌ actionlint가 설치되지 않았습니다."; \
		echo ""; \
		echo "설치 방법:"; \
		echo "  Linux:   bash <(curl https://raw.githubusercontent.com/rhysd/actionlint/main/scripts/download-actionlint.bash)"; \
		echo "  macOS:   brew install actionlint"; \
		echo "  Go:      go install github.com/rhysd/actionlint/cmd/actionlint@latest"; \
		echo ""; \
		exit 1; \
	}
	@actionlint .github/workflows/*.yml
	@echo "✅ 모든 워크플로우 검증 통과"

.PHONY: ci-validate
ci-validate: check test-all lint-workflows
	@echo "✅ CI 검증 완료"

.PHONY: ci-build
ci-build:
	@echo "=== CI: 주요 프로젝트 빌드 ==="
	$(MAKE) build-postgres-exts
	@echo "✅ CI 빌드 완료"
