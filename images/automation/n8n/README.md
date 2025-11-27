# n8n - Workflow Automation Platform

오픈소스 워크플로우 자동화 플랫폼 (Zapier/Make 대안)

## Features

- 200+ 통합 서비스 지원 (HTTP, DB, API 등)
- 비주얼 워크플로우 에디터 (드래그 앤 드롭)
- 코드 실행 지원 (JavaScript/Python)
- Webhook 및 트리거 기능
- 조건부 로직 및 데이터 변환
- 스케줄링 (Cron)
- Self-hosted (데이터 완전 통제)
- 커뮤니티 노드 지원

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
open http://localhost:5678
```

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
N8N_VERSION=latest
WEB_PORT=5678
N8N_HOST=localhost
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678/

# Database
DB_TYPE=sqlite  # or postgresdb

# Security
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin        # SECURITY: 변경 필수!
N8N_BASIC_AUTH_PASSWORD=changeme # SECURITY: 변경 필수!
```

### 초기 설정

첫 접속 시 Basic Authentication 로그인:

1. http://localhost:5678 접속
2. 기본 계정 사용:
   - **Username**: `admin` (N8N_BASIC_AUTH_USER)
   - **Password**: `changeme` (N8N_BASIC_AUTH_PASSWORD)
3. **즉시 비밀번호 변경 필수!**

## Ports

- `5678`: n8n Web UI & Webhook endpoint (기본값, WEB_PORT로 변경 가능)

## Volumes

- `n8n-data`: n8n 데이터 (워크플로우, 크레덴셜, 실행 기록)

## Database Options

### SQLite (기본)
- 간단한 설정, 추가 컨테이너 불필요
- 소규모 사용에 적합
- 단일 인스턴스만 가능

```bash
DB_TYPE=sqlite
```

### PostgreSQL (프로덕션 권장)
- 다중 인스턴스 지원
- 더 나은 성능 및 안정성
- 백업 및 복구 용이

compose.yml에서 PostgreSQL 섹션 주석 해제:

```yaml
# 1. postgres 서비스 주석 해제
# 2. postgres-data 볼륨 주석 해제
# 3. n8n 환경변수에서 PostgreSQL 설정 주석 해제
```

.env 파일 수정:

```bash
DB_TYPE=postgresdb
POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=strong-password-here
```

## Deployment Options

### Development (현재 구성)
- SQLite 데이터베이스
- Basic Authentication
- HTTP 프로토콜

### Production
프로덕션 배포 시 고려사항:

1. **HTTPS 설정** (Nginx/Traefik 리버스 프록시):
   ```bash
   N8N_PROTOCOL=https
   N8N_HOST=n8n.example.com
   WEBHOOK_URL=https://n8n.example.com/
   ```

2. **PostgreSQL 사용**:
   ```bash
   DB_TYPE=postgresdb
   POSTGRES_PASSWORD=<strong-password>
   ```

3. **암호화 키 설정**:
   ```bash
   # 암호화 키 생성
   openssl rand -base64 32

   # .env에 추가
   N8N_ENCRYPTION_KEY=<generated-key>
   ```

4. **Basic Auth 비활성화 및 n8n 내장 인증 사용**:
   ```bash
   N8N_BASIC_AUTH_ACTIVE=false
   # n8n UI에서 사용자 계정 생성
   ```

5. **백업 설정**:
   ```bash
   # 워크플로우 백업 (SQLite)
   docker run --rm \
     -v n8n_n8n-data:/data \
     -v $(pwd):/backup \
     alpine tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz /data

   # PostgreSQL 백업
   docker compose exec postgres pg_dump -U n8n n8n > backup.sql
   ```

## Workflow Examples

### 1. 일일 리포트 자동 발송

```
Cron Trigger (매일 9시)
  → HTTP Request (API에서 데이터 가져오기)
  → Function (데이터 가공)
  → Gmail (리포트 이메일 발송)
```

### 2. GitHub 이슈 → Slack 알림

```
Webhook (GitHub)
  → IF (이슈 타입 확인)
  → Slack (채널에 메시지 전송)
```

### 3. 파일 자동 처리

```
Cron Trigger (매 시간)
  → FTP (파일 다운로드)
  → Function (파일 처리)
  → S3 (처리된 파일 업로드)
  → Email (완료 알림)
```

## Advanced Configuration

### SMTP (이메일 발송)

.env 파일에 추가:

```bash
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=smtp.gmail.com
N8N_SMTP_PORT=587
N8N_SMTP_USER=your-email@gmail.com
N8N_SMTP_PASS=your-app-password
N8N_SMTP_SENDER=n8n@example.com
```

### Queue Mode (고부하 환경)

Redis 추가 필요:

```yaml
# compose.yml에 Redis 추가
redis:
  image: redis:7-alpine
  container_name: n8n-redis
  restart: always
```

.env 설정:

```bash
EXECUTIONS_MODE=queue
QUEUE_BULL_REDIS_HOST=redis
QUEUE_BULL_REDIS_PORT=6379
```

### Community Nodes

커뮤니티 노드 활성화:

```bash
N8N_COMMUNITY_PACKAGES_ENABLED=true
```

n8n UI에서 설치:
1. Settings → Community Nodes
2. 노드 이름 검색 및 설치

### Execution Logging

로그 레벨 설정:

```bash
N8N_LOG_LEVEL=debug
# Options: error, warn, info, verbose, debug
```

## Integration Examples

### Google Sheets
1. Credentials → Add Credential → Google Sheets OAuth2 API
2. Client ID/Secret 입력 (Google Cloud Console에서 생성)
3. 워크플로우에서 Google Sheets 노드 사용

### Slack
1. Credentials → Add Credential → Slack OAuth2 API
2. Slack App 생성 및 OAuth Token 입력
3. 워크플로우에서 Slack 노드 사용

### Database (PostgreSQL/MySQL)
1. Credentials → Add Credential → Postgres/MySQL
2. 연결 정보 입력
3. 워크플로우에서 SQL 쿼리 실행

### REST API
1. HTTP Request 노드 사용
2. Authentication 설정 (API Key, OAuth2 등)
3. Request 메서드 및 파라미터 설정

## Webhook Usage

### Webhook URL 형식

```
http://localhost:5678/webhook/<webhook-name>
https://n8n.example.com/webhook/<webhook-name>
```

### Webhook 보안

1. **Test Webhook**: 개발용, 재시작 시 URL 변경
2. **Production Webhook**: 프로덕션용, 고정 URL
3. **Authentication**: Header/Query Parameter로 인증 추가

예시 (Header Authentication):

```javascript
// Function 노드에서 인증 체크
if ($request.headers.authorization !== 'Bearer my-secret-token') {
  throw new Error('Unauthorized');
}
```

## Troubleshooting

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f

# 권한 확인
docker compose exec n8n ls -la /home/node/.n8n
```

### Webhook이 작동하지 않음

Webhook URL 확인:

```bash
# .env 파일
WEBHOOK_URL=http://localhost:5678/  # 또는 실제 도메인
```

방화벽 확인:

```bash
# 포트 5678이 열려있는지 확인
netstat -tuln | grep 5678
```

### 워크플로우 실행 실패

실행 로그 확인:
1. Executions 탭에서 실패한 실행 클릭
2. 에러 메시지 및 스택 트레이스 확인
3. 노드별 입출력 데이터 확인

### "Credentials could not be decrypted"

암호화 키 변경 시 발생. 해결 방법:

```bash
# 기존 크레덴셜 삭제 후 재생성
# 또는 백업에서 복원
```

### 데이터베이스 연결 실패 (PostgreSQL)

```bash
# PostgreSQL 연결 확인
docker compose exec postgres psql -U n8n -d n8n

# 환경변수 확인
docker compose exec n8n env | grep DB_
```

## Performance Optimization

### 실행 데이터 정리

오래된 실행 데이터 자동 삭제:

```bash
EXECUTIONS_DATA_PRUNE=true
EXECUTIONS_DATA_MAX_AGE=168  # 7일 (시간 단위)
```

### 메모리 제한

compose.yml에 추가:

```yaml
n8n:
  deploy:
    resources:
      limits:
        memory: 2G
      reservations:
        memory: 512M
```

## Backup and Restore

### 백업 (SQLite)

```bash
# 전체 데이터 백업
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz /data

# 워크플로우만 내보내기 (n8n UI)
Settings → Workflows → Export All
```

### 백업 (PostgreSQL)

```bash
# 데이터베이스 백업
docker compose exec postgres pg_dump -U n8n n8n \
  > n8n-db-backup-$(date +%Y%m%d).sql

# 볼륨 백업
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/n8n-data-$(date +%Y%m%d).tar.gz /data
```

### 복원

```bash
# SQLite 복원
docker run --rm \
  -v n8n_n8n-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/n8n-backup-20250127.tar.gz -C /

# PostgreSQL 복원
docker compose exec -T postgres psql -U n8n n8n \
  < n8n-db-backup-20250127.sql
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

- **Official Site**: https://n8n.io/
- **Documentation**: https://docs.n8n.io/
- **Docker Hub**: https://hub.docker.com/r/n8nio/n8n
- **GitHub**: https://github.com/n8n-io/n8n
- **Community**: https://community.n8n.io/
- **Integrations**: https://n8n.io/integrations/

## License

n8n is licensed under Sustainable Use License.
See: https://github.com/n8n-io/n8n/blob/master/LICENSE.md

---

**Version**: 1.0.0
**Port**: 5678
**Category**: automation
**Phase**: 14
