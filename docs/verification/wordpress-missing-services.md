# WordPress - Missing Database and Cache Services

## 문제 요약
WordPress compose.yml에 MariaDB와 Redis 서비스 정의가 누락됨

## 발견 일시
- 2025-11-16

## 에러 내용
```
service "wordpress" depends on undefined service "mariadb": invalid compose project
```

## 원인 분석
compose.yml에 wordpress와 wp-install 서비스가 다음을 의존하지만 정의되지 않음:
- `mariadb` (데이터베이스)
- `redis` (캐시)

## 현재 상태
- WordPress 서비스: ✅ 정의됨
- WP-CLI 서비스: ✅ 정의됨
- MariaDB 서비스: ❌ 누락
- Redis 서비스: ❌ 누락

## 필요한 수정 사항

### 1. MariaDB 서비스 추가
```yaml
mariadb:
  image: mariadb:11.8
  container_name: wordpress-mariadb
  restart: unless-stopped
  environment:
    - MYSQL_ROOT_PASSWORD=rootpass
    - MYSQL_DATABASE=db01
    - MYSQL_USER=user01
    - MYSQL_PASSWORD=passw0rd
  volumes:
    - mariadb-data:/var/lib/mysql
  networks:
    - data-network
  healthcheck:
    test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
    interval: 10s
    timeout: 5s
    retries: 5
```

### 2. Redis 서비스 추가
```yaml
redis:
  image: redis:7-alpine
  container_name: wordpress-redis
  restart: unless-stopped
  networks:
    - data-network
  healthcheck:
    test: ["CMD", "redis-cli", "ping"]
    interval: 10s
    timeout: 5s
    retries: 5
```

### 3. Volume 추가
```yaml
volumes:
  wordpress:
  mariadb-data:
```

## 포트 충돌 확인
- WordPress 포트: 8080 (이미 Flarum에서 사용 중 → 8082로 변경됨)
- **권장**: WordPress를 8085로 변경

## 참고
- Gnuboard6에서도 동일한 MariaDB 11.8 사용
- 표준 WordPress 스택 구성 필요
