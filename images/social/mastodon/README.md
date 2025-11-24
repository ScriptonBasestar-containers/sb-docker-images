# Mastodon

> 💡 **Quick Start**: For production deployment with PostgreSQL, Redis, and Elasticsearch, use the [standalone setup](standalone/README.md) - it includes all services and comprehensive documentation!

## 개요

Mastodon은 오픈소스 분산형 소셜 네트워크 서비스입니다:
- 🌐 분산형 소셜 네트워크 (ActivityPub 프로토콜)
- 📝 타임라인 기반 마이크로블로깅
- 🖼️ 미디어 첨부 및 공유 (이미지, 동영상, 오디오)
- 👥 팔로우/팔로워 시스템
- 🔒 프라이버시 제어 (공개, 비공개, 팔로워 전용, DM)
- 🛡️ 관리자 도구 및 모더레이션
- 🔍 전문 검색 (Elasticsearch 지원)
- 📱 모바일 앱 지원 (iOS, Android)
- 🔔 실시간 알림 및 푸시
- 🌍 연합(Federation) - 다른 인스턴스와 연결

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Mastodon Web, Streaming, Sidekiq
- ✅ PostgreSQL database
- ✅ Redis cache
- ✅ Elasticsearch (optional)
- ✅ Network isolation

**Access:** http://localhost:3000

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default ports:**
- 3000 (Web, 권장: 8500)
- 4000 (Streaming, 권장: 8501)

**Container name:** mastodon

Environment variables:
```bash
LOCAL_DOMAIN=mastodon.local
DB_HOST=db
REDIS_HOST=redis
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 3000 | Web | 메인 웹 인터페이스 (현재 설정) |
| 4000 | Streaming | WebSocket 스트리밍 (현재 설정) |
| 5432 | PostgreSQL | 데이터베이스 (내부) |
| 6379 | Redis | 캐시 서버 (내부) |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

> ⚠️ **포트 충돌 주의**: 현재 3000, 4000 포트를 사용하고 있습니다.
>
> **권장 포트**: 8500 (Web), 8501 (Streaming) ([포트 가이드](../PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # compose.yaml 파일에서 수정
> # web 서비스:
> #   ports:
> #     - "8500:3000"
> # streaming 서비스:
> #   ports:
> #     - "8501:4000"
> ```

## 빠른 시작

### 필수 요구사항

- Docker 및 Docker Compose
- Git
- 8GB 이상의 RAM 권장

### 설치 및 실행

```bash
# 개발 환경 시작
docker compose -f .devcontainer/compose.yaml up -d

# 초기 설정 (데이터베이스, 시드 데이터 등)
docker compose -f .devcontainer/compose.yaml exec app bin/setup

# 개발 서버 실행
docker compose -f .devcontainer/compose.yaml exec app bin/dev
```

### 접속

개발 서버가 실행되면 다음 주소로 접속할 수 있습니다:

- 웹 인터페이스: `http://localhost:3000`
- 관리자 패널: `http://localhost:3000/admin`

## 서비스 구성

Mastodon은 여러 컴포넌트로 구성되어 있습니다:

### 핵심 서비스

- **Web (Puma)**: Rails 애플리케이션 서버
- **Streaming**: WebSocket 스트리밍 서버 (Node.js)
- **Sidekiq**: 백그라운드 작업 처리

### 데이터 저장소

- **PostgreSQL**: 메인 데이터베이스
- **Redis**: 캐시 및 세션 저장소
- **Elasticsearch** (선택): 전문 검색 기능


## 환경 변수

주요 환경 변수 설정 예시 (`.env.production` 파일):

```bash
# 기본 설정
LOCAL_DOMAIN=mastodon.local
SINGLE_USER_MODE=false

# PostgreSQL
DB_HOST=db
DB_USER=mastodon
DB_NAME=mastodon_production
DB_PASS=your_password
DB_PORT=5432

# Redis
REDIS_HOST=redis
REDIS_PORT=6379

# 파일 저장소
S3_ENABLED=false
# S3_BUCKET=files
# AWS_ACCESS_KEY_ID=
# AWS_SECRET_ACCESS_KEY=

# 메일 설정
SMTP_SERVER=smtp.mailgun.org
SMTP_PORT=587
SMTP_LOGIN=
SMTP_PASSWORD=
SMTP_FROM_ADDRESS=notifications@mastodon.local

# 시크릿 키 (자동 생성)
SECRET_KEY_BASE=
OTP_SECRET=
VAPID_PRIVATE_KEY=
VAPID_PUBLIC_KEY=
```

## 사용법

### 관리자 계정 생성

```bash
# 컨테이너 내부에서 실행
docker compose -f .devcontainer/compose.yaml exec app bash

# 관리자 계정 생성
RAILS_ENV=development bin/tootctl accounts create \
  admin \
  --email admin@example.com \
  --confirmed \
  --role Owner
```

### 데이터베이스 마이그레이션

```bash
docker compose -f .devcontainer/compose.yaml exec app rails db:migrate
```

### 에셋 프리컴파일

```bash
docker compose -f .devcontainer/compose.yaml exec app rails assets:precompile
```

### 캐시 정리

```bash
docker compose -f .devcontainer/compose.yaml exec app rails cache:clear
```

## 개발

### 디버깅

개발 환경에서는 다음 도구들을 사용할 수 있습니다:

- **byebug**: Ruby 디버거
- **Rails console**: `rails console`
- **로그 확인**: `docker compose logs -f app`

### 테스트 실행

```bash
# RSpec 테스트 실행
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec

# 특정 테스트 파일 실행
docker compose -f .devcontainer/compose.yaml exec app bundle exec rspec spec/models/
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 서비스 상태 확인
docker compose -f .devcontainer/compose.yaml ps db

# 데이터베이스 재시작
docker compose -f .devcontainer/compose.yaml restart db
```

### 에셋이 로드되지 않는 경우

```bash
# 에셋 재컴파일
docker compose -f .devcontainer/compose.yaml exec app rails assets:clobber
docker compose -f .devcontainer/compose.yaml exec app rails assets:precompile
```

### 메모리 부족 오류

Mastodon은 메모리를 많이 사용합니다. Docker Desktop의 메모리 할당을 8GB 이상으로 늘려주세요.

### 포트 충돌

다른 서비스가 3000번 포트를 사용하고 있다면:

```bash
# compose.yaml 파일에서 포트 변경
# ports:
#   - "8500:3000"  # 외부:내부
```

## 유용한 명령어

```bash
# 모든 서비스 중지
docker compose -f .devcontainer/compose.yaml down

# 볼륨 포함 모든 데이터 삭제
docker compose -f .devcontainer/compose.yaml down -v

# 로그 확인
docker compose -f .devcontainer/compose.yaml logs -f

# 특정 서비스 재시작
docker compose -f .devcontainer/compose.yaml restart app

# 쉘 접속
docker compose -f .devcontainer/compose.yaml exec app bash
```

## 참고 자료

- [Mastodon 공식 홈페이지](https://joinmastodon.org/)
- [Mastodon GitHub 저장소](https://github.com/mastodon/mastodon)
- [Mastodon 공식 문서](https://docs.joinmastodon.org/)
- [ActivityPub 프로토콜](https://www.w3.org/TR/activitypub/)
- [Mastodon API 문서](https://docs.joinmastodon.org/api/)
- [운영 가이드](https://docs.joinmastodon.org/admin/prerequisites/)
