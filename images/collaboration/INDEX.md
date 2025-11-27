# Collaboration (협업 도구)

팀 협업 및 커뮤니케이션 도구 - 채팅, 화상회의, 프로젝트 관리

## 📚 프로젝트 목록 (준비 중)

### [Mattermost](mattermost/) 🚧 **Coming Soon**
**Slack 대안 팀 협업 플랫폼**
- 실시간 메시징 및 파일 공유
- 채널 기반 커뮤니케이션
- 모바일 앱 지원
- PostgreSQL 기반
- Port: 8350

### [Rocket.Chat](rocketchat/) 🚧 **Coming Soon**
**오픈소스 팀 채팅 플랫폼**
- 실시간 채팅 및 비디오 통화
- 옴니채널 지원 (고객 지원)
- 풍부한 통합 (Jira, GitHub 등)
- MongoDB 기반
- Port: 8340

## 🎯 카테고리 특징

### 주요 기능
- **실시간 메시징**: 팀 내 즉각적인 커뮤니케이션
- **채널/그룹**: 주제별, 프로젝트별 대화 구분
- **파일 공유**: 문서, 이미지, 코드 공유
- **통합**: CI/CD, 이슈 트래커 등 개발 도구 통합
- **검색**: 메시지 및 파일 전체 검색
- **알림**: 데스크톱/모바일 푸시 알림

### 사용 사례
- 원격 팀 협업
- 프로젝트 커뮤니케이션
- DevOps 알림 통합
- 고객 지원 (옴니채널)

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/collaboration/mattermost

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f
```

## 📖 공통 구성

모든 프로젝트는 다음을 포함합니다:
- ✅ 환경변수 템플릿 (.env.example)
- ✅ Docker Compose 구성
- ✅ Makefile 자동화
- ✅ README 문서화
- ✅ Health checks
- ✅ 데이터베이스 통합 (PostgreSQL/MongoDB)

## 🔗 관련 카테고리

- [Community](../community/) - 커뮤니티/포럼 플랫폼
- [Wiki](../wiki/) - 위키 및 문서 관리
- [DevTools](../devtools/) - 개발 도구

## 🆚 비교: Collaboration Tools

| 기능 | Mattermost | Rocket.Chat |
|------|-----------|------------|
| 오픈소스 | ✅ | ✅ |
| Self-hosted | ✅ | ✅ |
| 실시간 채팅 | ✅ | ✅ |
| 비디오/음성 통화 | ⭐⭐ | ⭐⭐⭐ |
| 모바일 앱 | ✅ | ✅ |
| 옴니채널 | ❌ | ✅ |
| 데이터베이스 | PostgreSQL | MongoDB |
| 통합 생태계 | ⭐⭐⭐ | ⭐⭐ |
| 엔터프라이즈 기능 | ⭐⭐⭐ | ⭐⭐ |
| 설치 난이도 | ⭐⭐ | ⭐⭐⭐ |

### Mattermost 추천 대상
- Slack과 유사한 경험 선호
- PostgreSQL 인프라 보유
- 엔터프라이즈 보안/컴플라이언스 중요
- DevOps 통합 중심

### Rocket.Chat 추천 대상
- 비디오/음성 통화 중요
- 고객 지원 (옴니채널) 필요
- MongoDB 인프라 보유
- 커스터마이징 자유도 중요

## 📝 프로덕션 배포 시 고려사항

### 보안
1. **HTTPS 필수**: 리버스 프록시로 SSL/TLS 설정
2. **비밀번호 변경**: 데이터베이스 및 관리자 계정
3. **방화벽 설정**: 필요한 포트만 오픈
4. **정기 업데이트**: 보안 패치 적용

### 성능
1. **데이터베이스 최적화**: 인덱싱, 커넥션 풀
2. **파일 스토리지**: S3 등 외부 스토리지 고려
3. **캐싱**: Redis 활용
4. **로드 밸런싱**: 대규모 팀 지원 시

### 백업
1. **데이터베이스**: 정기 백업 스크립트
2. **파일 업로드**: 볼륨 백업
3. **설정**: compose/env 파일 버전 관리

### 모니터링
1. **헬스 체크**: Docker health check 활용
2. **로그 수집**: ELK, Loki 등
3. **메트릭**: Prometheus + Grafana

## 🔧 트러블슈팅

### 일반적인 문제

**Q: 컨테이너가 시작되지 않음**
```bash
# 로그 확인
docker compose logs -f

# 데이터베이스 연결 확인
docker compose exec db pg_isready  # PostgreSQL
docker compose exec db mongosh --eval "db.adminCommand('ping')"  # MongoDB
```

**Q: 파일 업로드 실패**
- 볼륨 권한 확인
- 디스크 공간 확인
- 최대 파일 크기 설정 확인

**Q: 느린 성능**
- 데이터베이스 인덱싱 확인
- 메모리 할당 증가
- Redis 캐싱 활성화

## 📚 추가 리소스

### Mattermost
- 공식 사이트: https://mattermost.com/
- 문서: https://docs.mattermost.com/
- GitHub: https://github.com/mattermost/mattermost

### Rocket.Chat
- 공식 사이트: https://rocket.chat/
- 문서: https://docs.rocket.chat/
- GitHub: https://github.com/RocketChat/Rocket.Chat

---

**카테고리 생성일**: 2025-11-27 (Phase 14)
**프로젝트 상태**: 준비 중
**예상 완료**: Phase 14 완료 시
