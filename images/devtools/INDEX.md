# Devtools (개발 도구)

개발 환경 및 도구 - 코딩, 빌드, 테스트, 배포 자동화

## 📚 프로젝트 목록 (10개)

### [Ansible Dev](ansible-dev/)
**Ansible 개발 환경**
- 인프라 자동화 도구
- Playbook 개발/테스트
- Python 기반
- 격리된 개발 환경

### [Chef Dev](chef-dev/)
**Chef 개발 환경**
- 인프라 코드화 (IaC)
- Cookbook 개발
- Ruby 기반
- 테스트 환경 제공

### [Jenkins](jenkins/)
**오픈소스 CI/CD 서버**
- 빌드 자동화
- 플러그인 생태계
- 파이프라인 지원
- Standalone 구성 제공

### [Jenkins Controller](jenkins-controller/)
**Jenkins 컨트롤러 빌드 이미지**
- 플러그인 사전 설치 (plugins.txt)
- Jenkins 2.528.3-jdk21
- Harbor 레지스트리 빌드/푸시
- compose 미사용 (빌드 전용)

### [Jenkins Agent](jenkins-agent/)
**Jenkins 인바운드 에이전트 이미지**
- 컨트롤러 연결용 빌드 에이전트
- Jenkins agent 2.528.3-jdk21
- Harbor 레지스트리 빌드/푸시
- compose 미사용 (빌드 전용)

### [Jupyter](jupyter/)
**데이터 과학 노트북**
- 인터랙티브 컴퓨팅
- Python/R/Julia 지원
- 데이터 시각화
- 과학 연구용

### [Jupyter2](jupyter2/)
**Jupyter 대안 구성**
- 다른 설정/확장
- 커스터마이징 버전
- 실험용 환경

### [Ruby Dev](ruby-dev/)
**Ruby 개발 환경**
- Rails 개발 지원
- RVM/rbenv 통합
- Gem 관리
- 격리된 개발 환경

### [Node pnpm](node-pnpm/) ⭐ NEW
**Node.js with pnpm 패키지 매니저**
- 공식 pnpm Docker 이미지 없음 대응
- Debian, Alpine, Builder 3가지 변형
- Multi-arch (amd64, arm64)
- Corepack 기반 pnpm 관리

### [Taiga](taiga/) ⭐ NEW
**애자일 프로젝트 관리 플랫폼**
- Jira/Trello 오픈소스 대안
- Scrum & Kanban 지원
- 공식 이미지 기반 compose 구성
- WebSocket 실시간 이벤트

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/devtools/jenkins

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# Jenkins 초기 비밀번호 확인
docker compose logs jenkins | grep -A 2 "Jenkins initial setup"
```

## 📖 공통 기능

- ✅ 격리된 개발 환경
- ✅ 버전 관리 통합
- ✅ 패키지/의존성 관리
- ✅ 테스트 실행 지원
- ✅ CI/CD 파이프라인

## 🔗 관련 카테고리

- [Infrastructure](../infrastructure/) - 인프라 서비스
- [VCS](../vcs/) - 버전 관리 시스템
- [Registry](../registry/) - 패키지 레지스트리

## 📝 참고사항

### CI/CD 도구
- **Jenkins** - 범용 CI/CD 서버, 플러그인 풍부

### 개발 환경
- **Ansible Dev** - 인프라 자동화 개발
- **Chef Dev** - 인프라 코드화 개발
- **Ruby Dev** - Ruby/Rails 애플리케이션 개발

### 데이터 과학
- **Jupyter/Jupyter2** - 노트북 기반 인터랙티브 개발

### 프로덕션 배포 시
1. Jenkins: 보안 설정 강화 (CSRF, 인증)
2. 개발 환경: 볼륨 마운트로 코드 동기화
3. Jupyter: 토큰 인증 활성화
4. 정기 백업: Jenkins 설정/작업 백업
