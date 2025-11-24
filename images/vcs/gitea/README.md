# Gitea - Self-Hosted Git Service

**Gitea**는 Go로 작성된 경량 자체 호스팅 Git 서비스입니다. GitHub와 유사한 기능을 제공하면서도 최소한의 리소스로 실행됩니다.

## 주요 기능

- **Git 저장소 호스팅**: 완전한 Git 기능과 웹 UI 제공
- **협업 도구**: Issues, Pull Requests, Code Review, Wiki
- **Gitea Actions**: GitHub Actions 호환 CI/CD 파이프라인
- **패키지 레지스트리**: Container, npm, Maven, PyPI 등 지원
- **보안**: 2단계 인증, OAuth2, LDAP/AD 통합
- **경량**: 256MB RAM으로 실행 가능 (Raspberry Pi 지원)

## Quick Start

### 1. 서비스 시작

```bash
make up
```

### 2. 웹 UI 접속

브라우저에서 http://localhost:3000 접속

### 3. 초기 설정

첫 접속 시 설정 화면이 나타납니다:

- **데이터베이스**: PostgreSQL (이미 설정됨)
- **애플리케이션 URL**: http://localhost:3000 (또는 실제 도메인)
- **관리자 계정**: 생성할 관리자 계정 정보 입력
- **SSH 서버**: 포트 22 (Docker 외부에서는 2222로 매핑됨)

### 4. 첫 저장소 생성

1. 로그인 후 우측 상단 '+' 버튼 클릭
2. 'New Repository' 선택
3. 저장소 이름과 설명 입력
4. 공개/비공개 설정
5. 'Create Repository' 클릭

## 시스템 요구사항

| 항목 | 사양 |
|------|------|
| **메모리** | 256MB 최소, 512MB 권장 |
| **CPU** | 1 코어 |
| **디스크** | 500MB + 저장소 크기 |
| **데이터베이스** | PostgreSQL 16 (포함됨) |

## 포트 설정

| 서비스 | 내부 포트 | 외부 포트 | 용도 |
|--------|----------|----------|------|
| Web UI | 3000 | 3000 | 웹 인터페이스 |
| SSH | 22 | 2222 | Git SSH 접속 |

> **주의**: SSH 포트는 호스트의 SSH(22)와 충돌을 피하기 위해 2222로 매핑됩니다.

## Git 클라이언트 사용

### HTTPS 클론

```bash
git clone http://localhost:3000/username/repository.git
```

### SSH 클론

```bash
# SSH 포트를 2222로 지정
git clone ssh://git@localhost:2222/username/repository.git
```

SSH 설정을 간편하게 하려면 `~/.ssh/config`에 추가:

```
Host gitea
    HostName localhost
    Port 2222
    User git
```

이후 간단하게 사용:

```bash
git clone gitea:username/repository.git
```

## Gitea Actions (CI/CD)

Gitea 1.19+ 버전부터 GitHub Actions 호환 CI/CD를 지원합니다.

### Actions 활성화

1. **Runner 등록 토큰 발급**:
   - Gitea 관리자 페이지 → Actions → Runners
   - 'Create new Runner' 클릭하여 토큰 복사

2. **Runner 실행** (Docker):

```bash
docker run -d \
  --name gitea-runner \
  -e GITEA_INSTANCE_URL=http://gitea:3000 \
  -e GITEA_RUNNER_REGISTRATION_TOKEN=your-token-here \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitea/act_runner:latest
```

### Workflow 예제

`.gitea/workflows/test.yml`:

```yaml
name: Test
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests
        run: |
          echo "Running tests..."
          # 테스트 명령어 실행
```

## 데이터 백업

### 백업 대상

```bash
# 저장소 및 설정 데이터
./data/

# PostgreSQL 데이터
./postgres/
```

### 백업 방법

```bash
# 서비스 중지
make down

# 데이터 백업
tar czf gitea-backup-$(date +%Y%m%d).tar.gz data/ postgres/

# 서비스 재시작
make up
```

### 복원 방법

```bash
# 서비스 중지
make down

# 백업 복원
tar xzf gitea-backup-YYYYMMDD.tar.gz

# 서비스 시작
make up
```

## 고급 설정

### app.ini 커스터마이징

Gitea 설정은 `./data/gitea/conf/app.ini`에 저장됩니다.

주요 설정 항목:

```ini
[server]
DOMAIN = git.example.com
ROOT_URL = https://git.example.com/

[service]
DISABLE_REGISTRATION = true
REQUIRE_SIGNIN_VIEW = false

[repository]
DEFAULT_BRANCH = main

[webhook]
ALLOWED_HOST_LIST = *
```

설정 변경 후 재시작:

```bash
make restart
```

### 리버스 프록시 (Nginx)

```nginx
server {
    listen 80;
    server_name git.example.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 이메일 설정

`app.ini`에 SMTP 설정 추가:

```ini
[mailer]
ENABLED = true
FROM = gitea@example.com
PROTOCOL = smtp
SMTP_ADDR = smtp.gmail.com
SMTP_PORT = 587
USER = your-email@gmail.com
PASSWD = your-app-password
```

## GitHub에서 마이그레이션

### 1. GitHub 저장소 임포트

Gitea 웹 UI에서:
1. '+' → 'New Migration'
2. 'GitHub' 선택
3. GitHub 저장소 URL 입력
4. Personal Access Token 입력 (선택)
5. 'Migrate Repository' 클릭

### 2. 로컬 저장소 원격 변경

```bash
# 기존 GitHub 원격 확인
git remote -v

# Gitea로 원격 변경
git remote set-url origin http://localhost:3000/username/repository.git

# 푸시
git push -u origin main
```

### 3. GitHub Actions → Gitea Actions

GitHub Actions 워크플로우는 대부분 호환됩니다:

- `.github/workflows/` → `.gitea/workflows/`로 복사
- 대부분의 공식 actions는 그대로 동작
- Secrets는 Gitea 저장소 설정에서 재등록

## 문제 해결

### 권한 오류

```bash
# UID/GID 확인
id

# compose.yml의 USER_UID, USER_GID를 실제 값으로 변경
# 예: USER_UID=1001, USER_GID=1001
```

### 데이터베이스 연결 실패

```bash
# 로그 확인
make logs

# DB 컨테이너 상태 확인
docker compose ps db

# DB 재시작
docker compose restart db
```

### SSH 접속 실패

```bash
# 포트 확인
docker compose ps

# SSH 테스트
ssh -p 2222 git@localhost
```

## Makefile 명령어

```bash
make help     # 도움말 표시
make up       # 서비스 시작
make down     # 서비스 중지
make logs     # 로그 확인
make ps       # 컨테이너 상태
make restart  # 서비스 재시작
make test     # compose 파일 검증
make clean    # 모든 데이터 삭제 (주의!)
```

## 참고 자료

- [Gitea 공식 문서](https://docs.gitea.io/)
- [Gitea Actions 가이드](https://docs.gitea.io/en-us/actions/)
- [Docker 설치 가이드](https://docs.gitea.io/en-us/install-with-docker/)
- [GitHub에서 마이그레이션](https://docs.gitea.io/en-us/migrations-interfaces/)
- [Gitea vs GitLab 비교](https://docs.gitea.io/en-us/comparison/)

## 라이선스

Gitea는 MIT 라이선스로 배포됩니다.

## 관련 프로젝트

- **Forgejo**: Gitea의 커뮤니티 포크
- **GitLab**: 엔터프라이즈급 DevOps 플랫폼
- **Gogs**: Gitea의 원본 프로젝트 (경량화)
