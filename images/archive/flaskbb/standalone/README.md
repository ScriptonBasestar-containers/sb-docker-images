# FlaskBB Standalone Configuration

완전한 독립 실행 가능한 FlaskBB 포럼 시스템 구성

## 개요

이 standalone 구성은 FlaskBB 포럼을 모든 필수 서비스(PostgreSQL, Redis)와 함께 즉시 실행할 수 있도록 구성되어 있습니다.

### 포함된 서비스

- **FlaskBB**: Flask 기반 포럼 애플리케이션 (포트 8250)
- **PostgreSQL 15**: 메인 데이터베이스 (Alpine)
- **Redis 7**: 캐시 및 세션 저장소 (Alpine)

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env 파일 생성
cp .env.example .env

# 필수 항목 수정
# - FLASKBB_SECRET_KEY: 랜덤한 32자 이상의 시크릿 키
# - POSTGRES_PASSWORD: 강력한 데이터베이스 비밀번호
# - FLASKBB_MAIL_*: SMTP 메일 설정 (선택사항)
```

### 2. 서비스 시작

```bash
# 모든 서비스 시작
make up

# 또는 docker compose 직접 사용
docker compose up -d
```

### 3. 데이터베이스 초기화

```bash
# 데이터베이스 초기화
make db-init

# 또는 직접 실행
docker compose exec flaskbb flask flaskbb install
```

### 4. 관리자 계정 생성

```bash
# 관리자 계정 생성
make create-admin

# 또는 직접 실행
docker compose exec flaskbb flask flaskbb create-admin
```

프롬프트에 따라 관리자 정보 입력:
- Username
- Email
- Password

### 5. 접속

웹 브라우저에서 다음 주소로 접속:

```
http://localhost:8250
```

## 사용 가능한 명령어

### 서비스 관리

```bash
# 서비스 시작
make up

# 서비스 중지
make down

# 로그 확인 (모든 서비스)
make logs

# FlaskBB 로그만 확인
make logs-app

# 서비스 재시작
make restart

# 실행 중인 컨테이너 확인
make ps
```

### 데이터베이스 관리

```bash
# 데이터베이스 마이그레이션
make db-upgrade

# 데이터베이스 초기화 (첫 실행 시)
make db-init

# 관리자 계정 생성
make create-admin
```

### 쉘 접속

```bash
# FlaskBB 컨테이너 쉘
make shell

# PostgreSQL 쉘
make db-shell

# Redis CLI
make redis-shell
```

### 데이터 정리

```bash
# 모든 데이터 삭제 (⚠️ 주의: 복구 불가능)
make clean
```

## 서비스 구성

### 네트워크 구조

```
┌─────────────────┐
│    FlaskBB      │ :8250
│  (Flask Forum)  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌────────┐ ┌────────┐
│PostgreS│ │ Redis  │
│  QL 15 │ │   7    │
└────────┘ └────────┘
```

### 네트워크

- **app-network**: FlaskBB 애플리케이션
- **data-network**: 데이터베이스 및 캐시 통신

### 볼륨

| 볼륨 | 용도 |
|------|------|
| postgres-data | PostgreSQL 데이터 영구 저장 |
| redis-data | Redis 데이터 영구 저장 (AOF) |
| flaskbb-uploads | 업로드된 파일 저장 |
| flaskbb-logs | 애플리케이션 로그 |

### 포트

| 서비스 | 내부 포트 | 외부 포트 |
|--------|----------|----------|
| FlaskBB | 8080 | 8250 |
| PostgreSQL | 5432 | (내부 전용) |
| Redis | 6379 | (내부 전용) |

## 환경 변수

### 필수 환경 변수

```bash
# Flask 시크릿 키 (32자 이상)
FLASKBB_SECRET_KEY=your-random-secret-key

# PostgreSQL 설정
POSTGRES_DB=db01
POSTGRES_USER=user01
POSTGRES_PASSWORD=your-strong-password
```

### 선택적 환경 변수

```bash
# SMTP 메일 설정 (회원가입, 알림 등)
FLASKBB_MAIL_SERVER=smtp.gmail.com
FLASKBB_MAIL_PORT=587
FLASKBB_MAIL_USE_TLS=true
FLASKBB_MAIL_USERNAME=your-email@gmail.com
FLASKBB_MAIL_PASSWORD=your-app-password
FLASKBB_MAIL_DEFAULT_SENDER=noreply@example.com
```

## 주요 기능

### 포럼 기능

- 게시판 및 카테고리 관리
- 스레드 및 게시물 작성
- 사용자 프로필 및 권한 관리
- 개인 메시지
- 알림 시스템
- 검색 기능

### 관리자 기능

- 사용자 관리
- 포럼 설정
- 플러그인 관리
- 테마 커스터마이징
- 모더레이션 도구

## 설정

### SMTP 메일 설정 (Gmail 예시)

1. Gmail 2단계 인증 활성화
2. 앱 비밀번호 생성: https://myaccount.google.com/apppasswords
3. `.env` 파일에 설정:

```bash
FLASKBB_MAIL_SERVER=smtp.gmail.com
FLASKBB_MAIL_PORT=587
FLASKBB_MAIL_USE_TLS=true
FLASKBB_MAIL_USERNAME=your-email@gmail.com
FLASKBB_MAIL_PASSWORD=your-app-password
```

### 플러그인 설치

```bash
# FlaskBB 컨테이너 접속
make shell

# 플러그인 설치 예시
pip install flaskbb-plugin-name

# FlaskBB 재시작
exit
make restart
```

### 테마 변경

관리자 패널에서 설정 가능:
1. http://localhost:8250/admin 접속
2. 'Appearance' 또는 'Settings' 메뉴
3. 원하는 테마 선택 및 적용

## 백업 및 복원

### 데이터베이스 백업

```bash
# PostgreSQL 덤프 생성
docker compose exec postgres pg_dump -U user01 db01 > backup.sql

# 또는 커스텀 포맷으로 백업
docker compose exec postgres pg_dump -U user01 -Fc db01 > backup.dump
```

### 데이터베이스 복원

```bash
# SQL 파일에서 복원
docker compose exec -T postgres psql -U user01 db01 < backup.sql

# 또는 커스텀 포맷에서 복원
docker compose exec -T postgres pg_restore -U user01 -d db01 < backup.dump
```

### 업로드 파일 백업

```bash
# 업로드 볼륨 백업
docker run --rm \
  -v flaskbb-uploads:/source \
  -v $(pwd):/backup \
  alpine tar czf /backup/uploads-backup.tar.gz -C /source .

# 복원
docker run --rm \
  -v flaskbb-uploads:/target \
  -v $(pwd):/backup \
  alpine tar xzf /backup/uploads-backup.tar.gz -C /target
```

## 문제 해결

### FlaskBB가 시작되지 않는 경우

```bash
# 로그 확인
make logs-app

# PostgreSQL 상태 확인
docker compose ps postgres

# 데이터베이스 초기화 재시도
make db-init
```

### 데이터베이스 연결 오류

```bash
# PostgreSQL 헬스체크 확인
docker compose ps

# PostgreSQL 로그 확인
docker compose logs postgres

# 데이터베이스 재시작
docker compose restart postgres
```

### 관리자 비밀번호 재설정

```bash
# FlaskBB 컨테이너 접속
make shell

# Flask shell 실행
flask shell

# 비밀번호 재설정 (Python 코드)
>>> from flaskbb.user.models import User
>>> user = User.query.filter_by(username='admin').first()
>>> user.password = 'new_password'
>>> user.save()
>>> exit()
```

### 메일이 발송되지 않는 경우

1. SMTP 설정 확인:
   ```bash
   # .env 파일의 FLASKBB_MAIL_* 설정 확인
   cat .env | grep MAIL
   ```

2. 테스트 메일 발송:
   ```bash
   make shell
   flask shell
   >>> from flask_mail import Mail, Message
   >>> mail = Mail()
   >>> msg = Message("Test", recipients=["test@example.com"])
   >>> mail.send(msg)
   ```

3. Gmail 앱 비밀번호 확인

## 업그레이드

### FlaskBB 버전 업그레이드

```bash
# 최신 이미지 가져오기
docker compose pull flaskbb

# 서비스 중지
make down

# 데이터베이스 백업 (중요!)
docker compose exec postgres pg_dump -U user01 db01 > backup-$(date +%Y%m%d).sql

# 서비스 재시작
make up

# 데이터베이스 마이그레이션
make db-upgrade
```

## 보안 권장사항

### 프로덕션 배포 시

1. **시크릿 키 변경**
   ```bash
   # 강력한 랜덤 키 생성
   openssl rand -hex 32
   ```

2. **데이터베이스 비밀번호 변경**
   ```bash
   # 강력한 비밀번호 생성
   openssl rand -base64 32
   ```

3. **HTTPS 설정**
   - Nginx/Caddy 리버스 프록시 사용
   - Let's Encrypt SSL 인증서 적용

4. **방화벽 설정**
   - 8250 포트만 외부 접근 허용
   - PostgreSQL/Redis 포트는 내부만 접근

5. **정기 백업**
   - 데이터베이스 일일 백업
   - 업로드 파일 주간 백업

## 성능 최적화

### Redis 캐싱 활용

FlaskBB는 Redis를 캐시로 사용하여 성능을 향상시킵니다.

### PostgreSQL 튜닝

프로덕션 환경에서는 PostgreSQL 설정 조정:

```yaml
# compose.yml
postgres:
  command:
    - postgres
    - -c
    - shared_buffers=256MB
    - -c
    - effective_cache_size=1GB
    - -c
    - max_connections=100
```

### 리소스 제한

```yaml
# compose.yml
services:
  flaskbb:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          memory: 512M
```

## 참고 자료

- [FlaskBB 공식 사이트](https://flaskbb.org/)
- [FlaskBB 문서](https://flaskbb.readthedocs.io/)
- [FlaskBB GitHub](https://github.com/flaskbb/flaskbb)
- [Flask 문서](https://flask.palletsprojects.com/)
- [Docker Compose 문서](https://docs.docker.com/compose/)
- [포트 가이드](../../docs/PORT_STATUS.md)

## 라이센스

FlaskBB는 BSD License를 따릅니다.
