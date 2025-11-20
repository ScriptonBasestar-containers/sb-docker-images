# openNAMU Standalone Configuration

완전한 독립 실행형 openNAMU 한국어 위키 시스템

## 개요

이 standalone 구성은 openNAMU를 MariaDB와 함께 즉시 실행할 수 있는 완전한 패키지입니다.

### 포함된 서비스

- **openNAMU**: Python/Flask 기반 위키 애플리케이션 (포트 8330)
- **MariaDB**: 데이터베이스

### 주요 기능

- the seed 문법 지원 (나무위키 호환)
- 문서 역사 및 편집 추적
- ACL (접근 제어)
- 다양한 네임스페이스
- 테마 커스터마이징
- 한국어 최적화

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env.example을 .env로 복사
cp .env.example .env
```

### 2. .env 파일 수정

```bash
# 필수 설정
DB_PASSWORD=strong_password_here
MYSQL_PASSWORD=strong_password_here
MYSQL_ROOT_PASSWORD=strong_root_password_here
ADMIN_PASSWORD=strong_admin_password_here
WIKI_NAME=우리 위키  # 원하는 위키 이름으로 변경
```

### 3. 서비스 시작

```bash
# 모든 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f opennamu
```

### 4. 접속 및 초기 설정

- **웹사이트**: http://localhost:8330
- 초기 설정 마법사가 나타나면:
  1. 관리자 계정 설정 (또는 ADMIN_PASSWORD 사용)
  2. 위키 기본 정보 입력
  3. 설정 완료

### 5. 첫 문서 작성

- **대문 페이지**: http://localhost:8330/w/FrontPage
- the seed 문법을 사용하여 문서 작성

## 포트 정보

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 8330 | openNAMU | 위키 웹 인터페이스 |

포트는 `.env` 파일에서 변경할 수 있습니다:
```bash
OPENNAMU_PORT=8330
```

## 주요 명령어

### 서비스 관리

```bash
# 로그 확인
docker compose logs -f

# openNAMU 재시작
docker compose restart opennamu

# 모든 서비스 중지
docker compose down

# 볼륨 포함 완전 삭제 (주의: 모든 데이터 삭제!)
docker compose down -v
```

### 데이터베이스 관리

```bash
# 데이터베이스 백업
docker compose exec mariadb mysqldump -u opennamu -p opennamu > backup.sql
# 비밀번호 입력 필요

# 데이터베이스 복원
cat backup.sql | docker compose exec -T mariadb mysql -u opennamu -p opennamu
# 비밀번호 입력 필요

# MariaDB 콘솔 접속
docker compose exec mariadb mysql -u opennamu -p opennamu
```

### 파일 백업

```bash
# 업로드된 파일 백업
docker compose exec opennamu tar -czf /tmp/uploads.tar.gz /app/route/upload
docker compose cp opennamu:/tmp/uploads.tar.gz ./uploads-backup.tar.gz

# 데이터 디렉토리 백업
docker compose exec opennamu tar -czf /tmp/data.tar.gz /app/data
docker compose cp opennamu:/tmp/data.tar.gz ./data-backup.tar.gz
```

## the seed 문법 가이드

### 기본 문법

```
= 제목 1 =
== 제목 2 ==
=== 제목 3 ===

**굵게**
//기울임//
--취소선--
__밑줄__

[[문서이름]]  # 내부 링크
[[https://example.com|외부 링크]]

* 순서 없는 목록
 * 들여쓰기
  * 더 들여쓰기

1. 순서 있는 목록
 1. 들여쓰기

{{{#!syntax python
print("Hello, World!")
}}}
```

### 고급 기능

```
[include(틀:문서이름)]  # 틀 삽입
[목차]  # 목차 생성
[각주(각주 내용)]  # 각주
[br]  # 줄바꿈
```

## 관리

### 관리자 페이지

- URL: http://localhost:8330/admin
- 관리자 계정으로 로그인 필요

### ACL (접근 제어) 설정

```bash
# 관리자 페이지에서 설정 가능
1. 관리자 로그인
2. 관리 > ACL 설정
3. 문서/네임스페이스별 권한 설정
   - 읽기 권한
   - 편집 권한
   - 삭제 권한
```

### 사용자 관리

```bash
# 관리자 페이지에서:
1. 관리 > 사용자 관리
2. 사용자 목록 확인
3. 권한 변경
4. 사용자 차단/해제
```

### 스팸 방지

```bash
# 관리자 페이지에서:
1. 관리 > 스팸 필터
2. IP 차단 목록 관리
3. 편집 제한 설정
4. CAPTCHA 설정
```

## 프로덕션 배포

### 1. 보안 설정

```bash
# 강력한 비밀번호 설정
DB_PASSWORD=$(openssl rand -base64 32)
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)
ADMIN_PASSWORD=$(openssl rand -base64 16)
```

### 2. HTTPS 설정

```bash
# Nginx 리버스 프록시 사용 권장
# Let's Encrypt로 SSL 인증서 설정
```

### 3. 백업 자동화

```bash
# crontab 설정 예시
# 매일 오전 3시 데이터베이스 백업
0 3 * * * cd /path/to/opennamu && docker compose exec mariadb mysqldump -u opennamu -pYOUR_PASSWORD opennamu > backup-$(date +\%Y\%m\%d).sql
```

### 4. 성능 최적화

```bash
# MariaDB 성능 튜닝
# docker-compose.yml의 mariadb 서비스에 추가:
# command: --innodb-buffer-pool-size=1G --max-connections=200
```

## 테마 커스터마이징

### 스킨 변경

```bash
# .env 파일에서 설정
WIKI_SKIN=namu  # 나무위키 스타일
# 또는
WIKI_SKIN=buma  # 기본 스타일
```

### 커스텀 CSS

```bash
# 관리자 페이지에서:
1. 관리 > 설정 > 디자인
2. 사용자 정의 CSS 입력
3. 저장
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# MariaDB 상태 확인
docker compose ps mariadb

# 데이터베이스 재시작
docker compose restart mariadb

# 연결 테스트
docker compose exec mariadb mysql -u opennamu -p -e "SELECT 1;"
```

### 업로드 실패

```bash
# 권한 확인
docker compose exec opennamu ls -la /app/route/upload

# 볼륨 권한 수정 (필요시)
docker compose exec opennamu chown -R www-data:www-data /app/route/upload
```

### 페이지가 느림

```bash
# 캐시 클리어
docker compose exec mariadb mysql -u opennamu -p -e "TRUNCATE TABLE cache;"

# MariaDB 최적화
docker compose exec mariadb mysqlcheck -u opennamu -p --optimize opennamu
```

## 유지보수

### 정기 작업

```bash
# 주간: 데이터베이스 백업
docker compose exec mariadb mysqldump -u opennamu -p opennamu > backup-$(date +%Y%m%d).sql

# 월간: 데이터베이스 최적화
docker compose exec mariadb mysqlcheck -u opennamu -p --optimize opennamu

# 월간: 오래된 로그 정리
docker compose exec opennamu find /app/data/logs -name "*.log" -mtime +30 -delete
```

### 업데이트

```bash
# 이미지 업데이트
docker compose pull

# 서비스 재시작
docker compose down
docker compose up -d
```

## 보안 권장사항

1. ✅ 강력한 비밀번호 사용
2. ✅ HTTPS 사용 (Let's Encrypt)
3. ✅ 정기적인 백업
4. ✅ ACL 적절히 설정
5. ✅ 스팸 필터 활성화
6. ✅ IP 차단 목록 관리
7. ✅ 관리자 페이지 접근 제한
8. ✅ 파일 업로드 크기 제한

## 참고 자료

- [openNAMU GitHub](https://github.com/opennamu/opennamu)
- [openNAMU Wiki](https://github.com/opennamu/opennamu/wiki)
- [the seed 문법](https://theseed.io/wiki/더_시드_엔진)
- [나무위키 문법](https://namu.wiki/w/나무위키:문법_도움말)

## 라이선스

openNAMU는 MIT 라이선스를 따릅니다.
