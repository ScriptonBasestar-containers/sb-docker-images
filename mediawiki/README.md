# MediaWiki

MediaWiki는 Wikipedia에서 사용하는 강력하고 확장 가능한 오픈소스 위키 소프트웨어입니다. PHP로 작성되었으며, 대규모 협업 문서 작성에 최적화되어 있습니다.

## 개요

MediaWiki는 다음과 같은 기능을 제공합니다:
- Wikipedia와 동일한 위키 엔진
- 강력한 문서 관리 및 버전 관리
- 다양한 확장 기능 (Extensions)
- 스킨 커스터마이징
- 다국어 지원
- 이미지 및 미디어 파일 관리
- 카테고리 및 템플릿 시스템
- RESTful API
- 강력한 검색 기능

## 빠른 시작

```bash
# 1. 서비스 시작
docker compose up -d

# 2. 브라우저에서 접속
# http://localhost:8080

# 3. 초기 설정
# compose.yml의 환경 변수로 자동 설정되어 있습니다
# - Wiki Name: MyWiki
# - Admin User: admin1
# - Admin Password: qwer1234!@

# 4. LocalSettings.php 설정 (선택사항)
# 초기 설정 후 LocalSettings.php를 다운로드하여
# compose.yml의 volumes 주석을 해제하고 재시작

# 5. 위키 사용 시작
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **mediawiki**: MediaWiki 애플리케이션 (포트 8080→80)
  - PHP 기반 위키 엔진
  - 웹 UI 제공
  - API 서버
  - 확장 기능 지원

- **mariadb**: MariaDB 데이터베이스 (별도 실행 필요)
  - 위키 데이터 저장
  - 사용자 정보 관리
  - 페이지 히스토리 저장

- **redis**: Redis 캐시 (별도 실행 필요)
  - 세션 캐싱
  - 객체 캐싱
  - 성능 향상

> 참고: mariadb와 redis는 별도의 compose 파일이나 외부 서비스로 실행해야 합니다.

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8080 | mediawiki | MediaWiki 웹 사이트 (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 8080 포트 사용 중입니다.
>
> **권장 포트**: 8300 ([포트 가이드](../docs/PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # compose.yml 파일에서 수정
> sed -i 's/"8080:80"/"8300:80"/' compose.yml
>
> # 또는 직접 편집
> # ports:
> #   - "8300:80"
> ```

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

### 포트 변경 방법

compose.yml을 편집하여 포트를 변경할 수 있습니다:

```yaml
services:
  mediawiki:
    ports:
      - "8300:80"  # 8080 대신 8300 사용
```

또는 환경 변수를 사용:

```bash
# .env 파일 생성
MEDIAWIKI_PORT=8300

# compose.yml 수정
services:
  mediawiki:
    ports:
      - "${MEDIAWIKI_PORT:-8080}:80"
```

## 환경 변수

### 데이터베이스 설정

```yaml
# 데이터베이스 연결 설정
DB_HOST=mariadb          # 데이터베이스 호스트
DB_NAME=db01             # 데이터베이스 이름
DB_USER=user01           # 데이터베이스 사용자
DB_PASS=passw0rd         # 데이터베이스 비밀번호

# 초기 설치용 관리자 계정
DB_INSTALL_USER=root     # DB 관리자 (설치용)
DB_INSTALL_PASS=rootpass # DB 관리자 비밀번호
```

### MediaWiki 설정

```yaml
# 서버 설정
SERVER_HOSTNAME=http://localhost:8080  # 위키 URL

# 관리자 계정
ADMIN_USER=admin1        # 관리자 사용자명
ADMIN_PASS=qwer1234!@    # 관리자 비밀번호

# 위키 정보
WIKI_NAME=MyWiki         # 위키 이름
```

### 추가 환경 변수 (선택사항)

```yaml
services:
  mediawiki:
    environment:
      # 데이터베이스
      - DB_TYPE=mysql
      - DB_PREFIX=mw_
      - DB_PORT=3306

      # 언어 설정
      - MEDIAWIKI_LANG=ko  # 한국어

      # 업로드 설정
      - PHP_UPLOAD_MAX_FILESIZE=20M
      - PHP_POST_MAX_SIZE=20M

      # 메모리 제한
      - PHP_MEMORY_LIMIT=256M
```

## 사용법

### 기본 작업

```bash
# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# MediaWiki 로그만 확인
docker compose logs -f mediawiki

# 서비스 재시작
docker compose restart

# 서비스 중지
docker compose down

# 서비스 중지 및 데이터 삭제
docker compose down -v
```

### 초기 설정

MediaWiki는 환경 변수로 자동 설정되지만, 수동 설정도 가능합니다:

1. http://localhost:8080 접속
2. "Set up the wiki" 클릭
3. 설치 마법사 실행:
   - 언어 선택
   - 데이터베이스 설정 (환경 변수 사용)
   - 위키 이름 및 관리자 계정 설정
   - 옵션 설정
4. LocalSettings.php 다운로드
5. compose.yml의 volumes에 마운트:
   ```yaml
   volumes:
     - ./LocalSettings.php:/var/www/html/LocalSettings.php
   ```
6. 서비스 재시작: `docker compose restart`

### 확장 기능 설치

```bash
# 컨테이너 내부 접속
docker compose exec mediawiki bash

# Extension 다운로드 (예: VisualEditor)
cd /var/www/html/extensions
git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/VisualEditor.git

# LocalSettings.php에 추가
echo 'wfLoadExtension( "VisualEditor" );' >> /var/www/html/LocalSettings.php

# 서비스 재시작
exit
docker compose restart mediawiki
```

주요 확장 기능:
- **VisualEditor**: WYSIWYG 편집기
- **Cite**: 참고 문헌 기능
- **ParserFunctions**: 고급 파서 함수
- **SyntaxHighlight**: 코드 하이라이팅
- **Gadgets**: 사용자 정의 JavaScript/CSS
- **ConfirmEdit**: CAPTCHA 기능

### 스킨 변경

```bash
# 컨테이너 내부 접속
docker compose exec mediawiki bash

# 스킨 다운로드 (예: Timeless)
cd /var/www/html/skins
git clone https://gerrit.wikimedia.org/r/mediawiki/skins/Timeless.git

# LocalSettings.php에 추가
echo 'wfLoadSkin( "Timeless" );' >> /var/www/html/LocalSettings.php
echo '$wgDefaultSkin = "timeless";' >> /var/www/html/LocalSettings.php

# 서비스 재시작
exit
docker compose restart mediawiki
```

### 데이터 백업

```bash
# 데이터베이스 백업 (MariaDB 컨테이너에서)
docker exec mariadb mysqldump -u root -prootpass db01 > backup-$(date +%Y%m%d).sql

# 이미지 파일 백업
docker run --rm -v mediawiki_mediawiki-images:/data -v $(pwd):/backup \
  alpine tar czf /backup/mediawiki-images-$(date +%Y%m%d).tar.gz /data

# LocalSettings.php 백업
cp ./LocalSettings.php ./LocalSettings.php.backup

# 전체 백업 스크립트
mkdir -p backups
docker exec mariadb mysqldump -u root -prootpass db01 > backups/db-$(date +%Y%m%d).sql
docker run --rm -v mediawiki_mediawiki-images:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/images-$(date +%Y%m%d).tar.gz /data
```

### 데이터 복원

```bash
# 데이터베이스 복원
docker exec -i mariadb mysql -u root -prootpass db01 < backups/db-20250117.sql

# 이미지 파일 복원
docker run --rm -v mediawiki_mediawiki-images:/data -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/images-20250117.tar.gz -C /

# 서비스 재시작
docker compose restart mediawiki
```

### 유지보수 작업

```bash
# 데이터베이스 업데이트 (업그레이드 후)
docker compose exec mediawiki php /var/www/html/maintenance/update.php

# 캐시 클리어
docker compose exec mediawiki php /var/www/html/maintenance/rebuildall.php

# 검색 인덱스 재구축
docker compose exec mediawiki php /var/www/html/maintenance/rebuildrecentchanges.php

# 이미지 썸네일 재생성
docker compose exec mediawiki php /var/www/html/maintenance/rebuildImages.php

# 통계 업데이트
docker compose exec mediawiki php /var/www/html/maintenance/initSiteStats.php
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# MariaDB 서비스 확인
docker ps | grep mariadb

# MariaDB 로그 확인
docker logs mariadb

# 연결 테스트
docker compose exec mediawiki mysql -h mariadb -u user01 -ppassw0rd db01

# 데이터베이스 생성 (필요시)
docker exec -it mariadb mysql -u root -prootpass
CREATE DATABASE db01;
CREATE USER 'user01'@'%' IDENTIFIED BY 'passw0rd';
GRANT ALL PRIVILEGES ON db01.* TO 'user01'@'%';
FLUSH PRIVILEGES;
EXIT;
```

### "LocalSettings.php not found" 오류

```bash
# 초기 설정 실행
# http://localhost:8080 접속하여 설치 마법사 완료

# 또는 기존 LocalSettings.php 마운트
# compose.yml의 volumes 주석 해제
volumes:
  - ./LocalSettings.php:/var/www/html/LocalSettings.php

# 재시작
docker compose restart mediawiki
```

### 업로드가 작동하지 않음

LocalSettings.php에 다음 추가:

```php
$wgEnableUploads = true;
$wgUploadDirectory = "/var/www/html/images";
$wgUploadPath = "/images";
$wgFileExtensions = array('png', 'gif', 'jpg', 'jpeg', 'pdf', 'svg');
$wgMaxUploadSize = 20 * 1024 * 1024; // 20MB
```

컨테이너 재시작:
```bash
docker compose restart mediawiki
```

### 권한 오류

```bash
# 이미지 디렉토리 권한 확인
docker compose exec mediawiki ls -la /var/www/html/images

# 권한 수정
docker compose exec mediawiki chown -R www-data:www-data /var/www/html/images

# 볼륨 권한 재설정 (필요시)
docker compose down
docker volume rm mediawiki_mediawiki-images
docker compose up -d
```

### 성능 문제

LocalSettings.php에 캐싱 설정 추가:

```php
# Redis 캐싱 (redis 서비스 필요)
$wgMainCacheType = CACHE_REDIS;
$wgRedisServers = [
    [
        'host' => 'redis',
        'port' => 6379,
    ],
];

# 객체 캐싱
$wgCacheDirectory = "/tmp/cache";

# 파일 캐시
$wgUseFileCache = true;
$wgFileCacheDirectory = "/tmp/filecache";

# Memcached (대안)
# $wgMainCacheType = CACHE_MEMCACHED;
# $wgMemCachedServers = ['memcached:11211'];
```

### 로고 변경

LocalSettings.php에 다음 추가:

```php
$wgLogos = [
    '1x' => "/path/to/logo.png",
    '1.5x' => "/path/to/logo-1.5x.png",
    '2x' => "/path/to/logo-2x.png",
    'icon' => "/path/to/icon.png",
    'wordmark' => [
        'src' => "/path/to/wordmark.svg",
        'width' => 116,
        'height' => 18,
    ],
];
```

### API 활성화

LocalSettings.php에 다음 추가:

```php
$wgEnableAPI = true;
$wgEnableWriteAPI = true;

# API 액세스 제한 (선택사항)
$wgAPIModules['login'] = 'ApiLogin';
```

## 참고 자료

- [MediaWiki 공식 사이트](https://www.mediawiki.org/)
- [MediaWiki 공식 문서](https://www.mediawiki.org/wiki/Documentation)
- [MediaWiki 설치 가이드](https://www.mediawiki.org/wiki/Manual:Installation_guide)
- [MediaWiki Docker 가이드](https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Docker)
- [MediaWiki 확장 기능](https://www.mediawiki.org/wiki/Category:Extensions)
- [MediaWiki 스킨](https://www.mediawiki.org/wiki/Category:All_skins)
- [MediaWiki API 문서](https://www.mediawiki.org/wiki/API:Main_page)

## 기술 스택

- **Backend**: PHP
- **Database**: MariaDB / MySQL
- **Cache**: Redis (선택사항)
- **Web Server**: Apache
- **Container**: Docker, Docker Compose
- **마크업**: WikiText (MediaWiki 문법)

## 주요 기능

### 문서 관리
- 버전 관리 및 히스토리
- Diff 비교
- 페이지 되돌리기
- 문서 병합
- 삭제 및 복구

### 사용자 및 권한
- 사용자 등록 및 로그인
- 사용자 그룹 및 권한
- IP 기반 접근 제어
- CAPTCHA 지원
- 차단 기능

### 콘텐츠 구성
- 카테고리 시스템
- 템플릿 및 트랜스클루전
- 네임스페이스
- 리다이렉트
- 특수 문서

### 미디어 관리
- 이미지 업로드 및 관리
- 썸네일 자동 생성
- 다양한 파일 형식 지원
- 미디어 갤러리
- SVG 지원

### 검색 및 탐색
- 전체 텍스트 검색
- 고급 검색
- 최근 변경 추적
- 주시 문서
- 관련 문서

### API 및 통합
- RESTful API
- MediaWiki API
- 외부 인증 (OAuth, LDAP 등)
- 웹훅
- RSS/Atom 피드

## 라이선스

MediaWiki는 GPL-2.0+ 라이선스로 배포됩니다.

## 보안

### 프로덕션 환경 권장 사항

1. **데이터베이스 비밀번호 변경**:
```yaml
environment:
  DB_PASS: <강력한-비밀번호>
  DB_INSTALL_PASS: <강력한-관리자-비밀번호>
  ADMIN_PASS: <강력한-관리자-비밀번호>
```

2. **HTTPS 설정**:
LocalSettings.php에 추가:
```php
$wgServer = "https://your-domain.com";
$wgCookieSecure = true;
```

3. **업로드 제한**:
```php
$wgFileExtensions = array('png', 'gif', 'jpg', 'jpeg', 'pdf');
$wgStrictFileExtensions = true;
$wgCheckFileExtensions = true;
```

4. **스팸 방지**:
ConfirmEdit 확장 설치 및 활성화

5. **백업 자동화**:
정기적인 데이터베이스 및 파일 백업 스케줄 설정

6. **권한 설정**:
```php
$wgGroupPermissions['*']['edit'] = false;  // 익명 편집 금지
$wgGroupPermissions['*']['createaccount'] = false;  // 자동 가입 금지
```

7. **방화벽 설정**:
필요한 포트만 외부에 노출

8. **업데이트 유지**:
정기적으로 MediaWiki 및 확장 기능 업데이트

## 고급 설정

### 개발 환경 설정 (compose-new.yaml)

개발용 공식 Wikimedia 이미지를 사용하려면 compose-new.yaml을 참조하세요:

```yaml
services:
  mediawiki:
    image: docker-registry.wikimedia.org/dev/buster-php81-fpm:1.0.1-s2
    environment:
      MW_DOCKER_PORT: "${MW_DOCKER_PORT:-8080}"
      MW_DBTYPE: 'sqlite'  # SQLite 사용
      MW_USER: '${MEDIAWIKI_USER:-Admin}'
      MW_PASS: '${MEDIAWIKI_PASSWORD:-dockerpass}'
```

### 다국어 설정

LocalSettings.php에 추가:

```php
$wgLanguageCode = "ko";  # 기본 언어
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

# 다국어 지원
$wgGroupPermissions['user']['translate'] = true;
```

### 단축 URL 설정

LocalSettings.php에 추가:

```php
$wgScriptPath = "/w";
$wgArticlePath = "/wiki/$1";
$wgUsePathInfo = true;
```

Apache 설정 필요 (컨테이너 재빌드 또는 커스텀 이미지)

## CLI 도구

### mwcli 설치 (선택사항)

```bash
# 컨테이너 내부에서
apt-get update && apt-get install -y git
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

cd /tmp
git clone https://github.com/samwilson/mwcli
cd mwcli
composer install --no-dev
export PATH=$PATH:/tmp/mwcli/bin
```

### CLI로 설치

```bash
docker compose exec mediawiki php maintenance/install.php \
  --dbname=db01 \
  --dbserver="mariadb" \
  --installdbuser=root \
  --installdbpass=rootpass \
  --dbuser=user01 \
  --dbpass=passw0rd \
  --server="http://localhost:8080" \
  --lang=ko \
  --pass=qwer1234!@ \
  "MyWiki" \
  "admin1"
```

## 참고 사항

- **M1/ARM64 지원**: 현재 일부 이미지는 M1/ARM64를 지원하지 않을 수 있습니다
- **네트워크**: app-network와 data-network 두 개의 네트워크 사용
- **볼륨**: mediawiki-images 볼륨에 업로드된 파일 저장
