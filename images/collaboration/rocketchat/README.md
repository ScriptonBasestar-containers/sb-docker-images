# Rocket.Chat - Open Source Team Chat

오픈소스 팀 커뮤니케이션 플랫폼 (Slack/Teams 대안)

## Features

- 실시간 메시징 및 파일 공유
- 비디오/오디오 통화 (Jitsi 통합)
- 스레드 대화 및 리액션
- 모바일 앱 (iOS, Android)
- 풍부한 통합 (GitHub, GitLab, Jira, Trello 등)
- LiveChat 기능 (고객 지원)
- 엔드-투-엔드 암호화 (E2EE)
- Self-hosted (데이터 완전 통제)
- 무제한 사용자 및 채널

## Quick Start

```bash
# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작 (MongoDB replica set 자동 초기화)
docker compose up -d

# 로그 확인
docker compose logs -f rocketchat

# 웹 UI 접속
open http://localhost:8340
```

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
ROCKETCHAT_VERSION=latest
WEB_PORT=8340
ROOT_URL=http://localhost:8340  # IMPORTANT: 프로덕션에서 변경 필수

# Database
MONGO_VERSION=6  # MongoDB with replica set support
```

### 초기 설정

첫 접속 시 Setup Wizard 진행:

1. http://localhost:8340 접속
2. Setup Wizard 화면:
   - **Admin Info**: 관리자 계정 정보 입력
   - **Organization Info**: 조직 정보 입력
   - **Server Info**: 서버 설정 (기본값 사용 가능)
   - **Register Server**: 선택사항 (클라우드 기능 사용 시)
3. 설정 완료 후 Rocket.Chat 사용 시작

## Ports

- `8340`: Rocket.Chat Web UI (기본값, WEB_PORT로 변경 가능)
- `27017`: MongoDB (내부 네트워크, 외부 노출 안 됨)

## Volumes

- `rocketchat-uploads`: 사용자 업로드 파일
- `mongodb-data`: MongoDB 데이터베이스
- `mongodb-config`: MongoDB 설정

## MongoDB Replica Set

Rocket.Chat은 MongoDB replica set를 필수로 요구합니다. 이 구성은 자동으로 처리됩니다:

### 자동 초기화

compose.yml에 포함된 `mongo-init-replica` 서비스가 자동으로 replica set을 초기화합니다:

```bash
# 첫 실행 시
docker compose up -d
# MongoDB와 replica set이 자동으로 구성됩니다
```

### 수동 초기화 (필요 시)

Replica set 초기화에 문제가 있는 경우:

```bash
# Makefile 사용
make init-replica

# 또는 직접 실행
docker compose up -d mongodb
sleep 10
docker compose run --rm mongo-init-replica
```

### Replica Set 상태 확인

```bash
# MongoDB 컨테이너 접속
docker compose exec mongodb mongosh

# Replica set 상태 확인
rs.status()

# 정상 출력 예시:
# {
#   "set" : "rs0",
#   "members" : [ { "name" : "mongodb:27017", "health" : 1, "state" : 1 } ]
# }
```

## Deployment Options

### Development (현재 구성)
- Single MongoDB instance with replica set
- HTTP 프로토콜
- 빠른 시작

### Production

프로덕션 배포 시 고려사항:

1. **HTTPS 설정** (Nginx/Traefik 리버스 프록시):
   ```bash
   ROOT_URL=https://chat.example.com
   ```

   Nginx 설정 예시:
   ```nginx
   server {
       listen 443 ssl http2;
       server_name chat.example.com;

       location / {
           proxy_pass http://localhost:8340;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

2. **MongoDB 3-node Replica Set** (고가용성):
   - 운영 환경에서는 3개 MongoDB 노드 권장
   - 자동 장애 조치 (Automatic Failover)
   - 데이터 이중화

3. **백업 설정**:
   ```bash
   # MongoDB 백업
   docker compose exec mongodb mongodump --out=/dump
   docker cp rocketchat-mongodb:/dump ./backup-$(date +%Y%m%d)

   # 파일 업로드 백업
   docker run --rm \
     -v rocketchat_rocketchat-uploads:/data \
     -v $(pwd):/backup \
     alpine tar czf /backup/uploads-$(date +%Y%m%d).tar.gz /data
   ```

4. **리소스 제한**:
   ```yaml
   # compose.yml에 추가
   rocketchat:
     deploy:
       resources:
         limits:
           memory: 2G
         reservations:
           memory: 1G
   ```

## Advanced Configuration

### SMTP (이메일 발송)

.env 파일에 추가:

```bash
MAIL_URL=smtp://smtp.gmail.com:587
OVERWRITE_SETTING_SMTP_Host=smtp.gmail.com
OVERWRITE_SETTING_SMTP_Port=587
OVERWRITE_SETTING_SMTP_Username=your-email@gmail.com
OVERWRITE_SETTING_SMTP_Password=your-app-password
OVERWRITE_SETTING_From_Email=noreply@example.com
```

### OAuth/SSO

Admin → Settings → OAuth 에서 설정:

- **Google**: OAuth 2.0
- **GitHub**: OAuth App
- **GitLab**: OAuth Application
- **LDAP/AD**: LDAP 연동
- **SAML**: Enterprise SSO

### Jitsi Video Conference

.env 파일에 추가:

```bash
OVERWRITE_SETTING_Jitsi_Enabled=true
OVERWRITE_SETTING_Jitsi_Domain=meet.jit.si
OVERWRITE_SETTING_Jitsi_URL_Room_Prefix=RocketChat
```

또는 self-hosted Jitsi 사용:

```bash
OVERWRITE_SETTING_Jitsi_Domain=jitsi.example.com
```

### LiveChat (고객 지원)

Admin → Omnichannel에서 활성화:

1. Omnichannel 기능 활성화
2. LiveChat 설정
3. 웹사이트에 스크립트 삽입
4. 에이전트 할당 및 부서 설정

### Apps & Integrations

Rocket.Chat Marketplace에서 앱 설치:

1. Admin → Apps → Marketplace
2. 앱 검색 및 설치 (무료/유료)

인기 앱:
- GitHub
- GitLab
- Jira
- Trello
- Google Drive
- Poll
- Data Loss Prevention

### Webhooks

Incoming Webhooks:

1. Admin → Integrations → New Integration
2. "Incoming WebHook" 선택
3. 채널, 사용자명, 아이콘 설정
4. Webhook URL 생성

Outgoing Webhooks:

1. Admin → Integrations → New Integration
2. "Outgoing WebHook" 선택
3. 트리거 단어, URL 설정

## Troubleshooting

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f

# MongoDB replica set 상태 확인
docker compose exec mongodb mongosh --eval "rs.status()"
```

### "Replica set not initialized" 에러

수동으로 replica set 초기화:

```bash
make init-replica

# 또는
docker compose run --rm mongo-init-replica
```

### "Cannot connect to MongoDB" 에러

```bash
# MongoDB 컨테이너 상태 확인
docker compose ps mongodb

# MongoDB 로그 확인
docker compose logs mongodb

# Health check 확인
docker compose exec mongodb mongosh --eval "db.adminCommand('ping')"
```

### 파일 업로드 실패

파일 크기 제한 확인:

```bash
# .env에 추가
OVERWRITE_SETTING_FileUpload_MaxFileSize=104857600  # 100MB
```

Rocket.Chat 재시작:

```bash
docker compose restart rocketchat
```

### 이메일 발송 실패

SMTP 설정 확인:

1. Admin → Settings → Email → SMTP
2. "Test SMTP Settings" 클릭
3. 로그에서 에러 메시지 확인

```bash
docker compose logs -f rocketchat | grep -i smtp
```

### 성능 저하

MongoDB 인덱스 확인 및 최적화:

```bash
# MongoDB 컨테이너 접속
docker compose exec mongodb mongosh rocketchat

# 인덱스 확인
db.rocketchat_message.getIndexes()

# 느린 쿼리 확인
db.setProfilingLevel(1, { slowms: 100 })
db.system.profile.find().limit(10).sort({ ts: -1 }).pretty()
```

## Maintenance

### 업그레이드

```bash
# 최신 이미지 다운로드
docker compose pull

# 컨테이너 재생성
docker compose up -d

# 로그 확인
docker compose logs -f rocketchat
```

**중요**: 메이저 버전 업그레이드 전 백업 필수!

### 백업

```bash
# MongoDB 백업
docker compose exec mongodb mongodump \
  --archive=/dump/backup-$(date +%Y%m%d).archive \
  --gzip

docker cp rocketchat-mongodb:/dump/backup-$(date +%Y%m%d).archive .

# 업로드 파일 백업
docker run --rm \
  -v rocketchat_rocketchat-uploads:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/uploads-backup-$(date +%Y%m%d).tar.gz /data
```

### 복원

```bash
# MongoDB 복원
docker cp backup-20250127.archive rocketchat-mongodb:/dump/
docker compose exec mongodb mongorestore \
  --archive=/dump/backup-20250127.archive \
  --gzip \
  --drop

# 업로드 파일 복원
docker run --rm \
  -v rocketchat_rocketchat-uploads:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/uploads-backup-20250127.tar.gz -C /
```

### 로그 관리

로그 로테이션 설정 (compose.yml에 추가):

```yaml
rocketchat:
  logging:
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
```

## Performance Optimization

### MongoDB 최적화

```bash
# Oplog 크기 조정 (compose.yml)
command: mongod --oplogSize 256 --replSet rs0

# Connection pool 설정 (compose.yml, rocketchat)
environment:
  MONGO_OPTIONS: '{"poolSize": 10}'
```

### Rocket.Chat 설정

Admin → Settings → General:

- **CDN**: 정적 파일 CDN 사용
- **Cache**: 캐시 활성화
- **File Upload**: 파일 업로드 S3/MinIO로 오프로드

## Security Best Practices

1. **HTTPS 필수**: 프로덕션 환경에서는 반드시 HTTPS 사용
2. **방화벽 설정**: MongoDB 포트(27017) 외부 노출 금지
3. **정기 업데이트**: 보안 패치 적용
4. **백업**: 정기 백업 및 복원 테스트
5. **E2EE**: 중요 채널은 End-to-End 암호화 활성화
6. **Two-Factor Authentication**: 관리자 계정에 2FA 활성화

## Makefile Commands

```bash
make help         # 사용 가능한 명령어 목록
make up           # 서비스 시작
make down         # 서비스 중지
make logs         # 로그 확인
make restart      # 서비스 재시작
make ps           # 컨테이너 상태 확인
make clean        # 모든 리소스 제거 (주의!)
make init-replica # MongoDB replica set 수동 초기화
```

## References

- **Official Site**: https://rocket.chat/
- **Documentation**: https://docs.rocket.chat/
- **Docker Hub**: https://hub.docker.com/r/rocketchat/rocket.chat
- **GitHub**: https://github.com/RocketChat/Rocket.Chat
- **Community**: https://open.rocket.chat/
- **Marketplace**: https://rocket.chat/marketplace

## License

Rocket.Chat is licensed under MIT License.
See: https://github.com/RocketChat/Rocket.Chat/blob/develop/LICENSE

---

**Version**: 1.0.0
**Port**: 8340
**Category**: collaboration
**Phase**: 14
