# Discourse

Discourse는 Ruby on Rails로 작성된 현대적인 커뮤니티 토론 플랫폼입니다. Stack Overflow, Reddit, 전통적인 포럼의 장점을 결합한 차세대 인터넷 포럼 소프트웨어입니다.

## 개요

Discourse는 다음과 같은 기능을 제공합니다:
- 현대적이고 반응형인 디자인
- 실시간 알림 및 업데이트
- 강력한 검색 및 필터링
- 소셜 로그인 지원
- 마크다운 기반 에디터
- 모바일 앱 지원
- 플러그인 시스템
- 다국어 지원

## 빠른 시작

```bash
# 1. Discourse 소스코드 클론 (최초 1회만)
make prepare

# 2. 데이터베이스 및 Redis 서비스 시작
# buildbox의 postgres와 redis 서비스 필요
make server-up

# 3. 브라우저에서 접속
# http://localhost:3000 (Rails 서버)
# http://localhost:8080 (HTTP)
# http://localhost:8443 (HTTPS)
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **discourse**: Discourse Rails 애플리케이션
  - Rails 서버 (프로덕션 모드)
  - 자동 데이터베이스 마이그레이션
  - 자산 프리컴파일

- **postgres**: PostgreSQL 데이터베이스 (외부 서비스)
  - buildbox/compose/compose.postgres.yml 사용
  - 사용자 데이터 및 게시물 저장

- **redis**: Redis 캐시 서버 (외부 서비스)
  - buildbox/compose/compose.redis.yml 사용
  - 세션 관리 및 캐싱

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8080 | discourse | Discourse 웹 사이트 HTTP (현재 설정) |
| 8443 | discourse | Discourse 웹 사이트 HTTPS (현재 설정) |
| 3000 | discourse | Rails 서버 (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 8080 포트 사용 중입니다.
>
> **권장 포트**: 8230 ([포트 가이드](../docs/PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # compose.yml 파일에서 수정
> sed -i 's/8080:80/8230:80/' compose.yml
>
> # 또는 직접 편집
> # ports:
> #   - "8230:80"
> #   - "8443:443"
> ```

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

### 로케일 설정

```bash
LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8
LANGUAGE=en_US.UTF-8
```

### Rails 설정

```bash
RAILS_ENV=production
```

### Discourse 설정

```bash
DISCOURSE_HOSTNAME=test1.polypia.net
DISCOURSE_DEVELOPER_EMAILS=    # 개발자 이메일 주소
```

### 데이터베이스 설정

```bash
DISCOURSE_DB_HOST=postgres
DISCOURSE_DB_PORT=5432
DISCOURSE_DB_NAME=db01
DISCOURSE_DB_USERNAME=user01
DISCOURSE_DB_PASSWORD=passw0rd
```

### Redis 설정

```bash
DISCOURSE_REDIS_HOST=redis
DISCOURSE_REDIS_PORT=6379
DISCOURSE_REDIS_DB=0
DISCOURSE_REDIS_PASSWORD=passw0rd
DISCOURSE_REDIS_USE_SSL=false
```

## 사용 가능한 명령어

### 초기 설정

```bash
# Discourse 소스코드 클론
make prepare

# 기존 소스 삭제 및 재클론
make prepare
```

### 서비스 관리

```bash
# 서비스 시작
make server-up

# 서비스 중지 및 볼륨 삭제
make server-down

# 컨테이너 쉘 접속
make server-enter
```

### 빌드 관리

```bash
# 기존 이미지 삭제
make build-clear

# 베이스 이미지 빌드
make build-base

# 애플리케이션 이미지 빌드
make build-app
```

## 사용법

### 초기 관리자 계정 생성

```bash
# 컨테이너 내부로 진입
docker exec -it discourse_dev bash

# Rails 콘솔 실행
rails console

# 관리자 계정 생성
User.create!(
  username: 'admin',
  email: 'admin@example.com',
  password: 'password123',
  active: true,
  approved: true,
  admin: true,
  moderator: true
)
```

### 데이터베이스 마이그레이션

```bash
# 컨테이너 내부에서
bundle exec rake db:migrate

# 또는 외부에서
docker exec discourse_dev bundle exec rake db:migrate
```

### 자산 프리컴파일

```bash
# 컨테이너 내부에서
bin/rails assets:precompile

# 또는 외부에서
docker exec discourse_dev bin/rails assets:precompile
```

### 플러그인 설치

```bash
# 컨테이너 내부로 진입
docker exec -it discourse_dev bash

# 플러그인 디렉토리로 이동
cd /var/www/discourse/plugins

# Git으로 플러그인 클론
git clone https://github.com/discourse/discourse-plugin-name.git

# 자산 프리컴파일 및 재시작
cd /var/www/discourse
bin/rails assets:precompile
exit

# 컨테이너 재시작
docker restart discourse_dev
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 서비스 확인
docker ps | grep postgres

# buildbox postgres 서비스 시작
cd ../buildbox
docker-compose -f compose/compose.postgres.yml up -d

# Discourse 재시작
cd ../discourse
make server-down
make server-up
```

### Redis 연결 오류

```bash
# Redis 서비스 확인
docker ps | grep redis

# buildbox redis 서비스 시작
cd ../buildbox
docker-compose -f compose/compose.redis.yml up -d

# Discourse 재시작
cd ../discourse
make server-down
make server-up
```

### 자산 프리컴파일 실패

```bash
# 자산 삭제 및 재컴파일
docker exec discourse_dev bash -c "cd /var/www/discourse && rm -rf public/assets && bin/rails assets:precompile"

# 컨테이너 재시작
docker restart discourse_dev
```

### 마이그레이션 실패

```bash
# 데이터베이스 상태 확인
docker exec discourse_dev bundle exec rake db:migrate:status

# 특정 마이그레이션으로 롤백
docker exec discourse_dev bundle exec rake db:migrate:down VERSION=<version>

# 다시 마이그레이션
docker exec discourse_dev bundle exec rake db:migrate
```

### 로그 확인

```bash
# 컨테이너 로그
docker logs discourse_dev

# 실시간 로그
docker logs -f discourse_dev

# Rails 로그 (컨테이너 내부)
docker exec discourse_dev tail -f /var/www/discourse/log/production.log
```

## 디렉토리 구조

```
discourse/
├── compose.yml           # Docker Compose 설정
├── Makefile             # 편의 명령어
├── README.md            # 이 문서
├── entrypoint.sh        # 컨테이너 진입점 스크립트
├── image/               # Docker 이미지 빌드 파일
│   ├── base/           # 베이스 이미지
│   └── discourse_app/  # Discourse 애플리케이션 이미지
├── discourse/           # Discourse 소스코드 (make prepare로 생성)
└── discourse_docker/    # Discourse Docker 설정 (make prepare로 생성)
```

## 참고 자료

- [Discourse 공식 GitHub](https://github.com/discourse/discourse)
- [Discourse 공식 Docker 저장소](https://github.com/discourse/discourse_docker)
- [Discourse 공식 문서](https://docs.discourse.org/)
- [Discourse Meta (공식 커뮤니티)](https://meta.discourse.org/)
- [Discourse Plugin 개발 가이드](https://meta.discourse.org/c/dev/7)

## 기술 스택

- **Backend**: Ruby 3.x, Ruby on Rails 7.x
- **Frontend**: Ember.js
- **Database**: PostgreSQL
- **Cache**: Redis
- **Search**: PostgreSQL Full-Text Search
- **Container**: Docker, Docker Compose

## 주의사항

1. **프로덕션 환경**: 현재 설정은 개발/테스트용입니다. 프로덕션 환경에서는 추가 보안 설정이 필요합니다.
2. **이메일 설정**: SMTP 설정을 추가해야 이메일 알림이 작동합니다.
3. **도메인 설정**: `DISCOURSE_HOSTNAME`을 실제 도메인으로 변경해야 합니다.
4. **SSL 인증서**: HTTPS를 사용하려면 SSL 인증서를 설정해야 합니다.
5. **백업**: 정기적인 데이터베이스 백업을 권장합니다.

## 라이선스

Discourse는 GPLv2 라이선스로 배포됩니다.
