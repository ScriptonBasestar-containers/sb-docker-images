# Mattermost - Team Collaboration Platform

오픈소스 팀 협업 플랫폼 (Slack 대안)

## Features

- 실시간 메시징 및 파일 공유
- 채널 기반 커뮤니케이션
- 모바일 앱 지원 (iOS, Android)
- 풍부한 통합 (Jira, GitHub, GitLab 등)
- 엔터프라이즈급 보안 및 컴플라이언스
- Self-hosted (데이터 완전 통제)

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
open http://localhost:8350
```

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
MATTERMOST_VERSION=latest
WEB_PORT=8350
SITE_URL=http://localhost:8350  # IMPORTANT: 프로덕션에서 변경 필수

# Database
POSTGRES_VERSION=16-alpine
DB_NAME=mattermost
DB_USER=mmuser
DB_PASSWORD=changeme  # SECURITY: 변경 필수!
```

### 초기 설정

첫 접속 시 관리자 계정을 생성합니다:

1. http://localhost:8350 접속
2. "Create an account" 클릭
3. 이메일, 사용자명, 비밀번호 입력
4. 첫 번째 사용자가 자동으로 시스템 관리자가 됩니다

## Ports

- `8350`: Mattermost Web UI (기본값, WEB_PORT로 변경 가능)
- `5432`: PostgreSQL (내부 네트워크, 외부 노출 안 됨)

## Volumes

- `mattermost-config`: Mattermost 설정 파일
- `mattermost-data`: 사용자 업로드 파일
- `mattermost-logs`: 로그 파일
- `mattermost-plugins`: 플러그인
- `postgres-data`: PostgreSQL 데이터베이스

## Deployment Options

### Development (현재 구성)
- Docker Compose로 빠른 시작
- 개발 및 테스트용

### Production
프로덕션 배포 시 고려사항:

1. **HTTPS 설정**:
   ```bash
   # Nginx/Traefik 리버스 프록시 사용
   SITE_URL=https://chat.example.com
   ```

2. **비밀번호 변경**:
   ```bash
   DB_PASSWORD=<strong-password>
   ```

3. **백업 설정**:
   ```bash
   # 정기 백업 스크립트
   docker compose exec db pg_dump -U mmuser mattermost > backup.sql
   ```

4. **볼륨 백업**:
   ```bash
   # 파일 업로드 백업
   tar czf mattermost-data-backup.tar.gz \
     /var/lib/docker/volumes/mattermost_mattermost-data
   ```

## Advanced Configuration

### SMTP (이메일 발송)

.env 파일에 추가:

```bash
MM_EMAILSETTINGS_SMTPSERVER=smtp.gmail.com
MM_EMAILSETTINGS_SMTPPORT=587
MM_EMAILSETTINGS_SMTPUSERNAME=your-email@gmail.com
MM_EMAILSETTINGS_SMTPPASSWORD=your-app-password
MM_EMAILSETTINGS_ENABLESMTPAUTH=true
MM_EMAILSETTINGS_CONNECTIONSECURITY=STARTTLS
```

### SSO / SAML

Mattermost는 다음 SSO를 지원합니다:
- SAML 2.0
- OAuth 2.0 (GitLab, Google, Office 365)
- LDAP/AD

설정 방법: System Console → Authentication 참조

### Plugins

플러그인 설치:

1. System Console → Plugin Management
2. "Upload Plugin" 클릭
3. .tar.gz 파일 업로드
4. 플러그인 활성화

인기 플러그인:
- GitHub
- Jira
- Jenkins
- Zoom
- Google Calendar

## Troubleshooting

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f

# 데이터베이스 연결 확인
docker compose exec db pg_isready -U mmuser
```

### 파일 업로드 실패

```bash
# 볼륨 권한 확인
docker compose exec mattermost ls -la /mattermost/data

# 디스크 공간 확인
df -h
```

### "Invalid or expired session" 에러

SITE_URL 설정 확인:

```bash
# .env 파일
SITE_URL=http://localhost:8350  # 또는 실제 도메인
```

컨테이너 재시작:

```bash
docker compose restart mattermost
```

### 데이터베이스 마이그레이션 실패

```bash
# 데이터베이스 재생성
docker compose down -v
docker compose up -d
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

- **Official Site**: https://mattermost.com/
- **Documentation**: https://docs.mattermost.com/
- **Docker Hub**: https://hub.docker.com/r/mattermost/mattermost-team-edition
- **GitHub**: https://github.com/mattermost/mattermost
- **Community**: https://community.mattermost.com/

## License

Mattermost Team Edition is licensed under MIT License.
See: https://github.com/mattermost/mattermost/blob/master/LICENSE.txt

---

**Version**: 1.0.0
**Port**: 8350
**Category**: collaboration
**Phase**: 14
