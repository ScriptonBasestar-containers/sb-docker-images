# Solidus Standalone Configuration

완전한 독립 실행형 Solidus 이커머스 플랫폼

## 개요

이 standalone 구성은 Solidus를 모든 필수 서비스와 함께 즉시 실행할 수 있는 완전한 패키지입니다.

### 포함된 서비스

- **Web**: Solidus Rails 애플리케이션 (포트 8410)
- **PostgreSQL**: 메인 데이터베이스
- **Redis**: 캐시 및 세션 저장소

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env.example을 .env로 복사
cp .env.example .env

# SECRET_KEY_BASE 생성
ruby -rsecurerandom -e 'puts SecureRandom.hex(64)'
# 출력된 값을 .env의 SECRET_KEY_BASE에 복사
```

### 2. .env 파일 수정

```bash
# 필수 설정
SECRET_KEY_BASE=your_generated_secret_here
POSTGRES_PASSWORD=strong_password_here
HOST=shop.example.com  # 실제 도메인으로 변경
```

### 3. 서비스 시작

```bash
# 모든 서비스 시작
docker compose up -d

# 데이터베이스는 자동으로 준비됩니다 (db:prepare)

# 관리자 계정 생성
docker compose exec web bundle exec rails runner "
  Spree::User.create!(
    email: 'admin@example.com',
    password: 'admin123456',
    password_confirmation: 'admin123456'
  ).tap { |u| u.spree_roles << Spree::Role.find_or_create_by(name: 'admin') }
"

# 샘플 데이터 로드 (선택사항)
docker compose exec web bundle exec rails spree_sample:load
```

### 4. 접속

- **스토어 프론트**: http://localhost:8410
- **관리자 페이지**: http://localhost:8410/admin
  - Email: admin@example.com
  - Password: admin123456

## 포트 정보

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 8410 | Web | Solidus 웹 인터페이스 |

포트는 `.env` 파일에서 변경할 수 있습니다:
```bash
SOLIDUS_WEB_PORT=8410
```

## 주요 명령어

### 사용자 관리

```bash
# 관리자 계정 생성
docker compose exec web bundle exec rails runner "
  Spree::User.create!(
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password'
  ).tap { |u| u.spree_roles << Spree::Role.find_or_create_by(name: 'admin') }
"

# 모든 사용자 목록
docker compose exec web bundle exec rails console
> Spree::User.all.pluck(:email)
```

### 제품 관리

```bash
# Rails 콘솔에서 제품 생성
docker compose exec web bundle exec rails console

# 제품 생성 예시
> product = Spree::Product.create!(
    name: "Sample Product",
    price: 19.99,
    available_on: Time.current
  )
> product.master.stock_items.first.update(count_on_hand: 100)
```

### 데이터베이스 관리

```bash
# 마이그레이션 실행
docker compose exec web bundle exec rails db:migrate

# 데이터베이스 백업
docker compose exec postgres pg_dump -U postgres solidus_production > backup.sql

# 데이터베이스 복원
cat backup.sql | docker compose exec -T postgres psql -U postgres solidus_production

# 데이터베이스 재설정 (주의: 모든 데이터 삭제!)
docker compose exec web bundle exec rails db:reset
```

### Rails Console

```bash
# Rails 콘솔 실행
docker compose exec web bundle exec rails console

# 주문 확인
> Spree::Order.count
> Spree::Order.complete.count

# 제품 확인
> Spree::Product.active.count
```

### 서비스 관리

```bash
# 로그 확인
docker compose logs -f

# 웹 서비스 재시작
docker compose restart web

# 모든 서비스 중지
docker compose down

# 볼륨 포함 완전 삭제
docker compose down -v
```

## 프로덕션 배포

### 1. 환경 설정

```bash
# RAILS_ENV를 production으로 설정
RAILS_ENV=production

# SECRET_KEY_BASE 생성
SECRET_KEY_BASE=$(ruby -rsecurerandom -e 'puts SecureRandom.hex(64)')

# 강력한 데이터베이스 비밀번호
POSTGRES_PASSWORD=very-strong-password-here

# 실제 도메인 설정
HOST=shop.example.com
```

### 2. 결제 게이트웨이 설정

```bash
# Stripe 설정
STRIPE_PUBLISHABLE_KEY=pk_live_xxxxx
STRIPE_SECRET_KEY=sk_live_xxxxx

# PayPal 설정
PAYPAL_CLIENT_ID=xxxxx
PAYPAL_CLIENT_SECRET=xxxxx
PAYPAL_MODE=live
```

### 3. 이메일 설정

```bash
# SMTP 설정
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_DOMAIN=shop.example.com
```

### 4. 미디어 스토리지

```bash
# S3 사용 권장
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
S3_BUCKET_NAME=solidus-uploads
```

## 확장 기능

### Solidus Extensions 설치

Solidus는 다양한 확장 기능을 제공합니다:

```bash
# 컨테이너 내부 진입
docker compose exec web bash

# Gemfile에 확장 기능 추가
# gem 'solidus_auth_devise'
# gem 'solidus_paypal_commerce_platform'
# gem 'solidus_stripe'

# Bundle 업데이트
bundle install

# 설치 스크립트 실행
bundle exec rails generate solidus:auth:install
```

### 인기 확장 기능

- **solidus_auth_devise**: 사용자 인증
- **solidus_paypal_commerce_platform**: PayPal 통합
- **solidus_stripe**: Stripe 결제
- **solidus_related_products**: 관련 상품 추천
- **solidus_social**: 소셜 로그인

## 유지보수

### 정기 작업

```bash
# 주간: 데이터베이스 백업
docker compose exec postgres pg_dump -U postgres solidus_production > backup-$(date +%Y%m%d).sql

# 월간: 캐시 정리
docker compose exec web bundle exec rails cache:clear

# 월간: 세션 정리
docker compose exec redis redis-cli FLUSHALL
```

### 업데이트

```bash
# 이미지 업데이트
docker compose pull

# 서비스 재시작
docker compose down
docker compose up -d

# 마이그레이션 실행
docker compose exec web bundle exec rails db:migrate
```

## 문제 해결

### 데이터베이스 연결 오류

```bash
# PostgreSQL 상태 확인
docker compose ps postgres

# 데이터베이스 재시작
docker compose restart postgres

# 연결 테스트
docker compose exec postgres psql -U postgres -d solidus_production
```

### 에셋이 로드되지 않음

```bash
# 에셋 프리컴파일
docker compose exec web bundle exec rails assets:precompile

# 에셋 클리어 후 재컴파일
docker compose exec web bundle exec rails assets:clobber
docker compose exec web bundle exec rails assets:precompile
```

### 주문 처리 문제

```bash
# 주문 상태 확인
docker compose exec web bundle exec rails console
> Spree::Order.where(state: 'payment').count

# Sidekiq 백그라운드 작업 확인 (필요시)
docker compose logs -f web | grep -i sidekiq
```

## 보안 권장사항

1. ✅ 강력한 SECRET_KEY_BASE 사용
2. ✅ RAILS_ENV=production 설정
3. ✅ 데이터베이스 비밀번호 변경
4. ✅ HTTPS 사용 (Let's Encrypt)
5. ✅ 결제 정보 PCI DSS 준수
6. ✅ 정기적인 보안 업데이트
7. ✅ 관리자 페이지 접근 제한
8. ✅ 레이트 리미팅 설정

## 성능 최적화

```bash
# Redis 캐싱 활성화
# config/environments/production.rb:
# config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] }

# 데이터베이스 인덱스 최적화
docker compose exec web bundle exec rails db:migrate

# Sidekiq 워커 추가 (필요시)
# docker-compose.yml에 sidekiq 서비스 추가
```

## 참고 자료

- [Solidus 공식 사이트](https://solidus.io/)
- [Solidus Guides](https://guides.solidus.io/)
- [Solidus API Documentation](https://edgeapi.solidus.io/)
- [Solidus Extensions](https://extensions.solidus.io/)
- [Solidus GitHub](https://github.com/solidusio/solidus)

## 라이선스

Solidus는 BSD 3-Clause 라이선스를 따릅니다.
