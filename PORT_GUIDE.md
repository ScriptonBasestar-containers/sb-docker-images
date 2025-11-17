# Port Assignment Guide

이 문서는 sb-docker-images 저장소의 포트 할당 가이드입니다. 각 프로젝트가 고유한 포트를 사용하도록 하여 동시에 여러 서비스를 실행할 수 있습니다.

## 포트 범위 할당

### 데이터베이스 서비스 (3000-3999)
| 포트 | 서비스 | 프로젝트 | 용도 |
|------|--------|----------|------|
| 3306 | MariaDB/MySQL | buildbox, tsboard | MySQL 프로토콜 |
| 3000 | Discourse | discourse | Web UI |
| 3002 | BTC RPC Explorer | docker-bitcoin | Bitcoin Explorer |
| 3100 | Backend | tsboard | Backend API |
| 3141 | DevPI | devpi | Python Package Index |
| 3333 | Chrome | forem | Chrome DevTools |

### 웹 애플리케이션 (8000-8999)
| 포트 | 서비스 | 프로젝트 | 상태 |
|------|--------|----------|------|
| 8000 | Django CMS | django-cms | ✅ |
| 8025 | Mailhog | flarum | ✅ |
| 8080 | Discourse | discourse | ✅ |
| 8081 | phpMyAdmin | flarum, gnuboard5 | ✅ |
| 8090 | Django CMS | django-cms | ✅ |
| 8100 | WordPress | wordpress | ✅ |
| 8110 | Joomla | joomla | ✅ |
| 8120 | Drupal | drupal | ✅ |
| 8130 | DokuWiki | dokuwiki | ✅ |
| 8140 | Flarum | flarum | ✅ |
| 8150 | GNUboard5 | gnuboard5 | ✅ |
| 8170 | Gollum | gollum | ✅ |
| 8180 | Jenkins | jenkins | ✅ |
| 8200 | MediaWiki | mediawiki | ✅ |
| 8210 | Nextcloud/GNUboard6 | nextcloud, gnuboard6 | ✅ (독립 실행) |
| 8250 | FlaskBB | flaskbb | ⚠️ (충돌 해결 필요) |
| 8270 | XpressEngine | xpressengine | ✅ |
| 8332 | Bitcoin RPC | docker-bitcoin | ✅ |
| 8333 | Bitcoin P2P | docker-bitcoin | ✅ |
| 8443 | Discourse HTTPS | discourse | ✅ |
| 8545 | Ethereum HTTP | docker-ethereum | ✅ |
| 8546 | Ethereum WS | docker-ethereum | ✅ |

### 특수 목적 서비스 (기타)
| 포트 | 서비스 | 프로젝트 | 상태 |
|------|--------|----------|------|
| 80 | Nginx Proxy | misago | ✅ |
| 443 | Nginx Proxy | misago | ✅ |
| 1935 | RTMP | rtmp-proxy | ✅ |
| 4000 | Blockscout | docker-ethereum | ✅ |
| 4433 | Kratos Public | kratos | ✅ |
| 4434 | Kratos Admin | kratos | ✅ |
| 4436 | Mailslurper SMTP | kratos | ✅ |
| 4437 | Mailslurper Web | kratos | ✅ |
| 4455 | Kratos UI | kratos | ✅ |
| 5432 | PostgreSQL | buildbox, django-cms, 기타 | ✅ (독립 실행) |
| 6379 | Redis | redis, buildbox, 기타 | ✅ (독립 실행) |
| 10800 | Ignite Thin Client | ignite | ✅ |
| 11211 | Memcached/Ignite REST | memcached, ignite | ✅ (독립 실행) |
| 30303 | Ethereum P2P | docker-ethereum | ✅ |
| 47100 | Ignite Discovery | ignite | ✅ |
| 47500 | Ignite Communication | ignite | ✅ |
| 50000 | Jenkins Agent | jenkins | ✅ |

## 포트 충돌 해결 현황

### ✅ 해결 완료

**8080 포트 충돌 (10개 프로젝트 해결):**
- ✅ discourse: 8080 (유지 - 기준 포트)
- ✅ dokuwiki: 8130 (변경됨)
- ✅ flarum: 8140 (변경됨)
- ✅ gnuboard5: 8150 (변경됨)
- ✅ gollum: 8170 (4567에서 변경)
- ✅ jenkins: 8180 (변경됨)
- ✅ joomla: 8110 (이미 할당됨)
- ✅ mediawiki: 8200 (변경됨)
- ✅ nextcloud: 8210 (변경됨)
- ✅ wordpress: 8100 (이미 할당됨)
- ✅ xpressengine: 8270 (변경됨)

**4567 포트 충돌:**
- ✅ gollum: 8170으로 변경 (8080 해결과 통합)

**80 포트:**
- ✅ misago: 80 (유지 - nginx proxy, 독립 실행)
- ✅ nextcloud: 8210 (standalone만 사용, 충돌 해결)

### ⚠️ 해결 필요 (낮은 우선순위)

**8250 포트:**
- ⚠️ flaskbb/docker-compose.yml: 8250
- ⚠️ flaskbb/standalone/compose.yml: 8250 → 8251 변경 필요

**8081 포트:**
- ✅ flarum phpMyAdmin: 8081
- ✅ gnuboard5 phpMyAdmin: 8081
- 독립 실행이므로 문제없음

### ✅ 독립 실행 (충돌 무시)

다음 포트들은 서로 다른 프로젝트가 독립적으로 실행되므로 충돌해도 문제없습니다:

**3306 포트 (MariaDB/MySQL):**
- buildbox, tsboard, 기타 다수
- 동시에 실행하지 않음

**5432 포트 (PostgreSQL):**
- buildbox, django-cms, 기타 다수
- 동시에 실행하지 않음

**6379 포트 (Redis):**
- buildbox, redis, nextcloud, 기타 다수
- 동시에 실행하지 않음

**11211 포트 (Memcached):**
- memcached, ignite
- 동시에 실행하지 않음

## 구현 완료 현황

### ✅ Phase 1 완료: 8080 포트 충돌 해결
**완료일:** 2025-11-17

**작업 내용:**
- 10개 프로젝트의 포트 재할당 완료
- 24개 compose 파일 수정
- 모든 프로젝트에 환경변수 기반 포트 설정 적용
- .env.example 파일에 새로운 기본 포트 문서화

**변경된 파일:**
- dokuwiki, flarum, gnuboard5, gollum, jenkins, joomla, mediawiki, nextcloud, wordpress, xpressengine
- 각 프로젝트의 compose.yml, standalone/compose.yml, .env.example

**검증:**
- YAML 문법 검증 완료
- 포트 충돌 24개 → 9개로 감소
- 모든 환경변수 기본값 설정 완료

### 🔄 Phase 2: 남은 충돌 해결 (선택적)
**우선순위:** 낮음

**남은 작업:**
- flaskbb 포트 충돌 해결 (8250)
- 필요시 추가 프로젝트 README 업데이트

### ✅ Phase 3: 데이터베이스 포트
**상태:** 조치 불필요

**이유:**
- 모든 데이터베이스 포트 충돌은 독립 실행 프로젝트 간 발생
- 동시 실행되지 않으므로 문제 없음

## 포트 할당 원칙

1. **웹 UI**: 8000-8999 범위 사용
2. **데이터베이스**: 표준 포트 사용 (3306, 5432, 6379 등)
3. **특수 서비스**: 프로젝트별로 고유 범위 할당
4. **10 단위 간격**: 향후 확장을 위해 포트 사이 간격 유지
5. **환경변수 활용**: 모든 포트를 .env.example에서 설정 가능하도록

## 참고사항

- 이 가이드는 **동시 실행**을 위한 권장사항입니다
- 독립적으로 실행하는 경우 포트 충돌은 문제가 되지 않습니다
- 모든 포트는 환경변수로 재설정 가능해야 합니다
