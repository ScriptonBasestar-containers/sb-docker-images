# Spree Commerce

Spree Ruby 기반 오픈소스 E-commerce 플랫폼

## 개요

Spree는 Ruby on Rails 기반의 완전한 오픈소스 전자상거래 플랫폼입니다. 2007년부터 개발되어 온 성숙한 프로젝트로, 확장 가능한 아키텍처와 풍부한 기능을 제공합니다. 다양한 규모의 온라인 쇼핑몰 구축에 활용되며, 수많은 확장 기능(Extensions)을 통해 커스터마이징이 가능합니다.

## 빠른 시작

```bash
# Spree 프로젝트 생성 (로컬 환경)
gem install rails
gem install spree_cmd
spree new mystore

# Docker로 실행
cd mystore
docker compose up -d

# 웹 브라우저로 접속
# http://localhost:8400
```

## 서비스 구성

- **web**: Spree 애플리케이션 (포트 8400)
- **postgres**: PostgreSQL 데이터베이스
- **redis**: Redis (캐시/세션/백그라운드 작업)

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8400 | web | 웹 사이트 |

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

## 환경 변수

docker-compose.yml에서 설정:

```yaml
environment:
  - DATABASE_URL=postgresql://postgres:password@postgres/spree_development
  - REDIS_URL=redis://redis:6379/0
  - RAILS_ENV=development
  - SECRET_KEY_BASE=your-secret-key-here
```

## 디렉토리 구조

```
spree/
├── README.md             # 이 문서
└── mystore/              # Spree 프로젝트 디렉토리
    ├── docker-compose.yml
    ├── Dockerfile
    ├── Gemfile
    └── ...
```

## 설치 방법

### 1. Spree 프로젝트 생성

```bash
# Spree CLI 설치
gem install spree_cmd

# 새 프로젝트 생성
spree new mystore
cd mystore
```

### 2. Docker Compose 파일 생성

mystore/docker-compose.yml:

```yaml
version: '3.8'

services:
  web:
    build: .
    command: bundle exec rails server -b 0.0.0.0
    volumes:
      - .:/app
    ports:
      - "8400:3000"
    depends_on:
      - postgres
      - redis
    environment:
      - DATABASE_URL=postgresql://postgres:password@postgres/spree_development
      - REDIS_URL=redis://redis:6379/0
      - RAILS_ENV=development

  postgres:
    image: postgres:16
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=spree_development
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

### 3. 컨테이너 실행

```bash
cd mystore
docker compose up -d
```

### 4. 데이터베이스 초기화

```bash
docker compose exec web rails db:create db:migrate
docker compose exec web rails db:seed
```

### 5. 샘플 데이터 로드 (선택)

```bash
docker compose exec web rails spree_sample:load
```

## 사용법

### 관리자 페이지

```
URL: http://localhost:8400/admin
ID: spree@example.com (기본값)
PW: spree123 (기본값)
```

### 스토어프론트

```
URL: http://localhost:8400
```

### Rails 콘솔 접속

```bash
docker compose exec web rails console
```

### 사용자 생성

```ruby
# Rails 콘솔에서
user = Spree::User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)
user.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
```

## 데이터베이스 관리

### 데이터베이스 백업

```bash
docker compose exec postgres pg_dump -U postgres spree_development > backup.sql
```

### 데이터베이스 복원

```bash
docker compose exec -T postgres psql -U postgres spree_development < backup.sql
```

### 마이그레이션 실행

```bash
docker compose exec web rails db:migrate
```

### 데이터베이스 리셋

```bash
docker compose exec web rails db:reset
```

## 볼륨

```yaml
volumes:
  - postgres_data:/var/lib/postgresql/data  # 데이터베이스 데이터
  - redis_data:/data                         # Redis 데이터
  - .:/app                                   # 소스 코드
```

## 기능

### 주요 기능

- 상품 관리 (카테고리, 옵션, 변형)
- 주문 처리 및 배송
- 결제 게이트웨이 통합
- 재고 관리
- 프로모션 및 쿠폰
- 다국어 지원
- 다중 통화 지원
- SEO 최적화
- 반응형 디자인

### 확장 기능

Spree는 다양한 확장 기능을 제공합니다:

- **spree_auth_devise**: 사용자 인증
- **spree_gateway**: 결제 게이트웨이
- **spree_i18n**: 국제화
- **spree_multi_currency**: 다중 통화
- **spree_digital**: 디지털 상품
- **spree_email_to_friend**: 이메일 공유

## 문제 해결

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f web

# 의존성 설치
docker compose exec web bundle install

# 컨테이너 재시작
docker compose restart web
```

### 데이터베이스 연결 실패

```bash
# PostgreSQL 컨테이너 상태 확인
docker compose ps postgres

# 데이터베이스 재생성
docker compose exec web rails db:drop db:create db:migrate db:seed
```

### 에셋이 로드되지 않음

```bash
# 에셋 프리컴파일
docker compose exec web rails assets:precompile
```

### 포트 충돌

```bash
# docker-compose.yml의 포트 변경
ports:
  - "8401:3000"  # 기본 8400 대신 8401 사용
```

### Gemfile.lock 충돌

```bash
# 의존성 재설치
docker compose exec web bundle update
```

## 개발 환경

### 로그 확인

```bash
# 애플리케이션 로그
docker compose logs -f web

# Rails 로그
docker compose exec web tail -f log/development.log
```

### 컨테이너 내부 접속

```bash
docker compose exec web bash
```

### 테스트 실행

```bash
docker compose exec web bundle exec rspec
```

## 프로덕션 배포

### 1. 환경 변수 설정

```yaml
environment:
  - RAILS_ENV=production
  - SECRET_KEY_BASE=강력한시크릿키
  - DATABASE_URL=postgresql://user:password@host/database
  - REDIS_URL=redis://host:6379/0
```

### 2. 에셋 프리컴파일

```bash
docker compose exec web rails assets:precompile RAILS_ENV=production
```

### 3. 데이터베이스 마이그레이션

```bash
docker compose exec web rails db:migrate RAILS_ENV=production
```

## 기술 스택

- **Ruby**: 3.x
- **Rails**: 7.x
- **PostgreSQL**: 16
- **Redis**: 7
- **Spree**: 4.x

## 참고 자료

- [Spree 공식 사이트](https://spreecommerce.org/)
- [Spree GitHub](https://github.com/spree/spree)
- [Spree 문서](https://guides.spreecommerce.org/)
- [Spree API 문서](https://api.spreecommerce.org/)
- [Spree 확장 기능](https://spreecommerce.org/extensions/)

## 관련 프로젝트

- [solidus](../solidus/README.md) - Solidus (Spree에서 포크된 프로젝트)

## 라이선스

Spree는 BSD 3-Clause 라이선스를 따릅니다.

## 커뮤니티

- [Spree Slack](https://slack.spreecommerce.org/)
- [Spree 포럼](https://spreecommerce.org/community/)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/spree)

## 주의사항

- 프로덕션 환경에서는 SECRET_KEY_BASE를 반드시 변경하세요.
- 데이터베이스 비밀번호를 강력하게 설정하세요.
- HTTPS를 사용하여 보안을 강화하세요.
- 정기적으로 백업을 수행하세요.
