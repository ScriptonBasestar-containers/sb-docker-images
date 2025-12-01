# FlaskBB

> ⚠️ **DEPRECATED**: FlaskBB는 업스트림 개발이 중단된 상태입니다. 프로덕션 사용을 권장하지 않으며, Discourse, Flarum, NodeBB 등의 대안을 고려하세요.

> 💡 **Quick Start**: For production deployment with PostgreSQL and Redis, use the [standalone setup](standalone/README.md) - it includes all services and comprehensive documentation!

## 개요

FlaskBB는 Python과 Flask로 작성된 경량화된 현대적인 포럼 소프트웨어입니다. 심플하면서도 강력한 기능을 제공하는 클래식 스타일의 게시판 플랫폼입니다:
- 🎨 클래식 포럼 스타일의 직관적인 인터페이스
- 👥 사용자 및 그룹 관리
- 🔐 권한 기반 접근 제어
- ✍️ BBCode 및 마크다운 지원
- 🔌 플러그인 시스템
- 🎭 테마 커스터마이징
- 🌐 다국어 지원
- 📱 반응형 디자인
- 🔍 검색 기능
- 💬 프라이빗 메시지

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ FlaskBB (Python/Flask application)
- ✅ PostgreSQL 15 with health check
- ✅ Redis 7 for cache and sessions
- ✅ Network isolation (app-network, data-network)
- ✅ Standardized Makefile with helpful commands
- ✅ Environment variable configuration (.env.example)

**Access:** http://localhost:8250

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default port:** 8250 (see [PORT_STATUS.md](../PORT_STATUS.md))

**Container name:** flaskbb

Environment variables:
```bash
FLASK_APP=flaskbb
FLASK_ENV=production
FLASKBB_SERVER_NAME=localhost:8250
FLASKBB_SECRET_KEY=change-this-to-a-random-secret-key
FLASKBB_DATABASE_URI=postgresql://user01:passw0rd@postgres:5432/db01
FLASKBB_REDIS_URL=redis://redis:6379/0
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8250 | flaskbb | FlaskBB web server |

**Port conflicts:** See [PORT_STATUS.md](../PORT_STATUS.md) for port allocation details.

## 서비스 구성

docker-compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **flaskbb**: FlaskBB 포럼 애플리케이션
  - Flask 기반 웹 서버
  - Gunicorn WSGI 서버
  - 포트 8080 (컨테이너 내부)

- **postgres**: PostgreSQL 15 데이터베이스
  - 사용자 데이터 및 게시물 저장
  - 자동 헬스체크
  - 영구 데이터 저장

- **redis**: Redis 8.2 캐시 서버
  - 세션 관리
  - 캐시 저장소
  - Celery 브로커 (백그라운드 작업)

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8250 | flaskbb | FlaskBB 웹 서버 (권장 포트 사용 중) |

> ✅ **포트 설정**: 이미 권장 포트(8250)를 사용하고 있습니다. ([포트 가이드](../PORT_STATUS.md) 참조)

포트 충돌 방지: [포트 가이드](../PORT_STATUS.md)

## 환경 변수

### Flask 설정

```bash
FLASK_APP=flaskbb
FLASK_ENV=production
```

### FlaskBB 설정

```bash
FLASKBB_SERVER_NAME=localhost:8250
FLASKBB_SECRET_KEY=change-this-to-a-random-secret-key
```

### 데이터베이스 설정

```bash
FLASKBB_DATABASE_URI=postgresql://user01:passw0rd@postgres:5432/db01
```

### Redis 설정

```bash
FLASKBB_REDIS_URL=redis://redis:6379/0
```

### 메일 설정

```bash
FLASKBB_MAIL_SERVER=smtp.gmail.com
FLASKBB_MAIL_PORT=587
FLASKBB_MAIL_USE_TLS=true
FLASKBB_MAIL_USERNAME=your-email@gmail.com
FLASKBB_MAIL_PASSWORD=your-app-password
FLASKBB_MAIL_DEFAULT_SENDER=noreply@example.com
```

## 사용 가능한 명령어

### 서비스 관리

```bash
# 서비스 시작
make up

# 서비스 중지
make down

# 서비스 재시작
make restart

# 로그 확인
make logs

# FlaskBB 컨테이너 쉘 접속
make shell
```

### 데이터베이스 관리

```bash
# 데이터베이스 초기화 (최초 1회)
make db-init

# 데이터베이스 마이그레이션
make db-upgrade

# 완전 초기화 (데이터 삭제)
make clean
```

## 사용법

### 초기 설정

```bash
# 1. 서비스 시작
docker compose up -d

# 2. 데이터베이스 초기화
docker compose exec flaskbb flaskbb install

# 초기 설정 마법사에서 입력:
# - Admin Username: admin
# - Admin Email: admin@example.com
# - Admin Password: (강력한 비밀번호)
# - Forum Title: My Forum
# - Forum Description: A FlaskBB Forum
```

### 관리자 패널 접속

```
1. 브라우저에서 http://localhost:8250 접속
2. 우측 상단 로그인
3. 관리자 계정으로 로그인
4. 상단 메뉴에서 "Admin" 클릭
```

### 플러그인 관리

```bash
# 컨테이너 내부로 진입
docker compose exec flaskbb bash

# 플러그인 설치
pip install flaskbb-plugin-name

# FlaskBB 재시작
exit
docker compose restart flaskbb

# 웹 인터페이스에서
# Admin > Plugins > 플러그인 활성화
```

### 테마 변경

```bash
# 관리자 패널에서
1. Admin > Settings > Themes
2. 원하는 테마 선택
3. Save 클릭

# 커스텀 테마 추가
docker compose exec flaskbb bash
cd /flaskbb/themes
# 테마 파일 추가
```

### 데이터베이스 백업

```bash
# PostgreSQL 백업
docker compose exec postgres pg_dump -U user01 db01 > flaskbb-backup.sql

# 백업 복원
docker compose exec -T postgres psql -U user01 db01 < flaskbb-backup.sql
```

### CLI 명령어

```bash
# FlaskBB CLI 도움말
docker compose exec flaskbb flaskbb --help

# 사용자 생성
docker compose exec flaskbb flaskbb users create -u username -e user@example.com -p password

# 사용자를 관리자로 승격
docker compose exec flaskbb flaskbb users add-role -u username -r admin

# 포럼 설정 확인
docker compose exec flaskbb flaskbb settings list

# 캐시 삭제
docker compose exec flaskbb flaskbb cache clear
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 상태 확인
docker compose logs postgres

# "database system is ready" 확인 후
docker compose restart flaskbb
```

### Redis 연결 오류

```bash
# Redis 상태 확인
docker compose exec redis redis-cli ping
# PONG 응답이 와야 함

# Redis 재시작
docker compose restart redis
docker compose restart flaskbb
```

### FlaskBB가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f flaskbb

# 데이터베이스 초기화 확인
docker compose exec flaskbb flaskbb db current

# 마이그레이션 필요 시
docker compose exec flaskbb flaskbb db upgrade
```

### 관리자 비밀번호 재설정

```bash
# 컨테이너 내부로 진입
docker compose exec flaskbb bash

# Python 쉘 실행
python

# 비밀번호 재설정
from flaskbb.user.models import User
from flaskbb.extensions import db

user = User.query.filter_by(username='admin').first()
user.password = 'new-password'
db.session.commit()
exit()
```

### 권한 오류

```bash
# 업로드 디렉토리 권한 확인
docker compose exec flaskbb ls -la /flaskbb/uploads

# 권한 수정
docker compose exec flaskbb chown -R www-data:www-data /flaskbb/uploads
docker compose restart flaskbb
```

### 마이그레이션 오류

```bash
# 마이그레이션 상태 확인
docker compose exec flaskbb flaskbb db current

# 마이그레이션 히스토리
docker compose exec flaskbb flaskbb db history

# 특정 버전으로 다운그레이드
docker compose exec flaskbb flaskbb db downgrade <revision>

# 다시 업그레이드
docker compose exec flaskbb flaskbb db upgrade
```

### 이메일 발송 실패

```bash
# SMTP 설정 확인
docker compose exec flaskbb env | grep MAIL

# 테스트 이메일 발송
docker compose exec flaskbb flaskbb test-email admin@example.com

# 로그 확인
docker compose logs -f flaskbb
```

### 로그 확인

```bash
# 모든 로그
docker compose logs -f

# FlaskBB 로그만
docker compose logs -f flaskbb

# 로그 파일 (컨테이너 내부)
docker compose exec flaskbb tail -f /flaskbb/logs/flaskbb.log
```

## 디렉토리 구조

```
flaskbb/
├── docker-compose.yml    # Docker Compose 설정
├── Makefile              # 편의 명령어
├── README.md             # 이 문서
└── .gitignore            # Git 제외 파일 목록
```

## 참고 자료

- [FlaskBB 공식 GitHub](https://github.com/flaskbb/flaskbb)
- [FlaskBB 공식 문서](https://flaskbb.readthedocs.io/)
- [FlaskBB 데모 사이트](https://forums.flaskbb.org/)
- [FlaskBB 플러그인](https://github.com/flaskbb)
- [Flask 공식 문서](https://flask.palletsprojects.com/)
- [SQLAlchemy 문서](https://docs.sqlalchemy.org/)

## 기술 스택

- **Backend**: Python 3.x, Flask
- **Database**: PostgreSQL 15
- **Cache**: Redis 8.2
- **ORM**: SQLAlchemy
- **Migration**: Alembic
- **Frontend**: Bootstrap 5
- **Task Queue**: Celery (선택적)
- **Container**: Docker, Docker Compose

## 고급 설정

### 환경 변수 파일 사용

.env 파일 생성:
```bash
# .env
FLASK_ENV=production
FLASKBB_SECRET_KEY=your-secret-key-here
FLASKBB_DATABASE_URI=postgresql://user01:passw0rd@postgres:5432/db01
FLASKBB_REDIS_URL=redis://redis:6379/0
```

docker-compose.yml에서 참조:
```yaml
services:
  flaskbb:
    env_file:
      - .env
```

### HTTPS 설정 (Nginx 리버스 프록시)

nginx.conf 예시:
```nginx
server {
    listen 80;
    server_name forum.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name forum.example.com;

    ssl_certificate /etc/ssl/certs/cert.pem;
    ssl_certificate_key /etc/ssl/private/key.pem;

    location / {
        proxy_pass http://flaskbb:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Celery 백그라운드 작업 설정

docker-compose.yml에 Celery worker 추가:
```yaml
services:
  celery:
    image: flaskbb/flaskbb:latest
    command: celery -A flaskbb.tasks worker --loglevel=info
    environment:
      - FLASKBB_DATABASE_URI=postgresql://user01:passw0rd@postgres:5432/db01
      - FLASKBB_REDIS_URL=redis://redis:6379/0
    depends_on:
      - postgres
      - redis
    networks:
      - flaskbb-network
```

### 성능 최적화

```bash
# Gunicorn worker 수 증가
# docker-compose.yml에서
environment:
  - GUNICORN_WORKERS=4
  - GUNICORN_THREADS=2

# Redis 메모리 제한 설정
redis:
  command: redis-server --maxmemory 256mb --maxmemory-policy allkeys-lru
```

## 주의사항

1. **초기 설정**: 첫 실행 시 반드시 `make db-init`으로 데이터베이스를 초기화해야 합니다.
2. **SECRET_KEY**: 프로덕션 환경에서는 반드시 강력한 랜덤 시크릿 키를 사용하세요.
3. **이메일 설정**: Gmail 사용 시 앱 비밀번호를 생성하여 사용해야 합니다.
4. **백업**: 정기적인 데이터베이스 백업을 권장합니다.
5. **보안**: 프로덕션 환경에서는 HTTPS를 필수로 사용하세요.
6. **포트**: 포트 8250이 다른 서비스와 충돌할 경우 docker-compose.yml에서 변경하세요.

## 시크릿 키 생성

```bash
# Python으로 랜덤 시크릿 키 생성
python -c "import secrets; print(secrets.token_hex(32))"

# 또는
docker compose exec flaskbb python -c "import secrets; print(secrets.token_hex(32))"
```

## 라이선스

FlaskBB는 BSD 3-Clause 라이선스로 배포됩니다.
