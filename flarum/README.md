# Flarum - Modern Forum Platform

**Flarum**은 현대적인 PHP 기반 포럼 소프트웨어입니다. 간결하고 빠르며 확장 가능한 커뮤니티 플랫폼입니다.

## 주요 기능

- **현대적 UI**: React 기반 단일 페이지 애플리케이션
- **확장 시스템**: 200+ 공식/커뮤니티 확장
- **모바일 최적화**: 반응형 디자인
- **실시간 알림**: 즉각적인 사용자 피드백
- **태그 시스템**: 유연한 주제 분류
- **다국어 지원**: 40+ 언어팩

## 디렉토리 구조

```
flarum/
├── README.md                    # 이 파일
├── Makefile                     # 관리 명령어
├── compose.yml                  # 간단한 배포 (권장)
├── compose.nginx.yml            # Nginx + FPM 구성
├── compose.apache.yml           # Apache 구성
├── flarum-config.yaml           # 자동 설치 설정
├── flarum-fpm.dockerfile        # PHP-FPM 이미지
├── flarum-apache.dockerfile     # Apache 이미지
└── flarum-composer.dockerfile   # Composer 이미지
```

## 시스템 요구사항

| 항목 | 최소 | 권장 |
|------|------|------|
| **메모리** | 512MB | 1GB+ |
| **CPU** | 1코어 | 2코어+ |
| **스토리지** | 5GB | 20GB+ |
| **Database** | MySQL 5.6+ / MariaDB 10.0.5+ | MariaDB 11+ |
| **PHP** | 7.3+ | 8.2+ |

## Quick Start

### 방법 1: 간단한 배포 (권장)

```bash
docker compose up -d
```

웹 UI 접속: http://localhost:8080

**기본 Credentials**:
- Admin Username: `admin`
- Admin Password: `password`
- Admin Email: `admin@example.com`

> **⚠️ 보안 경고**: 프로덕션 환경에서는 반드시 비밀번호를 변경하세요!

### 방법 2: Nginx + FPM (고성능)

```bash
docker compose -f compose.nginx.yml up -d
```

### 방법 3: Apache (간단한 설정)

```bash
docker compose -f compose.apache.yml up -d
```

## 배포 방식 비교

### 1. 기본 배포 (compose.yml)

**장점**:
- 설정 간단
- 빠른 시작
- 커뮤니티 이미지 사용 (mondedie/flarum)

**포함 서비스**:
- Flarum (포트 8080)
- MariaDB 11.8
- phpMyAdmin (포트 8081)
- MailHog (이메일 테스트, 포트 8025)

### 2. Nginx + FPM (compose.nginx.yml)

**장점**:
- 높은 성능
- 리소스 효율적
- 커스터마이징 용이

**구성**:
- PHP-FPM + Nginx
- 직접 빌드 (Dockerfile 제공)

### 3. Apache (compose.apache.yml)

**장점**:
- 올인원 구성
- 추가 웹서버 불필요

## 환경 설정

### 주요 환경 변수

`compose.yml` 수정:

```yaml
services:
  flarum:
    environment:
      # 포럼 URL (필수)
      - FORUM_URL=http://localhost:8080

      # 데이터베이스
      - DB_HOST=mariadb
      - DB_NAME=db01
      - DB_USER=user01
      - DB_PASS=passw0rd
      - DB_PREF=flarum_
      - DB_PORT=3306

      # 관리자 계정
      - FLARUM_ADMIN_USER=admin
      - FLARUM_ADMIN_PASS=password
      - FLARUM_ADMIN_MAIL=admin@example.com
      - FLARUM_TITLE=Flarum Forum
```

### 자동 설치 설정

`flarum-config.yaml` 수정:

```yaml
debug: false  # 프로덕션에서는 false
baseUrl: https://forum.example.com

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
  password: your-strong-password
  email: admin@example.com

settings:
  extensions_enabled:
    - flarum-tags
    - flarum-sticky
    - flarum-mentions
    - flarum-emoji
    - fof-best-answer
```

## 확장(Extension) 관리

### 확장 설치

```bash
# Composer로 확장 설치
docker exec -w /flarum/app flarum composer require fof/polls

# 확장 활성화
docker exec flarum php flarum cache:clear
```

### 인기 확장 목록

#### 공식 확장

```bash
# 태그 시스템
flarum-tags

# 고정글
flarum-sticky

# 좋아요
flarum-likes

# 통계
flarum-statistics

# 멘션
flarum-mentions

# 이모지
flarum-emoji

# BBCode
flarum-bbcode

# 마크다운
flarum-markdown
```

#### 커뮤니티 확장 (Friends of Flarum)

```bash
# 베스트 답변
composer require fof/best-answer

# 투표
composer require fof/polls

# 사용자 디렉토리
composer require fof/user-directory

# 첨부파일 업로드
composer require fof/upload

# 소셜 로그인
composer require fof/oauth

# 게시판 읽음 표시
composer require fof/mark-read

# 사용자 뱃지
composer require fof/user-badge

# 초대 전용 가입
composer require fof/doorman
```

### 확장 제거

```bash
# Composer로 제거
docker exec -w /flarum/app flarum composer remove fof/polls

# 캐시 정리
docker exec flarum php flarum cache:clear
```

## 테마 커스터마이징

### 기본 테마 색상 변경

Admin Panel → Appearance → Colors에서 변경

### 커스텀 CSS 추가

Admin Panel → Appearance → Custom Styles:

```css
/* 예제: 헤더 색상 변경 */
.Header {
  background-color: #4285f4;
}

/* 버튼 스타일 */
.Button--primary {
  background-color: #34a853;
}
```

### 서드파티 테마

```bash
# Afrux Base Theme
docker exec -w /flarum/app flarum composer require afrux/theme-base

# Dark Mode
docker exec -w /flarum/app flarum composer require v17development/flarum-seo
```

## 이메일 설정

### MailHog (개발용)

기본 compose.yml에 포함됨:

```yaml
services:
  mailhog:
    image: mailhog/mailhog:latest
    ports:
      - "8025:8025"  # Web UI
    expose:
      - 1025  # SMTP
```

**Flarum 설정**:
- Admin Panel → Email
- Driver: SMTP
- Host: mailhog
- Port: 1025
- Encryption: None

**이메일 확인**: http://localhost:8025

### SMTP (프로덕션)

Admin Panel → Email:

```
Driver: SMTP
Host: smtp.gmail.com
Port: 587
Username: your-email@gmail.com
Password: app-password
Encryption: TLS
```

## 데이터베이스 관리

### phpMyAdmin 접속

http://localhost:8081

**Credentials**:
- Server: mariadb
- Username: root
- Password: rootpass

### 수동 백업

```bash
# 데이터베이스 백업
docker exec mariadb mysqldump -u user01 -ppassw0rd db01 | gzip > flarum-backup-$(date +%Y%m%d).sql.gz

# 파일 백업
docker run --rm \
  -v flarum_flarum-data:/source:ro \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/flarum-files-$(date +%Y%m%d).tar.gz -C /source .
```

### 복원

```bash
# 데이터베이스 복원
gunzip < flarum-backup-YYYYMMDD.sql.gz | \
  docker exec -i mariadb mysql -u user01 -ppassw0rd db01

# 파일 복원
docker run --rm \
  -v flarum_flarum-data:/target \
  -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/flarum-files-YYYYMMDD.tar.gz -C /target
```

## CLI 명령어

### 캐시 관리

```bash
# 캐시 정리
docker exec flarum php flarum cache:clear

# 자산 재빌드
docker exec flarum php flarum assets:publish
```

### 마이그레이션

```bash
# 마이그레이션 실행
docker exec flarum php flarum migrate

# 마이그레이션 상태 확인
docker exec flarum php flarum migrate:status
```

### 정보 확인

```bash
# Flarum 버전 확인
docker exec flarum php flarum info

# 설치된 확장 목록
docker exec flarum php flarum info:extensions
```

## 업그레이드

### Flarum 업그레이드

```bash
# 1. 백업 (중요!)
# 위 백업 섹션 참조

# 2. 유지보수 모드 활성화
docker exec flarum php flarum down

# 3. Composer 업데이트
docker exec -w /flarum/app flarum composer update --prefer-dist --no-dev -a --with-all-dependencies

# 4. 마이그레이션
docker exec flarum php flarum migrate

# 5. 캐시 정리
docker exec flarum php flarum cache:clear

# 6. 유지보수 모드 비활성화
docker exec flarum php flarum up
```

### Docker 이미지 업그레이드

```bash
# 이미지 풀
docker compose pull

# 재시작
docker compose up -d
```

## 성능 최적화

### PHP 설정

PHP-FPM 컨테이너의 `php.ini`:

```ini
memory_limit = 256M
upload_max_filesize = 10M
post_max_size = 10M
max_execution_time = 60
opcache.enable = 1
opcache.memory_consumption = 128
```

### Nginx 캐싱 (Nginx 구성 사용 시)

```nginx
location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff2)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}
```

### Redis 캐싱 (고급)

```yaml
services:
  redis:
    image: redis:7-alpine
    networks:
      - db-network

  flarum:
    environment:
      - CACHE_DRIVER=redis
      - REDIS_HOST=redis
      - REDIS_PORT=6379
```

## 보안 설정

### HTTPS 설정 (Nginx 리버스 프록시)

```nginx
server {
    listen 443 ssl http2;
    server_name forum.example.com;

    ssl_certificate /etc/ssl/certs/forum.example.com.crt;
    ssl_certificate_key /etc/ssl/private/forum.example.com.key;

    client_max_body_size 10M;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 환경 변수 보안

```bash
# .env 파일 생성
cat > .env << EOF
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)
MYSQL_PASSWORD=$(openssl rand -base64 32)
FLARUM_ADMIN_PASS=$(openssl rand -base64 16)
EOF

# 권한 설정
chmod 600 .env
```

### 스팸 방지

```bash
# reCAPTCHA 확장 설치
docker exec -w /flarum/app flarum composer require fof/recaptcha

# Admin Panel에서 Site Key/Secret Key 설정
```

## 문제 해결

### 데이터베이스 연결 실패

```bash
# MariaDB 상태 확인
docker exec mariadb healthcheck.sh --connect

# 로그 확인
docker logs flarum

# 네트워크 확인
docker exec flarum ping mariadb
```

### 확장 설치 실패

```bash
# Composer 캐시 정리
docker exec -w /flarum/app flarum composer clear-cache

# 의존성 재설치
docker exec -w /flarum/app flarum composer install --no-dev -a
```

### 500 Internal Server Error

```bash
# 로그 확인
docker logs flarum
docker exec flarum tail -f /var/www/flarum/storage/logs/flarum.log

# 권한 확인
docker exec flarum ls -la /var/www/flarum/storage
docker exec flarum chmod -R 775 /var/www/flarum/storage

# 캐시 정리
docker exec flarum php flarum cache:clear
```

### 이메일 전송 실패

```bash
# MailHog 확인
docker logs mailhog

# SMTP 설정 테스트
docker exec flarum php flarum test:mail admin@example.com
```

## 모범 사례

### 1. 정기 백업

```bash
# Cron 작업 추가 (매일 새벽 2시)
0 2 * * * /path/to/flarum-backup.sh
```

### 2. 유지보수 모드

업그레이드나 유지보수 시:

```bash
# 활성화
docker exec flarum php flarum down

# 작업 수행
# ...

# 비활성화
docker exec flarum php flarum up
```

### 3. 모니터링

```bash
# 디스크 사용량
docker exec flarum df -h

# 메모리 사용량
docker stats flarum --no-stream

# 로그 크기 확인
docker exec flarum du -sh /var/www/flarum/storage/logs
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
- [Flarum 공식 사이트](https://flarum.org/)
- [Flarum Documentation](https://docs.flarum.org/)
- [Flarum GitHub](https://github.com/flarum/flarum)
- [Extension Directory](https://extiverse.com/)

### Docker 이미지
- [mondedie/flarum](https://github.com/mondediefr/docker-flarum)
- [Docker Hub](https://hub.docker.com/r/mondedie/flarum)

### 확장 및 테마
- [Friends of Flarum](https://friendsofflarum.org/)
- [Awesome Flarum](https://github.com/realodix/awesome-flarum)
- [Extension List](https://discuss.flarum.org/d/1534-extension-list)
- [Theme Base](https://github.com/afrux/flarum-theme-base)
- [Flarum Themes](https://www.knthost.com/flarum/install-flarum-themes)

### 커뮤니티
- [Flarum Community](https://discuss.flarum.org/)
- [FreeFlarum](https://github.com/FreeFlarum/flarum-multitenant) - 멀티테넌트 SaaS

## 라이선스

Flarum은 MIT 라이선스로 배포됩니다.

## 관련 프로젝트

- **Discourse**: Ruby on Rails 기반 포럼 (../discourse/)
- **phpBB**: 전통적인 PHP 포럼
- **MyBB**: 오픈소스 PHP 포럼
- **NodeBB**: Node.js 기반 포럼

## 주의사항

### 공식 Docker 이미지 없음

Flarum은 공식 Docker 이미지를 제공하지 않습니다. 이 저장소는 커뮤니티 이미지(`mondedie/flarum`)를 사용합니다.

### 프로덕션 배포 시

1. **환경 변수 보안**: 강력한 비밀번호 사용
2. **HTTPS 필수**: SSL/TLS 인증서 설정
3. **정기 백업**: 자동 백업 시스템 구축
4. **업데이트 관리**: 보안 패치 즉시 적용
5. **모니터링**: 로그 및 성능 모니터링

## 설치 팁

### 초기 설정이 불편한 경우

`flarum-config.yaml`을 사용한 자동 설치:

```bash
docker exec -w /flarum/app flarum php flarum install -f /flarum-config.yaml
```

### 모듈화

Flarum은 확장 기반 아키텍처로 모듈화가 잘 되어 있습니다. 필요한 기능만 설치하여 사용하세요.
