# RSSHub

> 💡 **Quick Start**: This project does not have a standalone setup. Use the basic setup below for development and testing.

## 개요

RSSHub는 오픈소스 RSS 피드 생성기입니다. RSS를 지원하지 않는 다양한 웹사이트와 서비스에서 데이터를 수집하여 RSS 피드로 제공합니다:
- 🌐 300개 이상의 웹사이트 지원
- ⚡ 실시간 콘텐츠 업데이트
- 🎨 커스터마이징 가능한 라우트
- 💾 Redis 캐싱으로 성능 최적화
- 🔌 RESTful API 제공
- 🤖 Puppeteer를 통한 동적 콘텐츠 크롤링
- 📱 모바일 친화적 피드
- 🔐 접근 제어 및 인증
- 📊 모니터링 및 로깅
- 🐳 Docker 지원

## Deployment Options

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default port:** 1200 (권장: 8700, see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** rsshub

Environment variables:
```bash
PORT=1200
NODE_ENV=production
CACHE_TYPE=redis
REDIS_URL=redis://localhost:6379/
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 1200 | rsshub | RSSHub 웹 서버 (기본 포트) |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

> ⚠️ **포트 설정 주의**: 현재 1200 포트를 기본값으로 사용합니다.
>
> **권장 포트**: 8700 (프로덕션 환경, [포트 가이드](../PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # .env 파일에서 설정
> echo "PORT=8700" >> .env
>
> # 또는 docker-compose.yml에서 환경 변수 설정
> # environment:
> #   - PORT=8700
> ```

## 주요 기능

### 지원 서비스 예시

- 소셜 미디어: Twitter, Instagram, Facebook, TikTok
- 동영상 플랫폼: YouTube, Bilibili, Twitch
- 뉴스: Hacker News, Reddit, Medium
- 개발: GitHub, GitLab, Stack Overflow
- 쇼핑: Amazon, 타오바오, 알리바바
- 그 외 다수

## 빠른 시작

### 필수 요구사항

- Docker 및 Docker Compose
- Git
- 2GB 이상의 RAM

### 설치

```bash
# RSSHub 저장소 클론
make prepare

# 또는 직접 클론
git clone --depth 1 https://github.com/DIYgod/RSSHub.git
cd RSSHub
corepack enable pnpm
```

### 개발 환경 실행

```bash
# 의존성 설치 및 개발 서버 실행
make setup

# 또는 직접 실행
cd RSSHub
pnpm i
pnpm dev
```

### Docker로 실행

```bash
# 이미지 빌드
make build

# Docker Compose로 실행
make start

# 또는 직접 실행
docker compose up -d
```

### 접속

서버가 실행되면 다음 주소로 접속할 수 있습니다:

- 웹 인터페이스: `http://localhost:1200`
- API 엔드포인트: `http://localhost:1200/api/routes`

**참고**: 프로덕션 환경에서는 포트 8700을 사용하도록 설정할 수 있습니다.

## 서비스 구성

### 핵심 컴포넌트

- **Node.js 서버**: Express 기반 웹 서버
- **Redis** (선택): 캐싱 및 성능 향상
- **Puppeteer** (선택): 동적 콘텐츠 크롤링
- **PostgreSQL** (선택): 데이터 저장


## 환경 변수

주요 환경 변수 설정 예시 (`.env` 파일):

```bash
# 기본 설정
PORT=1200
NODE_ENV=production

# 캐시 설정 (Redis)
CACHE_TYPE=redis
REDIS_URL=redis://localhost:6379/

# 캐시 만료 시간 (초)
CACHE_EXPIRE=300
# 라우트별 캐시 시간 (초)
CACHE_CONTENT_EXPIRE=3600

# 요청 제한
# REQUEST_RETRY=2
# REQUEST_TIMEOUT=30000

# Puppeteer 설정 (동적 콘텐츠 크롤링)
PUPPETEER_WS_ENDPOINT=

# 접근 제어
# ACCESS_KEY=your_secret_key
# ALLOW_ORIGIN=*

# 로깅
# LOGGER_LEVEL=info
# DEBUG_INFO=true

# 데이터베이스 (선택)
# DATABASE_URL=postgres://user:pass@localhost:5432/rsshub

# 외부 API 키 (선택, 일부 라우트에 필요)
# YOUTUBE_KEY=
# TWITTER_API_KEY=
# GITHUB_ACCESS_TOKEN=
# PIXIV_USERNAME=
# PIXIV_PASSWORD=
```

## 사용법

### RSS 피드 구독하기

RSSHub의 라우트 형식:

```
http://localhost:1200/:namespace/:route/:parameters?
```

#### 예시

```bash
# GitHub 사용자의 활동
http://localhost:1200/github/activity/DIYgod

# YouTube 채널
http://localhost:1200/youtube/user/@username

# Twitter 사용자 타임라인
http://localhost:1200/twitter/user/username

# Hacker News 프론트 페이지
http://localhost:1200/hackernews/best

# Reddit 서브레딧
http://localhost:1200/reddit/r/programming
```

### API 사용하기

```bash
# 사용 가능한 모든 라우트 조회
curl http://localhost:1200/api/routes

# 특정 피드 JSON으로 가져오기
curl http://localhost:1200/github/trending/daily?format=json
```

### 접근 키 설정 (선택)

보안을 위해 접근 키를 설정할 수 있습니다:

```bash
# .env 파일
ACCESS_KEY=my_secret_key

# 요청 시 키 포함
http://localhost:1200/github/trending/daily?key=my_secret_key
```

## Docker 설정

### docker-compose.yml 예시

```yaml
version: '3'

services:
  rsshub:
    image: scriptonbasestar/rsshub:latest
    ports:
      - "8700:1200"
    environment:
      NODE_ENV: production
      CACHE_TYPE: redis
      REDIS_URL: redis://redis:6379/
      CACHE_EXPIRE: 300
    depends_on:
      - redis
    restart: unless-stopped

  redis:
    image: redis:alpine
    volumes:
      - redis-data:/data
    restart: unless-stopped

volumes:
  redis-data:
```

### 실행 명령어

```bash
# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f rsshub

# 서비스 중지
docker compose down

# 이미지 업데이트
docker compose pull
docker compose up -d
```

## 문제 해결

### RSS 피드가 업데이트되지 않음

```bash
# Redis 캐시 초기화
docker compose exec redis redis-cli FLUSHALL

# 또는 캐시 만료 시간 단축
# CACHE_EXPIRE=60  # .env 파일에 설정
```

### 특정 라우트 오류

일부 라우트는 API 키가 필요합니다:

```bash
# .env 파일에 필요한 API 키 추가
TWITTER_API_KEY=your_twitter_api_key
YOUTUBE_KEY=your_youtube_api_key
```

### 메모리 부족

```bash
# docker-compose.yml에서 메모리 제한 설정
services:
  rsshub:
    mem_limit: 2g
    environment:
      NODE_OPTIONS: --max-old-space-size=1024
```

### 요청 타임아웃

```bash
# .env 파일에서 타임아웃 증가
REQUEST_TIMEOUT=60000  # 60초
REQUEST_RETRY=3
```

### Puppeteer 크롤링 실패

동적 콘텐츠 크롤링이 필요한 경우:

```bash
# Chrome/Chromium 서비스 추가
docker compose exec rsshub npm install puppeteer

# 또는 외부 Puppeteer 서비스 사용
# PUPPETEER_WS_ENDPOINT=ws://browserless:3000
```

## 개발

### 새 라우트 추가

```bash
# 라우트 파일 생성
# lib/routes/[namespace]/[route].js

# 예시: lib/routes/example/index.js
module.exports = async (ctx) => {
    ctx.state.data = {
        title: 'Example Feed',
        link: 'https://example.com',
        item: [
            {
                title: 'Item 1',
                description: 'Description 1',
                link: 'https://example.com/item1',
                pubDate: new Date().toUTCString(),
            },
        ],
    };
};
```

### 테스트

```bash
# 단위 테스트 실행
cd RSSHub
pnpm test

# 특정 라우트 테스트
pnpm test -- routes/github
```

## 유용한 명령어

```bash
# 빌드 및 배포
make build        # Docker 이미지 빌드
make push         # Docker Hub에 푸시
make start        # 서비스 시작

# 개발
cd RSSHub
pnpm dev          # 개발 서버 (핫 리로드)
pnpm build        # 프로덕션 빌드
pnpm start        # 프로덕션 서버 시작

# 디버그
pnpm run docs     # 문서 생성
pnpm run format   # 코드 포맷팅
pnpm run lint     # 린트 검사
```

## 배포

### 프로덕션 배포 권장 사항

```bash
# .env 설정
NODE_ENV=production
CACHE_TYPE=redis
CACHE_EXPIRE=600
LOGGER_LEVEL=warn

# 리버스 프록시 (Nginx) 설정 예시
server {
    listen 80;
    server_name rsshub.example.com;

    location / {
        proxy_pass http://localhost:8700;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## 참고 자료

- [RSSHub 공식 홈페이지](https://docs.rsshub.app/)
- [RSSHub GitHub 저장소](https://github.com/DIYgod/RSSHub)
- [RSSHub 문서](https://docs.rsshub.app/en/)
- [지원 라우트 목록](https://docs.rsshub.app/en/routes/)
- [라우트 개발 가이드](https://docs.rsshub.app/en/joinus/quick-start.html)
- [RSS 스펙](https://www.rssboard.org/rss-specification)
- [Puppeteer 문서](https://pptr.dev/)
