# Flarum

Flarum은 PHP로 작성된 차세대 포럼 소프트웨어입니다. 심플하고 빠르며 반응형 디자인으로 모던한 커뮤니티를 구축할 수 있습니다.

## 개요

Flarum은 다음과 같은 기능을 제공합니다:
- 빠르고 간단한 사용자 경험
- 모바일 우선 반응형 디자인
- 강력한 확장 시스템
- 우아한 인터페이스
- 실시간 알림
- 태그 기반 토론 구성
- 마크다운 및 BBCode 지원
- 다국어 지원
- PWA (Progressive Web App) 지원
- RESTful API

## 빠른 시작

### 방법 1: 사전 구성된 이미지 사용 (간단)

```bash
# 1. 서비스 시작
docker compose up -d

# 2. 브라우저에서 접속
# http://localhost:8080

# 3. 관리자 계정으로 로그인
# Username: admin
# Password: password
```

### 방법 2: 소스에서 빌드 (커스터마이징)

```bash
# 1. Flarum 소스코드 클론 및 의존성 설치
make setup

# 2. Apache 또는 Nginx 선택하여 실행
make run-nginx   # Nginx + PHP-FPM 사용
# 또는
make run-apache  # Apache + mod_php 사용

# 3. 브라우저에서 접속
# http://localhost:8080
```

## 서비스 구성

### 기본 구성 (compose.yml)

- **flarum**: Flarum 포럼 애플리케이션
  - mondedie/flarum 커뮤니티 이미지 사용
  - 포트 8888 (컨테이너 내부)
  - 자동 설치 및 초기화

- **mariadb**: MariaDB 11.8 데이터베이스
  - 사용자 데이터 및 게시물 저장
  - 헬스체크 기능
  - 영구 데이터 저장

- **phpmyadmin**: phpMyAdmin (선택적)
  - 데이터베이스 관리 도구
  - 포트 8081

- **mailhog**: MailHog (개발용)
  - 이메일 테스트 도구
  - SMTP: 1025, Web UI: 8025

### Nginx 구성 (compose.nginx.yml)

- **flarum**: PHP-FPM 기반
- **nginx**: Nginx 웹 서버
  - 정적 파일 서빙
  - PHP-FPM 프록시

### Apache 구성 (compose.apache.yml)

- **flarum**: Apache + mod_php
  - Apache 웹 서버 내장
  - 직접 PHP 처리

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8080 | flarum | Flarum 포럼 웹 사이트 (현재 설정) |
| 8081 | phpmyadmin | DB 관리 도구 |
| 8025 | mailhog | 메일 테스트 Web UI |

> ⚠️ **포트 충돌 주의**: 현재 8080 포트 사용 중입니다.
>
> **권장 포트**: 8510 ([포트 가이드](../docs/PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # compose.yml 파일에서 수정
> sed -i 's/"8080:8888"/"8510:8888"/' compose.yml
> sed -i 's/localhost:8080/localhost:8510/' compose.yml
>
> # 또는 직접 편집
> # ports:
> #   - "8510:8888"
> # environment:
> #   - FORUM_URL=http://localhost:8510
> ```

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

또는 docker-compose.yml을 수정:
```yaml
services:
  flarum:
    ports:
      - "8510:8888"  # 기본 8080 대신 8510 사용
```

## 환경 변수

### Flarum 설정

```bash
FORUM_URL=http://localhost:8080
FLARUM_ADMIN_USER=admin
FLARUM_ADMIN_PASS=password
FLARUM_ADMIN_MAIL=admin@example.com
FLARUM_TITLE=Flarum Forum
```

### 데이터베이스 설정

```bash
DB_HOST=mariadb
DB_NAME=db01
DB_USER=user01
DB_PASS=passw0rd
DB_PREF=flarum_
DB_PORT=3306
```

### MariaDB 설정

```bash
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=db01
MYSQL_USER=user01
MYSQL_PASSWORD=passw0rd
```

## 사용 가능한 명령어

### 소스 빌드 방식

```bash
# Flarum 소스 클론 및 의존성 설치
make setup

# 소스 삭제
make teardown

# 베이스 이미지 빌드
make build-base

# Apache 버전 빌드
make build-apache

# Nginx 버전 빌드
make build-nginx

# Apache로 실행
make run-apache

# Nginx로 실행
make run-nginx

# Apache 컨테이너 쉘 접속
make enter-apache

# 모든 컨테이너 및 이미지 삭제
make clean
```

### Docker Compose 직접 사용

```bash
# 기본 이미지로 시작
docker compose up -d

# Nginx 구성으로 시작
docker compose -f compose.yml -f compose.nginx.yml up -d

# Apache 구성으로 시작
docker compose -f compose.yml -f compose.apache.yml up -d

# 로그 확인
docker compose logs -f

# 서비스 중지
docker compose down

# 서비스 중지 및 볼륨 삭제
docker compose down -v
```

## 사용법

### 초기 설정 (flarum-config.yaml 사용)

flarum-config.yaml 파일을 편집하여 초기 설정 자동화:

```yaml
debug: false
baseUrl: http://yourdomain.com
databaseConfiguration:
  driver: mysql
  host: mariadb
  port: 3306
  database: db01
  username: user01
  password: passw0rd
  prefix: fl_
adminUser:
  username: admin
  password: strong-password-here
  email: admin@example.com
settings:
  extensions_enabled:
    - flarum-tags
    - flarum-sticky
    - flarum-mentions
```

설치 실행:
```bash
docker exec flarum php flarum install -f /flarum-config.yaml
```

### 확장(Extension) 관리

웹 인터페이스에서:
```
1. 관리자로 로그인
2. Administration > Extensions
3. 확장 검색 및 설치
4. 활성화/비활성화
```

CLI로 확장 설치:
```bash
# 컨테이너 내부로 진입
docker exec -it flarum bash

# Composer로 확장 설치
composer require fof/best-answer

# 확장 활성화
php flarum cache:clear
php flarum migrate

# Flarum 재시작
exit
docker restart flarum
```

### 테마 설치

```bash
# 컨테이너 내부로 진입
docker exec -it flarum bash

# Composer로 테마 설치
composer require "vendor/theme-name:*"

# 캐시 클리어
php flarum cache:clear

# 웹 인터페이스에서
# Administration > Appearance > 테마 선택
```

### 데이터베이스 백업

```bash
# MariaDB 백업
docker exec flarum_mariadb mysqldump -u user01 -ppassw0rd db01 > flarum-backup.sql

# 백업 복원
docker exec -i flarum_mariadb mysql -u user01 -ppassw0rd db01 < flarum-backup.sql
```

### Flarum CLI 명령어

```bash
# 캐시 클리어
docker exec flarum php flarum cache:clear

# 자산 빌드
docker exec flarum php flarum assets:publish

# 마이그레이션 실행
docker exec flarum php flarum migrate

# 정보 확인
docker exec flarum php flarum info

# 스케줄러 실행
docker exec flarum php flarum schedule:run

# 확장 목록
docker exec flarum php flarum info | grep Extension
```

### 업데이트

```bash
# Composer로 업데이트
docker exec flarum composer update

# 자산 재빌드
docker exec flarum php flarum cache:clear
docker exec flarum php flarum assets:publish

# 마이그레이션 실행
docker exec flarum php flarum migrate

# 컨테이너 재시작
docker restart flarum
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# MariaDB 상태 확인
docker compose logs mariadb

# "ready for connections" 메시지 확인 후
docker restart flarum
```

### 설치가 완료되지 않음

```bash
# 수동 설치 실행
docker exec flarum php flarum install -f /flarum-config.yaml

# 또는 웹 브라우저에서 초기 설정 진행
# http://localhost:8080
```

### 자산(Assets)이 로드되지 않음

```bash
# 자산 재빌드
docker exec flarum php flarum cache:clear
docker exec flarum php flarum assets:publish

# 권한 확인
docker exec flarum chown -R www-data:www-data /flarum/app/public/assets
```

### 확장 설치 실패

```bash
# Composer 캐시 삭제
docker exec flarum composer clear-cache

# 확장 재설치
docker exec flarum composer require vendor/extension-name

# 의존성 문제 해결
docker exec flarum composer update --prefer-dist
```

### 권한 오류

```bash
# 파일 소유권 수정
docker exec flarum chown -R www-data:www-data /flarum/app

# 권한 설정
docker exec flarum chmod -R 755 /flarum/app
docker exec flarum chmod -R 775 /flarum/app/public/assets
docker exec flarum chmod -R 775 /flarum/app/storage
```

### 로그 확인

```bash
# Docker 로그
docker compose logs -f flarum

# Flarum 로그 (컨테이너 내부)
docker exec flarum tail -f /flarum/app/storage/logs/flarum.log

# Nginx 로그 (Nginx 구성 사용 시)
docker compose logs -f nginx
```

### MailHog로 이메일 테스트

```bash
# MailHog Web UI 접속
# http://localhost:8025

# Flarum 설정에서 SMTP 설정
# Administration > Email
# SMTP Host: mailhog
# SMTP Port: 1025
# Encryption: None
```

### 디버그 모드 활성화

config.php 편집:
```bash
docker exec flarum bash -c "echo \"<?php return ['debug' => true];\" > /flarum/app/config.php"
docker restart flarum
```

## 디렉토리 구조

```
flarum/
├── compose.yml              # Docker Compose 기본 설정
├── compose.nginx.yml        # Nginx 구성
├── compose.apache.yml       # Apache 구성
├── Makefile                 # 편의 명령어
├── README.md                # 이 문서
├── flarum-config.yaml       # Flarum 초기 설정 파일
├── flarum-composer.dockerfile # Composer 베이스 이미지
├── flarum-fpm.dockerfile   # PHP-FPM 이미지
├── flarum-apache.dockerfile # Apache 이미지
├── docker-entrypoint.sh     # 진입점 스크립트
├── nginx/                   # Nginx 설정 파일
│   ├── php-web.conf
│   └── .nginx.conf
├── config/                  # 설정 파일들
│   ├── nginx/
│   ├── apache2/
│   └── php/
└── app/                     # Flarum 애플리케이션 (make setup으로 생성)
```

## 참고 자료

- [Flarum 공식 웹사이트](https://flarum.org/)
- [Flarum 공식 GitHub](https://github.com/flarum/flarum)
- [Flarum 공식 문서](https://docs.flarum.org/)
- [Flarum 커뮤니티](https://discuss.flarum.org/)
- [Flarum 확장 디렉토리](https://extiverse.com/)
- [Docker Flarum 이미지 (mondedie)](https://github.com/mondediefr/docker-flarum)
- [Awesome Flarum](https://github.com/realodix/awesome-flarum)
- [Flarum 테마 설정 가이드](https://www.knthost.com/flarum/install-flarum-themes)

## 기술 스택

- **Backend**: PHP 8.x
- **Frontend**: Mithril.js
- **Database**: MariaDB 11.8 (또는 MySQL 5.7+)
- **Web Server**: Nginx (또는 Apache)
- **Package Manager**: Composer
- **Asset Pipeline**: Webpack
- **Container**: Docker, Docker Compose

## 인기 확장(Extensions)

### 공식 확장

- **flarum/tags** - 토론 태그 분류
- **flarum/mentions** - 사용자 멘션
- **flarum/sticky** - 고정 토론
- **flarum/lock** - 토론 잠금
- **flarum/suspend** - 사용자 정지
- **flarum/statistics** - 통계
- **flarum/bbcode** - BBCode 지원
- **flarum/emoji** - 이모지 지원
- **flarum/markdown** - 마크다운 지원

### Friends of Flarum (FoF) 확장

- **fof/best-answer** - 최고 답변 선택
- **fof/upload** - 파일 업로드
- **fof/polls** - 투표 기능
- **fof/user-directory** - 사용자 디렉토리
- **fof/links** - 링크 추가
- **fof/sitemap** - 사이트맵 생성
- **fof/moderator-notes** - 모더레이터 노트

## 고급 설정

### 프로덕션 환경 설정

config.php 최적화:
```php
<?php
return [
    'debug' => false,
    'offline' => false,
    'database' => [
        'driver' => 'mysql',
        'host' => 'mariadb',
        'port' => 3306,
        'database' => 'db01',
        'username' => 'user01',
        'password' => 'passw0rd',
        'charset' => 'utf8mb4',
        'collation' => 'utf8mb4_unicode_ci',
        'prefix' => 'flarum_',
        'strict' => false,
        'engine' => 'InnoDB',
        'prefix_indexes' => true,
    ],
    'url' => 'https://yourdomain.com',
    'paths' => [
        'api' => 'api',
        'admin' => 'admin',
    ],
];
```

### HTTPS 설정 (Nginx 리버스 프록시)

```nginx
server {
    listen 80;
    server_name forum.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name forum.example.com;

    ssl_certificate /etc/ssl/certs/fullchain.pem;
    ssl_certificate_key /etc/ssl/private/privkey.pem;

    location / {
        proxy_pass http://flarum:8888;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 성능 최적화

```bash
# OPcache 활성화 (PHP 설정)
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2

# MariaDB 최적화
innodb_buffer_pool_size=256M
innodb_log_file_size=64M
query_cache_size=16M
```

## 주의사항

1. **초기 설정**: flarum-config.yaml을 편집하거나 웹 인터페이스를 통해 초기 설정을 완료해야 합니다.
2. **보안**: 프로덕션 환경에서는 강력한 비밀번호와 HTTPS를 사용하세요.
3. **백업**: 정기적으로 데이터베이스와 업로드 파일을 백업하세요.
4. **업데이트**: Flarum 업데이트 전에 백업을 권장합니다.
5. **확장**: 너무 많은 확장을 설치하면 성능에 영향을 줄 수 있습니다.
6. **포트**: 기본 포트가 다른 서비스와 충돌할 경우 변경하세요.

## 라이선스

Flarum은 MIT 라이선스로 배포됩니다.
