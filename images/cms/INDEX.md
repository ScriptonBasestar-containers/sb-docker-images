# CMS (Content Management Systems)

컨텐츠 관리 시스템 - 웹사이트 구축 및 관리를 위한 플랫폼

## 📚 프로젝트 목록 (8개)

### [Django CMS](django-cms/)
**Python/Django 기반 엔터프라이즈 CMS**
- 유연한 플러그인 아키텍처
- 다국어 지원
- 강력한 권한 관리

### [Drupal](drupal/)
**강력한 PHP 기반 엔터프라이즈 CMS**
- 높은 확장성 및 커스터마이징
- 대규모 사이트에 적합
- Apache/FPM 구성 지원

### [Gnuboard5](gnuboard5/)
**한국형 커뮤니티 CMS (PHP)**
- 게시판 중심 구조
- 한국어 최적화
- FPM 기반 운영

### [Gnuboard6](gnuboard6/)
**Gnuboard 차세대 버전**
- Laravel 기반 리빌드
- 현대적인 아키텍처
- API 우선 설계

### [Joomla](joomla/)
**사용하기 쉬운 PHP CMS**
- 풍부한 확장 생태계
- 다목적 웹사이트 구축
- Standalone 구성 제공

### [Nextcloud](nextcloud/)
**개인 클라우드 스토리지 & 협업 플랫폼**
- 파일 동기화 및 공유
- 온라인 오피스
- Apache/FPM 구성 선택 가능

### [WordPress](wordpress/)
**세계 최대 CMS 플랫폼**
- 블로그 및 웹사이트 구축
- 방대한 플러그인/테마
- Standalone 구성 제공

### [XpressEngine](xpressengine/)
**한국형 CMS/포털 솔루션 (Deprecated)**
- 모듈 기반 확장
- 레거시 XE3 버전
- ⚠️ 공식 지원 종료

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/cms/wordpress

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f
```

## 📖 공통 기능

- ✅ 환경변수 템플릿 (.env.example)
- ✅ Docker Compose 구성
- ✅ Makefile 자동화
- ✅ README 문서화

## 🔗 관련 카테고리

- [Community](../community/) - 커뮤니티/포럼 플랫폼
- [Wiki](../wiki/) - 위키 시스템
- [E-commerce](../ecommerce/) - 전자상거래

## 📝 참고사항

### Standalone 구성 제공
다음 프로젝트는 완전한 스택 구성을 제공합니다:
- drupal, joomla, nextcloud, wordpress

### 프로덕션 배포 시
1. `.env` 파일에서 비밀번호 변경
2. 볼륨 백업 전략 수립
3. 리버스 프록시 구성 (Nginx/Traefik)
4. HTTPS 인증서 설정
