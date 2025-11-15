# Discourse - Modern Forum Platform

**Discourse**는 현대적인 오픈소스 토론 플랫폼입니다. 전통적인 포럼을 대체하는 차세대 커뮤니티 소프트웨어입니다.

## 주요 기능

- **현대적 UI**: 반응형 디자인, 실시간 업데이트
- **강력한 검색**: 전문 검색 엔진 (ElasticSearch 선택)
- **알림 시스템**: 이메일, 웹 푸시, 모바일 푸시
- **멀티미디어**: 이미지/비디오 임베딩, Emoji, GIF
- **권한 관리**: 세밀한 사용자/그룹 권한
- **모바일 앱**: iOS/Android 네이티브 앱
- **플러그인**: 풍부한 플러그인 생태계
- **국제화**: 30+ 언어 지원

## Quick Start

### 1. 서비스 시작

```bash
docker compose up -d
```

### 2. 웹 UI 접속

브라우저에서 http://localhost:8080 접속

> **참고**: 초기 설정 마법사가 자동으로 시작됩니다.

### 3. 관리자 계정 생성

초기 설정 시 관리자 계정을 생성합니다.

## 시스템 요구사항

| 항목 | 최소 | 권장 |
|------|------|------|
| **메모리** | 1GB | 2GB+ |
| **CPU** | 1코어 | 2코어+ |
| **스토리지** | 10GB | 50GB+ |
| **Database** | PostgreSQL 12+ | PostgreSQL 16 |

## 아키텍처

Discourse는 Ruby on Rails 기반이며 다음 구성요소로 이루어집니다:

```
┌─────────────────────────────────────────┐
│         Discourse Rails App              │
│  (Web Server + API + Background Jobs)   │
└────────────┬──────────────┬─────────────┘
             │              │
    ┌────────▼─────┐  ┌────▼──────────┐
    │  PostgreSQL  │  │     Redis     │
    │  (Database)  │  │  (Cache/Jobs) │
    └──────────────┘  └───────────────┘
```

## 환경 설정

### 주요 환경 변수

```yaml
services:
  discourse:
    environment:
      # 호스트명 (필수)
      DISCOURSE_HOSTNAME: 'forum.example.com'

      # 관리자 이메일
      DISCOURSE_DEVELOPER_EMAILS: 'admin@example.com'

      # PostgreSQL
      DISCOURSE_DB_HOST: postgres
      DISCOURSE_DB_NAME: discourse
      DISCOURSE_DB_USERNAME: discourse
      DISCOURSE_DB_PASSWORD: your-password

      # Redis
      DISCOURSE_REDIS_HOST: redis
      DISCOURSE_REDIS_PASSWORD: redis-password
      DISCOURSE_REDIS_PORT: 6379

      # 환경 (production/development)
      RAILS_ENV: production
```

## 플러그인 설치

### 공식 플러그인

Discourse는 다양한 공식 플러그인을 제공합니다:

- **discourse-solved**: 해결된 질문 표시
- **discourse-voting**: 투표 기능
- **discourse-calendar**: 이벤트 캘린더
- **discourse-chat**: 실시간 채팅
- **discourse-assign**: 주제 할당
- **discourse-checklist**: 체크리스트

### 플러그인 설치 방법

#### 1. Git으로 플러그인 추가

```bash
# 컨테이너 접속
docker exec -it discourse_dev bash

# plugins 디렉토리로 이동
cd /var/www/discourse/plugins

# 플러그인 클론
git clone https://github.com/discourse/discourse-solved.git

# 번들 설치
cd /var/www/discourse
bundle install

# 마이그레이션
RAILS_ENV=production rake db:migrate

# 에셋 빌드
RAILS_ENV=production rake assets:precompile

# 재시작
exit
docker compose restart discourse
```

#### 2. Dockerfile로 플러그인 포함

```dockerfile
FROM discourse/app:latest

# 플러그인 설치
RUN cd /var/www/discourse/plugins && \
    git clone https://github.com/discourse/discourse-solved.git && \
    git clone https://github.com/discourse/discourse-voting.git

# 의존성 설치
RUN cd /var/www/discourse && \
    bundle install && \
    RAILS_ENV=production rake db:migrate && \
    RAILS_ENV=production rake assets:precompile
```

## 이메일 설정

Discourse는 이메일 알림이 필수입니다.

### SMTP 설정

```yaml
services:
  discourse:
    environment:
      DISCOURSE_SMTP_ADDRESS: smtp.gmail.com
      DISCOURSE_SMTP_PORT: 587
      DISCOURSE_SMTP_USER_NAME: your-email@gmail.com
      DISCOURSE_SMTP_PASSWORD: your-app-password
      DISCOURSE_SMTP_ENABLE_START_TLS: 'true'
      DISCOURSE_SMTP_DOMAIN: gmail.com
      DISCOURSE_SMTP_AUTHENTICATION: login
```

### 이메일 테스트

```bash
docker exec -it discourse_dev bash
cd /var/www/discourse
RAILS_ENV=production rails c

# Rails 콘솔에서
Email::Sender.new('test subject', 'test body').send(to: 'admin@example.com')
```

## 백업 및 복원

### 자동 백업 설정

Admin → Backups → Settings:
- Enable automatic backups: ✅
- Backup frequency: Every day
- Maximum backups: 7

### 수동 백업

```bash
# Rails 콘솔 접속
docker exec -it discourse_dev bash
cd /var/www/discourse
RAILS_ENV=production rails c

# 백업 생성
Backup.create!(user_id: 1)

# 백업 파일 위치
# /var/www/discourse/public/backups/default/
```

### PostgreSQL 백업

```bash
docker exec postgres pg_dump -U discourse discourse | gzip > discourse-backup-$(date +%Y%m%d).sql.gz
```

### 복원

```bash
# 백업 파일을 컨테이너로 복사
docker cp discourse-backup.sql.gz discourse_dev:/tmp/

# 데이터베이스 복원
docker exec -i postgres psql -U discourse discourse < /tmp/discourse-backup.sql
```

## 성능 최적화

### Redis 캐싱

이미 기본으로 설정됨. Redis가 다음 용도로 사용됩니다:
- 세션 스토리지
- 캐시
- 백그라운드 작업 큐 (Sidekiq)

### PostgreSQL 최적화

```sql
-- PostgreSQL 설정 최적화
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;

-- 설정 재로드
SELECT pg_reload_conf();
```

### Precompile Assets

```bash
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake assets:precompile"
```

## 업그레이드

### 1. 백업 (필수)

위 백업 섹션 참조

### 2. 이미지 업데이트

```bash
docker compose pull discourse
docker compose up -d discourse
```

### 3. 마이그레이션 실행

```bash
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake db:migrate"
```

### 4. 에셋 재컴파일

```bash
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake assets:precompile"
```

### 5. 재시작

```bash
docker compose restart discourse
```

## 보안 설정

### HTTPS 설정 (Nginx 리버스 프록시)

```nginx
server {
    listen 443 ssl http2;
    server_name forum.example.com;

    ssl_certificate /etc/ssl/certs/forum.example.com.crt;
    ssl_certificate_key /etc/ssl/private/forum.example.com.key;

    client_max_body_size 20M;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket 지원
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### Rate Limiting

Admin → Settings → Security:
- Max requests per minute: 20
- Max topics per day: 20
- Max private messages per day: 20

### 2FA 강제

Admin → Settings → Security:
- Enforce second factor authentication: ✅

## 문제 해결

### 데이터베이스 연결 실패

```bash
# PostgreSQL 상태 확인
docker exec postgres pg_isready -U discourse

# 로그 확인
docker logs discourse_dev

# 데이터베이스 재시작
docker compose restart postgres
```

### Redis 연결 실패

```bash
# Redis 상태 확인
docker exec redis redis-cli ping

# Redis 재시작
docker compose restart redis
```

### 에셋 로드 실패

```bash
# 에셋 재컴파일
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake assets:precompile"

# 캐시 정리
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake tmp:cache:clear"
```

### 마이그레이션 오류

```bash
# 마이그레이션 상태 확인
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake db:migrate:status"

# 마이그레이션 재실행
docker exec discourse_dev bash -c "cd /var/www/discourse && RAILS_ENV=production rake db:migrate"
```

## 관리자 도구

### Rails 콘솔

```bash
docker exec -it discourse_dev bash
cd /var/www/discourse
RAILS_ENV=production rails c

# 사용자 관리
User.find_by_email('user@example.com').admin = true
User.find_by_email('user@example.com').save

# 통계
User.count
Topic.count
Post.count
```

### Rake 태스크

```bash
# 이메일 재전송
rake emails:test

# 사용자 통계 재계산
rake users:recalculate_trust_level

# 검색 인덱스 재구축
rake search:reindex

# 아바tar 재생성
rake avatars:refresh
```

## 커뮤니티 가이드

### 카테고리 구성

카테고리는 주제를 조직하는 핵심입니다:

1. Admin → Categories → New Category
2. 이름, 색상, 아이콘 설정
3. 권한 설정 (공개/비공개)
4. 하위 카테고리 생성 가능

### 사용자 그룹

1. Admin → Groups → New Group
2. 그룹 이름, 권한 설정
3. 사용자 추가
4. 카테고리별 그룹 권한 설정

### 신뢰 레벨

Discourse는 5단계 신뢰 레벨 시스템:

- **TL0 (New)**: 신규 사용자
- **TL1 (Basic)**: 읽기/좋아요 일정 수준 도달
- **TL2 (Member)**: 정기적으로 방문, 좋아요 받음
- **TL3 (Regular)**: 활발한 참여, 높은 신뢰도
- **TL4 (Leader)**: 최고 레벨 (수동 승급)

## 참고 자료

### 공식 문서
- [Discourse 공식 사이트](https://www.discourse.org/)
- [Discourse Meta](https://meta.discourse.org/) - 공식 커뮤니티
- [Developer Documentation](https://docs.discourse.org/)
- [Admin Guide](https://meta.discourse.org/docs?category=6)

### Docker 관련
- [Official Docker Repository](https://github.com/discourse/discourse_docker)
- [Docker Hub](https://hub.docker.com/r/discourse/discourse_test)

### 플러그인
- [Official Plugins](https://github.com/discourse?q=discourse-plugin)
- [Plugin Directory](https://meta.discourse.org/c/plugin)

### 커뮤니티
- [Discourse Meta](https://meta.discourse.org/)
- [GitHub Issues](https://github.com/discourse/discourse/issues)

## 주의사항

### 공식 권장 방법

Discourse 공식 문서는 `discourse_docker`를 권장합니다:
- https://github.com/discourse/discourse_docker

이 저장소의 구성은 개발/테스트 목적입니다.

### 프로덕션 배포

프로덕션 배포 시:
1. **공식 discourse_docker** 사용 권장
2. 또는 플러그인이 필요한 경우:
   - 오피셜 이미지 사용
   - 볼륨에 플러그인 마운트
   - 인스턴스 시작 시 마이그레이션 실행

## 라이선스

Discourse는 GPLv2 라이선스로 배포됩니다.

## 관련 프로젝트

- **Flarum**: PHP 기반 경량 포럼
- **NodeBB**: Node.js 기반 포럼
- **Misago**: Django 기반 포럼
- **phpBB**: 전통적인 PHP 포럼

## Source

- https://github.com/discourse/discourse.git
- https://github.com/discourse/discourse_docker.git
