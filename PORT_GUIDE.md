# Port Assignment Guide

이 문서는 sb-docker-images 저장소의 포트 할당 가이드입니다. 각 프로젝트가 고유한 포트를 사용하도록 하여 동시에 여러 서비스를 실행할 수 있습니다.

## 포트 범위 할당

### 데이터베이스 서비스 (3000-3999)
| 포트 | 서비스 | 프로젝트 | 용도 |
|------|--------|----------|------|
| 3306 | MariaDB/MySQL | buildbox, tsboard | MySQL 프로토콜 |
| 3000 | **충돌** | discourse, supabase | Web UI, Studio |
| 3002 | BTC RPC Explorer | docker-bitcoin | Bitcoin Explorer |
| 3100 | Backend | tsboard | Backend API |
| 3141 | DevPI | devpi | Python Package Index |
| 3333 | Chrome | forem | Chrome DevTools |

### 웹 애플리케이션 (8000-8999)
| 포트 | 서비스 | 프로젝트 | 용도 |
|------|--------|----------|------|
| 8000 | **충돌** | django-cms, supabase | Web UI, Kong HTTP |
| 8025 | Mailhog | flarum | Mail testing |
| 8080 | **충돌** | discourse, dokuwiki, flarum, gnuboard5, gnuboard6, gollum, ignite, joomla, jupyter, mediawiki, nextcloud, nodebb, notebook, opennamu, solidus, xpressengine, supabase | Web UI, Meta API |
| 8081 | phpMyAdmin | flarum | DB Admin |
| 8090 | Django CMS | django-cms | Additional port |
| 8100 | WordPress | wordpress | Web UI |
| 8110 | Joomla | joomla | Web UI |
| 8120 | Drupal | drupal | Web UI |
| 8250 | **Available** | (was flaskbb - archived) | - |
| 8332 | Bitcoin RPC | docker-bitcoin | RPC |
| 8333 | Bitcoin P2P | docker-bitcoin | P2P Network |
| 8350 | Mattermost | mattermost | Web UI |
| 8443 | **충돌** | discourse, supabase | HTTPS, Kong HTTPS |
| 8545 | Ethereum HTTP | docker-ethereum | HTTP RPC |
| 8546 | Ethereum WS | docker-ethereum | WebSocket RPC |

### 특수 목적 서비스 (기타)
| 포트 | 서비스 | 프로젝트 | 용도 |
|------|--------|----------|------|
| 80 | **충돌** | misago, nextcloud | HTTP |
| 443 | Nginx Proxy | misago | HTTPS |
| 1935 | RTMP | rtmp-proxy | RTMP Streaming |
| 4000 | **충돌** | docker-ethereum, supabase | Blockchain Explorer, Realtime/Analytics |
| 4433 | Kratos Public | kratos | Public API |
| 4434 | Kratos Admin | kratos | Admin API |
| 4436 | Mailslurper SMTP | kratos | SMTP |
| 4437 | Mailslurper Web | kratos | Web UI |
| 4455 | Kratos UI | kratos | Self-service UI |
| 4567 | **충돌** | gollum | Web UI |
| 5000 | Storage API | supabase | Storage API |
| 5432 | **충돌** | buildbox, django-cms, supabase | PostgreSQL |
| 6379 | **충돌** | redis, buildbox, nextcloud | Redis |
| 9001 | Vector | supabase | Log collection |
| 9999 | Auth (Internal) | supabase | GoTrue Auth |
| 10800 | Ignite | ignite | Ignite service |
| 11211 | **충돌** | memcached, ignite | Memcached |
| 30303 | **충돌** | geth | Ethereum P2P |
| 47100 | Ignite | ignite | Ignite communication |
| 47500 | Ignite | ignite | Ignite discovery |
| 50000 | Jenkins | jenkins | Jenkins agent |

## 포트 충돌 현황 및 해결

### ✅ 해결 완료: 실질적 충돌 0개

**Phase 11 기준:** 모든 실질적 포트 충돌이 해결되었습니다.

**현재 포트 충돌 (4개 - 모두 선택적 구성):**
- 8140: flarum (apache vs nginx 구성)
- 8210: nextcloud (apache vs fpm 구성)
- 11211: ignite vs memcached (독립 실행)
- 4567: gollum (포트 매핑 중복)

---

## 선택적 구성 포트 충돌

다음 포트 충돌은 **정상적인 상황**이며 조치가 필요하지 않습니다:

### 1. Flarum - 8140 포트 (Apache vs Nginx)

**충돌 위치:**
- `flarum/compose.apache.yml` - Apache 웹서버
- `flarum/compose.nginx.yml` - Nginx 웹서버

**설명:**
- 사용자는 Apache 또는 Nginx 중 **하나만 선택**하여 사용
- 두 구성을 동시에 실행하지 않음
- 각각 독립적인 compose 파일로 분리됨

**사용 방법:**
```bash
# Apache 사용
docker compose -f compose.apache.yml up -d

# 또는 Nginx 사용
docker compose -f compose.nginx.yml up -d
```

---

### 2. Nextcloud - 8210 포트 (Apache vs FPM)

**충돌 위치:**
- `nextcloud/standalone/compose.apache.yml` - Apache 웹서버
- `nextcloud/standalone/compose.fpm.yml` - Nginx + PHP-FPM

**설명:**
- 사용자는 Apache 또는 Nginx+FPM 중 **하나만 선택**
- 두 구성을 동시에 실행하지 않음
- Standalone 디렉토리에서 선택적 구성 제공

**사용 방법:**
```bash
cd nextcloud/standalone

# Apache 사용 (간단, 초보자 권장)
docker compose -f compose.apache.yml up -d

# 또는 Nginx + FPM 사용 (고성능, 고급 사용자)
docker compose -f compose.fpm.yml up -d
```

---

### 3. Memcached - 11211 포트 (독립 서비스)

**충돌 위치:**
- `ignite/compose.yml` - Apache Ignite 내장 Memcached
- `memcached/compose.yml` - 독립 Memcached 서비스

**설명:**
- 두 서비스는 **독립적으로 실행**
- 동시에 실행할 일이 거의 없음
- 필요 시 환경변수로 포트 변경 가능

**해결 방법 (필요 시):**
```bash
# Memcached 포트 변경
MEMCACHED_PORT=11212 docker compose up -d
```

---

### 4. Gollum - 4567 포트 (내부 포트 매핑)

**충돌 위치:**
- `gollum/compose.yml` 내부에서 `4567:8081` 매핑

**설명:**
- 동일 파일 내 포트 매핑 (외부 4567 → 내부 8081)
- 스크립트가 오탐으로 인식
- 실제로는 충돌이 아님

---

## 포트 충돌 해결 완료 (Phase 8-11)

### ✅ 8080 포트 충돌 (완전 해결)
이전에 16개 프로젝트가 충돌했으나, 모두 고유 포트로 재할당 완료:

**할당 완료 포트:**
- discourse: 8080
- dokuwiki: 8130
- flarum: 8140
- gnuboard5: 8150
- gnuboard6: 8160
- gollum: 8170
- ignite: 8180
- joomla: 8110
- jupyter: 8190
- mediawiki: 8200
- nextcloud: 8210
- nodebb: 8220
- notebook: 8230
- (8240: was opennamu - archived)
- (8260: was solidus - archived)
- xpressengine: 8270
- owa: 8280
- koel: 8290
- agendav: 8300
- rhymix: 8310
- taiga: 9000

### ✅ 기타 포트 충돌 해결 완료

**80 포트:**
- misago: 80 (nginx proxy 유지)
- nextcloud: 8210 (변경 완료)

**3306 포트 (MariaDB/MySQL):**
- buildbox: 3306 (개발용 독립 실행)
- tsboard: 3306 (독립 실행)
- 독립 실행이므로 충돌 없음 ✅

**4567 포트:**
- gollum: 8170 (변경 완료)

**6379 포트 (Redis):**
- buildbox: 6379 (개발용 독립 실행)
- redis: 6379 (독립 실행)
- nextcloud: 내부 Redis (외부 노출 없음)
- 독립 실행이므로 충돌 없음 ✅

**8081 포트:**
- flarum phpMyAdmin: 8081 (유지)

**8250 포트:**
- (was flaskbb: 8250 - archived)

**11211 포트 (Memcached):**
- memcached: 11211 (독립 실행)
- ignite: 11211 (독립 실행)
- 독립 실행이므로 충돌 없음 ✅

**30303 포트 (Ethereum P2P):**
- geth: 30303 (확인 완료, 문제 없음)

## 포트 변경 이력

### Phase 8-9: 8080 포트 충돌 해결
- 10개 프로젝트 포트 재할당
- 환경변수 기반 설정 적용
- 24개 충돌 → 9개 충돌

### Phase 10: 추가 포트 충돌 해결
- flaskbb, gnuboard5 포트 수정
- 9개 충돌 → 7개 충돌

### Phase 11: 오탐 제거 및 최종 정리
- 스크립트 개선 (동일 파일 내 중복 제외)
- discourse, dokuwiki, forem, flaskbb 검증
- 7개 충돌 → 4개 충돌 (모두 선택적 구성)
- **실질적 충돌: 0개** ✅

## 포트 할당 원칙

1. **웹 UI**: 8000-8999 범위 사용
2. **데이터베이스**: 표준 포트 사용 (3306, 5432, 6379 등)
3. **특수 서비스**: 프로젝트별로 고유 범위 할당
4. **10 단위 간격**: 향후 확장을 위해 포트 사이 간격 유지
5. **환경변수 활용**: 모든 포트를 .env.example에서 설정 가능하도록

## 포트 충돌 확인 방법

프로젝트 루트에서 자동 검증 스크립트를 실행할 수 있습니다:

```bash
# 포트 충돌 자동 감지
./scripts/check-port-conflicts.sh

# 출력 예시:
# ✓ Port 8082 → flarum/compose.yml (flarum)
# ⚠ CONFLICT: Port 8140
#   Already used:
#     File: flarum/compose.apache.yml
#   Also used in:
#     File: flarum/compose.nginx.yml
```

**주의:** 선택적 구성으로 인한 충돌은 정상입니다.

---

## 참고사항

### 동시 실행 vs 독립 실행

**동시 실행 (Simultaneous Run):**
- 여러 프로젝트를 동시에 실행하는 경우
- 포트 충돌 방지 필요
- 환경변수로 포트 변경 가능

**독립 실행 (Standalone Run):**
- 한 번에 하나의 프로젝트만 실행
- 포트 충돌 걱정 불필요
- 표준 포트 사용 가능

### 환경변수 활용

모든 프로젝트는 `.env.example` 파일을 제공하며, 포트를 환경변수로 재설정할 수 있습니다:

```bash
# .env 파일 생성
cp .env.example .env

# 포트 변경
# WEB_PORT=8888  # 원하는 포트로 변경

# 서비스 시작
docker compose up -d
```

### 추가 정보

- 검증 스크립트: `scripts/check-port-conflicts.sh`
- 검증 완료 프로젝트: 23개 (95.8%)
- 마지막 업데이트: 2025-11-21 (Phase 11)
