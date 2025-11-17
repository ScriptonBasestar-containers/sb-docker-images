# Buildbox

재사용 가능한 Docker Compose 템플릿 모음

## 개요

buildbox는 다양한 인프라 서비스(DB, 캐시, 인증 등)를 위한 재사용 가능한 Docker Compose 파일 모음입니다. 각 프로젝트에서 필요한 서비스를 조합하여 사용할 수 있습니다.

## 디렉토리 구조

```
buildbox/
├── compose/          # Docker Compose 템플릿 파일들
│   ├── compose.base-network.yml      # 기본 네트워크 정의
│   ├── compose.postgres.yml          # PostgreSQL
│   ├── compose.mariadb.yml           # MariaDB
│   ├── compose.redis.yml             # Redis
│   ├── compose.kratos.yml            # Ory Kratos (인증)
│   ├── compose.authelia.yml          # Authelia (인증)
│   ├── compose.mailslurper.yml       # Mail Slurper (메일 테스트)
│   └── ...
├── config/           # 서비스별 설정 파일들
│   ├── authelia/
│   └── kratos/
└── bin/              # 유틸리티 스크립트
```

## 사용 가능한 서비스

### 데이터베이스

| 파일 | 서비스 | 포트 | 설명 |
|------|--------|------|------|
| compose.postgres.yml | PostgreSQL | 5432 | PostgreSQL 데이터베이스 |
| compose.bn-pg15.yml | PostgreSQL 15 | 5432 | PostgreSQL 15 (base-network 연결) |
| compose.mariadb.yml | MariaDB | 3306 | MariaDB/MySQL 데이터베이스 |

### 캐시

| 파일 | 서비스 | 포트 | 설명 |
|------|--------|------|------|
| compose.redis.yml | Redis | 6379 | Redis 캐시 서버 |
| compose.bn-redis.yml | Redis | 6379 | Redis (base-network 연결) |

### 인증/보안

| 파일 | 서비스 | 포트 | 설명 |
|------|--------|------|------|
| compose.kratos.yml | Ory Kratos | 4433, 4434 | Ory Kratos 인증 시스템 |
| compose.ory-kratos.yml | Ory Kratos | 4433, 4434 | Ory Kratos (전체 구성) |
| compose.kratos-standalone.yml | Ory Kratos | 4433, 4434 | Ory Kratos (단독) |
| compose.kratos-pg.yml | Kratos + PostgreSQL | - | Kratos with PostgreSQL |
| compose.authelia.yml | Authelia | 9091 | Authelia 인증/SSO |

### 개발 도구

| 파일 | 서비스 | 포트 | 설명 |
|------|--------|------|------|
| compose.mailslurper.yml | MailSlurper | 8080, 2500 | 개발용 SMTP 서버 |
| compose.mailhog.yml | MailHog | 8025, 1025 | 개발용 SMTP 서버 |

### 네트워크

| 파일 | 서비스 | 설명 |
|------|--------|------|
| compose.base-network.yml | - | 기본 네트워크 정의 (app-network, intra-network, data-network) |

## 사용법

### 기본 사용법

```bash
# 단일 서비스 실행
docker-compose -f compose/compose.postgres.yml up -d

# 여러 서비스 조합
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  up -d
```

### 프로젝트와 함께 사용

프로젝트 디렉토리의 docker-compose.yml에서 buildbox 서비스 참조:

```yaml
# your-project/docker-compose.yml
services:
  app:
    image: your-app:latest
    networks:
      - app-network
    depends_on:
      - postgres
      - redis

networks:
  app-network:
    external: true  # buildbox의 네트워크 사용
```

```bash
# buildbox 네트워크 및 서비스 시작
cd buildbox
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  up -d

# 프로젝트 실행
cd ../your-project
docker-compose up
```

### 환경 변수 오버라이드

```bash
# .env 파일 생성
cat > .env <<EOF
POSTGRES_USER=myuser
POSTGRES_PASSWORD=mypassword
POSTGRES_DB=mydb
EOF

# 환경 변수와 함께 실행
docker-compose -f compose/compose.postgres.yml up -d
```

## 서비스별 상세 정보

### PostgreSQL

```bash
# 실행
docker-compose -f compose/compose.postgres.yml up -d

# 접속
docker exec -it postgres_container psql -U postgres

# 환경 변수
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=postgres
```

### MariaDB

```bash
# 실행
docker-compose -f compose/compose.mariadb.yml up -d

# 접속
docker exec -it mariadb_container mysql -u root -p

# 환경 변수
MYSQL_ROOT_PASSWORD=rootpass
MYSQL_DATABASE=appdb
MYSQL_USER=appuser
MYSQL_PASSWORD=apppass
```

### Redis

```bash
# 실행
docker-compose -f compose/compose.redis.yml up -d

# 접속
docker exec -it redis_container redis-cli

# 인증이 필요한 경우
docker exec -it redis_container redis-cli -a yourpassword
```

### Ory Kratos

```bash
# 실행
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.kratos-pg.yml \
  -f compose/compose.kratos.yml \
  up -d

# API 확인
curl http://localhost:4433/health/ready
curl http://localhost:4434/health/ready

# 포트
4433: Public API
4434: Admin API
```

### Authelia

```bash
# 실행
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.authelia.yml \
  up -d

# 설정 파일 위치
config/authelia/configuration.yml
config/authelia/users_database.yml

# 포트
9091: Authelia Web UI
```

### MailSlurper

```bash
# 실행
docker-compose -f compose/compose.mailslurper.yml up -d

# 웹 UI 접속
http://localhost:8080

# SMTP 포트
2500: SMTP 서버
8080: Web UI
```

## 네트워크 구성

buildbox는 다음 네트워크를 제공합니다:

```yaml
networks:
  app-network:      # 애플리케이션 레이어
  intra-network:    # 내부 서비스 통신
  data-network:     # 데이터베이스 레이어
```

### 네트워크 사용 예시

```yaml
services:
  web:
    networks:
      - app-network

  api:
    networks:
      - app-network
      - data-network

  db:
    networks:
      - data-network
```

## 포트 관리

각 서비스의 기본 포트는 다음과 같습니다:

| 서비스 | 포트 | 용도 |
|--------|------|------|
| PostgreSQL | 5432 | DB 연결 |
| MariaDB | 3306 | DB 연결 |
| Redis | 6379 | 캐시 연결 |
| Kratos Public | 4433 | 공개 API |
| Kratos Admin | 4434 | 관리 API |
| Authelia | 9091 | Web UI |
| MailSlurper Web | 8080 | Web UI |
| MailSlurper SMTP | 2500 | SMTP |

포트 충돌 방지는 [포트 가이드](../docs/PORT_GUIDE.md)를 참조하세요.

## 모범 사례

### 1. 네트워크 분리

보안을 위해 네트워크를 분리:

```bash
docker-compose -f compose/compose.base-network.yml up -d
```

### 2. 영구 데이터 보관

볼륨을 사용하여 데이터 영구 보관:

```yaml
volumes:
  postgres_data:
    driver: local
```

### 3. 환경별 설정

개발/스테이징/프로덕션 환경별로 .env 파일 분리:

```bash
# 개발
docker-compose --env-file .env.dev up

# 프로덕션
docker-compose --env-file .env.prod up
```

## 예시 시나리오

### 시나리오 1: Django 개발 환경

```bash
# PostgreSQL + Redis + MailSlurper 실행
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  -f compose/compose.mailslurper.yml \
  up -d
```

### 시나리오 2: Rails 개발 환경

```bash
# PostgreSQL + Redis 실행
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  up -d
```

### 시나리오 3: PHP 개발 환경

```bash
# MariaDB + Redis 실행
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.mariadb.yml \
  -f compose/compose.redis.yml \
  up -d
```

### 시나리오 4: 인증 시스템 테스트

```bash
# Ory Kratos + PostgreSQL 실행
docker-compose \
  -f compose/compose.base-network.yml \
  -f compose/compose.kratos-pg.yml \
  -f compose/compose.kratos.yml \
  up -d
```

## 문제 해결

### 네트워크가 없다는 오류

```bash
# 먼저 base-network 실행
docker-compose -f compose/compose.base-network.yml up -d
```

### 포트가 이미 사용 중

```bash
# 사용 중인 포트 확인
docker ps --format "table {{.Names}}\t{{.Ports}}"

# 충돌하는 컨테이너 중지
docker stop <container_name>
```

### 데이터베이스 연결 실패

```bash
# 컨테이너 로그 확인
docker-compose logs postgres

# 서비스 상태 확인
docker-compose ps
```

## 정리

```bash
# 모든 서비스 중지
docker-compose \
  -f compose/compose.postgres.yml \
  -f compose/compose.redis.yml \
  down

# 볼륨까지 삭제
docker-compose \
  -f compose/compose.postgres.yml \
  down -v
```

## 참고 자료

- [Docker Compose 문서](https://docs.docker.com/compose/)
- [Ory Kratos 문서](https://www.ory.sh/docs/kratos/)
- [Authelia 문서](https://www.authelia.com/)
- [서비스 템플릿 가이드](../docs/SERVICE_TEMPLATES.md)
- [포트 충돌 방지 가이드](../docs/PORT_GUIDE.md)
