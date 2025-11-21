# Joomla

Joomla CMS 개발 환경

> 💡 **Quick Start**: For production deployment with database and caching, use the [standalone setup](standalone/README.md) - it includes MariaDB, Redis, and comprehensive documentation!

## 개요

Joomla는 전 세계적으로 널리 사용되는 오픈소스 콘텐츠 관리 시스템(CMS)입니다:
- 🌐 유연하고 확장 가능한 CMS 플랫폼
- 🎨 다양한 템플릿과 확장 기능
- 🔌 수천 개의 무료/유료 확장 프로그램
- ✍️ 강력한 콘텐츠 관리 기능
- 📱 반응형 디자인 지원
- 🔍 SEO 최적화 기능 내장
- 👥 다국어 지원

이 프로젝트는 Joomla의 개발 및 테스트를 위한 Docker 환경을 제공합니다.

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Joomla 5 PHP 8.3 Apache
- ✅ MariaDB 11.8 with health check
- ✅ Redis 7 for caching
- ✅ Standardized Makefile

**Access:** http://localhost:8110

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Uses minimal configuration with external services.

## Quick Start (Basic Setup)

```bash
# 컨테이너 시작
docker-compose up -d

# 웹 브라우저로 접속
# http://localhost:8110

# Joomla 설치 마법사 실행
# 1. http://localhost:8110 접속
# 2. 사이트 정보 입력
# 3. DB 정보 입력:
#    - DB Host: mariadb
#    - DB Name: db01
#    - DB User: user01
#    - DB Password: passw0rd
# 4. 설치 완료
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **joomla**: Joomla 5 PHP 8.3 Apache (포트 8110)
- **mariadb**: MariaDB 데이터베이스 (외부 서비스)
- **redis**: Redis 캐시 서버 (외부 서비스)

## Default Configuration

**Default port:** 8110 (recommended port - see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** joomla

Environment variables:

```bash
JOOMLA_DB_HOST=mariadb
JOOMLA_DB_USER=user01
JOOMLA_DB_PASSWORD=passw0rd
JOOMLA_DB_NAME=db01
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8110 | joomla | Joomla web application |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## 환경 변수

compose.yml에서 설정:

```yaml
environment:
  JOOMLA_DB_HOST: mariadb
  JOOMLA_DB_USER: user01
  JOOMLA_DB_PASSWORD: passw0rd
  JOOMLA_DB_NAME: db01
  JOOMLA_SITE_NAME: Joomla
  JOOMLA_ADMIN_USER: Joomla Hero
  JOOMLA_ADMIN_USERNAME: joomla
  JOOMLA_ADMIN_PASSWORD: joomla@secured
  JOOMLA_ADMIN_EMAIL: joomla@example.com
```

## 디렉토리 구조

```
joomla/
├── docker-compose.yml    # Docker Compose 설정
└── README.md            # 이 파일
```

## 사용법

### 관리자 페이지 접속

```
URL: http://localhost:8110/administrator
Username: joomla
Password: joomla@secured
```

### 확장 기능 설치

1. 관리자 페이지 접속
2. System > Extensions > Install
3. 확장 기능 파일 업로드 또는 URL 입력
4. 설치 완료

### 템플릿 설치

1. 관리자 페이지 > System > Site Templates
2. Install 버튼 클릭
3. 템플릿 파일 업로드
4. 설치 후 활성화

### 모듈 관리

1. 관리자 페이지 > Content > Site Modules
2. 원하는 모듈 편집 또는 새로 생성
3. 위치 및 설정 조정
4. 저장

### 메뉴 관리

1. 관리자 페이지 > Menus
2. 메뉴 항목 추가/편집
3. 메뉴 타입 선택 (Article, Category, Custom URL 등)
4. 저장

## 볼륨

```yaml
volumes:
  - joomla:/var/www/html  # Joomla 파일 및 데이터
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
# 백업
docker-compose exec mariadb mysqldump -u user01 -ppassw0rd db01 > backup.sql

# 복원
docker-compose exec -T mariadb mysql -u user01 -ppassw0rd db01 < backup.sql
```

## 문제 해결

### 설치 페이지가 보이지 않음

```bash
# 컨테이너 상태 확인
docker-compose ps

# 로그 확인
docker-compose logs joomla

# 재시작
docker-compose restart joomla
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

### 파일 업로드 실패

```bash
# 볼륨 권한 확인
docker-compose exec joomla ls -la /var/www/html

# PHP 설정 확인
docker-compose exec joomla php -i | grep upload_max_filesize
docker-compose exec joomla php -i | grep post_max_size
```

### 캐시 문제

```bash
# Joomla 캐시 클리어
# 관리자 페이지 > System > Clear Cache

# Redis 캐시 클리어 (사용 시)
docker-compose exec redis redis-cli FLUSHALL
```

## 보안 설정

### 1. 관리자 비밀번호 변경

설치 후 반드시 강력한 비밀번호로 변경:

```
관리자 페이지 > Users > Manage > 관리자 계정 선택 > 비밀번호 변경
```

### 2. DB 비밀번호 변경

프로덕션에서는 강력한 비밀번호 사용:

```yaml
environment:
  JOOMLA_DB_PASSWORD: 강력한비밀번호
```

### 3. Two-Factor Authentication 활성화

```
관리자 페이지 > Users > Manage > 관리자 계정 > Two Factor Authentication
```

### 4. 불필요한 확장 기능 제거

```
System > Extensions > Manage > 사용하지 않는 확장 기능 삭제
```

## 유용한 확장 기능

### SEO

- **sh404SEF**: SEO 최적화
- **JoomSEF**: URL 개선

### 보안

- **Akeeba Backup**: 백업 및 복원
- **Admin Tools**: 보안 강화

### 성능

- **JCH Optimize**: CSS/JS 최적화
- **Cache Cleaner**: 캐시 관리

### 콘텐츠

- **K2**: 확장된 콘텐츠 관리
- **JCE Editor**: 강화된 에디터

## 프로덕션 배포

### 1. 환경 변수 수정

```yaml
environment:
  JOOMLA_DB_PASSWORD: 강력한비밀번호
  JOOMLA_ADMIN_PASSWORD: 강력한비밀번호
```

### 2. HTTPS 설정

Apache에 SSL 인증서 추가 또는 리버스 프록시 사용

### 3. 볼륨 백업

```bash
# 정기 백업 스크립트 설정
crontab -e
0 2 * * * /path/to/backup-script.sh
```

### 4. 보안 헤더 설정

```apache
# .htaccess 또는 Apache 설정
Header set X-Frame-Options "SAMEORIGIN"
Header set X-Content-Type-Options "nosniff"
Header set X-XSS-Protection "1; mode=block"
```

## 기술 스택

- **Joomla**: 5.x
- **PHP**: 8.3
- **Apache**: Latest
- **MariaDB**: 11.8 (외부 서비스)
- **Redis**: Latest (외부 서비스)

## 참고 자료

- [Joomla 공식 사이트](https://www.joomla.org/)
- [Joomla 문서](https://docs.joomla.org/)
- [Joomla Extensions Directory](https://extensions.joomla.org/)
- [Joomla 포럼](https://forum.joomla.org/)
- [Joomla Docker Hub](https://hub.docker.com/_/joomla)

## 관련 프로젝트

- [wordpress](../wordpress/README.md) - WordPress CMS
- [drupal](../drupal/README.md) - Drupal CMS
- [django-cms](../django-cms/README.md) - Django CMS

## 라이선스

Joomla는 GPL v2 라이선스를 따릅니다.
