# Community (Forums & Discussion Platforms)

커뮤니티 및 포럼 플랫폼 - 온라인 토론 및 커뮤니티 구축

## 📚 프로젝트 목록 (6개)

### [Discourse](discourse/)
**현대적인 오픈소스 포럼 플랫폼**
- Ruby on Rails 기반
- 실시간 알림 및 토론
- 모바일 최적화
- Standalone 구성 제공

### [Flarum](flarum/)
**차세대 포럼 소프트웨어**
- PHP 기반, 빠르고 가벼움
- 확장 가능한 구조
- 우아한 UI/UX
- Apache/Nginx 구성 지원

### [FlaskBB](flaskbb/)
**Python Flask 기반 포럼 (Deprecated)**
- 경량 포럼 솔루션
- ⚠️ 개발 중단됨
- Standalone 구성 제공

### [Misago](misago/)
**Django 기반 포럼 플랫폼**
- Python/Django 스택
- 현대적인 UI
- 확장 가능한 구조

### [NodeBB](nodebb/)
**Node.js 기반 포럼**
- 실시간 상호작용
- 소셜 로그인 통합
- 플러그인 시스템
- Standalone 구성 제공

### [TSBoard](tsboard/)
**TypeScript + Go 하이브리드 포럼**
- 프론트엔드: TypeScript
- 백엔드: Go API
- 현대적인 아키텍처

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/community/discourse

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 초기 설정 (Discourse 예시)
docker compose exec web rake admin:create
```

## 📖 공통 기능

- ✅ 실시간 알림
- ✅ 사용자 권한 관리
- ✅ 게시글/댓글 시스템
- ✅ 검색 기능
- ✅ 모바일 반응형

## 🔗 관련 카테고리

- [CMS](../cms/) - 컨텐츠 관리 시스템
- [Wiki](../wiki/) - 위키 시스템
- [Social](../social/) - 소셜 네트워크

## 📝 참고사항

### 활발히 유지보수 중
- **Discourse** - 가장 활발한 커뮤니티
- **Flarum** - 빠른 성장 중
- **NodeBB** - 실시간 기능 강점

### Deprecated 프로젝트
- **FlaskBB** - 개발 중단, 참고용

### 데이터베이스 요구사항
- Discourse: PostgreSQL, Redis
- Flarum: MySQL/MariaDB
- NodeBB: MongoDB, Redis
