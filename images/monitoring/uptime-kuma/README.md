# Uptime Kuma - Self-hosted Monitoring Tool

오픈소스 모니터링 및 알림 플랫폼 (Uptime Robot 대안)

## Features

- 웹사이트/API 모니터링 (HTTP/HTTPS)
- TCP/UDP 포트 모니터링
- Ping 모니터링 (ICMP)
- DNS 레코드 모니터링
- Docker 컨테이너 모니터링
- 60+ 알림 채널 지원 (Slack, Discord, Telegram, Email 등)
- 상태 페이지 (Status Page) 제공
- 멀티 언어 지원 (한국어 포함)
- 모바일 친화적 UI
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
open http://localhost:3011
```

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
UPTIME_KUMA_VERSION=1  # Latest stable v1.x
WEB_PORT=3011          # Web UI port
```

### 초기 설정

첫 접속 시 관리자 계정 생성:

1. http://localhost:3011 접속
2. "Create Account" 화면에서 계정 생성:
   - Username
   - Password (8자 이상)
3. 첫 번째 사용자가 자동으로 관리자가 됩니다

## Ports

- `3011`: Uptime Kuma Web UI (기본값, WEB_PORT로 변경 가능)

## Volumes

- `uptime-kuma-data`: 데이터베이스 및 설정 (SQLite)

## Monitor Types

### 1. HTTP(s) Monitoring

웹사이트 및 API 엔드포인트 모니터링:

- **Method**: GET, POST, PUT, DELETE 등
- **Expected Status**: 200, 201, 204 등
- **Keyword Check**: 응답 본문에 특정 키워드 포함 확인
- **Headers**: 커스텀 HTTP 헤더 추가
- **Body**: POST 요청 시 본문 전송

### 2. TCP Port Monitoring

TCP 포트 상태 확인:

- **Hostname**: 대상 호스트
- **Port**: 포트 번호 (예: 3306, 5432, 6379)
- **Timeout**: 연결 타임아웃

### 3. Ping (ICMP)

호스트 Ping 응답 확인:

- **Hostname/IP**: 대상 호스트
- **Packet Count**: Ping 패킷 수

### 4. DNS Monitoring

DNS 레코드 확인:

- **Record Type**: A, AAAA, CNAME, MX, TXT 등
- **Nameserver**: 사용할 DNS 서버
- **Expected Value**: 예상되는 값

### 5. Docker Container

Docker 컨테이너 상태 모니터링:

- **Docker Host**: Docker 데몬 주소
- **Container Name**: 컨테이너 이름

## Notification Channels

Uptime Kuma는 60+ 알림 채널을 지원합니다:

### Email (SMTP)

Settings → Notifications → Setup Notification → Email (SMTP):

```
SMTP Host: smtp.gmail.com
SMTP Port: 587
Security: TLS
Username: your-email@gmail.com
Password: your-app-password
From Email: your-email@gmail.com
To Email: alert@example.com
```

### Slack

Settings → Notifications → Setup Notification → Slack:

1. Slack Webhook URL 생성 (Slack App 설정)
2. Webhook URL 입력
3. Channel/Username 설정 (선택)

### Discord

Settings → Notifications → Setup Notification → Discord:

1. Discord Webhook URL 생성 (서버 설정 → 통합)
2. Webhook URL 입력
3. Username 설정 (선택)

### Telegram

Settings → Notifications → Setup Notification → Telegram:

1. BotFather에서 봇 생성 및 Token 획득
2. Bot Token 입력
3. Chat ID 입력 (@userinfobot에서 확인)

### 기타 지원 채널

- Gotify
- Pushover
- Pushbullet
- Line
- Mattermost
- Rocket.Chat
- Microsoft Teams
- Webhook (커스텀)
- MQTT
- Twilio (SMS)
- ...그 외 50+ 채널

## Status Pages

공개 상태 페이지 생성:

1. **Status Pages** 메뉴 클릭
2. "Create Status Page" 클릭
3. 설정:
   - **Slug**: URL 경로 (예: `my-services`)
   - **Title**: 페이지 제목
   - **Description**: 설명
   - **Monitors**: 포함할 모니터 선택
4. 공개 URL: `http://localhost:3011/status/<slug>`

### 커스터마이징

- **Theme**: Light/Dark
- **Custom CSS**: 스타일 커스터마이징
- **Footer Text**: 하단 텍스트 추가
- **Show Powered By**: "Powered by Uptime Kuma" 표시 여부

## Advanced Configuration

### Heartbeat Interval

모니터별 확인 주기 설정:

- **Heartbeat Interval**: 20초, 60초, 300초 등
- **Retries**: 재시도 횟수 (실패 판정 전)

### Certificate Monitoring

SSL 인증서 만료 모니터링:

- **Certificate Expiry**: 자동 체크
- **Certificate Expiry Notification**: 만료 N일 전 알림

### Proxy Settings

프록시 서버 사용:

Settings → Proxies:
- **Protocol**: HTTP, HTTPS, SOCKS
- **Host**: 프록시 호스트
- **Port**: 프록시 포트
- **Auth**: 인증 정보 (선택)

### API Keys

API를 통한 모니터 관리:

Settings → API Keys:
1. "Generate" 클릭
2. API Key 생성 및 권한 설정
3. API 문서: https://github.com/louislam/uptime-kuma/wiki/API

## Deployment Options

### Development (현재 구성)
- SQLite 데이터베이스
- 단일 컨테이너
- 빠른 시작

### Production

프로덕션 배포 시 고려사항:

1. **HTTPS 설정** (Nginx/Traefik 리버스 프록시):
   ```nginx
   server {
       listen 443 ssl;
       server_name uptime.example.com;

       location / {
           proxy_pass http://localhost:3011;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
       }
   }
   ```

2. **백업 설정**:
   ```bash
   # 정기 백업 (cron)
   0 2 * * * docker run --rm \
     -v uptime-kuma_uptime-kuma-data:/data \
     -v /backup:/backup \
     alpine tar czf /backup/uptime-kuma-$(date +\%Y\%m\%d).tar.gz /data
   ```

3. **리소스 제한**:
   ```yaml
   # compose.yml에 추가
   deploy:
     resources:
       limits:
         memory: 512M
       reservations:
         memory: 256M
   ```

## Troubleshooting

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f

# 권한 확인
docker compose exec uptime-kuma ls -la /app/data
```

### 모니터가 실패로 표시됨

**HTTP/HTTPS 모니터:**
- Target URL 확인
- 네트워크 연결 확인
- SSL 인증서 유효성 확인
- Firewall 설정 확인

**TCP 모니터:**
- 포트가 열려있는지 확인
- Firewall 설정 확인

**Ping 모니터:**
- ICMP가 허용되는지 확인 (일부 호스팅은 차단)

### 알림이 전송되지 않음

```bash
# Notification 테스트
Settings → Notifications → Test 버튼 클릭

# 로그 확인
docker compose logs -f uptime-kuma
```

**SMTP 이메일:**
- SMTP 서버 정보 확인
- 앱 비밀번호 사용 (Gmail 등)
- 방화벽에서 SMTP 포트 허용 확인

### 데이터베이스 복구

```bash
# SQLite 백업에서 복원
docker run --rm \
  -v uptime-kuma_uptime-kuma-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/uptime-kuma-20250127.tar.gz -C /
```

### "WebSocket connection failed"

리버스 프록시 설정 확인:

```nginx
# Nginx
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";

# Apache
RewriteEngine On
RewriteCond %{HTTP:Upgrade} websocket [NC]
RewriteRule /(.*) ws://localhost:3011/$1 [P,L]
```

## Maintenance

### 업그레이드

```bash
# 최신 이미지 다운로드
docker compose pull

# 컨테이너 재생성
docker compose up -d

# 로그 확인
docker compose logs -f uptime-kuma
```

### 백업

```bash
# 데이터 백업
docker run --rm \
  -v uptime-kuma_uptime-kuma-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/uptime-kuma-backup-$(date +%Y%m%d).tar.gz /data
```

### 복원

```bash
# 데이터 복원
docker compose down
docker run --rm \
  -v uptime-kuma_uptime-kuma-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/uptime-kuma-backup-20250127.tar.gz -C /
docker compose up -d
```

## Best Practices

### 모니터 설정

1. **적절한 Heartbeat Interval**:
   - 중요한 서비스: 30-60초
   - 일반 서비스: 5분
   - 덜 중요한 서비스: 10-15분

2. **Retry 설정**:
   - 네트워크 불안정: Retry 2-3회
   - 안정적 환경: Retry 1회

3. **그룹화**:
   - 프로젝트별로 모니터 그룹 생성
   - 태그를 사용한 분류

### 알림 전략

1. **중요도별 채널 분리**:
   - Critical: Slack + Email + SMS
   - Warning: Slack
   - Info: Email

2. **알림 빈도 제한**:
   - Resend Interval 설정으로 스팸 방지

3. **상태 페이지 활용**:
   - 고객용 공개 상태 페이지 제공
   - 예정된 유지보수 공지

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

- **Official Site**: https://uptime.kuma.pet/
- **GitHub**: https://github.com/louislam/uptime-kuma
- **Docker Hub**: https://hub.docker.com/r/louislam/uptime-kuma
- **Documentation**: https://github.com/louislam/uptime-kuma/wiki
- **Demo**: https://demo.uptime.kuma.pet/

## License

Uptime Kuma is licensed under MIT License.
See: https://github.com/louislam/uptime-kuma/blob/master/LICENSE

---

**Version**: 1.0.0
**Port**: 3011
**Category**: monitoring
**Phase**: 14
