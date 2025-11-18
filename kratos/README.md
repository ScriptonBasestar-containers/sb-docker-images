# Ory Kratos

Ory Kratos는 클라우드 네이티브 인증 및 사용자 관리 시스템입니다. 회원가입, 로그인, 다중 인증(MFA), 계정 복구 등 사용자 인증의 모든 측면을 처리합니다.

## 빠른 시작

이 디렉토리에서 바로 Kratos를 실행할 수 있습니다:

```bash
# 1. Kratos 및 UI 소스코드 클론 (최초 1회만)
make init

# 2. Docker 이미지 빌드
make build

# 3. 서비스 시작
make run

# 4. 브라우저에서 접속
# http://localhost:4455 (UI)
# http://localhost:4433 (Public API)
# http://localhost:4434 (Admin API)
```

## 사용 가능한 명령어

```bash
make init     # Kratos 및 UI 소스코드 클론
make build    # Docker 이미지 빌드
make run      # 모든 서비스 시작 (docker compose up)
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **postgres**: PostgreSQL 16 데이터베이스 (내부 사용)
- **kratos-migrate**: 데이터베이스 마이그레이션 작업
- **kratos**: Ory Kratos 메인 서비스
  - Public API (포트 4433): 사용자 인증 엔드포인트
  - Admin API (포트 4434): 관리자 엔드포인트
- **kratos-ui-node**: Node.js 기반 셀프서비스 UI (포트 4455)
- **mailslurper**: 개발용 메일 테스트 도구 (포트 4436, 4437)

## 디렉토리 구조

```
kratos/
├── compose.yml                              # Docker Compose 설정
├── Makefile                                 # 편의 명령어
├── README.md                                # 이 문서
├── kratos/                                  # Kratos 소스코드 (make init으로 생성)
├── ory-kratos-selfservice-ui-node/          # Node.js UI (make init으로 생성)
└── ory-kratos-selfservice-ui-react-nextjs/  # Next.js UI (make init으로 생성)
```

## 포트

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 4433 | Kratos Public API | 사용자 인증, 회원가입, 로그인 등 (Ory Kratos 기본 포트) |
| 4434 | Kratos Admin API | 관리자 API (Ory Kratos 기본 포트) |
| 4455 | Kratos UI | 셀프서비스 웹 UI |
| 4436 | MailSlurper API | 메일 테스트 API |
| 4437 | MailSlurper Web | 메일 확인 웹 UI |

> ℹ️ **포트 설정**: Ory Kratos 공식 기본 포트(4433, 4434)를 사용하고 있습니다.
>
> **참고**: [포트 가이드](../PORT_GUIDE.md)에서는 8800, 8801 포트를 제안하지만, Ory Kratos의 공식 기본 포트를 그대로 사용하는 것이 일반적입니다.

포트 충돌 방지: [포트 가이드](../PORT_GUIDE.md)

## 환경 변수

주요 환경 변수 (compose.yml에서 설정):

### Kratos 서비스
- `DSN`: 데이터베이스 연결 문자열 (기본값: sqlite:///var/lib/sqlite/db.sqlite?_fk=true)
- `LOG_LEVEL`: 로그 레벨 (기본값: trace)

### Kratos UI 서비스
- `PORT`: UI 서버 포트 (기본값: 4455)
- `KRATOS_PUBLIC_URL`: Kratos Public API URL (내부: http://kratos:4433/)
- `KRATOS_BROWSER_URL`: Kratos Browser URL (외부: http://127.0.0.1:4433/)
- `COOKIE_SECRET`: 쿠키 암호화 시크릿 (프로덕션에서 변경 필수)
- `CSRF_COOKIE_NAME`: CSRF 쿠키 이름 (기본값: ory_csrf_ui)
- `CSRF_COOKIE_SECRET`: CSRF 토큰 시크릿 (프로덕션에서 변경 필요)

### PostgreSQL
- `POSTGRES_USER`: 데이터베이스 사용자 (기본값: kratos)
- `POSTGRES_PASSWORD`: 데이터베이스 비밀번호 (기본값: secret)
- `POSTGRES_DB`: 데이터베이스 이름 (기본값: kratos)

## 사용법

### 1. 회원가입

```bash
# 브라우저에서 접속
http://localhost:4455/registration

# 이메일/비밀번호로 회원가입
# 인증 이메일은 MailSlurper에서 확인 가능
http://localhost:4437
```

### 2. 로그인

```bash
# 브라우저에서 접속
http://localhost:4455/login

# 등록한 이메일/비밀번호로 로그인
```

### 3. API 사용 예제

```bash
# Public API - 인증 플로우 생성
curl http://localhost:4433/self-service/registration/browser

# Admin API - 사용자 목록 조회
curl http://localhost:4434/admin/identities

# 사용자 생성 (Admin API)
curl -X POST http://localhost:4434/admin/identities \
  -H "Content-Type: application/json" \
  -d '{
    "schema_id": "default",
    "traits": {
      "email": "user@example.com"
    }
  }'
```

### 4. 이메일 확인

모든 인증 관련 이메일은 MailSlurper로 전송됩니다:

```bash
# MailSlurper 웹 UI에서 확인
http://localhost:4437

# 이메일 인증 링크, 비밀번호 재설정 링크 등을 여기서 확인
```

## 기술 스택

- **Ory Kratos**: v1.3.1 - 인증 및 사용자 관리
- **PostgreSQL**: 16-alpine - 데이터베이스
- **SQLite**: 개발 환경 기본 DB
- **Node.js UI**: Express 기반 셀프서비스 UI
- **MailSlurper**: 개발용 SMTP 서버

## 문제 해결

### 소스코드가 없다는 에러

```bash
# kratos, ory-kratos-selfservice-ui-node 디렉토리가 없으면
make init
```

### 빌드 에러

```bash
# 컨테이너와 볼륨을 모두 삭제하고 재시작
docker compose down -v
make init  # 소스코드가 없으면
make build
make run
```

### 데이터베이스 연결 에러

```bash
# postgres 서비스가 준비될 때까지 기다리고 재시도
docker compose down
docker compose up -d postgres
# postgres가 준비되면 (약 10-30초)
docker compose up
```

### 마이그레이션 실패

```bash
# kratos-migrate 서비스 로그 확인
docker compose logs kratos-migrate

# 볼륨 삭제 후 재시작
docker compose down -v
docker compose up
```

### UI에서 Kratos에 연결 안 됨

환경 변수 확인:
```bash
# KRATOS_PUBLIC_URL과 KRATOS_BROWSER_URL이 올바른지 확인
docker compose config | grep KRATOS

# 네트워크 확인
docker compose ps
```

### 이메일이 전송되지 않음

MailSlurper 서비스 확인:
```bash
# MailSlurper 로그 확인
docker compose logs mailslurper

# MailSlurper UI 접속 확인
curl http://localhost:4437
```

## 프로덕션 배포 시 주의사항

1. **시크릿 변경**: `COOKIE_SECRET`, `CSRF_COOKIE_SECRET` 등을 강력한 값으로 변경
2. **데이터베이스**: SQLite 대신 PostgreSQL 사용 권장
3. **HTTPS**: 프로덕션에서는 반드시 HTTPS 사용
4. **메일 서버**: MailSlurper 대신 실제 SMTP 서버 설정
5. **로그 레벨**: `LOG_LEVEL`을 `info` 또는 `warn`으로 변경

## 참고 자료

### 공식 문서
- [Ory Kratos 공식 문서](https://www.ory.sh/docs/kratos/)
- [Ory Kratos GitHub](https://github.com/ory/kratos)
- [Quickstart 가이드](https://www.ory.sh/docs/kratos/quickstart)
- [Self-Service UI](https://www.ory.sh/docs/kratos/self-service)

### API 문서
- [Public API Reference](https://www.ory.sh/docs/kratos/reference/api)
- [Admin API Reference](https://www.ory.sh/docs/kratos/reference/api)

### 개발 리소스
- [UI Node.js GitHub](https://github.com/ory/kratos-selfservice-ui-node)
- [UI React/Next.js GitHub](https://github.com/ory/kratos-selfservice-ui-react-nextjs)
- [Kratos 예제 모음](https://github.com/ory/kratos/tree/master/examples)

### 커뮤니티
- [Ory Community](https://community.ory.sh/)
- [Slack 채널](https://slack.ory.sh/)
- [Ory 블로그](https://www.ory.sh/blog/)

## 라이선스

Ory Kratos는 Apache 2.0 라이선스로 배포됩니다.
