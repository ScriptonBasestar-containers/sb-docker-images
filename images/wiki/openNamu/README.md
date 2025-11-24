# openNAMU

openNAMU는 the seed 엔진 기반의 한국어 위키 소프트웨어입니다. Python과 Flask로 작성되었으며, 나무위키 스타일의 문법을 지원합니다.

> 💡 **Quick Start**: This project provides a basic `compose.yml` for development. For complete examples and production setup, see the quick start methods below.

## 개요

openNAMU는 다음과 같은 기능을 제공합니다:
- 📝 the seed 문법 지원 (나무위키 호환)
- 🐍 Python/Flask 기반의 가벼운 구조
- 💾 SQLite 또는 MariaDB 지원
- 📁 다양한 네임스페이스
- 📜 문서 역사 및 편집 추적
- 🔒 ACL (접근 제어)
- 🎨 테마 커스터마이징
- 🇰🇷 한국어 최적화
- 🔗 RESTful API

## Deployment Options

### 🔧 Basic Setup (Minimal Configuration)

This directory includes a minimal `compose.yml` for development with external MariaDB.

**Prerequisites:**
- External MariaDB database (running separately)

### 📦 Docker Compose (Recommended)

Complete setup using the examples below - includes all dependencies.

## 빠른 시작

### 방법 1: 공식 Docker 이미지 사용

```bash
# 1. openNAMU 디렉토리 생성
mkdir -p data

# 2. Docker로 실행 (SQLite 사용)
docker run -d \
  --name opennamu \
  -p 8330:3000 \
  -v $(pwd)/data:/app/data \
  namu/opennamu:latest

# 3. 브라우저에서 접속
# http://localhost:8330

# 4. 초기 설정
# - 관리자 계정 생성
# - 위키 이름 설정
# - 기본 설정 완료
```

### 방법 2: Docker Compose 사용 (권장)

아래 내용으로 `docker-compose.yml` 파일을 생성하세요:

```yaml
services:
  opennamu:
    image: namu/opennamu:latest
    container_name: opennamu
    restart: unless-stopped
    ports:
      - "8330:3000"
    volumes:
      - opennamu-data:/app/data
    environment:
      # 데이터베이스 설정 (SQLite 사용 시 생략 가능)
      # - DB_TYPE=mysql
      # - DB_HOST=mariadb
      # - DB_PORT=3306
      # - DB_NAME=opennamu
      # - DB_USER=opennamu
      # - DB_PASSWORD=password

      # 관리자 설정 (선택사항)
      # - ADMIN_PASSWORD=admin123

      # 언어 설정
      - LANGUAGE=ko_KR
    # depends_on:
    #   - mariadb

  # MariaDB (선택사항 - MySQL 사용 시)
  # mariadb:
  #   image: mariadb:10.11
  #   container_name: opennamu-db
  #   restart: unless-stopped
  #   environment:
  #     - MYSQL_ROOT_PASSWORD=rootpassword
  #     - MYSQL_DATABASE=opennamu
  #     - MYSQL_USER=opennamu
  #     - MYSQL_PASSWORD=password
  #   volumes:
  #     - mariadb-data:/var/lib/mysql

volumes:
  opennamu-data:
  # mariadb-data:
```

실행:

```bash
# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# 서비스 중지
docker compose down
```

### 방법 3: 소스에서 빌드

```bash
# 1. 공식 리포지토리 클론
git clone https://github.com/openNAMU/openNAMU.git
cd openNAMU

# 2. Docker 이미지 빌드
docker build -t opennamu-custom .

# 3. 실행
docker run -d \
  --name opennamu \
  -p 8330:3000 \
  -v $(pwd)/data:/app/data \
  opennamu-custom
```

## 서비스 구성

기본 Docker Compose 구성에는 다음 서비스가 포함됩니다:

- **opennamu**: openNAMU 위키 애플리케이션
  - Python/Flask 기반
  - 웹 UI 제공
  - API 서버
  - the seed 문법 파서

- **mariadb** (선택사항): MariaDB 데이터베이스
  - 위키 데이터 저장
  - SQLite 대신 사용 가능
  - 다중 사용자 환경에 권장

## Default Configuration

**Default port:** 8330 (recommended port - see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** opennamu

Environment variables (.env recommended):

```bash
OPENNAMU_PORT=8330
OPENNAMU_CONTAINER_NAME=opennamu
```

**Port change method** (if needed):

```yaml
services:
  opennamu:
    ports:
      - "${OPENNAMU_PORT:-8330}:3000"  # Use environment variable
```

## 환경 변수

### 데이터베이스 설정 (MariaDB 사용 시)

```yaml
environment:
  DB_TYPE: mysql              # 데이터베이스 타입 (sqlite 또는 mysql)
  DB_HOST: mariadb            # 데이터베이스 호스트
  DB_PORT: 3306               # 데이터베이스 포트
  DB_NAME: opennamu           # 데이터베이스 이름
  DB_USER: opennamu           # 데이터베이스 사용자
  DB_PASSWORD: password       # 데이터베이스 비밀번호
```

### openNAMU 설정

```yaml
environment:
  # 언어 설정
  LANGUAGE: ko_KR             # 한국어

  # 관리자 설정 (선택사항)
  ADMIN_PASSWORD: admin123    # 기본 관리자 비밀번호

  # 서버 설정
  HOST: 0.0.0.0               # 바인드 주소
  PORT: 3000                  # 포트 (컨테이너 내부)

  # 기타 설정 (config.json에서도 설정 가능)
  # WIKI_NAME: "내 위키"
  # WIKI_DESCRIPTION: "위키 설명"
```

### 추가 환경 변수 (선택사항)

```yaml
environment:
  # 업로드 설정
  MAX_FILE_SIZE: 10485760     # 10MB

  # 캐싱
  CACHE_TYPE: redis           # redis 또는 simple
  REDIS_HOST: redis
  REDIS_PORT: 6379

  # 보안 설정
  SECRET_KEY: your-secret-key
```

## Makefile Commands

This basic setup uses `docker compose` commands directly:

```bash
docker compose up -d      # Start openNAMU
docker compose down       # Stop openNAMU
docker compose logs -f    # View logs
docker compose restart    # Restart openNAMU
docker compose ps         # List containers
docker compose exec opennamu bash  # Access container shell
```

## 사용법

### 기본 작업

```bash
# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# openNAMU 로그만 확인
docker compose logs -f opennamu

# 서비스 재시작
docker compose restart

# 서비스 중지
docker compose down

# 서비스 중지 및 데이터 삭제
docker compose down -v
```

### 초기 설정

1. http://localhost:8330 접속
2. 초기 설정 화면에서 다음을 입력:
   - 관리자 계정 정보
   - 위키 이름 및 설명
   - 데이터베이스 설정 (환경 변수 사용 시 자동)
3. 설정 완료 후 로그인
4. 관리 페이지에서 추가 설정

### 위키 문법 (the seed)

openNAMU는 나무위키와 동일한 the seed 문법을 사용합니다:

```
= 대제목 =
== 중제목 ==
=== 소제목 ===

'''굵게''' ''기울임'' --취소선-- __밑줄__

[[문서명]] - 내부 링크
[[문서명|표시 텍스트]] - 내부 링크 (표시 텍스트)
[https://example.com 외부 링크]

* 순서 없는 목록
 * 들여쓰기
  * 더 들여쓰기

1. 순서 있는 목록
 1. 들여쓰기

> 인용문

{{{#!syntax python
def hello():
    print("Hello, World!")
}}}

[[파일:이미지.png]]
```

### 설정 파일 관리

```bash
# 컨테이너 내부 접속
docker compose exec opennamu bash

# 설정 파일 위치
cd /app
cat config.json

# 설정 수정 (웹 UI에서 권장)
# 또는 config.json 직접 편집
vi config.json

# 서비스 재시작
exit
docker compose restart opennamu
```

### 데이터 백업

```bash
# SQLite 사용 시
docker run --rm -v opennamu_opennamu-data:/data -v $(pwd):/backup \
  alpine tar czf /backup/opennamu-backup-$(date +%Y%m%d).tar.gz /data

# MariaDB 사용 시
docker exec opennamu-db mysqldump -u opennamu -ppassword opennamu > backup-$(date +%Y%m%d).sql

# 전체 백업 (데이터 + 이미지)
mkdir -p backups
docker run --rm -v opennamu_opennamu-data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/opennamu-data-$(date +%Y%m%d).tar.gz /data
```

### 데이터 복원

```bash
# SQLite 복원
docker run --rm -v opennamu_opennamu-data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/opennamu-backup-20250117.tar.gz -C /

# MariaDB 복원
docker exec -i opennamu-db mysql -u opennamu -ppassword opennamu < backup-20250117.sql

# 서비스 재시작
docker compose restart opennamu
```

### 테마 및 커스터마이징

```bash
# 컨테이너 내부 접속
docker compose exec opennamu bash

# 스킨 디렉토리 확인
ls /app/views/

# 커스텀 CSS 추가 (웹 UI 관리 페이지에서 가능)
# 또는 파일 직접 편집
vi /app/views/css/custom.css

# 재시작
exit
docker compose restart opennamu
```

### 확장 기능

openNAMU는 다양한 확장 기능을 지원합니다:
- **문법 확장**: ACL, Include, 각주 등
- **테마**: 기본, 다크, 커스텀 테마
- **플러그인**: 통계, 검색, 알림 등
- **API**: RESTful API 지원

## 문제 해결

### 데이터베이스 연결 오류

```bash
# MariaDB 서비스 확인
docker ps | grep mariadb

# MariaDB 로그 확인
docker compose logs mariadb

# 연결 테스트
docker compose exec opennamu python -c "import pymysql; print('OK')"

# 데이터베이스 생성 (필요시)
docker exec -it opennamu-db mysql -u root -prootpassword
CREATE DATABASE opennamu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'opennamu'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON opennamu.* TO 'opennamu'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### 설정 파일 오류

```bash
# 기본 설정으로 초기화
docker compose down -v
docker compose up -d

# 또는 config.json 수동 수정
docker compose exec opennamu vi /app/config.json

# 재시작
docker compose restart opennamu
```

### 업로드가 작동하지 않음

```bash
# 업로드 디렉토리 권한 확인
docker compose exec opennamu ls -la /app/data

# 권한 수정
docker compose exec opennamu chown -R www-data:www-data /app/data

# config.json에서 업로드 설정 확인
docker compose exec opennamu cat /app/config.json | grep upload
```

### 성능 문제

```bash
# Redis 캐싱 추가
# docker-compose.yml에 redis 서비스 추가
services:
  redis:
    image: redis:7-alpine
    container_name: opennamu-redis
    restart: unless-stopped

  opennamu:
    environment:
      - CACHE_TYPE=redis
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      - redis
```

### 한글 깨짐 현상

```bash
# MariaDB 문자셋 확인
docker exec opennamu-db mysql -u opennamu -ppassword -e "SHOW VARIABLES LIKE 'character%';"

# 데이터베이스 문자셋 변경 (필요시)
docker exec opennamu-db mysql -u root -prootpassword
ALTER DATABASE opennamu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;

# 서비스 재시작
docker compose restart
```

### 로그 레벨 변경

```bash
# config.json에서 로그 레벨 설정
docker compose exec opennamu bash
vi /app/config.json

# "log_level": "DEBUG" 또는 "INFO", "WARNING", "ERROR"

# 재시작
exit
docker compose restart opennamu
```

## Port Information

See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation strategy.

**Default port:**
- openNAMU: 8330

To change the port, create a `.env` file or edit `docker-compose.yml`:
```bash
OPENNAMU_PORT=8330  # Change to your preferred port
```

## 참고 자료

- [openNAMU 공식 GitHub](https://github.com/openNAMU/openNAMU)
- [openNAMU 공식 문서](https://github.com/openNAMU/openNAMU/wiki)
- [the seed 문법 가이드](https://namu.wiki/w/the%20seed/문법)
- [openNAMU Docker 이미지](https://hub.docker.com/r/namu/opennamu)
- [Flask 공식 문서](https://flask.palletsprojects.com/)

## 기술 스택

- **Backend**: Python 3.x
- **Framework**: Flask
- **Database**: SQLite 또는 MariaDB/MySQL
- **Cache**: Redis (선택사항)
- **Container**: Docker, Docker Compose
- **마크업**: the seed (나무위키 문법)

## 주요 기능

### 문서 관리
- 문서 생성, 편집, 삭제
- 문서 히스토리 및 버전 관리
- Diff 비교
- 문서 되돌리기
- 문서 이동 및 삭제

### 네임스페이스
- 일반 문서
- 사용자 문서
- 파일 문서
- 틀 (템플릿)
- 분류 (카테고리)
- 특수 문서

### 사용자 및 권한
- 사용자 등록 및 로그인
- 사용자 그룹 및 권한
- ACL (Access Control List)
- IP 차단
- 편집 제한

### 검색 및 탐색
- 전체 텍스트 검색
- 최근 변경
- 최근 토론
- 무작위 문서
- 문서 통계

### the seed 문법
- 제목 및 목차
- 텍스트 서식
- 링크 (내부/외부)
- 이미지 및 파일
- 표 (테이블)
- 목록
- 인용문
- 코드 블록 (문법 하이라이팅)
- 수식 (LaTeX)
- 매크로

### API
- RESTful API
- 문서 조회
- 문서 편집
- 검색
- 사용자 관리

## 라이선스

openNAMU는 BSD 3-Clause 라이선스로 배포됩니다.

## 보안

### 프로덕션 환경 권장 사항

1. **데이터베이스 비밀번호 변경**:
```yaml
environment:
  DB_PASSWORD: <강력한-비밀번호>
  MYSQL_ROOT_PASSWORD: <강력한-루트-비밀번호>
```

2. **시크릿 키 설정**:
```yaml
environment:
  SECRET_KEY: <무작위-생성된-긴-문자열>
```

3. **HTTPS 설정**:
Nginx 또는 Traefik과 같은 리버스 프록시 사용 권장

4. **접근 제어**:
- 관리 페이지 접근 제한
- ACL 설정
- IP 차단 기능 활용

5. **백업 자동화**:
정기적인 데이터베이스 및 파일 백업 스케줄 설정

6. **업데이트 유지**:
정기적으로 openNAMU 이미지 업데이트

7. **방화벽 설정**:
필요한 포트만 외부에 노출

8. **로그 모니터링**:
정기적인 로그 확인 및 이상 징후 감지

## 고급 설정

### Nginx 리버스 프록시

```nginx
# nginx.conf
server {
    listen 80;
    server_name wiki.example.com;

    location / {
        proxy_pass http://localhost:8330;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Redis 캐싱

```yaml
services:
  redis:
    image: redis:7-alpine
    container_name: opennamu-redis
    restart: unless-stopped
    volumes:
      - redis-data:/data

  opennamu:
    environment:
      - CACHE_TYPE=redis
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    depends_on:
      - redis

volumes:
  redis-data:
```

### 다중 워커 설정

```yaml
services:
  opennamu:
    environment:
      - WORKERS: 4              # Gunicorn 워커 수
      - THREADS: 2              # 워커당 스레드 수
```

## 개발 환경

### 소스 코드에서 실행

```bash
# 리포지토리 클론
git clone https://github.com/openNAMU/openNAMU.git
cd openNAMU

# 의존성 설치
pip install -r requirements.txt

# 개발 서버 실행
python app.py

# 브라우저에서 접속
# http://localhost:3000
```

### 커스텀 이미지 빌드

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# 의존성 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 복사
COPY . .

# 포트 노출
EXPOSE 3000

# 실행
CMD ["python", "app.py"]
```

빌드 및 실행:

```bash
docker build -t opennamu-custom .
docker run -p 8330:3000 opennamu-custom
```

## 참고 사항

- openNAMU는 활발히 개발 중인 프로젝트입니다
- the seed 문법은 나무위키와 호환되지만, 일부 차이가 있을 수 있습니다
- 공식 리포지토리의 최신 문서를 참고하세요
- 프로덕션 환경에서는 MariaDB/MySQL 사용을 권장합니다
- 대용량 위키의 경우 Redis 캐싱을 강력히 권장합니다

## 추가 설정 필요

> **알림**: 이 디렉토리에 실제 Docker Compose 설정을 추가하려면:
> 1. 위의 예제 `docker-compose.yml`을 이 디렉토리에 복사
> 2. 필요에 따라 환경 변수 및 볼륨 설정 조정
> 3. `docker compose up -d`로 실행
>
> 또는 공식 리포지토리에서 제공하는 Docker 설정을 사용하세요.
