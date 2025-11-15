# RELEASE

## 실서버 적용 이미지
없음

## 실서버 사용 가능 이미지

테스트는 되었으나 실제 프로덕션 적용 경험은 없는 이미지들:

### 인프라/데이터베이스
- **postgres-exts** - CloudNativePG용 PostgreSQL 확장 이미지
  - Essential: pgvector + 기본 확장
  - Full: PostGIS, TimescaleDB, pg_cron 등 포함
  - 상태: 빌드/문서 완료, 프로덕션 준비됨

### 커뮤니티/포럼
- **flarum** - 현대적인 포럼 소프트웨어
- **discourse** - 오픈소스 토론 플랫폼

### CMS/콘텐츠
- **nextcloud** - 파일 공유 및 협업 플랫폼
- **gnuboard5** - 한국형 게시판

### 네트워크/프록시
- **rtmp-proxy** - RTMP 스트리밍 프록시
- **squid** - HTTP 프록시 서버

## 개발/테스트 전용

### 개발 도구
- **buildbox** - 통합 테스트 환경
- **ansible-dev, chef-dev, ruby-dev** - 개발 환경

### 테스트/실험용
- docker-bitcoin, docker-ethereum
- mastodon, forem
- jupyter, jupyter2
- django-cms, joomla
- nodebb, rsshub, tsboard, wikijs

## Deprecated / 지원 중단

### 아카이브 대상
- **xpressengine** (XE3) - 공식 지원 종료
- **flaskbb** - 개발 중단
- **openNamu** - 개발 중단
- **spree, solidus** - 테스트만 진행, 실사용 없음

> 이들 프로젝트는 필요 시 `archive/` 디렉토리로 이동 예정
