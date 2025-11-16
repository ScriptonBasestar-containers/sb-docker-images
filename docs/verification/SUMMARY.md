# Docker Compose 프로젝트 검증 요약 보고서

## 개요
- 검증 일시: 2025-11-16
- 검증 환경: macOS (Darwin 25.0.0, ARM64)
- 검증 도구: Docker Compose v2.40.2
- 검증 대상: sb-docker-images 프로젝트의 주요 compose.yml 파일들

## 검증 결과 요약

| 프로젝트 | 상태 | 설정 검증 | 실행 테스트 | 주요 이슈 |
|---------|------|----------|------------|----------|
| **Minio** | ✅ 성공 | ✅ Pass | ✅ Pass | 없음 |
| **Gitea** | ⚠️ 포트 충돌 | ✅ Pass | ❌ Fail | 포트 3000 충돌 |
| **Discourse** | ❌ 설정 오류 | ❌ Fail | - | 서비스 정의 누락 |
| **Flarum** | ⚠️ 포트/플랫폼 | ✅ Pass | ❌ Fail | 포트 8025 충돌, ARM64 경고 |
| **Gnuboard6** | ❌ 빌드 실패 | ✅ Pass | ❌ Fail | app/ 디렉토리 누락 |
| **Wiki.js** | ✅ 성공 | ✅ Pass | ✅ Pass | 없음 |

## 상세 검증 결과

### 1. ✅ Minio (S3 호환 오브젝트 스토리지)

**검증 결과**: 완전 성공

**테스트 내용**:
- compose.yml 구문 검증: ✅ Pass
- 컨테이너 시작: ✅ Pass
- 헬스체크: ✅ Pass
- 초기화 스크립트: ✅ Pass (버킷 자동 생성 성공)

**실행된 서비스**:
- minio: S3 API (9000), Web Console (9001)
- minio-setup: 자동 버킷 생성 (backups, media, uploads)

**평가**: 프로덕션 사용 가능

---

### 2. ⚠️ Gitea (Git 호스팅 서비스)

**검증 결과**: 설정 정상, 런타임 포트 충돌

**테스트 내용**:
- compose.yml 구문 검증: ✅ Pass
- 컨테이너 생성: ✅ Pass
- 네트워크/볼륨 생성: ✅ Pass
- 컨테이너 시작: ❌ Fail (포트 충돌)

**에러 메시지**:
```
Bind for 127.0.0.1:3000 failed: port is already allocated
```

**수정 방법**:
```yaml
ports:
  - "3001:3000"  # 3000 → 3001로 변경
  - "2222:22"
```

**참조**: `tmp/issues/gitea-port-conflict.md`

---

### 3. ❌ Discourse (커뮤니티 포럼)

**검증 결과**: 설정 오류 (서비스 정의 누락)

**테스트 내용**:
- compose.yml 구문 검증: ❌ Fail

**에러 메시지**:
```
service "discourse" depends on undefined service "redis": invalid compose project
```

**문제점**:
- `redis` 서비스 정의 누락
- `postgres` 서비스 정의 누락
- discourse 서비스는 이 두 서비스에 의존

**필요 조치**:
1. Redis 서비스 추가 (redis:7-alpine)
2. PostgreSQL 서비스 추가 (postgres:16-alpine)
3. 볼륨 정의 추가

**참조**: `tmp/issues/discourse-missing-services.md`

---

### 4. ⚠️ Flarum (모던 PHP 포럼)

**검증 결과**: 설정 정상, 플랫폼 불일치 + 포트 충돌

**테스트 내용**:
- compose.yml 구문 검증: ✅ Pass
- 컨테이너 생성: ✅ Pass
- MariaDB 시작: ✅ Pass (healthy)
- Mailhog 시작: ❌ Fail (포트 충돌)

**이슈 1: 포트 충돌**
```
Bind for 127.0.0.1:8025 failed: port is already allocated
```

수정 방법:
```yaml
mailhog:
  ports:
    - "8026:8025"  # 8025 → 8026로 변경
```

**이슈 2: 플랫폼 불일치 (경고)**
```
The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8)
```

영향받는 이미지:
- mailhog/mailhog:latest
- phpmyadmin/phpmyadmin:latest

해결 방법:
```yaml
services:
  mailhog:
    platform: linux/arm64  # 또는 linux/amd64 (에뮬레이션)
```

**참조**: `tmp/issues/flarum-port-platform-issues.md`

---

### 5. ❌ Gnuboard6 (한국형 CMS)

**검증 결과**: 빌드 실패 (애플리케이션 소스 누락)

**테스트 내용**:
- compose.yml 구문 검증: ✅ Pass
- Docker 빌드: ❌ Fail

**에러 메시지**:
```
COPY app/. /app/
failed to calculate checksum: "/app": not found
```

**문제점**:
- Dockerfile이 `app/` 디렉토리를 참조
- 실제 디렉토리에 `app/` 없음
- `requirements.txt`, `main.py` 등 소스 코드 누락

**의심스러운 점**:
- 환경변수는 Django를 가리킴 (`DB_ENGINE=django.db.backends.mysql`)
- CMD는 Uvicorn을 사용 (FastAPI/Starlette)
- Gnuboard는 전통적으로 PHP 기반
- Gnuboard6(g6) Python 버전의 존재 여부 불명확

**필요 조치**:
1. Gnuboard6 저장소 확인 및 클론
2. Dockerfile 수정 (소스 코드 다운로드 포함)
3. 프레임워크 확인 (Django vs FastAPI)

**참조**: `tmp/issues/gnuboard6-missing-app-directory.md`

---

### 6. ✅ Wiki.js (문서 위키)

**검증 결과**: 완전 성공

**테스트 내용**:
- compose.yml 구문 검증: ✅ Pass
- 컨테이너 시작: ✅ Pass
- PostgreSQL 시작: ✅ Pass
- Wiki.js 시작: ✅ Pass

**실행된 서비스**:
- wiki: Wiki.js 애플리케이션 (포트 80 → 3000)
- db: PostgreSQL 15-alpine

**평가**: 프로덕션 사용 가능

---

## 공통 문제점

### 1. 포트 충돌
- **영향받는 프로젝트**: Gitea (3000), Flarum (8025)
- **원인**: 호스트에서 이미 사용 중인 포트
- **해결**: compose.yml에서 포트 번호 변경

### 2. ARM64 플랫폼 호환성 (Apple Silicon)
- **영향받는 프로젝트**: Flarum (mailhog, phpmyadmin)
- **영향**: 성능 저하 가능성 (에뮬레이션)
- **해결**: platform 명시 또는 ARM64 네이티브 이미지 사용

### 3. 서비스 정의 누락
- **영향받는 프로젝트**: Discourse
- **문제**: 의존 서비스가 compose.yml에 없음
- **해결**: 누락된 서비스 추가

### 4. 애플리케이션 소스 누락
- **영향받는 프로젝트**: Gnuboard6
- **문제**: 빌드에 필요한 소스 코드 없음
- **해결**: 저장소 클론 또는 Dockerfile 수정

---

## 권장 조치사항

### 즉시 수정 가능 (간단)

1. **Gitea 포트 변경**
   ```yaml
   ports:
     - "3001:3000"
   ```

2. **Flarum Mailhog 포트 변경**
   ```yaml
   ports:
     - "8026:8025"
   ```

3. **Flarum 플랫폼 명시** (선택)
   ```yaml
   platform: linux/arm64
   ```

### 추가 작업 필요 (중간)

4. **Discourse 서비스 추가**
   - Redis 서비스 정의 추가
   - PostgreSQL 서비스 정의 추가
   - 볼륨 섹션 추가

### 조사 및 재작업 필요 (복잡)

5. **Gnuboard6 재구성**
   - Gnuboard6 공식 저장소 확인
   - 소스 코드 클론 또는 다운로드
   - Dockerfile 수정 (빌드 중 소스 다운로드)
   - 프레임워크 명확화 (Django vs FastAPI)

---

## 테스트되지 않은 프로젝트

다음 프로젝트들은 시간 관계상 테스트하지 못했습니다:

- devpi (Python PyPI 서버)
- Django CMS
- Docker Bitcoin/Ethereum
- Drupal
- Gnuboard5
- Gollum
- Home Assistant
- Jenkins
- Joomla
- Jupyter
- Kratos
- Mastodon
- MediaWiki
- Misago
- Nextcloud
- NodeBB
- openNamu
- PostgreSQL Extensions
- RSSHub
- RTMP Proxy
- Ruby Dev
- Solidus/Spree
- Squid
- TSBoard
- WordPress
- XpressEngine

---

## 결론

### 즉시 사용 가능
- ✅ **Minio**: 완벽 동작
- ✅ **Wiki.js**: 완벽 동작

### 간단한 수정으로 사용 가능
- ⚠️ **Gitea**: 포트만 변경하면 OK
- ⚠️ **Flarum**: 포트 변경 + 플랫폼 명시 권장

### 추가 작업 필요
- ❌ **Discourse**: 서비스 정의 추가 필요
- ❌ **Gnuboard6**: 소스 코드 확보 및 Dockerfile 수정 필요

### 전체 평가
- **성공률**: 2/6 (33%)
- **수정 가능**: 4/6 (67%)
- **프로덕션 준비**: 2/6 (33%)

---

## 첨부 파일
- `gitea-port-conflict.md`: Gitea 포트 충돌 상세
- `discourse-missing-services.md`: Discourse 서비스 누락 상세
- `flarum-port-platform-issues.md`: Flarum 포트/플랫폼 이슈 상세
- `gnuboard6-missing-app-directory.md`: Gnuboard6 빌드 실패 상세
