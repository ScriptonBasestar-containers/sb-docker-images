# 그누보드5 (Gnuboard 5)

그누보드5 PHP 게시판 시스템

## 개요

그누보드5는 한국에서 가장 많이 사용되는 오픈소스 PHP 게시판 시스템입니다. 커뮤니티 사이트, 회사 홈페이지 등에 활용됩니다.

## 빠른 시작

```bash
# 컨테이너 시작
docker-compose up -d

# 웹 브라우저로 접속
# http://localhost:8200

# 설치 마법사 실행
# 1. http://localhost:8200/install 접속
# 2. DB 정보 입력:
#    - DB Host: mariadb
#    - DB Name: db01
#    - DB User: user01
#    - DB Password: passw0rd
# 3. 관리자 정보 입력
# 4. 설치 완료
```

## 서비스 구성

- **nginx**: 웹 서버 (포트 8200)
- **php**: PHP-FPM (그누보드5)
- **mariadb**: MariaDB 11.8 데이터베이스
- **phpmyadmin**: 데이터베이스 관리 (포트 8201)

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8200 | nginx | 웹 사이트 |
| 8201 | phpmyadmin | DB 관리 |

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

docker-compose.yml에서 설정:

```yaml
environment:
  - G5_DOMAIN=localhost:8200
  - MYSQL_ROOT_PASSWORD=rootpass
  - MYSQL_DATABASE=db01
  - MYSQL_USER=user01
  - MYSQL_PASSWORD=passw0rd
```

## 디렉토리 구조

```
gnuboard5/
├── docker-compose.yml       # Docker Compose 설정
├── gnuboard5-fpm.dockerfile # PHP-FPM Dockerfile
├── nginx/
│   └── php-web.conf        # Nginx 설정
├── .nginx.conf             # Nginx 추가 설정
└── app/                    # 그누보드5 소스 (마운트)
```

## 설치 방법

### 1. 그누보드5 다운로드

```bash
# 공식 사이트에서 다운로드
wget https://github.com/gnuboard/gnuboard5/archive/refs/heads/master.zip
unzip master.zip
mv gnuboard5-master/* app/

# 또는
cd app
git clone https://github.com/gnuboard/gnuboard5.git .
```

### 2. 파일 권한 설정

```bash
# 쓰기 권한 부여
chmod 707 app/data
chmod 707 app/data/*
chmod 707 app/theme
```

### 3. 설치 진행

브라우저에서 http://localhost:8200/install 접속하여 설치 진행

## 사용법

### 관리자 페이지

```
URL: http://localhost:8200/adm
ID: 설치 시 입력한 관리자 ID
PW: 설치 시 입력한 관리자 비밀번호
```

### 게시판 생성

1. 관리자 페이지 > 게시판관리 > 게시판 생성
2. 게시판 ID, 제목 등 설정
3. 스킨 선택
4. 생성 완료

### 스킨 변경

1. 관리자 페이지 > 테마설정
2. 원하는 테마 선택
3. 적용

## 데이터베이스 관리

### phpMyAdmin 접속

```
URL: http://localhost:8201
서버: mariadb
사용자: root
비밀번호: dockerPWDroot
```

### 데이터베이스 백업

```bash
# 백업
docker-compose exec mariadb mysqldump -u root -prootpass db01 > backup.sql

# 복원
docker-compose exec -T mariadb mysql -u root -prootpass db01 < backup.sql
```

## 볼륨

```yaml
volumes:
  - ./app:/var/www/html  # 소스 코드
```

## 네트워크

```yaml
networks:
  - code-network  # 웹 레이어
  - db-network    # 데이터베이스 레이어
```

## 문제 해결

### 설치 페이지가 보이지 않음

```bash
# app 디렉토리에 그누보드5 소스가 있는지 확인
ls -la app/

# 없다면 다운로드
cd app
git clone https://github.com/gnuboard/gnuboard5.git .
```

### 파일 업로드 실패

```bash
# data 디렉토리 권한 확인
chmod -R 777 app/data
chmod -R 777 app/theme
```

### 데이터베이스 연결 실패

```bash
# mariadb 컨테이너 상태 확인
docker-compose ps mariadb

# 재시작
docker-compose restart mariadb

# 설치 시 DB 정보 확인:
# Host: mariadb (localhost 아님!)
# Database: db01
# User: user01
# Password: passw0rd
```

### 한글이 깨짐

```bash
# DB charset 확인
docker-compose exec mariadb mysql -u root -prootpass -e "SHOW VARIABLES LIKE 'character%';"

# utf8mb4로 변경
docker-compose exec mariadb mysql -u root -prootpass db01 -e "
  ALTER DATABASE db01 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
"
```

## 보안 설정

### 1. install 디렉토리 삭제

설치 완료 후 반드시 삭제:

```bash
rm -rf app/install
```

### 2. 관리자 비밀번호 변경

- 강력한 비밀번호 사용
- 주기적으로 변경

### 3. DB 비밀번호 변경

프로덕션에서는 강력한 비밀번호 사용:

```yaml
environment:
  - MYSQL_ROOT_PASSWORD=강력한비밀번호
  - MYSQL_PASSWORD=강력한비밀번호
```

### 4. 불필요한 파일 제거

```bash
# 예제 파일 삭제
rm -f app/LICENSE.txt
rm -f app/README.md
```

## 플러그인 및 테마

### 무료 테마

- 그누보드5 공식 사이트에서 다운로드
- app/theme 디렉토리에 압축 해제
- 관리자 페이지에서 적용

### 스킨

- app/skin 디렉토리에 설치
- 게시판별로 스킨 설정 가능

## 프로덕션 배포

### 1. 환경 변수 수정

```yaml
environment:
  - G5_DOMAIN=yourdomain.com
  - MYSQL_ROOT_PASSWORD=강력한비밀번호
  - MYSQL_PASSWORD=강력한비밀번호
```

### 2. HTTPS 설정

Nginx에 SSL 인증서 추가

### 3. 볼륨 백업

```bash
# 정기 백업 스크립트
./backup.sh
```

## 기술 스택

- **PHP**: 7.4+ (또는 8.x)
- **MariaDB**: 11.8
- **Nginx**: latest
- **phpMyAdmin**: latest

## 참고 자료

- [그누보드5 공식 사이트](https://www.gnuboard5.com/)
- [그누보드5 GitHub](https://github.com/gnuboard/gnuboard5)
- [그누보드5 매뉴얼](https://www.gnuboard5.com/manual/)
- [그누보드 커뮤니티](https://sir.kr/)

## 관련 프로젝트

- [gnuboard6](../gnuboard6/README.md) - 그누보드6 (최신 버전)
- [xpressengine](../xpressengine/README.md) - XE
- [wordpress](../wordpress/README.md) - WordPress

## 라이선스

그누보드5는 GPL 라이선스를 따릅니다.
