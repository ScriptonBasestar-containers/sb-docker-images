# Ruby on Rails Development Environment

호스트에서 편집하고 Docker 환경에서 실행할 수 있는 Ruby on Rails 개발 환경

## 개요

Ruby on Rails 애플리케이션 개발을 위한 완전한 Docker 환경입니다. 호스트에서 코드를 편집하고 컨테이너 내에서 실행할 수 있어, 로컬 환경을 오염시키지 않고 일관된 개발 환경을 유지할 수 있습니다.

## 특징

- **Ruby**: 커스터마이징 가능한 Ruby 버전
- **Rails**: Ruby on Rails 프레임워크
- **Node.js 8**: 프론트엔드 빌드 도구
- **Webpack & Yarn**: 모던 JavaScript 빌드
- **카카오 미러**: 빠른 패키지 다운로드
- **커스텀 사용자**: 비 root 사용자로 실행
- **Sudo 권한**: 필요 시 관리자 권한 사용
- **작업 디렉토리**: /work

## 빠른 시작

### 이미지 빌드

```bash
# 빌드 스크립트 사용
./build.sh

# 또는 직접 빌드
docker build \
  --build-arg RUBY_VERSION=2.7 \
  --build-arg CUSTOM_USER=developer \
  -t ruby-dev .
```

### 기본 실행

```bash
# bash 쉘 실행
docker run -ti \
  -p 3000:3000 \
  -v $(pwd):/work \
  ruby-dev bash
```

### Rails 서버 실행

```bash
# run.sh 스크립트 사용
./run.sh

# 또는 직접 실행
docker run -ti \
  -p 3000:3000 \
  -v $(pwd):/work \
  -v gempath:/usr/local/bundle \
  --link mysql:mysql \
  ruby-dev bash
```

## 서비스 구성

### 포트

| 포트 | 용도 | 설명 |
|------|------|------|
| 3000 | Rails Server | 기본 Rails 개발 서버 포트 (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 3000 포트 사용 중입니다.
>
> **권장 포트**: 8640 ([포트 가이드](../PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # run.sh 또는 docker run 명령 사용 시 -p 옵션으로 포트 지정
> docker run -p 8640:3000 -v $(pwd):/work ruby-dev
> ```

포트 충돌 방지: [포트 가이드](../PORT_GUIDE.md)

### 볼륨

- `/work`: 애플리케이션 작업 디렉토리
- `/usr/local/bundle`: Gem 패키지 저장소 (Named Volume 권장)

### 환경 변수

`.env` 파일에서 설정:

```bash
RUBY_VERSION=2.7           # Ruby 버전
CUSTOM_USER=developer      # 컨테이너 사용자명
```

`.env` 파일이 없으면 `.env` 파일을 생성하세요:

```bash
cp .env.example .env  # 있는 경우
# 또는
echo "RUBY_VERSION=2.7" > .env
echo "CUSTOM_USER=developer" >> .env
```

## 디렉토리 구조

```
ruby-dev/
├── Dockerfile              # Ruby 개발 환경 이미지
├── docker-compose.yaml     # Docker Compose 설정
├── docker-entrypoint.sh    # 엔트리포인트 스크립트
├── .env                    # 환경 변수 설정
├── build.sh                # 빌드 스크립트
├── run.sh                  # 실행 스크립트
├── test.sh                 # 테스트 스크립트
└── README.md               # 이 문서
```

## 사용법

### 1. 새 Rails 프로젝트 생성

```bash
# 컨테이너 시작
docker run -ti \
  -v $(pwd):/work \
  ruby-dev bash

# 컨테이너 내부에서
gem install rails
rails new myapp --database=mysql
cd myapp
```

### 2. 기존 프로젝트 실행

```bash
# 프로젝트 디렉토리로 이동
cd /path/to/your/rails/app

# 컨테이너 시작
docker run -ti \
  -p 3000:3000 \
  -v $(pwd):/work \
  -v gempath:/usr/local/bundle \
  ruby-dev bash

# 컨테이너 내부에서
bundle install
rails server -b 0.0.0.0 -p 3000
```

### 3. 임시 디렉토리 설정

성능 향상을 위해 tmp 디렉토리를 tmpfs로 마운트:

```bash
# 컨테이너 내부에서
mkdir /tmp/rails
rm -rf /work/tmp
ln -s /tmp/rails /work/tmp
```

### 4. 데이터베이스 설정

```yaml
# config/database.yml
development:
  adapter: mysql2
  encoding: utf8mb4
  database: myapp_development
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password: password
  host: mysql  # Docker Compose 사용 시
  # host: host.docker.internal  # Docker Desktop 사용 시
```

### 5. 의존성 관리

```bash
# Gemfile 수정 후
bundle install

# 특정 gem 추가
gem install devise
bundle add devise

# Gemfile.lock 업데이트
bundle update
```

### 6. 서버 실행 옵션

```bash
# 기본 실행
rails server -b 0.0.0.0 -p 3000

# 개발 모드
rails server -e development -b 0.0.0.0 -p 3000

# PID 파일 지정
rails server -e development -b 0.0.0.0 -p 3000 --pid /tmp/rails/server.pid

# 프로덕션 모드 (테스트)
rails server -e production -b 0.0.0.0 -p 3000
```

## Docker Compose 사용

### docker-compose.yaml

```yaml
version: '3'

services:
  mysql:
    image: mysql:8.4
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: myapp_development
    volumes:
      - mysql-data:/var/lib/mysql
    ports:
      - "3306:3306"

  web:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b 0.0.0.0"
    volumes:
      - .:/work
      - gem-cache:/usr/local/bundle
    ports:
      - "3000:3000"
    depends_on:
      - mysql
    environment:
      - DATABASE_HOST=mysql
      - DATABASE_USERNAME=root
      - DATABASE_PASSWORD=password

volumes:
  mysql-data:
  gem-cache:
```

### 실행

```bash
# 서비스 시작
docker-compose up

# 백그라운드 실행
docker-compose up -d

# 로그 확인
docker-compose logs -f web

# 컨테이너 접속
docker-compose exec web bash

# 서비스 중지
docker-compose down
```

## 개발 워크플로우

### 1. 프로젝트 초기 설정

```bash
# 컨테이너 시작
docker-compose run --rm web bash

# Rails 프로젝트 생성
rails new . --database=mysql --force

# 의존성 설치
bundle install

# 데이터베이스 생성
rails db:create
rails db:migrate
```

### 2. 모델 생성

```bash
# 컨테이너 접속
docker-compose exec web bash

# 모델 생성
rails generate model User name:string email:string

# 마이그레이션 실행
rails db:migrate
```

### 3. 컨트롤러 생성

```bash
# Scaffold 생성
rails generate scaffold Article title:string body:text

rails db:migrate
```

### 4. 테스트 실행

```bash
# 전체 테스트
rails test

# 특정 테스트
rails test test/models/user_test.rb

# RSpec 사용 시
bundle exec rspec
```

### 5. 에셋 컴파일

```bash
# 개발 환경
rails assets:precompile

# 프로덕션 환경
RAILS_ENV=production rails assets:precompile
```

## 포함된 패키지

### Ruby 도구

- **Ruby**: 설정 가능한 버전
- **Bundler**: Gem 의존성 관리
- **Rails**: Ruby on Rails 프레임워크 (수동 설치)

### JavaScript 도구

- **Node.js 8**: JavaScript 런타임
- **npm**: Node 패키지 관리자
- **Webpack**: 모듈 번들러
- **Yarn**: 빠른 패키지 관리자

### 시스템 도구

- **curl**: HTTP 클라이언트
- **sudo**: 관리자 권한 실행

## 문제 해결

### Gem 설치 실패

```bash
# Bundler 업데이트
gem update --system
gem install bundler

# Bundle 재설치
rm Gemfile.lock
bundle install
```

### 서버 시작 실패

```bash
# PID 파일 삭제
rm -f tmp/pids/server.pid

# tmp 디렉토리 재생성
rm -rf tmp
mkdir -p tmp/cache tmp/pids tmp/sockets
```

### 데이터베이스 연결 실패

```bash
# MySQL 서버 확인
docker-compose ps mysql

# 데이터베이스 생성
rails db:create

# 연결 테스트
rails db:migrate:status
```

### 권한 문제

```bash
# 호스트에서 소유권 변경
sudo chown -R $(id -u):$(id -g) .

# 컨테이너 내부에서
sudo chown -R developer:developer /work
```

### 포트 충돌

```bash
# 다른 포트 사용
docker run -ti -p 8640:3000 ruby-dev

# 또는 실행 중인 프로세스 확인
lsof -i :3000
kill -9 <PID>
```

### Node 모듈 문제

```bash
# node_modules 재설치
rm -rf node_modules
yarn install

# 또는 npm 사용
npm install
```

## 고급 사용법

### 1. 멀티 스테이지 개발

```yaml
# docker-compose.override.yml
version: '3'

services:
  web:
    environment:
      - RAILS_ENV=development
      - WEBPACKER_DEV_SERVER_HOST=0.0.0.0
```

### 2. Webpacker Dev Server

```yaml
# docker-compose.yml
services:
  webpacker:
    build: .
    command: ./bin/webpack-dev-server
    volumes:
      - .:/work
    ports:
      - "3035:3035"
    environment:
      - WEBPACKER_DEV_SERVER_HOST=0.0.0.0
```

### 3. Redis 추가

```yaml
services:
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data

  web:
    depends_on:
      - mysql
      - redis
    environment:
      - REDIS_URL=redis://redis:6379/0

volumes:
  redis-data:
```

### 4. Sidekiq Workers

```yaml
services:
  sidekiq:
    build: .
    command: bundle exec sidekiq
    volumes:
      - .:/work
      - gem-cache:/usr/local/bundle
    depends_on:
      - mysql
      - redis
    environment:
      - REDIS_URL=redis://redis:6379/0
```

### 5. 프로덕션 빌드

```dockerfile
# Dockerfile.production
FROM ruby:2.7-slim

# 프로덕션 의존성만 설치
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install

COPY . .

# 에셋 사전 컴파일
RUN SECRET_KEY_BASE=dummy rails assets:precompile

CMD ["rails", "server", "-b", "0.0.0.0", "-e", "production"]
```

### 6. 환경별 설정

```bash
# .env.development
RAILS_ENV=development
DATABASE_HOST=mysql
REDIS_URL=redis://redis:6379/0

# .env.production
RAILS_ENV=production
DATABASE_HOST=production-db.example.com
REDIS_URL=redis://production-redis:6379/0
```

## 테스트 환경

### RSpec 설정

```bash
# Gemfile
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

# 설치
bundle install
rails generate rspec:install

# 실행
bundle exec rspec
```

### 테스트 데이터베이스

```bash
# 테스트 DB 준비
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:migrate

# 테스트 실행
RAILS_ENV=test bundle exec rspec
```

## 성능 최적화

### 1. Bootsnap 사용

```ruby
# Gemfile
gem 'bootsnap', require: false

# config/boot.rb
require 'bootsnap/setup'
```

### 2. Spring 사용

```bash
# Spring 프리로더
bin/spring binstub --all

# 명령 실행
bin/rails console
bin/rake db:migrate
```

### 3. Volume 최적화

```yaml
# 읽기 전용 볼륨
volumes:
  - .:/work:cached  # macOS에서 성능 향상

# tmpfs 사용
tmpfs:
  - /work/tmp
```

## 보안 권장사항

1. **SECRET_KEY_BASE**: 프로덕션에서 환경 변수로 관리
2. **데이터베이스 비밀번호**: 환경 변수 사용
3. **Git 제외**: `.env`, `config/master.key` 커밋 금지
4. **의존성 업데이트**: 정기적인 `bundle update`
5. **보안 검사**: `bundle audit` 실행

## 참고 자료

- [Ruby 공식 문서](https://www.ruby-lang.org/)
- [Rails Guides](https://guides.rubyonrails.org/)
- [Docker와 Rails](https://docs.docker.com/samples/rails/)
- [Bundler 문서](https://bundler.io/)
- [Webpacker](https://github.com/rails/webpacker)

## 관련 프로젝트

- [chef-dev](../chef-dev/README.md) - Chef 개발 환경
- [ansible-dev](../ansible-dev/README.md) - Ansible 개발 환경
- [jupyter2](../jupyter2/README.md) - Jupyter Lab (Ruby 커널 포함)

## 베이스 이미지

- ruby:${RUBY_VERSION} (공식 Ruby 이미지)

## 라이선스

Ruby on Rails는 MIT 라이선스를 따릅니다.
