# DokuWiki Standalone Configuration

완전한 독립 실행 가능한 DokuWiki 파일 기반 위키 시스템 구성

## 개요

이 standalone 구성은 DokuWiki를 즉시 실행할 수 있도록 구성되어 있습니다. DokuWiki는 데이터베이스가 필요 없는 파일 기반 위키로, 매우 간단하게 설치하고 사용할 수 있습니다.

### 포함된 서비스

- **DokuWiki**: 파일 기반 위키 시스템 (포트 8080)
- **데이터베이스 불필요**: 모든 데이터가 파일로 저장됨

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env 파일 생성
cp .env.example .env

# 필수 항목 수정
# - DOKUWIKI_ADMIN_PASS: 강력한 관리자 비밀번호
```

### 2. DokuWiki 시작

```bash
# 서비스 시작
make up
```

### 3. 접속 및 로그인

```
http://localhost:8080
```

관리자 계정으로 로그인:
- Username: `admin` (또는 .env에서 설정한 값)
- Password: `.env`에서 설정한 `DOKUWIKI_ADMIN_PASS` 값

### 4. 관리자 패널 접속

```
http://localhost:8080/doku.php?do=admin
```

## 사용 가능한 명령어

### 서비스 관리

```bash
# DokuWiki 시작
make up

# DokuWiki 중지
make down

# 로그 확인
make logs

# DokuWiki 재시작
make restart

# 실행 중인 컨테이너 확인
make ps
```

### 접속 및 관리

```bash
# DokuWiki 컨테이너 쉘 접속
make shell
```

### 백업 및 복원

```bash
# DokuWiki 전체 백업
make backup

# 백업에서 복원
make restore
```

### 데이터 정리

```bash
# 모든 데이터 삭제 (⚠️ 주의: 복구 불가능)
make clean
```

## DokuWiki 기능

### 주요 기능

- **파일 기반**: 데이터베이스 불필요, 모든 데이터가 텍스트 파일로 저장
- **버전 관리**: 모든 페이지 변경 이력 자동 저장
- **네임스페이스**: 계층적 페이지 구조
- **접근 제어**: ACL(Access Control List)을 통한 세밀한 권한 관리
- **플러그인 시스템**: 다양한 확장 기능
- **템플릿**: 외관 커스터마이징
- **미디어 관리**: 이미지 및 파일 업로드/관리
- **검색**: 전문 검색 기능
- **다국어**: 50개 이상 언어 지원

### 지원 문법

- **DokuWiki 문법**: 간단하고 직관적인 위키 문법
- **Markdown**: 플러그인을 통한 마크다운 지원
- **HTML**: 제한적 HTML 태그 지원

## 사용법

### 페이지 생성

1. 새 페이지 링크 작성:
   ```
   [[new_page|새 페이지]]
   ```

2. 링크 클릭하여 페이지 생성

3. 내용 작성 및 저장

### 네임스페이스 사용

네임스페이스로 페이지를 계층적으로 구성:

```
[[project:documentation:api|API 문서]]
[[project:documentation:guide|가이드]]
```

디렉토리 구조:
```
project/
  documentation/
    api.txt
    guide.txt
```

### 이미지 삽입

```
{{:image.png}}                     # 원본 크기
{{:image.png?200}}                 # 너비 200px
{{:image.png?200x100}}             # 너비 200px, 높이 100px
{{wiki:dokuwiki-128.png|DokuWiki}} # Alt 텍스트
```

### 미디어 파일 업로드

1. 편집 모드에서 미디어 관리자 버튼 클릭
2. 파일 선택 및 업로드
3. 네임스페이스 지정 가능

### ACL 설정

관리자 패널 > Access Control Manager

권한 레벨:
- **None**: 접근 불가
- **Read**: 읽기만 가능
- **Edit**: 편집 가능
- **Create**: 새 페이지 생성 가능
- **Upload**: 파일 업로드 가능
- **Delete**: 삭제 가능

설정 예시:
```
# 전체 위키를 로그인 사용자만 읽기 가능
*                @ALL        0
*                @user       1

# 특정 네임스페이스를 특정 그룹만 편집 가능
project:internal @admin      8
project:internal @developer  2
project:internal @ALL        1
```

### 플러그인 관리

관리자 패널 > Extension Manager

**권장 플러그인:**
- **Wrap**: 박스, 컬럼 등 레이아웃 요소
- **ckgedit**: WYSIWYG 편집기
- **dw2pdf**: PDF 내보내기
- **pagelist**: 페이지 목록 생성
- **Discussion**: 댓글/토론 기능
- **tagging**: 태그 기능
- **gallery**: 이미지 갤러리
- **Include**: 다른 페이지 포함
- **Graphviz**: 다이어그램 생성

플러그인 설치:
1. Extension Manager 접속
2. Search and Install 탭
3. 플러그인 검색 및 설치

### 템플릿 변경

관리자 패널 > Configuration Settings > Template

**인기 템플릿:**
- **dokuwiki** (기본): 심플하고 깔끔
- **bootstrap3**: 모던한 부트스트랩 디자인
- **vector**: 미디어위키 스타일
- **argon**: 모던하고 반응형

## 백업 및 복원

### 자동 백업

DokuWiki는 자동으로 페이지 변경 이력을 보관합니다:
- `data/pages/`: 현재 페이지
- `data/attic/`: 이전 버전들
- `data/meta/`: 메타데이터

### 수동 백업

```bash
# 전체 백업 (페이지, 미디어, 설정 포함)
make backup

# 백업 파일은 ./backups/ 디렉토리에 저장
# 파일명 형식: dokuwiki-backup-YYYYMMDD-HHMMSS.tar.gz
```

### 백업 복원

```bash
# 대화형 복원
make restore

# 프롬프트에서 백업 파일명 입력
```

### 중요한 백업 항목

DokuWiki storage 디렉토리 (`/dokuwiki/storage`) 포함 항목:
- **data/pages/**: 모든 위키 페이지
- **data/media/**: 업로드된 이미지 및 파일
- **data/meta/**: 페이지 메타데이터
- **data/attic/**: 페이지 변경 이력
- **data/cache/**: 캐시 (선택적)
- **conf/**: 설정 파일

## 문제 해결

### DokuWiki가 시작되지 않는 경우

```bash
# 로그 확인
make logs

# 일반적인 원인:
# 1. 포트 충돌 (8080)
# 2. 권한 문제
```

### 포트 충돌

`.env` 파일에서 포트 변경:

```bash
DOKUWIKI_PORT=8090
```

```bash
# 재시작
make down
make up
```

### 관리자 비밀번호 분실

```bash
# 컨테이너 쉘 접속
make shell

# 사용자 데이터 파일 확인
cat /dokuwiki/storage/conf/users.auth.php

# 비밀번호 해시 재생성 (PHP)
php -r "echo password_hash('new_password', PASSWORD_DEFAULT);"

# users.auth.php 파일 편집하여 해시 업데이트
```

또는 `.env` 파일에서 새 비밀번호 설정 후 재시작:

```bash
# .env 파일 수정
DOKUWIKI_ADMIN_PASS=new-password

# 재시작 (초기 설정 다시 실행됨)
make down
make clean  # ⚠️ 모든 데이터 삭제
make up
```

### 파일 업로드 실패

권한 문제일 수 있습니다:

```bash
# 컨테이너 쉘 접속
make shell

# 권한 확인
ls -la /dokuwiki/storage/data/media/

# 필요시 권한 수정 (컨테이너 내부에서)
chown -R www-data:www-data /dokuwiki/storage/data/media/
```

### 페이지가 저장되지 않는 경우

```bash
# 디스크 공간 확인
df -h

# 볼륨 상태 확인
docker volume inspect dokuwiki-storage

# 로그 확인
make logs
```

## 고급 설정

### 환경 변수를 통한 설정

`.env` 파일에서 주요 설정 변경 가능:

```bash
# 위키 언어 변경 (한국어)
DOKUWIKI_WIKI_LANG=ko

# 위키 제목 변경
DOKUWIKI_WIKI_TITLE=우리 회사 위키

# 타임존 변경
TZ=Asia/Seoul
```

### 설정 파일 직접 수정

고급 설정은 컨테이너 내부 또는 볼륨에서 직접 수정:

```bash
# 컨테이너 쉘 접속
make shell

# 주요 설정 파일
# /dokuwiki/storage/conf/local.php        - 로컬 설정
# /dokuwiki/storage/conf/users.auth.php   - 사용자 데이터
# /dokuwiki/storage/conf/acl.auth.php     - ACL 설정
```

### Nginx 리버스 프록시 (HTTPS)

```nginx
# nginx.conf
server {
    listen 80;
    server_name wiki.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name wiki.example.com;

    ssl_certificate /etc/ssl/certs/wiki.crt;
    ssl_certificate_key /etc/ssl/private/wiki.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Important for DokuWiki
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
    }
}
```

DokuWiki 설정 업데이트:

```bash
# 관리자 패널 > Configuration Settings
# baseurl: https://wiki.example.com
# userewrite: 1 (URL rewriting 활성화)
```

## 보안 권장사항

### 1. 강력한 관리자 비밀번호

```bash
# 강력한 비밀번호 생성
openssl rand -base64 32
```

### 2. ACL 설정

- 기본적으로 모든 페이지를 비공개로 설정
- 필요한 페이지만 공개
- 사용자 그룹별 권한 세밀하게 관리

### 3. 플러그인 보안

- 신뢰할 수 있는 소스의 플러그인만 설치
- 정기적으로 플러그인 업데이트
- 사용하지 않는 플러그인 제거

### 4. 정기 백업

```bash
# 일일 백업 자동화 (cron)
0 2 * * * cd /path/to/dokuwiki/standalone && make backup
```

### 5. HTTPS 사용

프로덕션 환경에서는 반드시 HTTPS 사용

### 6. 파일 업로드 제한

관리자 패널 > Configuration Settings:
- `maxsize`: 업로드 최대 크기 제한
- `mime`: 허용할 파일 형식 제한

## 성능 최적화

### 캐시 설정

관리자 패널 > Configuration Settings > Performance:
- `cachetime`: 캐시 유지 시간 (기본: 1일)
- `compress`: 페이지 압축 활성화

### 검색 인덱스

```bash
# 컨테이너 내부에서 수동 인덱싱
make shell
php /dokuwiki/bin/indexer.php
```

### 볼륨 성능

로컬 볼륨 대신 named volume 사용 (이미 적용됨):
```yaml
volumes:
  dokuwiki-storage:
    driver: local
```

## DokuWiki 문법 참고

### 기본 포맷팅

```
**굵게** __굵게__
//기울임// ''기울임''
__**굵게 기울임**__
<del>취소선</del>
<sub>아래첨자</sub>
<sup>위첨자</sup>
''monospace''
```

### 제목

```
====== 제목 1 ======
===== 제목 2 =====
==== 제목 3 ====
=== 제목 4 ===
== 제목 5 ==
```

### 링크

```
[[pagename|링크 텍스트]]
[[namespace:pagename|링크]]
http://www.example.com
[[http://www.example.com|외부 링크]]
```

### 리스트

```
  * 항목 1
  * 항목 2
    * 하위 항목 2.1

  - 번호 리스트 1
  - 번호 리스트 2
    - 하위 항목 2.1
```

### 표

```
^ 제목 1      ^ 제목 2        ^
| 셀 1-1      | 셀 1-2        |
| 셀 2-1      | 셀 2-2        |
```

### 코드 블록

```
<code>
일반 코드
</code>

<code php>
<?php
echo "PHP 코드";
?>
</code>

<file>
파일 내용
</file>
```

## 참고 자료

- [DokuWiki 공식 사이트](https://www.dokuwiki.org/)
- [DokuWiki 문서](https://www.dokuwiki.org/manual)
- [DokuWiki 문법](https://www.dokuwiki.org/syntax)
- [플러그인 목록](https://www.dokuwiki.org/plugins)
- [템플릿 목록](https://www.dokuwiki.org/template)
- [FAQ](https://www.dokuwiki.org/faq)
- [포트 가이드](../../docs/PORT_GUIDE.md)

## 라이센스

DokuWiki는 GPL 2 License를 따릅니다.
