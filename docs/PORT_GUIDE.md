# 포트 충돌 방지 가이드

## 개요

이 저장소에는 여러 Docker 기반 프로젝트가 포함되어 있으며, 동시에 여러 프로젝트를 실행할 때 포트 충돌이 발생할 수 있습니다. 이 문서는 포트 할당 전략과 충돌 방지 방법을 안내합니다.

## 포트 할당 전략

### 기본 원칙

1. **포트 범위 분리**: 각 카테고리별로 포트 범위를 할당
2. **표준 포트 회피**: 시스템 표준 포트(1-1024)는 호스트에서 사용하지 않음
3. **명확한 문서화**: 각 프로젝트 README에 사용 포트 명시
4. **환경 변수 지원**: docker-compose.yml에서 포트를 환경 변수로 설정 가능하게 함

### 포트 범위 할당

| 범위 | 카테고리 | 설명 |
|------|----------|------|
| 3000-3999 | 개발 환경 | Node.js, Rails 등 개발 서버 |
| 5000-5999 | Python/Flask | Python 웹 프레임워크 |
| 8000-8099 | Django/CMS | Django CMS, Python CMS |
| 8100-8199 | PHP CMS | WordPress, Joomla, Drupal 등 |
| 8200-8299 | 게시판/포럼 | gnuboard, xpressengine, discourse 등 |
| 8300-8399 | Wiki | MediaWiki, Gollum, Wiki.js |
| 8400-8499 | E-commerce | Spree, Solidus |
| 8500-8599 | 소셜/커뮤니티 | Mastodon, Forem, NodeBB |
| 8600-8699 | 개발 도구 | Jenkins, DevPI 등 |
| 8700-8799 | 미디어/스트리밍 | RTMP Proxy, RSSHub |
| 8800-8899 | 인프라 | Squid, MariaDB 관리 도구 |
| 8900-8999 | 기타 | Nextcloud, 기타 서비스 |
| 9000-9999 | 관리 도구 | phpMyAdmin, Adminer 등 |

## 프로젝트별 포트 목록

### CMS/블로그 (8000-8199)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| django-cms | 8000 | Web | 8090 (Frontend), 5432 (DB) |
| wordpress | 8100 | Web | 3306 (MariaDB), 9001 (phpMyAdmin) |
| joomla | 8110 | Web | 9002 (phpMyAdmin) |
| drupal | 8120 | Web | 9003 (phpMyAdmin) |

### 게시판/포럼 (8200-8299)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| gnuboard5 | 8200 | Web | 8201 (phpMyAdmin) |
| gnuboard6 | 8210 | Web | 8211 (phpMyAdmin) |
| xpressengine | 8220 | Web | 8221 (phpMyAdmin) |
| discourse | 8230 | Web | - |
| nodebb | 8240 | Web | - |
| flaskbb | 8250 | Web | - |
| misago | 8260 | Web | - |

### Wiki (8300-8399)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| mediawiki | 8300 | Web | 9010 (phpMyAdmin) |
| gollum | 8310 | Web | - |
| wikijs | 8320 | Web | - |
| openNamu | 8330 | Web | - |

### E-commerce (8400-8499)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| spree | 8400 | Web | - |
| solidus | 8410 | Web | - |

### 소셜/커뮤니티 (8500-8599)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| forem | 3000 | Web | 3333 (Chrome) |
| mastodon | 8500 | Web | 8501 (Streaming) |
| flarum | 8510 | Web | - |

### 개발 환경 (8600-8699, 일부 예외)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| jenkins | 8600 | Web | 50000 (Agent) |
| devpi | 8610 | Web | - |
| jupyter | 8888 | Web | - |
| jupyter2 | 8889 | Web | - |
| ansible-dev | 8620 | Web | - |
| chef-dev | 8630 | Web | - |
| ruby-dev | 8640 | Web | - |

### 미디어/스트리밍 (8700-8799)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| rsshub | 8700 | Web | - |
| rtmp-proxy | 1935 | RTMP | 8080 (HTTP) |

### 인프라/도구 (8800-8899)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| squid | 3128 | Proxy | - |
| kratos | 8800 | Web | 8801 (Admin) |
| mailslurper | 8810 | Web | 2500 (SMTP) |
| mariadb | - | DB | 3306 |
| postgres-exts | - | DB | 5432 |

### 기타 (8900-8999)

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| nextcloud | 8900 | Web | 9020 (phpMyAdmin) |
| tsboard | 8910 | Web | - |

### 블록체인

| 프로젝트 | 기본 포트 | 서비스 | 추가 포트 |
|---------|----------|--------|-----------|
| docker-bitcoin | 8332 | RPC | 8333 (P2P) |
| docker-ethereum | 8545 | RPC | 8546 (WS), 30303 (P2P) |

## 포트 충돌 해결 방법

### 1. 환경 변수 사용

각 프로젝트의 `.env` 파일에서 포트를 변경:

```bash
# .env 파일
WEB_PORT=8080
DB_PORT=3306
```

docker-compose.yml에서 환경 변수 사용:

```yaml
services:
  web:
    ports:
      - "${WEB_PORT:-8080}:80"
```

### 2. docker-compose 오버라이드

프로젝트 디렉토리에 `docker-compose.override.yml` 생성:

```yaml
services:
  web:
    ports:
      - "8081:80"  # 기본 포트 대신 8081 사용
```

### 3. 명령줄에서 포트 지정

```bash
# 일시적으로 다른 포트 사용
docker-compose run -p 8081:80 web

# 또는 환경 변수로 지정
WEB_PORT=8081 docker-compose up
```

### 4. 프로젝트 격리

네트워크를 분리하여 동시 실행:

```bash
# 프로젝트 A
cd project-a
docker-compose -p project_a up

# 프로젝트 B (다른 터미널)
cd project-b
docker-compose -p project_b up
```

## 포트 사용 확인 방법

### 호스트에서 사용 중인 포트 확인

```bash
# Linux/Mac
sudo lsof -i :8080
netstat -tuln | grep 8080

# Windows
netstat -ano | findstr :8080
```

### Docker에서 사용 중인 포트 확인

```bash
# 실행 중인 컨테이너의 포트 확인
docker ps --format "table {{.Names}}\t{{.Ports}}"

# 특정 포트를 사용하는 컨테이너 찾기
docker ps --format "table {{.Names}}\t{{.Ports}}" | grep 8080
```

## 권장 사항

1. **한 번에 하나의 프로젝트만 실행**: 테스트/개발 시 필요한 프로젝트만 실행
2. **포트 문서화**: 각 프로젝트 README에 사용 포트 명시
3. **환경 변수 활용**: 포트를 하드코딩하지 않고 환경 변수로 설정
4. **명명 규칙**: docker-compose 프로젝트명을 명확히 지정 (`-p` 옵션)
5. **사용 후 정리**: 작업 완료 후 `docker-compose down`으로 리소스 해제

## 동시 실행 시나리오

### 시나리오 1: 개발 환경 + DB 도구

```bash
# Terminal 1: PostgreSQL + pgAdmin
cd postgres-exts
docker-compose up

# Terminal 2: 개발 환경
cd jupyter
WEB_PORT=8888 docker-compose up
```

### 시나리오 2: 여러 CMS 비교 테스트

```bash
# WordPress on 8100
cd wordpress
WEB_PORT=8100 docker-compose up -d

# Joomla on 8110
cd joomla
WEB_PORT=8110 docker-compose up -d

# Drupal on 8120
cd drupal
WEB_PORT=8120 docker-compose up -d
```

## 참고 자료

- [Docker Compose 네트워킹](https://docs.docker.com/compose/networking/)
- [Docker Compose 환경 변수](https://docs.docker.com/compose/environment-variables/)
- [Docker Compose 오버라이드](https://docs.docker.com/compose/extends/)

## 문제 해결

### "port is already allocated" 오류

```bash
# 1. 사용 중인 컨테이너 확인
docker ps -a

# 2. 충돌하는 컨테이너 중지
docker stop <container_name>

# 3. 또는 다른 포트로 실행
WEB_PORT=8081 docker-compose up
```

### 포트가 사용 중인데 컨테이너가 없는 경우

```bash
# 1. 호스트 프로세스 확인 (Linux/Mac)
sudo lsof -i :<port>

# 2. 프로세스 종료
sudo kill -9 <PID>

# 3. 방화벽 확인
sudo iptables -L -n | grep <port>
```
