# Wiki.js

Wiki.js는 Node.js 기반의 현대적이고 강력한 오픈소스 위키 소프트웨어입니다. 아름다운 UI와 다양한 기능을 제공하며, Git 동기화, 검색, 인증 등을 지원합니다.

## 개요

Wiki.js는 다음과 같은 기능을 제공합니다:
- 직관적인 Markdown 에디터
- Git 저장소 동기화 (GitHub, GitLab, Bitbucket 등)
- 강력한 검색 엔진 (Elasticsearch, Algolia, DB 등)
- 다양한 인증 방법 (로컬, LDAP, OAuth, SAML 등)
- 다국어 지원
- 권한 관리 시스템
- 테마 및 커스터마이징
- REST API

## Deployment Options

### Standalone (Recommended)

Complete production-ready setup with all dependencies included:

```bash
cd standalone/
docker compose up -d
```

**Includes:**
- Wiki.js (ghcr.io/requarks/wiki:2)
- PostgreSQL 15 with health check
- Network isolation (app-network, data-network)

See [standalone/README.md](standalone/README.md) for detailed instructions.

### Basic Setup

Basic setup using docker-compose.yml:

## 빠른 시작

```bash
# 1. 서비스 시작
docker-compose up -d

# 2. 브라우저에서 접속
# http://localhost:8320

# 3. 초기 설정 마법사 실행
# - 관리자 계정 생성
# - 사이트 정보 입력
# - 데이터베이스 연결 확인 (자동 설정됨)

# 4. 위키 사용 시작
```

## 서비스 구성

docker-compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **wiki**: Wiki.js 애플리케이션 (포트 80→3000)
  - Node.js 기반 위키 엔진
  - 웹 UI 제공
  - API 서버

- **db**: PostgreSQL 15 데이터베이스
  - Wiki 데이터 저장
  - 사용자 정보 관리
  - 메타데이터 저장

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 80 | wiki | Wiki.js 웹 UI (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 80 포트 사용 중입니다.
>
> **권장 포트**: 8320 ([포트 가이드](../PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # docker-compose.yml 파일에서 수정
> sed -i 's/"80:3000"/"8320:3000"/' docker-compose.yml
>
> # 또는 직접 편집
> # ports:
> #   - "8320:3000"
>
> # 또는 환경 변수 사용
> # .env 파일에 WIKI_PORT=8320 추가 후
> # ports:
> #   - "${WIKI_PORT:-80}:3000"
> ```

포트 충돌 방지: [포트 가이드](../PORT_GUIDE.md)

## 환경 변수

### 데이터베이스 설정

```yaml
# PostgreSQL 설정 (db 서비스)
POSTGRES_DB=wiki
POSTGRES_USER=wikijs
POSTGRES_PASSWORD=wikijsrocks

# Wiki.js 데이터베이스 연결 설정
DB_TYPE=postgres
DB_HOST=db
DB_PORT=5432
DB_USER=wikijs
DB_PASS=wikijsrocks
DB_NAME=wiki
```

### 추가 환경 변수 (선택사항)

Wiki.js는 다양한 환경 변수를 지원합니다. docker-compose.yml에 추가할 수 있습니다:

```yaml
services:
  wiki:
    environment:
      # 데이터베이스
      DB_TYPE: postgres
      DB_HOST: db
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: wikijsrocks
      DB_NAME: wiki

      # SSL/TLS (선택)
      # DB_SSL: true
      # DB_SSL_CA: /path/to/ca.crt

      # 로깅
      # LOG_LEVEL: info

      # 업로드 크기 제한
      # UPLOAD_MAX_FILE_SIZE: 5242880  # 5MB
      # UPLOAD_MAX_FILES: 10
```

## 사용법

### Makefile 명령어

이 프로젝트는 간편한 관리를 위한 Makefile을 제공합니다:

```bash
make help      # 사용 가능한 명령어 보기
make up        # 서비스 시작
make down      # 서비스 중지
make restart   # 서비스 재시작
make logs      # 로그 보기
make ps        # 실행 중인 컨테이너 확인
make shell     # Wiki.js 컨테이너 접속
make clean     # 모든 데이터 삭제 (주의!)
```

### 기본 작업

```bash
# Makefile 사용 (권장)
make up

# 또는 docker compose 직접 사용
docker compose up -d

# 로그 확인
docker-compose logs -f

# Wiki.js 로그만 확인
docker-compose logs -f wiki

# 서비스 재시작
docker-compose restart

# 서비스 중지
docker-compose down

# 서비스 중지 및 데이터 삭제
docker-compose down -v
```

### 관리자 인터페이스

Wiki.js는 웹 기반 관리 인터페이스를 제공합니다:

1. http://localhost:8320/login 접속
2. 관리자 계정으로 로그인
3. 우측 상단 사용자 아이콘 클릭
4. "Administration" 선택

관리 페이지에서 다음을 설정할 수 있습니다:
- 인증 방법
- 저장소 동기화 (Git)
- 검색 엔진
- 렌더링 설정
- 테마 및 스타일
- 사용자 및 그룹
- 권한 관리

### 데이터 백업

```bash
# 데이터베이스 백업
docker-compose exec db pg_dump -U wikijs wiki > backup-$(date +%Y%m%d).sql

# 데이터베이스 복원
docker-compose exec -T db psql -U wikijs wiki < backup-20250117.sql

# 전체 볼륨 백업 (권장)
docker run --rm -v wikijs_db-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/wikijs-backup-$(date +%Y%m%d).tar.gz /data
```

### Git 동기화 설정

Wiki.js는 Git 저장소와 동기화할 수 있습니다:

1. 관리 페이지 → Storage 이동
2. Git 선택 및 활성화
3. 저장소 정보 입력:
   - Repository URL
   - Branch
   - Authentication (SSH Key, Token 등)
4. Sync Direction 선택:
   - Bi-directional: 양방향 동기화
   - Pull only: Git → Wiki만
   - Push only: Wiki → Git만

### 검색 엔진 설정

기본적으로 Database 검색을 사용하지만, 더 강력한 검색을 위해 다른 엔진을 사용할 수 있습니다:

1. 관리 페이지 → Search Engine
2. 원하는 엔진 선택:
   - Database (기본)
   - Elasticsearch
   - Algolia
   - Azure Search
   - Solr
3. 설정 저장 및 Rebuild Index

### 사용자 및 권한 관리

```bash
# 관리 페이지 → Users에서:
# - 새 사용자 생성
# - 그룹 할당
# - 권한 설정

# 관리 페이지 → Groups에서:
# - 그룹 생성
# - 페이지별 권한 설정 (읽기, 쓰기, 관리)
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 준비 확인
docker-compose logs db

# "database system is ready to accept connections" 확인 후
docker-compose restart wiki

# 연결 테스트
docker-compose exec db psql -U wikijs -d wiki -c "SELECT version();"
```

### 초기 설정 화면이 나타나지 않음

```bash
# 데이터베이스 초기화
docker-compose down -v
docker-compose up -d

# 브라우저 캐시 삭제 후 재접속
```

### 업로드가 작동하지 않음

docker-compose.yml에 업로드 제한 설정 추가:

```yaml
services:
  wiki:
    environment:
      UPLOAD_MAX_FILE_SIZE: 10485760  # 10MB
      UPLOAD_MAX_FILES: 20
```

### 성능 문제

```bash
# 메모리 사용량 확인
docker stats

# Node.js 메모리 제한 설정
services:
  wiki:
    environment:
      NODE_OPTIONS: "--max-old-space-size=2048"
    mem_limit: 2g
```

### 검색이 작동하지 않음

```bash
# 관리 페이지 → Search Engine
# "Rebuild Index" 버튼 클릭

# 또는 컨테이너 재시작
docker-compose restart wiki
```

### 로그 레벨 변경

```yaml
services:
  wiki:
    environment:
      LOG_LEVEL: debug  # error, warn, info, debug
```

### 데이터베이스 로그 비활성화

현재 설정에서는 데이터베이스 로그가 비활성화되어 있습니다:

```yaml
db:
  logging:
    driver: "none"
```

문제 해결을 위해 일시적으로 활성화:

```yaml
db:
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
```

## 참고 자료

- [Wiki.js 공식 사이트](https://js.wiki/)
- [Wiki.js 공식 GitHub](https://github.com/requarks/wiki)
- [Wiki.js 공식 문서](https://docs.requarks.io/)
- [Wiki.js Docker 가이드](https://docs.requarks.io/install/docker)
- [Wiki.js 커뮤니티](https://github.com/requarks/wiki/discussions)
- [PostgreSQL 공식 문서](https://www.postgresql.org/docs/)

## 기술 스택

- **Backend**: Node.js
- **Frontend**: Vue.js
- **Database**: PostgreSQL 15
- **Container**: Docker, Docker Compose
- **지원 저장소**: Git, S3, Azure Blob, 로컬 디스크 등
- **지원 인증**: Local, LDAP, OAuth2, SAML, OpenID 등

## 주요 기능

### 에디터
- Markdown
- WYSIWYG
- Code (Raw HTML)

### 저장소
- Git (GitHub, GitLab, Bitbucket 등)
- AWS S3
- Azure Blob Storage
- DigitalOcean Spaces
- 로컬 디스크

### 검색
- Database (기본)
- Elasticsearch
- Algolia
- Azure Search
- Solr
- AWS CloudSearch

### 인증
- Local
- LDAP / Active Directory
- OAuth 2.0
- SAML 2.0
- OpenID Connect
- Google, GitHub, Microsoft 등

## 라이선스

Wiki.js는 AGPL-v3 라이선스로 배포됩니다.

## 보안

### 프로덕션 환경 권장 사항

1. **데이터베이스 비밀번호 변경**:
```yaml
environment:
  POSTGRES_PASSWORD: <강력한-비밀번호>
  DB_PASS: <강력한-비밀번호>
```

2. **HTTPS 설정**:
Nginx 또는 Traefik과 같은 리버스 프록시 사용 권장

3. **백업 자동화**:
정기적인 데이터베이스 백업 스케줄 설정

4. **방화벽 설정**:
필요한 포트만 외부에 노출

5. **업데이트 유지**:
정기적으로 Wiki.js 및 PostgreSQL 이미지 업데이트
