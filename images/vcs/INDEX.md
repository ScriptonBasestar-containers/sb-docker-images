# VCS (Version Control Systems)

버전 관리 시스템 - 소스 코드 관리 및 협업

## 📚 프로젝트 목록 (1개)

### [Gitea](gitea/)
**경량 Git 서비스**
- 자체 호스팅 Git 서버
- GitHub 유사 인터페이스
- 이슈 트래킹
- Pull Request
- Go 기반 단일 바이너리
- 낮은 리소스 요구사항

## 🚀 빠른 시작

```bash
# 프로젝트 이동
cd images/vcs/gitea

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 웹 인터페이스 접속
# http://localhost:3000
# 초기 설정 마법사 진행
```

## 📖 주요 기능

- ✅ Git 저장소 호스팅
- ✅ 웹 기반 코드 뷰어
- ✅ 이슈 트래킹
- ✅ Pull Request/Code Review
- ✅ Wiki 기능
- ✅ CI/CD 통합 (Gitea Actions)
- ✅ 조직/팀 관리
- ✅ 다국어 지원

## 🔗 관련 카테고리

- [Devtools](../devtools/) - 개발 도구
- [Infrastructure](../infrastructure/) - 인프라
- [Registry](../registry/) - 패키지 레지스트리

## 📝 참고사항

### GitHub 대안
- **Gitea** - 가볍고 빠른 자체 호스팅
  - GitHub와 유사한 UI/UX
  - 낮은 리소스 요구사항
  - Raspberry Pi에서도 실행 가능

### 주요 특징
- **단일 바이너리**: 설치 및 관리 간편
- **SQLite/MySQL/PostgreSQL**: 다양한 DB 지원
- **SSH/HTTP(S)**: Git 프로토콜 모두 지원
- **API**: RESTful API 제공

### 비교
| 기능 | Gitea | GitLab | GitHub |
|------|-------|--------|--------|
| 리소스 | 경량 | 무겁 | N/A |
| 자체 호스팅 | ✅ | ✅ | ❌ |
| CI/CD | 기본 | 강력 | 강력 |
| 설치 | 쉬움 | 복잡 | N/A |

### 프로덕션 배포 시
1. **백업**: Git 저장소 정기 백업
2. **SSH 키**: SSH 접근 설정
3. **HTTPS**: SSL 인증서 필수
4. **인증**: LDAP/OAuth 연동 고려
5. **스토리지**: LFS 사용 시 충분한 공간 확보
6. **업데이트**: 정기 보안 패치 적용
7. **웹훅**: CI/CD 파이프라인 통합
