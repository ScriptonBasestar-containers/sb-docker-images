# Misago

Misago는 Python과 Django로 작성된 현대적인 포럼 시스템입니다. Reddit과 Discourse에서 영감을 받아 만들어진 완전한 기능을 갖춘 커뮤니티 플랫폼입니다.

## 개요

Misago는 다음과 같은 기능을 제공합니다:
- 현대적인 반응형 디자인
- 실시간 알림 및 업데이트
- 강력한 모더레이션 도구
- 사용자 프로필 및 아바타
- 카테고리 및 스레드 관리
- 검색 및 필터링
- REST API 지원

## 빠른 시작

```bash
# 1. 환경 변수 설정
cp .env.sample .env
# .env 파일을 편집하여 필요한 설정 수정

# 2. 서비스 시작
docker-compose up -d

# 3. 데이터베이스 마이그레이션
docker-compose exec misago python manage.py migrate

# 4. 슈퍼유저 생성
docker-compose exec misago python manage.py createsuperuser

# 5. 정적 파일 수집
docker-compose exec misago python manage.py collectstatic --noinput

# 6. 브라우저에서 접속
# http://localhost (또는 설정한 도메인)
```

## 서비스 구성

docker-compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **nginx-proxy**: Nginx 리버스 프록시 (포트 80, 443)
  - SSL/TLS 지원
  - 정적 파일 서빙
  - uWSGI 프록시

- **postgres**: PostgreSQL 15 데이터베이스
  - 사용자 데이터 저장
  - 포럼 콘텐츠 관리

- **redis**: Redis 8.2 캐시 서버
  - 세션 관리
  - 캐시 저장소
  - Celery 브로커

- **misago**: Django 기반 포럼 애플리케이션
  - uWSGI로 실행
  - 메인 웹 애플리케이션

- **celery-worker**: Celery 백그라운드 작업 처리
  - 이메일 발송
  - 알림 처리
  - 예약 작업

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 80 | nginx-proxy | Misago 웹 사이트 HTTP (현재 설정) |
| 443 | nginx-proxy | Misago 웹 사이트 HTTPS (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 80 포트 사용 중입니다.
>
> **권장 포트**: 8260 ([포트 가이드](../docs/PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # docker-compose.yml 파일에서 수정
> sed -i 's/"80:80"/"8260:80"/' docker-compose.yml
>
> # 또는 직접 편집
> # ports:
> #   - "8260:80"
> #   - "8443:443"
> ```

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

### 데이터베이스 설정

```bash
# PostgreSQL 설정
MISAGO_POSTGRES_HOST=postgres
MISAGO_POSTGRES_DB=db01
MISAGO_POSTGRES_USER=user01
MISAGO_POSTGRES_PASSWORD=passw0rd
```

### 애플리케이션 설정 (.env.sample)

```bash
# Django 기본 설정
SECRET_KEY=<your-secret-key>
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

# 데이터베이스
DATABASE_URL=postgres://user01:passw0rd@postgres:5432/db01

# Redis
REDIS_URL=redis://redis:6379/0

# 이메일 설정
EMAIL_HOST=smtp.example.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@example.com
EMAIL_HOST_PASSWORD=your-password

# 사이트 설정
SITE_NAME=My Forum
SITE_DOMAIN=forum.example.com
```

### SSL/TLS 설정

```bash
# Nginx Proxy 설정
ENABLE_IPV6=true
SSL_POLICY=Mozilla-Modern
VIRTUAL_PROTO=uwsgi
```

## 사용법

### 기본 작업

```bash
# 서비스 시작
docker-compose up -d

# 로그 확인
docker-compose logs -f

# 특정 서비스 로그 확인
docker-compose logs -f misago

# 서비스 재시작
docker-compose restart

# 서비스 중지
docker-compose down

# 서비스 중지 및 볼륨 삭제
docker-compose down -v
```

### 관리 명령어

```bash
# Django 쉘 접속
docker-compose exec misago python manage.py shell

# 데이터베이스 마이그레이션
docker-compose exec misago python manage.py migrate

# 정적 파일 수집
docker-compose exec misago python manage.py collectstatic

# 사용자 생성
docker-compose exec misago python manage.py createsuperuser

# 캐시 삭제
docker-compose exec misago python manage.py clear_cache
```

### 백업 및 복원

```bash
# 데이터베이스 백업
docker-compose exec postgres pg_dump -U user01 db01 > backup.sql

# 데이터베이스 복원
docker-compose exec -T postgres psql -U user01 db01 < backup.sql

# 미디어 파일 백업
tar -czf media-backup.tar.gz ./misago/media/

# 백업 디렉토리
# ./backups/ 디렉토리가 misago 컨테이너에 마운트되어 있습니다
```

### Celery 작업 모니터링

```bash
# Celery worker 상태 확인
docker-compose exec celery-worker celery -A misagodocker inspect stats

# 활성 작업 확인
docker-compose exec celery-worker celery -A misagodocker inspect active

# 예약된 작업 확인
docker-compose exec celery-worker celery -A misagodocker inspect scheduled
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL이 준비될 때까지 기다립니다
docker-compose up -d postgres
docker-compose logs -f postgres

# "database system is ready to accept connections" 메시지 확인 후
docker-compose up -d
```

### 정적 파일이 로드되지 않음

```bash
# 정적 파일 재수집
docker-compose exec misago python manage.py collectstatic --noinput

# Nginx 재시작
docker-compose restart nginx-proxy
```

### 권한 오류

```bash
# 미디어 및 정적 파일 디렉토리 권한 확인
chmod -R 755 ./misago/media
chmod -R 755 ./misago/static

# SELinux 레이블 재설정 (Fedora/RHEL/CentOS)
chcon -R -t svirt_sandbox_file_t ./misago/media
chcon -R -t svirt_sandbox_file_t ./misago/static
```

### Celery worker가 작업을 처리하지 않음

```bash
# Celery worker 로그 확인
docker-compose logs -f celery-worker

# Redis 연결 확인
docker-compose exec redis redis-cli ping

# Celery worker 재시작
docker-compose restart celery-worker
```

### 메모리 부족

```bash
# 각 서비스의 메모리 사용량 확인
docker stats

# docker-compose.yml에 메모리 제한 추가
services:
  misago:
    mem_limit: 1g
  celery-worker:
    mem_limit: 512m
```

### 로그 확인

```bash
# 모든 로그는 ./logs 디렉토리에 저장됩니다
ls -la ./logs/

# Nginx 로그
tail -f ./logs/nginx/access.log
tail -f ./logs/nginx/error.log

# Misago 애플리케이션 로그
docker-compose logs -f misago
```

## 참고 자료

- [Misago 공식 GitHub](https://github.com/rafalp/Misago)
- [Misago 공식 문서](https://misago-project.org/)
- [Misago 데모 사이트](https://misago-project.org/demo/)
- [Django 공식 문서](https://docs.djangoproject.com/)
- [Celery 공식 문서](https://docs.celeryproject.org/)
- [PostgreSQL 공식 문서](https://www.postgresql.org/docs/)
- [Redis 공식 문서](https://redis.io/documentation)

## 기술 스택

- **Backend**: Python 3.x, Django
- **Frontend**: React, TypeScript
- **Database**: PostgreSQL 15
- **Cache**: Redis 8.2
- **Task Queue**: Celery
- **Web Server**: Nginx, uWSGI
- **Container**: Docker, Docker Compose

## 라이선스

Misago는 GPL v2 라이선스로 배포됩니다.
