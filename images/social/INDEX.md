# Social (소셜 네트워크 & 팀 메신저)

소셜 미디어, 커뮤니티 플랫폼 및 팀 메신저 - 탈중앙화 소셜 네트워킹 & 협업

## 📚 프로젝트 목록 (4개)

### [Forem](forem/)
**오픈소스 커뮤니티 플랫폼**
- DEV Community 엔진
- 블로그 + 소셜 기능
- 태그 기반 컨텐츠
- Ruby on Rails 기반
- 완전한 커뮤니티 솔루션

### [Mastodon](mastodon/)
**탈중앙화 소셜 네트워크**
- ActivityPub 프로토콜
- 연합형 소셜 미디어
- Twitter 유사 인터페이스
- Ruby on Rails + Node.js
- 프라이버시 중시

### [Mattermost](mattermost/)
**오픈소스 팀 메신저**
- Slack 대체용
- 팀 채널 메시징
- 파일 공유 및 검색
- 모바일 앱 지원
- Go + PostgreSQL
- 엔터프라이즈급 보안

### [Rocket.Chat](rocketchat/)
**강력한 팀 커뮤니케이션**
- 음성/영화 통화 지원
- 옴니채널 고객지원
- 앱 마켓플레이스
- 연합 (Federation)
- Node.js + MongoDB
- 확장 가능한 아키텍처

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/social/mastodon

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 관리자 계정 생성 (Mastodon)
docker compose exec web bundle exec rails mastodon:make_admin USERNAME=admin
```

## 📖 공통 기능

- ✅ 사용자 프로필
- ✅ 게시물 작성/공유
- ✅ 팔로우 시스템
- ✅ 알림
- ✅ 해시태그/검색
- ✅ 미디어 업로드

## 🔗 관련 카테고리

- [Community](../community/) - 커뮤니티/포럼
- [CMS](../cms/) - 컨텐츠 관리
- [Database](../database/) - 데이터베이스

## 📝 참고사항

### 탈중앙화 소셜 미디어
- **Mastodon** - ActivityPub 기반, 연합형 네트워크
  - 다른 Mastodon 인스턴스와 통신
  - 중앙 서버 없음
  - 커뮤니티 주도 운영

### 커뮤니티 플랫폼
- **Forem** - DEV.to와 동일한 엔진
  - 개발자 커뮤니티에 최적화
  - 블로그 + 소셜 기능 통합
  - 기술 중심 커뮤니티

### 팀 메신저
- **Mattermost** - Slack 대체, 엔터프라이즈 중심
  - 강력한 권한 관리
  - 플러그인 확장
  - 규정 준수 기능
- **Rocket.Chat** - 기능 풍부, 앱 생태계
  - 음성/영상 통화
  - 옴니채널 지원
  - 연합 (Federation)

### 기술 스택
- Mastodon: Ruby on Rails + Node.js + PostgreSQL + Redis
- Forem: Ruby on Rails + PostgreSQL + Redis
- Mattermost: Go + PostgreSQL
- Rocket.Chat: Node.js + MongoDB (Replica Set)

### 프로덕션 배포 시
1. **이메일**: SMTP 설정 필수 (가입 확인)
2. **미디어**: S3/MinIO 스토리지 연동 권장
3. **백업**: 데이터베이스 정기 백업
4. **스케일링**: Sidekiq 워커 개수 조정
5. **모더레이션**: 관리 도구 설정 및 규칙 수립
6. **리소스**: 충분한 메모리/CPU 할당 (미디어 처리)
