# WordPress

WordPress CMS 개발 환경

> 💡 **Quick Start**: For production deployment with database and caching, use the [standalone setup](standalone/README.md) - it includes MariaDB, Redis, and comprehensive documentation!

## 개요

WordPress는 전 세계에서 가장 많이 사용되는 오픈소스 콘텐츠 관리 시스템(CMS)입니다:
- 🌐 전 세계 웹사이트의 43% 이상이 WordPress 사용
- 🎨 수천 개의 무료/유료 테마
- 🔌 60,000개 이상의 플러그인
- ✍️ 직관적인 블록 에디터 (Gutenberg)
- 📱 반응형 디자인 지원
- 🔍 SEO 친화적
- 👥 다중 사용자 및 권한 관리

이 프로젝트는 WordPress의 개발 및 테스트를 위한 Docker 환경을 제공하며, WP-CLI를 통한 자동 설치 및 플러그인 설정을 지원합니다.

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ WordPress (wordpress:6-php8.3-apache)
- ✅ MariaDB 11.8 with health check
- ✅ Redis 7 for caching
- ✅ WP-CLI auto-install
- ✅ Standardized Makefile

**Access:** http://localhost:8100

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Uses minimal configuration with external services.

## Quick Start (Basic Setup)

```bash
# 컨테이너 시작 (자동 설치)
docker-compose up -d

# 웹 브라우저로 접속
# http://localhost:8100

# 관리자 로그인
# URL: http://localhost:8100/wp-admin
# Username: a01
# Password: passw0rd
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **wordpress**: WordPress 6 PHP 8.3 Apache (포트 8100)
- **wp-install**: WP-CLI 자동 설치 서비스
- **mariadb**: MariaDB 데이터베이스 (외부 서비스)
- **redis**: Redis 캐시 서버 (외부 서비스)

## Default Configuration

**Default port:** 8100 (recommended port - see [PORT_STATUS.md](../PORT_STATUS.md))

**Container name:** wordpress

Environment variables:

```bash
WORDPRESS_DB_HOST=mariadb
WORDPRESS_DB_USER=user01
WORDPRESS_DB_PASSWORD=passw0rd
WORDPRESS_DB_NAME=db01
```

## 환경 변수

compose.yml에서 설정:

```yaml
environment:
  # WordPress 서비스
  WORDPRESS_DB_HOST: mariadb
  WORDPRESS_DB_USER: user01
  WORDPRESS_DB_PASSWORD: passw0rd
  WORDPRESS_DB_NAME: db01
```

## 디렉토리 구조

```
wordpress/
├── compose.yml           # Docker Compose 설정
├── run-wp-cli.sh        # WP-CLI 자동 설치 스크립트
├── run-wp-permission.sh # 권한 설정 스크립트
├── Makefile             # Make 명령어
└── README.md            # 이 파일
```

## 자동 설치

`run-wp-cli.sh` 스크립트를 통해 다음이 자동으로 설치됩니다:

### 기본 설정
- 사이트 제목: My WordPress Site
- 관리자 계정: a01 / passw0rd
- 관리자 이메일: a01@a.com

### 자동 설치 플러그인
- **user-switching**: 사용자 전환 도구
- **miniorange-login-with-eve-online-google-facebook**: 소셜 로그인
- **social-rocket**: 소셜 미디어 통합
- **bbpress**: 포럼 기능

### 자동 생성 사용자
- admin1, admin2 (관리자)
- user1, user2, user3 (일반 사용자)

## 사용법

### 관리자 페이지 접속

```
URL: http://localhost:8100/wp-admin
Username: a01
Password: passw0rd
```

### 플러그인 관리

#### WP-CLI로 플러그인 설치

```bash
# 플러그인 검색
docker-compose exec wordpress wp plugin search [플러그인명]

# 플러그인 설치
docker-compose exec wordpress wp plugin install [플러그인명] --activate

# 설치된 플러그인 목록
docker-compose exec wordpress wp plugin list

# 플러그인 활성화/비활성화
docker-compose exec wordpress wp plugin activate [플러그인명]
docker-compose exec wordpress wp plugin deactivate [플러그인명]

# 플러그인 삭제
docker-compose exec wordpress wp plugin delete [플러그인명]
```

#### 관리자 페이지에서 설치

1. 관리자 페이지 > Plugins > Add New
2. 플러그인 검색 또는 업로드
3. Install Now 클릭
4. Activate 클릭

### 테마 관리

#### WP-CLI로 테마 설치

```bash
# 테마 검색
docker-compose exec wordpress wp theme search [테마명]

# 테마 설치
docker-compose exec wordpress wp theme install [테마명] --activate

# 설치된 테마 목록
docker-compose exec wordpress wp theme list

# 테마 활성화
docker-compose exec wordpress wp theme activate [테마명]
```

#### 관리자 페이지에서 설치

1. 관리자 페이지 > Appearance > Themes
2. Add New 클릭
3. 테마 검색 또는 업로드
4. Install 후 Activate

### 사용자 관리

```bash
# 사용자 목록
docker-compose exec wordpress wp user list

# 사용자 생성
docker-compose exec wordpress wp user create [username] [email] --role=[role] --user_pass=[password]

# 역할: administrator, editor, author, contributor, subscriber

# 사용자 삭제
docker-compose exec wordpress wp user delete [ID]
```

### 포스트 및 페이지 관리

```bash
# 포스트 목록
docker-compose exec wordpress wp post list

# 포스트 생성
docker-compose exec wordpress wp post create --post_title='제목' --post_content='내용' --post_status=publish

# 페이지 목록
docker-compose exec wordpress wp post list --post_type=page

# 페이지 생성
docker-compose exec wordpress wp post create --post_type=page --post_title='페이지 제목' --post_content='내용' --post_status=publish
```

## 유용한 플러그인

### 성능 및 캐시

- **WP Rocket**: 캐싱 및 성능 최적화 (유료)
- **W3 Total Cache**: 종합 캐싱 솔루션
- **WP Super Cache**: 간단한 캐싱
- **WP Fastest Cache**: 빠른 캐싱
- **WP-Optimize**: 데이터베이스 최적화

### SEO

- **Yoast SEO**: SEO 최적화
- **Rank Math**: SEO 도구
- **All in One SEO**: SEO 플러그인

### 보안

- **Wordfence Security**: 보안 강화
- **iThemes Security**: 보안 설정
- **Sucuri Security**: 보안 감사

### 백업

- **UpdraftPlus**: 백업 및 복원
- **BackWPup**: 백업 솔루션
- **Duplicator**: 마이그레이션 및 백업

### 폼

- **Contact Form 7**: 컨택트 폼
- **WPForms**: 폼 빌더
- **Gravity Forms**: 고급 폼 (유료)

### 포럼

- **bbPress**: 포럼 (자동 설치됨)
- **wpForo**: 포럼 플러그인
- **Asgaros Forum**: 간단한 포럼

## 볼륨

```yaml
volumes:
  - wordpress:/var/www/html  # WordPress 파일 및 데이터
```

## 네트워크

```yaml
networks:
  - app-network    # 애플리케이션 레이어
  - data-network   # 데이터베이스 레이어
```

## 데이터베이스

### 데이터베이스 백업

```bash
# WP-CLI로 백업
docker-compose exec wordpress wp db export backup.sql

# mysqldump로 백업
docker-compose exec mariadb mysqldump -u user01 -ppassw0rd db01 > backup.sql

# 복원
docker-compose exec -T wordpress wp db import backup.sql
# 또는
docker-compose exec -T mariadb mysql -u user01 -ppassw0rd db01 < backup.sql
```

### 데이터베이스 최적화

```bash
# 데이터베이스 최적화
docker-compose exec wordpress wp db optimize

# 데이터베이스 복구
docker-compose exec wordpress wp db repair

# 데이터베이스 정보 확인
docker-compose exec wordpress wp db check
```

## 문제 해결

### 설치 페이지가 보이지 않음

```bash
# 컨테이너 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs wordpress
docker-compose logs wp-install

# 재시작
docker-compose restart wordpress
```

### 데이터베이스 연결 실패

```bash
# mariadb 컨테이너 상태 확인
docker-compose ps mariadb

# DB 연결 정보 확인:
# Host: mariadb (localhost 아님!)
# Database: db01
# User: user01
# Password: passw0rd

# 재시작
docker-compose restart mariadb
```

### 권한 문제

```bash
# 권한 설정 스크립트 실행
docker-compose exec wordpress bash /run-wp-permission.sh

# 또는 수동으로
docker-compose exec wordpress chown -R www-data:www-data /var/www/html
docker-compose exec wordpress find /var/www/html -type d -exec chmod 755 {} \;
docker-compose exec wordpress find /var/www/html -type f -exec chmod 644 {} \;
```

### 파일 업로드 실패

```bash
# PHP 설정 확인
docker-compose exec wordpress php -i | grep upload_max_filesize
docker-compose exec wordpress php -i | grep post_max_size

# wp-config.php에 추가
# define('WP_MEMORY_LIMIT', '256M');
```

### White Screen of Death (WSOD)

```bash
# 디버그 모드 활성화 (wp-config.php)
docker-compose exec wordpress wp config set WP_DEBUG true --raw
docker-compose exec wordpress wp config set WP_DEBUG_LOG true --raw

# 로그 확인
docker-compose exec wordpress tail -f /var/www/html/wp-content/debug.log
```

### 플러그인 충돌

```bash
# 모든 플러그인 비활성화
docker-compose exec wordpress wp plugin deactivate --all

# 하나씩 활성화하여 문제 플러그인 찾기
docker-compose exec wordpress wp plugin activate [플러그인명]
```

## 보안 설정

### 1. 관리자 비밀번호 변경

설치 후 반드시 강력한 비밀번호로 변경:

```bash
docker-compose exec wordpress wp user update a01 --user_pass=강력한비밀번호
```

### 2. DB 비밀번호 변경

프로덕션에서는 강력한 비밀번호 사용:

```yaml
environment:
  WORDPRESS_DB_PASSWORD: 강력한비밀번호
```

### 3. wp-config.php 보안 키 변경

```bash
# 보안 키 생성
docker-compose exec wordpress wp config shuffle-salts
```

### 4. 불필요한 플러그인 및 테마 제거

```bash
# 사용하지 않는 플러그인 삭제
docker-compose exec wordpress wp plugin delete [플러그인명]

# 사용하지 않는 테마 삭제
docker-compose exec wordpress wp theme delete [테마명]
```

### 5. 파일 편집 비활성화

wp-config.php에 추가:

```php
define('DISALLOW_FILE_EDIT', true);
```

## 프로덕션 배포

### 1. 환경 변수 수정

```yaml
environment:
  WORDPRESS_DB_PASSWORD: 강력한비밀번호
  # wp-config.php에서 설정:
  # define('WP_DEBUG', false);
```

### 2. HTTPS 설정

```bash
# wp-config.php에 추가
docker-compose exec wordpress wp config set FORCE_SSL_ADMIN true --raw

# 사이트 URL 변경
docker-compose exec wordpress wp option update home 'https://yourdomain.com'
docker-compose exec wordpress wp option update siteurl 'https://yourdomain.com'
```

### 3. 볼륨 백업

```bash
# 정기 백업 스크립트 설정
crontab -e
0 2 * * * docker-compose -f /path/to/wordpress/compose.yml exec wordpress wp db export /backup/wp-backup-$(date +\%Y\%m\%d).sql
```

### 4. 보안 헤더 설정

.htaccess에 추가:

```apache
# 보안 헤더
Header set X-Frame-Options "SAMEORIGIN"
Header set X-Content-Type-Options "nosniff"
Header set X-XSS-Protection "1; mode=block"
Header set Referrer-Policy "strict-origin-when-cross-origin"
```

## WP-CLI 유용한 명령어

```bash
# WordPress 버전 확인
docker-compose exec wordpress wp core version

# WordPress 업데이트
docker-compose exec wordpress wp core update

# 캐시 클리어
docker-compose exec wordpress wp cache flush

# 리라이트 규칙 재생성
docker-compose exec wordpress wp rewrite flush

# 미디어 재생성
docker-compose exec wordpress wp media regenerate --yes

# 사이트 정보
docker-compose exec wordpress wp option get siteurl
docker-compose exec wordpress wp option get home
```

## 멀티사이트 설정

```bash
# 멀티사이트 활성화
docker-compose exec wordpress wp core multisite-install \
  --title="My Network" \
  --admin_user="admin" \
  --admin_password="your_secure_password" \
  --admin_email="admin@example.com" \
  --url="http://localhost:8100" \
  --base="/"
```

wp-config.php에 자동 추가:

```php
define('WP_ALLOW_MULTISITE', true);
define('MULTISITE', true);
define('SUBDOMAIN_INSTALL', false);
define('DOMAIN_CURRENT_SITE', 'localhost');
define('PATH_CURRENT_SITE', '/');
define('SITE_ID_CURRENT_SITE', 1);
define('BLOG_ID_CURRENT_SITE', 1);
```

## 기술 스택

- **WordPress**: 6.x
- **PHP**: 8.3
- **Apache**: Latest
- **WP-CLI**: Latest
- **MariaDB**: 11.8 (외부 서비스)
- **Redis**: Latest (외부 서비스)

## Port Information

See [PORT_STATUS.md](../PORT_STATUS.md) for port allocation strategy.

**Default port:**
- WordPress: 8100

To change the port, edit `compose.yml` or use environment variables.

## 참고 자료

- [WordPress 공식 사이트](https://wordpress.org/)
- [WordPress 문서](https://wordpress.org/support/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [WP-CLI 문서](https://wp-cli.org/)
- [WordPress Plugin Directory](https://wordpress.org/plugins/)
- [WordPress Theme Directory](https://wordpress.org/themes/)
- [WordPress Docker Hub](https://hub.docker.com/_/wordpress)

## 관련 프로젝트

- [joomla](../joomla/README.md) - Joomla CMS
- [drupal](../drupal/README.md) - Drupal CMS
- [django-cms](../django-cms/README.md) - Django CMS

## 라이선스

WordPress는 GPL v2 라이선스를 따릅니다.
