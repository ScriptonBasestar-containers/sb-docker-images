# Drupal

Drupal CMS 개발 환경

> 💡 **Quick Start**: For production deployment with database and caching, use the [standalone setup](standalone/README.md) - it includes MariaDB, Redis, and comprehensive documentation!

## 개요

Drupal은 강력하고 확장 가능한 오픈소스 콘텐츠 관리 시스템(CMS)입니다:
- 🏢 엔터프라이즈급 웹사이트 구축
- 🔧 강력한 API와 확장성
- 🎯 복잡한 콘텐츠 구조 관리
- 🔒 강력한 보안 기능
- 🌐 다국어 지원
- 📊 고급 사용자 권한 시스템
- 🎨 테마 시스템 (Twig)

이 프로젝트는 Drupal의 개발 및 테스트를 위한 Docker 환경을 제공합니다.

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Drupal 10 (drupal:10-apache-bookworm)
- ✅ MariaDB with health check
- ✅ Redis for caching
- ✅ Standardized Makefile

**Access:** http://localhost:8120

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Uses minimal configuration with external services.

## Quick Start (Basic Setup)

```bash
# standalone 디렉토리로 이동
cd standalone

# 컨테이너 시작
docker-compose up -d

# 웹 브라우저로 접속
# http://localhost:8120

# Drupal 설치 마법사 실행
# 1. http://localhost:8120 접속
# 2. 언어 선택
# 3. 설치 프로필 선택 (Standard 권장)
# 4. DB 정보 입력:
#    - Database type: MySQL, MariaDB, or equivalent
#    - Database name: db01
#    - Database username: user01
#    - Database password: passw0rd
#    - ADVANCED OPTIONS > Host: mariadb
# 5. 사이트 정보 입력
# 6. 설치 완료
```

## 서비스 구성

standalone/compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **drupal**: Drupal 10 Apache Bookworm (포트 8120)
- **mariadb**: MariaDB 데이터베이스 (외부 서비스)
- **redis**: Redis 캐시 서버 (외부 서비스)

## Default Configuration

**Default port:** 8120 (recommended port - see [PORT_STATUS.md](../PORT_STATUS.md))

**Container name:** drupal

Environment variables:

```bash
DRUPAL_DATABASE_HOST=mariadb
DRUPAL_DATABASE_NAME=db01
DRUPAL_DATABASE_USERNAME=user01
DRUPAL_DATABASE_PASSWORD=passw0rd
```

## 환경 변수

standalone/compose.yml에서 설정:

```yaml
environment:
  # 데이터베이스 설정
  DRUPAL_DATABASE_HOST: mariadb
  DRUPAL_DATABASE_PORT: 3306
  DRUPAL_DATABASE_NAME: db01
  DRUPAL_DATABASE_USERNAME: user01
  DRUPAL_DATABASE_PASSWORD: passw0rd
  DRUPAL_DATABASE_PREFIX: dr_

  # 보안 설정
  DRUPAL_HASH_SALT: db0de8a1556aa5348f87cfc950cd2c9641713d46e9412c8b05

  # 레거시 DB 설정 (일부 모듈용)
  DB_HOST: mariadb
  DB_NAME: db01
  DB_USER: user01
  DB_PASS: passw0rd

  # 사이트 설정
  SITE_NAME: "Drupal Core - LOCAL"
```

## 디렉토리 구조

```
drupal/
├── standalone/
│   └── compose.yml          # Docker Compose 설정 (실제 사용)
├── drupal-apache.dockerfile # Apache Dockerfile (개발용)
├── drupal-composer.dockerfile # Composer Dockerfile (개발용)
├── drupal-fpm.dockerfile    # PHP-FPM Dockerfile (개발용)
├── entrypoint.sh            # 엔트리포인트 스크립트
├── Makefile                 # Make 명령어
└── README.md                # 이 파일
```

## 사용법

### 관리자 페이지 접속

설치 시 생성한 계정으로 로그인:

```
URL: http://localhost:8120/user/login
또는: http://localhost:8120/admin
```

### 콘텐츠 타입 관리

1. 관리자 페이지 > Structure > Content types
2. Add content type 클릭
3. 콘텐츠 타입 이름과 설명 입력
4. 필드 추가 및 설정
5. Save 클릭

### 모듈 설치

#### 웹 인터페이스로 설치

1. 관리자 페이지 > Extend
2. Install new module 클릭
3. 모듈 파일 업로드 또는 URL 입력
4. Install 클릭
5. 모듈 활성화

#### Composer로 설치 (권장)

```bash
# 컨테이너 접속
docker-compose exec drupal bash

# Composer로 모듈 설치
cd /var/www/html
composer require drupal/[module_name]

# Drush로 모듈 활성화
drush en [module_name] -y
```

### 테마 설치

#### 웹 인터페이스로 설치

1. 관리자 페이지 > Appearance
2. Install new theme 클릭
3. 테마 파일 업로드 또는 URL 입력
4. Install 클릭
5. 테마 활성화

#### Composer로 설치 (권장)

```bash
# Composer로 테마 설치
docker-compose exec drupal composer require drupal/[theme_name]

# Drush로 테마 활성화
docker-compose exec drupal drush theme:enable [theme_name]
docker-compose exec drupal drush config:set system.theme default [theme_name] -y
```

### 뷰(Views) 생성

1. 관리자 페이지 > Structure > Views
2. Add view 클릭
3. 뷰 설정 (이름, 표시 형식, 필터 등)
4. Save and edit
5. 디스플레이 추가 및 설정

### 블록 관리

1. 관리자 페이지 > Structure > Block layout
2. Place block 클릭
3. 블록 선택 및 리전 지정
4. 설정 및 Save

## Drush (Drupal Shell)

Drush는 Drupal 명령줄 도구입니다.

### Drush 설치

```bash
# Composer로 Drush 설치
docker-compose exec drupal composer require drush/drush

# Drush 경로 확인
docker-compose exec drupal which drush
```

### Drush 명령어

```bash
# Drupal 상태 확인
docker-compose exec drupal drush status

# 캐시 클리어
docker-compose exec drupal drush cache-rebuild
# 또는 짧게
docker-compose exec drupal drush cr

# 모듈 목록
docker-compose exec drupal drush pm:list

# 모듈 활성화
docker-compose exec drupal drush en [module_name] -y

# 모듈 비활성화
docker-compose exec drupal drush pm:uninstall [module_name] -y

# 데이터베이스 업데이트
docker-compose exec drupal drush updatedb
# 또는
docker-compose exec drupal drush updb

# 설정 내보내기
docker-compose exec drupal drush config:export -y
# 또는
docker-compose exec drupal drush cex -y

# 설정 가져오기
docker-compose exec drupal drush config:import -y
# 또는
docker-compose exec drupal drush cim -y

# 사용자 생성
docker-compose exec drupal drush user:create testuser --mail="test@example.com" --password="password"

# 사용자 비밀번호 재설정
docker-compose exec drupal drush user:password admin "newpassword"

# 일회용 로그인 링크
docker-compose exec drupal drush user:login
```

## 유용한 모듈

### 관리 및 개발

- **Admin Toolbar**: 개선된 관리 툴바
- **Devel**: 개발자 도구
- **Web Profiler**: 성능 프로파일링
- **Configuration Split**: 환경별 설정 관리

### 콘텐츠 관리

- **Paragraphs**: 유연한 콘텐츠 구조
- **Entity Reference**: 엔티티 참조
- **Inline Entity Form**: 인라인 엔티티 편집
- **Media**: 미디어 관리

### SEO

- **Pathauto**: URL 자동 생성
- **Metatag**: 메타태그 관리
- **Redirect**: URL 리다이렉트
- **Simple XML Sitemap**: 사이트맵 생성

### 성능

- **Advanced CSS/JS Aggregation**: CSS/JS 최적화
- **Memcache API and Integration**: Memcache 통합
- **Redis**: Redis 캐시

### 보안

- **Security Kit**: 보안 강화
- **Password Policy**: 비밀번호 정책
- **Automated Logout**: 자동 로그아웃
- **Two-factor Authentication (TFA)**: 2단계 인증

### 기타

- **Views**: 콘텐츠 목록 및 쿼리 (코어 포함)
- **Webform**: 폼 빌더
- **Token**: 토큰 시스템
- **CKEditor**: WYSIWYG 에디터 (코어 포함)

## Composer 의존성 관리

```bash
# 컨테이너 접속
docker-compose exec drupal bash

# 모듈 설치
composer require drupal/[module_name]

# 특정 버전 설치
composer require drupal/[module_name]:^2.0

# 모듈 업데이트
composer update drupal/[module_name]

# 모든 패키지 업데이트
composer update

# 모듈 제거
composer remove drupal/[module_name]

# Drupal 코어 업데이트
composer update drupal/core --with-dependencies

# 개발 도구 설치
composer require --dev drupal/devel
```

## 볼륨

```yaml
volumes:
  - drupal:/var/www/html  # Drupal 파일 및 데이터
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
# Drush로 백업
docker-compose exec drupal drush sql:dump > backup.sql

# mysqldump로 백업
docker-compose exec mariadb mysqldump -u user01 -ppassw0rd db01 > backup.sql

# 복원
docker-compose exec drupal drush sql:cli < backup.sql
# 또는
docker-compose exec -T mariadb mysql -u user01 -ppassw0rd db01 < backup.sql
```

### 데이터베이스 접속

```bash
# Drush로 접속
docker-compose exec drupal drush sql:cli

# MySQL 클라이언트로 접속
docker-compose exec mariadb mysql -u user01 -ppassw0rd db01
```

## 문제 해결

### 설치 페이지가 보이지 않음

```bash
# 컨테이너 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs drupal

# 재시작
docker-compose restart drupal
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
# 파일 권한 설정
docker-compose exec drupal chown -R www-data:www-data /var/www/html/sites/default/files
docker-compose exec drupal chmod -R 755 /var/www/html/sites/default/files

# settings.php 권한
docker-compose exec drupal chmod 444 /var/www/html/sites/default/settings.php
```

### 캐시 문제

```bash
# Drupal 캐시 클리어 (Drush)
docker-compose exec drupal drush cr

# 웹 인터페이스
# 관리자 페이지 > Configuration > Development > Performance > Clear all caches

# Redis 캐시 클리어 (사용 시)
docker-compose exec redis redis-cli FLUSHALL
```

### White Screen of Death (WSOD)

```bash
# 에러 로그 확인
docker-compose exec drupal tail -f /var/log/apache2/error.log

# Verbose 에러 로깅 활성화
# settings.php에 추가:
# $config['system.logging']['error_level'] = 'verbose';

# 또는 Drush로
docker-compose exec drupal drush config:set system.logging error_level verbose -y

# 캐시 클리어
docker-compose exec drupal drush cr
```

### Drush가 없음

```bash
# Composer로 Drush 설치
docker-compose exec drupal composer global require drush/drush

# PATH 추가
docker-compose exec drupal bash -c 'echo "export PATH=\"\$HOME/.composer/vendor/bin:\$PATH\"" >> ~/.bashrc'
docker-compose exec drupal bash -c 'source ~/.bashrc'

# Drush 버전 확인
docker-compose exec drupal drush --version
```

### 모듈 설치 실패

```bash
# Composer 캐시 클리어
docker-compose exec drupal composer clear-cache

# 의존성 확인
docker-compose exec drupal composer why-not drupal/[module_name]

# 재시도
docker-compose exec drupal composer require drupal/[module_name] --no-cache
```

## 보안 설정

### 1. 관리자 비밀번호 변경

설치 후 반드시 강력한 비밀번호로 변경:

```bash
docker-compose exec drupal drush user:password admin "강력한비밀번호"
```

### 2. DB 비밀번호 변경

프로덕션에서는 강력한 비밀번호 사용:

```yaml
environment:
  DRUPAL_DATABASE_PASSWORD: 강력한비밀번호
  DB_PASS: 강력한비밀번호
```

### 3. Hash Salt 변경

새로운 hash salt 생성:

```bash
# 새로운 salt 생성
php -r "echo bin2hex(random_bytes(25));"

# compose.yml에 적용
environment:
  DRUPAL_HASH_SALT: [새로운_salt_값]
```

### 4. 파일 권한 설정

```bash
# settings.php 읽기 전용
docker-compose exec drupal chmod 444 /var/www/html/sites/default/settings.php

# 업로드 디렉토리
docker-compose exec drupal chmod 755 /var/www/html/sites/default/files
```

### 5. 불필요한 모듈 제거

```bash
# 사용하지 않는 모듈 삭제
docker-compose exec drupal drush pm:uninstall [module_name] -y
docker-compose exec drupal composer remove drupal/[module_name]
```

## 프로덕션 배포

### 1. 환경 변수 수정

```yaml
environment:
  DRUPAL_DATABASE_PASSWORD: 강력한비밀번호
  DRUPAL_HASH_SALT: [프로덕션용_새로운_salt]
  SITE_NAME: "Your Production Site"
```

### 2. 성능 최적화

```bash
# CSS/JS 집계 활성화
docker-compose exec drupal drush config:set system.performance css.preprocess 1 -y
docker-compose exec drupal drush config:set system.performance js.preprocess 1 -y

# 캐시 설정
docker-compose exec drupal drush config:set system.performance cache.page.max_age 3600 -y
```

### 3. HTTPS 설정

```bash
# settings.php에 추가
# $settings['reverse_proxy'] = TRUE;
# $settings['reverse_proxy_addresses'] = ['프록시_IP'];
# $settings['trusted_host_patterns'] = ['^yourdomain\.com$'];
```

### 4. 볼륨 백업

```bash
# 정기 백업 스크립트 설정
crontab -e
0 2 * * * docker-compose -f /path/to/drupal/standalone/compose.yml exec drupal drush sql:dump > /backup/drupal-backup-$(date +\%Y\%m\%d).sql
```

## Drupal 버전별 차이

### Drupal 10

- PHP 8.1+ 필수
- Symfony 6.x 기반
- CKEditor 5
- 개선된 미디어 시스템

### Drupal 9

- PHP 7.3+ 지원
- Symfony 4.x 기반
- CKEditor 4

## 기술 스택

- **Drupal**: 10.x
- **PHP**: 8.1+
- **Apache**: Bookworm
- **Composer**: Latest
- **Drush**: 11.x+ (권장)
- **MariaDB**: 11.8 (외부 서비스)
- **Redis**: Latest (외부 서비스)

## Port Information

See [PORT_STATUS.md](../PORT_STATUS.md) for port allocation strategy.

**Default port:**
- Drupal: 8120

To change the port, edit `standalone/compose.yml` or use environment variables.

## 참고 자료

- [Drupal 공식 사이트](https://www.drupal.org/)
- [Drupal 문서](https://www.drupal.org/docs)
- [Drupal API](https://api.drupal.org/)
- [Drush 문서](https://www.drush.org/)
- [Composer 의존성 관리](https://www.drupal.org/docs/develop/using-composer/manage-dependencies)
- [에러 로깅 가이드](https://www.drupal.org/docs/develop/development-tools/enable-verbose-error-logging-for-better-backtracing-and-debugging)
- [Drupal Container GitHub](https://github.com/geerlingguy/drupal-container)
- [Drupal Docker Hub](https://hub.docker.com/_/drupal)

## 관련 프로젝트

- [wordpress](../wordpress/README.md) - WordPress CMS
- [joomla](../joomla/README.md) - Joomla CMS
- [django-cms](../django-cms/README.md) - Django CMS

## 라이선스

Drupal은 GPL v2 라이선스를 따릅니다.
