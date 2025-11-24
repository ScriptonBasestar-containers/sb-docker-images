# Wiki (Knowledge Management Systems)

위키 및 지식 관리 시스템 - 협업 문서화 및 지식베이스 구축

## 📚 프로젝트 목록 (5개)

### [DokuWiki](dokuwiki/)
**파일 기반 경량 위키**
- DB 불필요 (텍스트 파일 저장)
- 플러그인 확장 가능
- 간단한 구문
- Standalone 구성 제공

### [Gollum](gollum/)
**Git 기반 위키 시스템**
- Git 백엔드 활용
- Markdown/다양한 마크업 지원
- 버전 관리 내장
- Ruby 기반

### [MediaWiki](mediawiki/)
**위키백과와 동일한 위키 엔진**
- 강력한 편집 기능
- 대규모 문서 관리
- 확장 기능 풍부
- PHP 기반

### [openNamu](openNamu/)
**한국형 위키 엔진**
- 나무위키 스타일
- 한국어 최적화
- Python Flask 기반
- 간편한 설치

### [Wiki.js](wikijs/)
**현대적인 오픈소스 위키**
- Node.js 기반
- Markdown 에디터
- 다양한 인증 지원
- Git 동기화

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/wiki/mediawiki

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 초기 설정 (MediaWiki 예시)
# 브라우저에서 http://localhost:8080 접속
```

## 📖 공통 기능

- ✅ 문서 버전 관리
- ✅ 검색 기능
- ✅ 사용자 권한 관리
- ✅ 카테고리/태그 시스템
- ✅ 내부 링크

## 🔗 관련 카테고리

- [CMS](../cms/) - 컨텐츠 관리 시스템
- [Community](../community/) - 커뮤니티/포럼 플랫폼
- [Devtools](../devtools/) - 개발 도구

## 📝 참고사항

### Git 기반 워크플로우
- **Gollum** - Git 저장소와 직접 통합
- **Wiki.js** - Git 동기화 옵션 제공

### 데이터베이스 요구사항
- DokuWiki: 없음 (파일 기반)
- MediaWiki: MySQL/PostgreSQL
- Wiki.js: PostgreSQL/MySQL/SQLite
- openNamu: SQLite (기본)

### 프로덕션 배포 시
1. 정기 백업 설정 (문서 손실 방지)
2. 검색 인덱스 최적화
3. 이미지 업로드 용량 제한
4. 스팸 방지 설정
