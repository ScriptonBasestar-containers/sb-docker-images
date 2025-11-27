# BookStack - Wiki and Documentation Platform

오픈소스 위키 및 문서화 플랫폼

## Features

- 계층적 문서 구조 (Shelves → Books → Chapters → Pages)
- WYSIWYG 마크다운 에디터
- 강력한 검색 및 태그 기능
- 세밀한 권한 관리 (Role-based Access Control)
- 다중 인증 지원 (LDAP, SAML, OAuth)
- 이미지 관리 및 드로잉 도구
- API 지원 (자동화 및 통합)
- 변경 이력 추적 (Audit log)

## Quick Start

```bash
# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# 웹 UI 접속
open http://localhost:8390
```

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
BOOKSTACK_VERSION=latest
WEB_PORT=8390
APP_URL=http://localhost:8390  # IMPORTANT: 프로덕션에서 변경 필수

# User/Group (LinuxServer.io)
PUID=1000  # id -u 명령으로 확인
PGID=1000  # id -g 명령으로 확인

# Database
MARIADB_VERSION=11.5
DB_NAME=bookstack
DB_USER=bookstack
DB_PASSWORD=changeme          # SECURITY: 변경 필수!
DB_ROOT_PASSWORD=rootchangeme # SECURITY: 변경 필수!
```

### 초기 설정

첫 접속 시 기본 관리자 계정으로 로그인:

1. http://localhost:8390 접속
2. 기본 계정 사용:
   - **Email**: `admin@admin.com`
   - **Password**: `password`
3. **즉시 비밀번호 변경 필수!**
4. Settings → Users → Admin 프로필 수정

## Ports

- `8390`: BookStack Web UI (기본값, WEB_PORT로 변경 가능)
- `3306`: MariaDB (내부 네트워크, 외부 노출 안 됨)

## Volumes

- `bookstack-config`: BookStack 설정 및 업로드 파일
- `mariadb-data`: MariaDB 데이터베이스

## Deployment Options

### Development (현재 구성)
- Docker Compose로 빠른 시작
- 개발 및 테스트용

### Production
프로덕션 배포 시 고려사항:

1. **HTTPS 설정**:
   ```bash
   # Nginx/Traefik 리버스 프록시 사용
   APP_URL=https://docs.example.com
   ```

2. **비밀번호 변경**:
   ```bash
   DB_PASSWORD=<strong-password>
   DB_ROOT_PASSWORD=<strong-root-password>
   ```

3. **백업 설정**:
   ```bash
   # 정기 백업 스크립트
   docker compose exec db mariadb-dump -u bookstack -p bookstack > backup.sql
   ```

4. **볼륨 백업**:
   ```bash
   # 설정 및 파일 백업
   tar czf bookstack-config-backup.tar.gz \
     /var/lib/docker/volumes/bookstack_bookstack-config
   ```

## Advanced Configuration

### SMTP (이메일 발송)

.env 파일에 추가:

```bash
MAIL_DRIVER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM=wiki@example.com
MAIL_FROM_NAME=BookStack
```

### LDAP 인증

.env 파일에 추가:

```bash
AUTH_METHOD=ldap
LDAP_SERVER=ldap://ldap.example.com:389
LDAP_BASE_DN=ou=People,dc=example,dc=com
LDAP_DN=cn=admin,dc=example,dc=com
LDAP_PASS=admin_password
LDAP_USER_FILTER=(&(uid=\${user}))
LDAP_VERSION=3
```

설정 후 컨테이너 재시작:

```bash
docker compose restart bookstack
```

### OAuth 2.0 (Google, GitHub, etc.)

BookStack Web UI에서 설정:
1. Settings → Access Control → Social Authentication
2. OAuth Provider 선택 및 Client ID/Secret 입력
3. Redirect URI 복사하여 OAuth 앱에 등록

### 파일 업로드 제한 변경

.env 파일에 추가:

```bash
FILE_UPLOAD_SIZE_LIMIT=50
# MB 단위, 기본값: 50MB
```

## Document Organization

### 구조 이해

```
Shelves (서가)
  └── Books (책)
        └── Chapters (챕터, 선택)
              └── Pages (페이지)
```

### 베스트 프랙티스

1. **Shelves**: 대분류 (예: 프로젝트, 부서)
2. **Books**: 중분류 (예: API 문서, 운영 가이드)
3. **Chapters**: 소분류 (선택, 예: 인증, 데이터베이스)
4. **Pages**: 개별 문서

### 권한 관리

- **Public**: 모든 사용자 읽기 가능
- **Private**: 소유자만 접근
- **Custom**: 세밀한 Role 기반 권한 설정

## API Usage

### API Token 생성

1. Settings → Users → Your Profile
2. API Tokens 섹션
3. "Create Token" 클릭
4. Token 이름 입력 및 만료 기간 설정

### API 예시

```bash
# 모든 책 목록 조회
curl -H "Authorization: Token YOUR_TOKEN" \
  http://localhost:8390/api/books

# 새 페이지 생성
curl -X POST \
  -H "Authorization: Token YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"book_id": 1, "name": "New Page", "markdown": "# Hello"}' \
  http://localhost:8390/api/pages
```

API 문서: http://localhost:8390/api/docs

## Troubleshooting

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f

# 데이터베이스 연결 확인
docker compose exec db mariadb -u bookstack -p
```

### 파일 업로드 실패

```bash
# 볼륨 권한 확인
docker compose exec bookstack ls -la /config

# PUID/PGID 확인
id -u  # PUID
id -g  # PGID
```

### "Please set the APP_URL environment variable"

APP_URL 설정 확인:

```bash
# .env 파일
APP_URL=http://localhost:8390  # 또는 실제 도메인
```

컨테이너 재시작:

```bash
docker compose restart bookstack
```

### 데이터베이스 마이그레이션 실패

```bash
# 데이터베이스 재생성
docker compose down -v
docker compose up -d
```

### 이미지 업로드 후 표시 안 됨

APP_URL이 실제 접속 URL과 일치하는지 확인:

```bash
# 로컬: http://localhost:8390
# 프로덕션: https://docs.example.com
```

### LDAP 인증 실패

```bash
# LDAP 연결 테스트
docker compose exec bookstack ldapsearch \
  -x -H ldap://ldap.example.com:389 \
  -D "cn=admin,dc=example,dc=com" \
  -w admin_password \
  -b "ou=People,dc=example,dc=com"
```

## Maintenance

### 업그레이드

```bash
# 최신 이미지 다운로드
docker compose pull

# 컨테이너 재생성
docker compose up -d

# 로그 확인
docker compose logs -f bookstack
```

### 백업

```bash
# 데이터베이스 백업
docker compose exec db mariadb-dump -u bookstack -p bookstack \
  > backup-$(date +%Y%m%d).sql

# 설정 및 업로드 파일 백업
docker run --rm \
  -v bookstack_bookstack-config:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/bookstack-files-$(date +%Y%m%d).tar.gz /data
```

### 복원

```bash
# 데이터베이스 복원
docker compose exec -T db mariadb -u bookstack -p bookstack \
  < backup-20250127.sql

# 파일 복원
docker run --rm \
  -v bookstack_bookstack-config:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/bookstack-files-20250127.tar.gz -C /
```

## Makefile Commands

```bash
make help      # 사용 가능한 명령어 목록
make up        # 서비스 시작
make down      # 서비스 중지
make logs      # 로그 확인
make restart   # 서비스 재시작
make ps        # 컨테이너 상태 확인
make clean     # 모든 리소스 제거 (주의!)
```

## References

- **Official Site**: https://www.bookstackapp.com/
- **Documentation**: https://www.bookstackapp.com/docs/
- **Docker Image**: https://docs.linuxserver.io/images/docker-bookstack/
- **GitHub**: https://github.com/BookStackApp/BookStack
- **Community**: https://github.com/BookStackApp/BookStack/discussions

## License

BookStack is licensed under MIT License.
See: https://github.com/BookStackApp/BookStack/blob/development/LICENSE

---

**Version**: 1.0.0
**Port**: 8390
**Category**: collaboration
**Phase**: 14
