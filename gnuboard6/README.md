# Gnuboard6 - 한국형 CMS (Python/Django)

**Gnuboard6**는 Python/Django 기반의 한국형 CMS입니다. 그누보드 5의 차세대 버전으로 개발 중입니다.

> **⚠️ 개발 중**: Gnuboard6는 현재 개발 단계이며 프로덕션 사용은 권장하지 않습니다.

## 주요 기능

- **Python/Django 기반**: 현대적인 웹 프레임워크
- **한국형 게시판**: 그누보드 5의 기능 계승
- **REST API**: RESTful API 제공
- **관리자 패널**: Django Admin 활용
- **MySQL/MariaDB**: 데이터베이스 지원

## 시스템 요구사항

| 항목 | 사양 |
|------|------|
| **메모리** | 512MB 최소, 1GB 권장 |
| **CPU** | 1코어 |
| **스토리지** | 5GB+ |
| **Database** | MariaDB 11+ / MySQL 8+ |
| **Python** | 3.9+ |

## Quick Start

### 1. 서비스 시작

```bash
docker compose up -d
```

### 2. 웹 UI 접속

브라우저에서 http://localhost:8080 접속

### 3. 초기 설정

Django 마이그레이션 및 관리자 생성:

```bash
# 마이그레이션 실행
docker exec gnuboard6 python manage.py migrate

# 슈퍼유저 생성
docker exec -it gnuboard6 python manage.py createsuperuser
```

## 환경 설정

### 주요 환경 변수

```yaml
services:
  gnuboard6:
    environment:
      # 데이터베이스
      - DB_ENGINE=django.db.backends.mysql
      - DB_NAME=gnuboard6
      - DB_USER=gnuboard
      - DB_PASSWORD=your-password
      - DB_HOST=mariadb
      - DB_PORT=3306

      # Django 설정
      - SECRET_KEY=your-secret-key-change-in-production
      - DEBUG=false  # 프로덕션에서는 false
      - ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
```

> **⚠️ 보안 경고**: 프로덕션 환경에서는 반드시:
> 1. SECRET_KEY 변경
> 2. DEBUG=false 설정
> 3. ALLOWED_HOSTS 설정
> 4. 데이터베이스 비밀번호 변경

## 데이터베이스 관리

### Django 마이그레이션

```bash
# 마이그레이션 생성
docker exec gnuboard6 python manage.py makemigrations

# 마이그레이션 적용
docker exec gnuboard6 python manage.py migrate

# 마이그레이션 상태 확인
docker exec gnuboard6 python manage.py showmigrations
```

### 데이터베이스 백업

```bash
# MariaDB 백업
docker exec gnuboard6-mariadb mysqldump -u gnuboard -ppassw0rd gnuboard6 | gzip > gnuboard6-backup-$(date +%Y%m%d).sql.gz
```

### 데이터베이스 복원

```bash
# 백업 복원
gunzip < gnuboard6-backup-YYYYMMDD.sql.gz | docker exec -i gnuboard6-mariadb mysql -u gnuboard -ppassw0rd gnuboard6
```

## Django 관리

### 관리자 페널

http://localhost:8080/admin 접속

### 슈퍼유저 관리

```bash
# 슈퍼유저 생성
docker exec -it gnuboard6 python manage.py createsuperuser

# 비밀번호 변경
docker exec -it gnuboard6 python manage.py changepassword username
```

### 정적 파일 수집

```bash
# 정적 파일 수집 (프로덕션 배포 시)
docker exec gnuboard6 python manage.py collectstatic --noinput
```

### Django Shell

```bash
# Django Shell 실행
docker exec -it gnuboard6 python manage.py shell

# 예제: 사용자 목록 조회
>>> from django.contrib.auth.models import User
>>> User.objects.all()
```

## 개발 환경

### 로그 확인

```bash
# 애플리케이션 로그
docker logs -f gnuboard6

# 데이터베이스 로그
docker logs -f gnuboard6-mariadb
```

### 컨테이너 재시작

```bash
# Gnuboard6만 재시작
docker compose restart gnuboard6

# 전체 재시작
docker compose restart
```

### 코드 수정 반영

```bash
# DEBUG=true 일 때는 자동 반영
# 프로덕션에서는 재시작 필요
docker compose restart gnuboard6
```

## 프로덕션 배포

### 1. 환경 변수 설정

`.env` 파일 생성:

```env
SECRET_KEY=your-very-long-random-secret-key-here
DEBUG=false
ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
DB_PASSWORD=strong-database-password
MYSQL_ROOT_PASSWORD=strong-root-password
```

### 2. compose.yml 수정

```yaml
services:
  gnuboard6:
    env_file:
      - .env
    environment:
      - DEBUG=false
```

### 3. 정적 파일 처리

```bash
docker exec gnuboard6 python manage.py collectstatic --noinput
```

### 4. HTTPS 설정 (Nginx)

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com;

    ssl_certificate /etc/ssl/certs/yourdomain.com.crt;
    ssl_certificate_key /etc/ssl/private/yourdomain.com.key;

    client_max_body_size 20M;

    # 정적 파일
    location /static/ {
        alias /path/to/static/;
        expires 30d;
    }

    # 미디어 파일
    location /media/ {
        alias /path/to/media/;
        expires 30d;
    }

    # 애플리케이션
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 문제 해결

### 데이터베이스 연결 실패

```bash
# MariaDB 상태 확인
docker exec gnuboard6-mariadb healthcheck.sh --connect

# 로그 확인
docker logs gnuboard6-mariadb

# 재시작
docker compose restart mariadb
```

### 마이그레이션 오류

```bash
# 마이그레이션 리셋 (주의: 데이터 손실!)
docker exec gnuboard6 python manage.py migrate --fake-initial

# 또는 데이터베이스 재생성
docker compose down -v
docker compose up -d
docker exec gnuboard6 python manage.py migrate
```

### 정적 파일 404 에러

```bash
# 정적 파일 재수집
docker exec gnuboard6 python manage.py collectstatic --noinput --clear

# 볼륨 확인
docker volume inspect gnuboard6_gnuboard6-static
```

## Makefile 명령어

```bash
make up       # 서비스 시작
make down     # 서비스 중지
make logs     # 로그 확인
make restart  # 재시작
make clean    # 데이터 삭제 (주의!)
```

## 참고 자료

### 공식
- [Gnuboard6 GitHub](https://github.com/gnuboard/g6)
- [Django Documentation](https://docs.djangoproject.com/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)

### 커뮤니티
- [그누보드 공식 사이트](https://sir.kr/)
- [그누보드 커뮤니티](https://sir.kr/bbs/gnuboard5)

## 주의사항

### 개발 상태

Gnuboard6는 **개발 중**입니다:
- API 변경 가능성
- 기능 불완전
- 프로덕션 사용 비권장

### 그누보드 5 대안

프로덕션 사용이 필요하다면:
- **Gnuboard5**: 안정적인 PHP 기반 버전
- 위치: `../gnuboard5/`

## 개발 로드맵

Gnuboard6 목표:
- Python/Django 기반 현대화
- REST API 우선 설계
- 모바일 친화적 UI
- 클라우드 네이티브 아키텍처

## 라이선스

Gnuboard6는 GPL 라이선스로 배포됩니다.

## 관련 프로젝트

- **Gnuboard5**: PHP 기반 안정 버전
- **Django CMS**: Django 기반 CMS
- **Wagtail**: Django 기반 현대적 CMS
