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
| 포트 | 서비스 | 프로젝트 | 용도 |
|------|--------|----------|------|
| 8000 | Django CMS | django-cms | Web UI |
| 8025 | Mailhog | flarum | Mail testing |
| 8080 | **충돌** | discourse, dokuwiki, flarum, gnuboard5, gnuboard6, gollum, ignite, joomla, jupyter, mediawiki, nextcloud, nodebb, notebook, opennamu, solidus, xpressengine | Web UI |
| 8081 | phpMyAdmin | flarum | DB Admin |
| 8090 | Django CMS | django-cms | Additional port |
| 8100 | WordPress | wordpress | Web UI |
| 8110 | Joomla | joomla | Web UI |
| 8120 | Drupal | drupal | Web UI |
| 8250 | **충돌** | flaskbb | Web UI |
| 8332 | Bitcoin RPC | docker-bitcoin | RPC |
| 8333 | Bitcoin P2P | docker-bitcoin | P2P Network |
| 8443 | Discourse HTTPS | discourse | HTTPS |
| 8545 | Ethereum HTTP | docker-ethereum | HTTP RPC |
| 8546 | Ethereum WS | docker-ethereum | WebSocket RPC |

### 특수 목적 서비스 (기타)
| 포트 | 서비스 | 프로젝트 | 용도 |
|------|--------|----------|------|
| 80 | **충돌** | misago, nextcloud | HTTP |
| 443 | Nginx Proxy | misago | HTTPS |
| 1935 | RTMP | rtmp-proxy | RTMP Streaming |
| 4000 | Blockscout | docker-ethereum | Blockchain Explorer |
| 4433 | Kratos Public | kratos | Public API |
| 4434 | Kratos Admin | kratos | Admin API |
| 4436 | Mailslurper SMTP | kratos | SMTP |
| 4437 | Mailslurper Web | kratos | Web UI |
| 4455 | Kratos UI | kratos | Self-service UI |
| 4567 | **충돌** | gollum | Web UI |
| 5432 | PostgreSQL | buildbox, django-cms | PostgreSQL |
| 6379 | **충돌** | redis, buildbox, nextcloud | Redis |
| 10800 | Ignite | ignite | Ignite service |
| 11211 | **충돌** | memcached, ignite | Memcached |
| 30303 | **충돌** | geth | Ethereum P2P |
| 47100 | Ignite | ignite | Ignite communication |
| 47500 | Ignite | ignite | Ignite discovery |
| 50000 | Jenkins | jenkins | Jenkins agent |

## 포트 충돌 해결 계획

### 8080 포트 충돌 (16개 프로젝트)
가장 많이 사용되는 포트입니다. 각 프로젝트에 고유 포트를 할당합니다.

**제안 포트 할당:**
- discourse: 8080 (유지)
- dokuwiki: 8130
- flarum: 8140
- gnuboard5: 8150
- gnuboard6: 8160
- gollum: 8170
- ignite: 8180
- joomla: 8110 (현재)
- jupyter: 8190
- mediawiki: 8200
- nextcloud: 8210
- nodebb: 8220
- notebook: 8230
- opennamu: 8240
- solidus: 8260
- xpressengine: 8270

### 기타 포트 충돌

**80 포트:**
- misago: 80 (유지 - nginx proxy)
- nextcloud: 8210 (변경)

**3306 포트 (MariaDB/MySQL):**
- 충돌이지만 독립 실행이므로 문제없음
- buildbox: 3306 (개발용)
- tsboard: 3306 (독립 실행)

**4567 포트:**
- gollum: 8170 (변경 - 위의 8080 해결과 통합)
- 기타 프로젝트: 확인 필요

**6379 포트 (Redis):**
- 충돌이지만 독립 실행이므로 문제없음
- buildbox: 6379 (개발용)
- redis: 6379 (독립 실행)
- nextcloud: 내부 Redis (외부 노출 제거 고려)

**8081 포트:**
- flarum phpMyAdmin: 8081 (유지)
- 충돌 대상 확인 필요

**8250 포트:**
- flaskbb: 8250 (기존)
- flaskbb/standalone: 8251 (변경)

**11211 포트 (Memcached):**
- memcached: 11211 (독립 실행)
- ignite: 11211 (독립 실행)
- 독립 실행이므로 문제없음

**30303 포트 (Ethereum P2P):**
- geth 내부 중복 (compose 파일 확인 필요)

## 구현 단계

### Phase 1: 높은 우선순위 (8080 포트 충돌)
1. 각 프로젝트의 compose.yml 수정
2. .env.example에 포트 환경변수 추가
3. README.md 업데이트
4. 검증 및 테스트

### Phase 2: 중간 우선순위 (80, 8081, 8250 포트)
1. 개별 프로젝트 포트 재할당
2. 문서 업데이트

### Phase 3: 낮은 우선순위 (데이터베이스 포트)
- 독립 실행 서비스는 충돌해도 무방
- 필요시에만 수정

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
