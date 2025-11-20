# Mastodon Standalone Configuration

완전한 독립 실행형 Mastodon 소셜 네트워크 인스턴스

## 개요

이 standalone 구성은 Mastodon을 모든 필수 서비스와 함께 즉시 실행할 수 있는 완전한 패키지입니다.

### 포함된 서비스

- **Web (Puma)**: Rails 애플리케이션 서버 (포트 8500)
- **Streaming**: WebSocket 실시간 업데이트 서버 (포트 8501)
- **Sidekiq**: 백그라운드 작업 처리
- **PostgreSQL**: 메인 데이터베이스
- **Redis**: 캐시 및 세션 저장소

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env.example을 .env로 복사
cp .env.example .env

# 필수 시크릿 키 생성
docker run --rm tootsuite/mastodon:v4.2 bundle exec rake secret
# 출력된 값을 .env의 SECRET_KEY_BASE에 복사

docker run --rm tootsuite/mastodon:v4.2 bundle exec rake secret
# 출력된 값을 .env의 OTP_SECRET에 복사

# VAPID 키 생성
docker run --rm tootsuite/mastodon:v4.2 bundle exec rake mastodon:webpush:generate_vapid_key
# 출력된 VAPID_PRIVATE_KEY와 VAPID_PUBLIC_KEY를 .env에 복사
```

### 2. .env 파일 수정

```bash
# 필수 설정
LOCAL_DOMAIN=mastodon.example.com  # 실제 도메인으로 변경
DB_PASS=strong_password_here       # 강력한 비밀번호 설정
```

### 3. 서비스 시작

```bash
# 모든 서비스 시작
docker compose up -d

# 데이터베이스 초기화
docker compose exec web rails db:migrate
docker compose exec web rails db:seed

# 관리자 계정 생성
docker compose exec web bin/tootctl accounts create \
  admin \
  --email admin@example.com \
  --confirmed \
  --role Owner

# 비밀번호가 출력됩니다 - 반드시 저장하세요!
```

### 4. 접속

- **웹 인터페이스**: http://localhost:8500
- **관리자 패널**: http://localhost:8500/admin

## 포트 정보

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 8500 | Web | 메인 웹 인터페이스 |
| 8501 | Streaming | WebSocket 스트리밍 |

포트는 `.env` 파일에서 변경할 수 있습니다:
```bash
MASTODON_WEB_PORT=8500
MASTODON_STREAMING_PORT=8501
```

## 주요 명령어

### 사용자 관리

```bash
# 사용자 목록 확인
docker compose exec web bin/tootctl accounts list

# 사용자 승인
docker compose exec web bin/tootctl accounts approve USERNAME

# 관리자 권한 부여
docker compose exec web bin/tootctl accounts modify USERNAME --role Admin

# 비밀번호 재설정
docker compose exec web bin/tootctl accounts modify USERNAME --reset-password
```

### 데이터베이스 관리

```bash
# 마이그레이션 실행
docker compose exec web rails db:migrate

# 백업
docker compose exec postgres pg_dump -U mastodon mastodon_production > backup.sql

# 복원
cat backup.sql | docker compose exec -T postgres psql -U mastodon mastodon_production
```

### 미디어 관리

```bash
# 미디어 캐시 정리 (7일 이상 된 항목)
docker compose exec web bin/tootctl media remove --days=7

# 프리뷰 카드 정리
docker compose exec web bin/tootctl preview_cards remove --days=30

# 원격 미디어 정리
docker compose exec web bin/tootctl media remove-orphans
```

### 서비스 관리

```bash
# 로그 확인
docker compose logs -f

# 특정 서비스 재시작
docker compose restart web
docker compose restart streaming
docker compose restart sidekiq

# 모든 서비스 중지
docker compose down

# 볼륨 포함 완전 삭제
docker compose down -v
```

## 프로덕션 배포

### 1. 도메인 및 SSL 설정

```bash
# LOCAL_DOMAIN을 실제 도메인으로 설정
LOCAL_DOMAIN=mastodon.example.com

# Nginx나 Traefik 같은 리버스 프록시 사용
# Let's Encrypt로 SSL 인증서 설정
```

### 2. 이메일 설정

```bash
# SMTP 설정 (예: Mailgun)
SMTP_SERVER=smtp.mailgun.org
SMTP_PORT=587
SMTP_LOGIN=postmaster@mg.example.com
SMTP_PASSWORD=your_smtp_password
SMTP_FROM_ADDRESS=notifications@mastodon.example.com
```

### 3. 미디어 스토리지

```bash
# S3 사용 권장 (큰 파일 처리)
S3_ENABLED=true
S3_BUCKET=mastodon-files
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
S3_REGION=us-east-1
```

### 4. 성능 최적화

```bash
# Sidekiq 워커 수 조정
# docker-compose.yml에서 sidekiq 명령 수정:
# command: bundle exec sidekiq -c 25 -q default -q push -q mailers -q pull

# Streaming 서버 스케일링
docker compose up -d --scale streaming=3
```

## 유지보수

### 정기 작업

```bash
# 주간: 미디어 캐시 정리
docker compose exec web bin/tootctl media remove --days=7

# 월간: 데이터베이스 백업
docker compose exec postgres pg_dump -U mastodon mastodon_production > backup-$(date +%Y%m%d).sql

# 월간: 프리뷰 카드 정리
docker compose exec web bin/tootctl preview_cards remove --days=30
```

### 업데이트

```bash
# 이미지 업데이트
docker compose pull

# 서비스 재시작
docker compose down
docker compose up -d

# 데이터베이스 마이그레이션
docker compose exec web rails db:migrate

# 에셋 프리컴파일 (필요시)
docker compose exec web rails assets:precompile
```

## 문제 해결

### 메모리 부족

Mastodon은 메모리를 많이 사용합니다 (최소 4GB 권장, 8GB 이상 권장).

```bash
# Docker Desktop 메모리 설정 증가
# Settings > Resources > Memory: 8GB 이상
```

### 데이터베이스 연결 오류

```bash
# PostgreSQL 상태 확인
docker compose ps postgres

# 데이터베이스 재시작
docker compose restart postgres

# 연결 테스트
docker compose exec postgres psql -U mastodon -d mastodon_production
```

### Sidekiq 작업 막힘

```bash
# Sidekiq 상태 확인
docker compose logs sidekiq

# Sidekiq 재시작
docker compose restart sidekiq

# Redis 캐시 클리어 (주의!)
docker compose exec redis redis-cli FLUSHALL
```

### 에셋이 로드되지 않음

```bash
# 에셋 재컴파일
docker compose exec web rails assets:clobber
docker compose exec web rails assets:precompile

# Nginx 캐시 클리어 (리버스 프록시 사용시)
```

## 보안 권장사항

1. ✅ 강력한 비밀번호 사용
2. ✅ HTTPS 필수 (Let's Encrypt)
3. ✅ 정기적인 백업
4. ✅ 소프트웨어 업데이트
5. ✅ 방화벽 설정
6. ✅ 레이트 리미팅 설정
7. ✅ 모니터링 및 로깅

## 참고 자료

- [Mastodon 공식 문서](https://docs.joinmastodon.org/)
- [설치 가이드](https://docs.joinmastodon.org/admin/install/)
- [설정 가이드](https://docs.joinmastodon.org/admin/config/)
- [tootctl 명령어](https://docs.joinmastodon.org/admin/tootctl/)
- [문제 해결](https://docs.joinmastodon.org/admin/troubleshooting/)

## 라이선스

Mastodon은 AGPLv3 라이선스를 따릅니다.
