# 그누보드6 (Gnuboard 6)

그누보드6 Python 기반 차세대 게시판 시스템

## 개요

그누보드6는 한국에서 가장 인기 있는 그누보드5의 후속 버전으로, Python(Django/FastAPI)으로 완전히 재작성된 차세대 게시판 시스템입니다. 기존 PHP 기반에서 Python으로 전환하여 더 나은 성능과 확장성을 제공합니다.

## 빠른 시작

```bash
# 그누보드6 소스 코드 다운로드
make setup

# Docker 이미지 빌드
make build_debian

# 컨테이너 시작
docker-compose up -d

# 웹 브라우저로 접속
# http://localhost:8210

# 데이터베이스 마이그레이션
docker-compose exec gnuboard6 python manage.py migrate

# 관리자 계정 생성
docker-compose exec gnuboard6 python manage.py createsuperuser
```

## 서비스 구성

- **gnuboard6**: 그누보드6 애플리케이션 (포트 8210)
- **mariadb**: MariaDB 11.8 데이터베이스
- **phpmyadmin**: 데이터베이스 관리 (선택사항, 포트 8211)

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8210 | gnuboard6 | 웹 사이트 |
| 8211 | phpmyadmin | DB 관리 (선택사항) |

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

※ 참고: docker-compose.yml에서는 8080 포트를 사용하지만, PORT_GUIDE.md의 표준에 따라 8210 포트 사용을 권장합니다.

## 환경 변수

docker-compose.yml에서 설정:

```yaml
environment:
  # 데이터베이스 설정
  - DB_ENGINE=django.db.backends.mysql
  - DB_NAME=gnuboard6
  - DB_USER=gnuboard
  - DB_PASSWORD=passw0rd
  - DB_HOST=mariadb
  - DB_PORT=3306

  # Django 설정
  - SECRET_KEY=change-me-in-production
  - DEBUG=true
  - ALLOWED_HOSTS=localhost,127.0.0.1
```

## 디렉토리 구조

```
gnuboard6/
├── docker-compose.yml           # Docker Compose 설정
├── gnuboard6-debian.dockerfile  # Dockerfile
├── Makefile                     # 빌드 스크립트
├── setup_debian.sh              # 설정 스크립트
├── README.md                    # 이 문서
└── app/                         # 그누보드6 소스 (클론됨)
    ├── main.py
    ├── requirements.txt
    └── ...
```

## 설치 방법

### 1. 그누보드6 다운로드

```bash
# Makefile을 사용한 자동 설치
make setup

# 또는 수동 설치
git clone https://github.com/gnuboard/g6.git --depth 1 app
```

### 2. Docker 이미지 빌드

```bash
make build_debian
# 또는
docker build -f gnuboard6-debian.dockerfile -t gnuboard6 .
```

### 3. 컨테이너 실행

```bash
docker-compose up -d
```

### 4. 데이터베이스 초기화

```bash
# 마이그레이션 실행
docker-compose exec gnuboard6 python manage.py migrate

# 관리자 계정 생성
docker-compose exec gnuboard6 python manage.py createsuperuser
```

## 사용법

### 관리자 페이지

```
URL: http://localhost:8210/admin
ID: createsuperuser 명령으로 생성한 계정
PW: createsuperuser 명령으로 설정한 비밀번호
```

### 메인 페이지

```
URL: http://localhost:8210
```

### Python 쉘 접속

```bash
docker-compose exec gnuboard6 python manage.py shell
```

### 정적 파일 수집

```bash
docker-compose exec gnuboard6 python manage.py collectstatic --noinput
```

## 데이터베이스 관리

### phpMyAdmin 접속

```
URL: http://localhost:8211
서버: mariadb
사용자: root
비밀번호: rootpass
```

### 데이터베이스 백업

```bash
# 백업
docker-compose exec mariadb mysqldump -u root -prootpass gnuboard6 > backup.sql

# 복원
docker-compose exec -T mariadb mysql -u root -prootpass gnuboard6 < backup.sql
```

### 마이그레이션 관리

```bash
# 마이그레이션 생성
docker-compose exec gnuboard6 python manage.py makemigrations

# 마이그레이션 적용
docker-compose exec gnuboard6 python manage.py migrate

# 마이그레이션 상태 확인
docker-compose exec gnuboard6 python manage.py showmigrations
```

## 볼륨

```yaml
volumes:
  - gnuboard6-media:/app/media    # 업로드 파일
  - gnuboard6-static:/app/static  # 정적 파일
  - mariadb-data:/var/lib/mysql   # 데이터베이스
```

## 네트워크

```yaml
networks:
  - app-network  # 애플리케이션 레이어
  - db-network   # 데이터베이스 레이어
```

## 문제 해결

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker-compose logs -f gnuboard6

# 컨테이너 재시작
docker-compose restart gnuboard6
```

### 데이터베이스 연결 실패

```bash
# MariaDB 컨테이너 상태 확인
docker-compose ps mariadb

# 헬스체크 확인
docker-compose exec mariadb healthcheck.sh --connect --innodb_initialized

# 재시작
docker-compose restart mariadb

# 설치 시 DB 정보 확인:
# Host: mariadb (localhost 아님!)
# Database: gnuboard6
# User: gnuboard
# Password: passw0rd
```

### 정적 파일이 로드되지 않음

```bash
# 정적 파일 수집
docker-compose exec gnuboard6 python manage.py collectstatic --noinput

# 권한 확인
docker-compose exec gnuboard6 ls -la /app/static
```

### 미디어 파일 업로드 실패

```bash
# 미디어 디렉토리 권한 확인
docker-compose exec gnuboard6 mkdir -p /app/media
docker-compose exec gnuboard6 chmod -R 755 /app/media
```

### 한글이 깨짐

```bash
# DB charset 확인
docker-compose exec mariadb mysql -u root -prootpass -e "SHOW VARIABLES LIKE 'character%';"

# utf8mb4로 변경
docker-compose exec mariadb mysql -u root -prootpass gnuboard6 -e "
  ALTER DATABASE gnuboard6 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
"
```

## 포트 변경 방법

PORT_GUIDE.md의 표준 포트(8210)로 변경:

```yaml
# docker-compose.yml 수정
services:
  gnuboard6:
    ports:
      - "8210:8000"  # 기존 8080:8000에서 변경
```

## 보안 설정

### 1. SECRET_KEY 변경

프로덕션에서는 반드시 강력한 SECRET_KEY 사용:

```yaml
environment:
  - SECRET_KEY=강력하고긴랜덤문자열
```

### 2. DEBUG 모드 비활성화

```yaml
environment:
  - DEBUG=false
```

### 3. ALLOWED_HOSTS 설정

```yaml
environment:
  - ALLOWED_HOSTS=yourdomain.com,www.yourdomain.com
```

### 4. 데이터베이스 비밀번호 변경

```yaml
environment:
  - MYSQL_ROOT_PASSWORD=강력한비밀번호
  - DB_PASSWORD=강력한비밀번호
```

## 개발 환경

### 로그 확인

```bash
docker-compose logs -f gnuboard6
```

### 컨테이너 내부 접속

```bash
docker-compose exec gnuboard6 bash
```

### 의존성 추가

```bash
# requirements.txt 수정 후
docker-compose exec gnuboard6 pip install -r requirements.txt
```

## 프로덕션 배포

### 1. 환경 변수 수정

```yaml
environment:
  - DEBUG=false
  - SECRET_KEY=강력한시크릿키
  - ALLOWED_HOSTS=yourdomain.com
  - DB_PASSWORD=강력한비밀번호
```

### 2. HTTPS 설정

Nginx 리버스 프록시 사용 권장

### 3. 정적 파일 서빙

```bash
docker-compose exec gnuboard6 python manage.py collectstatic --noinput
```

## 기술 스택

- **Python**: 3.9+
- **Framework**: Django / FastAPI (uvicorn)
- **Database**: MariaDB 11.8
- **Server**: Uvicorn (ASGI)

## 참고 자료

- [그누보드6 GitHub](https://github.com/gnuboard/g6)
- [그누보드 공식 사이트](https://www.gnuboard.com/)
- [그누보드 커뮤니티](https://sir.kr/)
- [Django 문서](https://docs.djangoproject.com/)
- [FastAPI 문서](https://fastapi.tiangolo.com/)

## 관련 프로젝트

- [gnuboard5](../gnuboard5/README.md) - 그누보드5 (PHP 버전)
- [xpressengine](../xpressengine/README.md) - XE
- [tsboard](../tsboard/README.md) - TypeScript 게시판

## 라이선스

그누보드6는 GPL 라이선스를 따릅니다.

## 주의사항

- 그누보드6는 현재 개발 중인 프로젝트입니다.
- 프로덕션 사용 전 충분한 테스트가 필요합니다.
- 그누보드5와는 호환되지 않으므로 별도 설치가 필요합니다.
- Python/Django 환경에서 동작하므로 기존 PHP 플러그인은 사용할 수 없습니다.
