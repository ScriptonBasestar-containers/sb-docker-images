# Gollum

Gollum은 Git 기반의 간단하고 강력한 위키 시스템입니다. Ruby로 작성되었으며, Git 저장소를 위키 페이지의 백엔드로 사용합니다. GitHub에서 사용하는 위키 엔진이기도 합니다.

> 💡 **Quick Start**: For production deployment, use the [standalone setup](standalone/README.md) - it includes comprehensive documentation and best practices!

## 개요

Gollum은 다음과 같은 기능을 제공합니다:
- 📚 Git을 활용한 버전 관리
- 📝 Markdown, AsciiDoc, Org-mode, Textile 등 다양한 마크업 지원
- 🖥️ 간단하고 직관적인 웹 인터페이스
- 💾 파일 기반 저장소 (데이터베이스 불필요)
- 🔍 전체 텍스트 검색
- 📖 페이지 히스토리 및 diff 보기
- 🐙 GitHub와 동일한 위키 경험

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Gollum (gollumwiki/gollum:latest)
- ✅ Environment variable configuration
- ✅ Health checks
- ✅ Standardized Makefile
- ✅ Comprehensive README with backup strategies

**Access:** http://localhost:8170

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide, Git integration, and production deployment checklist.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Uses minimal configuration with advanced permissions helper.

## Quick Start (Basic Setup)

```bash
# 1. 서비스 시작
docker compose up -d

# 2. 브라우저에서 접속
# http://localhost:8170 (GOLLUM_PORT로 변경 가능)

# 3. 위키 페이지 생성
# - "New Page" 버튼 클릭
# - 페이지 이름 입력
# - Markdown 또는 다른 포맷으로 작성
# - Save 클릭

# 4. Git 저장소로 백업 가능
# 모든 페이지는 Git 저장소에 저장됨
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **gollum**: Gollum 위키 애플리케이션
  - Ruby 3.3.6 기반
  - 웹 UI 제공
  - Git 저장소 관리
  - 다양한 마크업 렌더링

- **dollum**: 볼륨 권한 관리 헬퍼
  - busybox 기반
  - gollum 볼륨 권한 설정
  - gollum 서비스 시작 전 실행

## Default Configuration

**Default port:** 8170 (configurable via `GOLLUM_PORT`)

**Container name:** gollum (configurable via `GOLLUM_CONTAINER_NAME`)

Environment variables (.env.example):

```bash
GOLLUM_PORT=8170
GOLLUM_CONTAINER_NAME=gollum
```

## 환경 변수

### Gollum 설정

현재 compose.yml에는 환경 변수가 설정되어 있지 않지만, 다음과 같이 추가할 수 있습니다:

```yaml
services:
  gollum:
    environment:
      # 사용자 정보
      - USER01=user01
      - UID=1000

      # Git 설정 (선택사항)
      - GIT_AUTHOR_NAME=Your Name
      - GIT_AUTHOR_EMAIL=your.email@example.com
```

### 볼륨 설정

Gollum은 Named Volume을 사용하여 위키 데이터를 저장합니다:

```yaml
volumes:
  gollum:  # 위키 데이터 및 Git 저장소
```

로컬 디렉토리를 사용하려면:

```yaml
services:
  gollum:
    volumes:
      - ./wiki:/wiki  # 로컬 wiki 디렉토리 사용
```

## Makefile Commands

For standalone setup, use these commands:

```bash
make help     # Show available commands
make up       # Start Gollum
make down     # Stop Gollum
make restart  # Restart Gollum
make logs     # View logs (real-time)
make ps       # List running containers
make shell    # Access container shell
make clean    # Remove all data (with confirmation)
```

For basic setup, use `docker compose` commands directly.

## 사용법

### 기본 작업

```bash
# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# Gollum 로그만 확인
docker compose logs -f gollum

# 서비스 재시작
docker compose restart

# 서비스 중지
docker compose down

# 서비스 중지 및 데이터 삭제
docker compose down -v
```

### 페이지 생성 및 편집

1. 웹 인터페이스에서 "New Page" 클릭
2. 페이지 이름 입력 (예: Home, Tutorial)
3. 포맷 선택:
   - Markdown (기본)
   - AsciiDoc
   - Org-mode
   - Textile
   - RDoc
4. 내용 작성 및 저장

### 마크업 포맷

Gollum은 다양한 마크업을 지원합니다:

```markdown
# Markdown 예제
## 제목
**굵게** *기울임* `코드`

- 목록 1
- 목록 2

[링크](페이지명)
[[위키링크]]

\`\`\`python
def hello():
    print("Hello, Wiki!")
\`\`\`
```

### Git 저장소 직접 접근

```bash
# 컨테이너 내부 접속
docker compose exec gollum bash

# Git 히스토리 확인
cd /wiki
git log

# 변경 내용 확인
git diff

# 원격 저장소로 푸시 (선택사항)
git remote add origin https://github.com/your/repo.git
git push -u origin master
```

### 데이터 백업

```bash
# Git 저장소 백업 (권장)
docker compose exec gollum tar czf - /wiki | cat > backup-$(date +%Y%m%d).tar.gz

# 또는 볼륨 백업
docker run --rm -v gollum_gollum:/data -v $(pwd):/backup \
  alpine tar czf /backup/gollum-backup-$(date +%Y%m%d).tar.gz /data

# 로컬 디렉토리 사용 시
tar czf backup-$(date +%Y%m%d).tar.gz ./wiki
```

### 데이터 복원

```bash
# Git 저장소 복원
docker compose exec -T gollum tar xzf - -C / < backup-20250117.tar.gz

# 볼륨 복원
docker run --rm -v gollum_gollum:/data -v $(pwd):/backup \
  alpine tar xzf /backup/gollum-backup-20250117.tar.gz -C /

# 로컬 디렉토리 복원
tar xzf backup-20250117.tar.gz
```

### 고급 기능

Gollum 시작 시 추가 옵션을 사용할 수 있습니다:

```yaml
services:
  gollum:
    command:
      - gollum
      - /wiki
      - --port
      - "8170"
      - --host
      - "0.0.0.0"
      - --config
      - /path/to/config.rb
      - --ref
      - master  # Git 브랜치 지정
      - --adapter
      - grit  # Git 어댑터 선택
```

## 문제 해결

### Git 저장소가 초기화되지 않음

```bash
# 컨테이너 내부에서 수동 초기화
docker compose exec gollum bash
cd /wiki
git init
git config user.name "Gollum"
git config user.email "gollum@example.com"
```

### 권한 오류

```bash
# 볼륨 권한 확인
docker compose exec gollum ls -la /wiki

# 권한 수정 (필요시)
docker compose exec gollum chown -R 1000:1000 /wiki

# 또는 dollum 서비스 재시작
docker compose restart dollum gollum
```

### 페이지가 저장되지 않음

```bash
# Git 설정 확인
docker compose exec gollum bash
cd /wiki
git config --list

# Git 사용자 정보 설정
git config user.name "Your Name"
git config user.email "your@email.com"

# 저장소 상태 확인
git status
```

### 포트 충돌

```bash
# 다른 포트로 실행
# compose.yml에서 포트 변경 후
docker compose down
docker compose up -d

# 또는 임시로 다른 포트 사용
docker compose run -p 8888:4567 gollum
```

### 검색이 작동하지 않음

Gollum의 검색 기능은 Git grep을 사용합니다:

```bash
# 컨테이너 내부에서 수동 검색
docker compose exec gollum bash
cd /wiki
git grep "검색어"
```

### 마크업 렌더링 오류

```bash
# 필요한 gem이 설치되어 있는지 확인
docker compose exec gollum bash
gem list | grep -E "gollum|github-linguist|org-ruby|asciidoctor"

# 누락된 gem 설치 (필요시)
gem install org-ruby
gem install asciidoctor
```

## Port Information

See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation strategy.

**Default port:**
- Gollum: 8170

To change the port, create a `.env` file (copy from `.env.example`) and modify:
```bash
GOLLUM_PORT=8170  # Change to your preferred port
```

## 참고 자료

- [Gollum 공식 GitHub](https://github.com/gollum/gollum)
- [Gollum 공식 Docker 이미지](https://hub.docker.com/r/gollumwiki/gollum)
- [Gollum Wiki 문서](https://github.com/gollum/gollum/wiki)
- [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/)
- [AsciiDoc 문법](https://asciidoc.org/)
- [Git 공식 문서](https://git-scm.com/doc)

## 기술 스택

- **Backend**: Ruby 3.3.6
- **Wiki Engine**: Gollum
- **Version Control**: Git
- **Markup Languages**:
  - Markdown (GitHub Flavored)
  - AsciiDoc
  - Org-mode
  - Textile
  - RDoc
  - MediaWiki
  - Creole
- **Container**: Docker, Docker Compose
- **Web Server**: WEBrick (내장)

## 주요 기능

### 마크업 지원
- Markdown (GitHub Flavored Markdown)
- AsciiDoc
- Org-mode
- Textile
- RDoc
- MediaWiki
- Creole
- reStructuredText

### Git 통합
- 자동 버전 관리
- 페이지 히스토리
- Diff 보기
- 되돌리기 (Revert)
- 원격 저장소 동기화

### 검색 및 탐색
- 전체 텍스트 검색
- 페이지 목록
- 최근 변경 페이지
- Git 히스토리 탐색

### 편집 기능
- 실시간 미리보기
- 다중 포맷 지원
- 파일 업로드
- 이미지 삽입
- 코드 하이라이팅

## 라이선스

Gollum은 MIT 라이선스로 배포됩니다.

## 보안

### 프로덕션 환경 권장 사항

1. **접근 제어 설정**:
Gollum은 기본적으로 인증 기능이 없으므로, 리버스 프록시로 인증을 추가하는 것이 좋습니다:

```nginx
# Nginx 예제
location / {
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://localhost:8170;
}
```

2. **HTTPS 설정**:
Nginx 또는 Traefik과 같은 리버스 프록시 사용 권장

3. **Git 저장소 백업**:
정기적인 Git 저장소 백업 스케줄 설정

4. **읽기 전용 모드** (선택사항):
```yaml
command: ["gollum", "/wiki", "--no-edit"]
```

5. **방화벽 설정**:
필요한 포트만 외부에 노출

## 고급 설정

### 커스텀 config.rb

Gollum의 동작을 커스터마이징하려면 config.rb 파일을 생성:

```ruby
# config.rb
Precious::App.set(:wiki_options, {
  :universal_toc => true,
  :mathjax => true,
  :h1_title => true,
  :css => true,
  :js => true
})
```

compose.yml에 마운트:

```yaml
services:
  gollum:
    volumes:
      - gollum:/wiki
      - ./config.rb:/config.rb
    command: ["gollum", "/wiki", "--config", "/config.rb"]
```

### 커스텀 CSS/JS

```yaml
services:
  gollum:
    volumes:
      - gollum:/wiki
      - ./custom.css:/wiki/custom.css
      - ./custom.js:/wiki/custom.js
```

### Git Hooks

```bash
# 컨테이너 내부에서
docker compose exec gollum bash
cd /wiki/.git/hooks
cat > post-commit << 'EOF'
#!/bin/bash
# 커밋 후 원격 저장소로 자동 푸시
git push origin master
EOF
chmod +x post-commit
```

## Build & Push (개발자용)

```bash
# 로컬 빌드
make jenkins-build

# 태그 생성
make jenkins-tag

# 이미지 푸시
make jenkins-push
```
