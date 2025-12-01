# Chef Development Environment

> **Migration Notice (2024)**: ChefDK has been deprecated. This project now uses **Chef Workstation** which is actively maintained.

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)

```bash
# 1. 환경 설정
cp .env.example .env

# 2. Cookbooks 디렉토리 생성
mkdir -p cookbooks

# 3. 샘플 Cookbook 생성
cat > cookbooks/hello/recipes/default.rb <<'EOF'
log 'Hello from Chef!' do
  level :info
end

package 'curl' do
  action :install
end
EOF

# 4. 서비스 시작 (백그라운드)
make up

# 5. 셸 접근
make shell

# 6. (컨테이너 내부에서) Cookbook 실행
chef-client --local-mode --runlist 'recipe[hello]'
```

### Option 2: Direct Docker Run

```bash
# 이미지 빌드
docker build -t chef-dev:latest .

# 개발 셸 시작
docker run -it --rm \
  -v $(pwd)/cookbooks:/work/cookbooks \
  chef-dev:latest
```

## 개요

Chef Workstation이 포함된 개발 환경입니다:

- 👨‍🍳 **Chef Workstation**: Chef 개발 도구 전체 세트 (ChefDK 후속)
- 🔪 **knife-solo**: Solo 모드로 Chef 레시피 실행
- 🧪 **Test Kitchen**: 통합 테스트 프레임워크
- 📚 **Berkshelf**: Cookbook 의존성 관리 도구
- 🔨 **개발 도구**: build-essential, tree, nano 등
- 👤 **커스텀 사용자**: 비 root 사용자로 안전한 실행
- 🔐 **Sudo 권한**: 관리자 권한 필요 시 사용 가능
- 🚀 **한국 미러**: 카카오 미러로 빠른 패키지 다운로드
- 📦 **Ruby Gems**: Chef 생태계 gem 자동 설치
- 🏗️ **레시피 개발**: Cookbook 생성 및 테스트 환경

## Deployment Options

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default port:** N/A (Chef is a development tool, no exposed ports by default)

**Container name:** chef-dev

Environment variables:
```bash
CHEF_VERSION=latest                   # Chef Workstation version
CUSTOM_USER=developer                 # Container username
CHEF_LICENSE=accept                   # Chef license acceptance
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| N/A | Development Tool | Chef is used for cookbook development, no ports exposed |

**Port conflicts:** See [PORT_STATUS.md](../PORT_STATUS.md) for port allocation details.

> **Note:** If you need to expose ports for testing, use `-p` flag when running the container.

## 디렉토리 구조

```
chef-dev/
├── Dockerfile            # Docker 이미지 정의
├── docker-entrypoint.sh  # 엔트리포인트 스크립트
├── build.sh              # 빌드 스크립트
└── .env                  # 환경 변수
```

## 사용 예시

### 1. Chef 레시피 개발

```bash
# cookbooks 디렉토리 마운트
docker run -it --rm \
  -v $(pwd):/work \
  chef-dev bash

# 컨테이너 내에서
knife cookbook create my_cookbook
cd my_cookbook
# 레시피 작성
```

### 2. knife-solo 사용

```bash
# solo 환경 초기화
knife solo init chef-repo
cd chef-repo

# 노드 준비
knife solo prepare user@hostname

# 실행
knife solo cook user@hostname
```

### 3. Chef 레시피 테스트

```bash
# Test Kitchen 실행 (컨테이너 내에서)
kitchen init
kitchen create
kitchen converge
kitchen verify
```

## 포함된 도구

### Chef 도구

- **chef**: Chef Infra Client
- **knife**: Chef 관리 도구
- **chef-solo**: Standalone Chef 실행
- **knife-solo**: Solo 환경 관리
- **berkshelf**: Cookbook 의존성 관리
- **test-kitchen**: 통합 테스트 프레임워크

### 개발 도구

- **build-essential**: 컴파일 도구 (gcc, make 등)
- **tree**: 디렉토리 구조 출력
- **nano**: 텍스트 에디터
- **sudo**: 관리자 권한 실행

## Docker Compose 예시

```yaml
services:
  chef-dev:
    build:
      context: .
      args:
        CHEF_VERSION: 3.4.28
        CUSTOM_USER: developer
    volumes:
      - ./cookbooks:/work
      - chef-cache:/var/chef/cache
    environment:
      - CHEF_LICENSE=accept
    working_dir: /work
    command: /bin/bash

volumes:
  chef-cache:
```

## 사용자 설정

컨테이너는 기본적으로 `CUSTOM_USER` 환경 변수에 지정된 사용자로 실행됩니다:

- sudo 권한 있음 (비밀번호 불필요)
- 홈 디렉토리: `/home/${CUSTOM_USER}`
- 작업 디렉토리: `/work`

```bash
# 컨테이너 내에서 root 권한 명령 실행
sudo apt-get install package-name
```

## 버전 관리

Dockerfile의 `ARG CHEF_VERSION`을 수정하여 Chef Workstation 버전 변경:

```dockerfile
ARG CHEF_VERSION=latest  # 원하는 버전으로 변경
```

사용 가능한 버전은 [Docker Hub](https://hub.docker.com/r/chef/chefworkstation/tags)에서 확인하세요.

## 문제 해결

### gem 설치 실패

```bash
# 컨테이너 내에서 gem 업데이트
gem update --system
gem install bundler
```

### 권한 문제

```bash
# 호스트에서 디렉토리 권한 설정
sudo chown -R $(id -u):$(id -g) ./cookbooks

# 또는 컨테이너 내에서
sudo chown -R ${USER}:${USER} /work
```

### 네트워크 연결 문제

빌드 시 미러 서버를 변경할 수 있습니다:

```dockerfile
# Dockerfile에서 미러 변경
RUN sed -i 's@http://mirror.kakao.com/@http://mirror.example.com/@g' /etc/apt/sources.list
```

## 개발 워크플로우

### 1. 새 Cookbook 생성

```bash
# 컨테이너 실행
docker run -it --rm -v $(pwd):/work chef-dev bash

# Cookbook 생성
knife cookbook create my_app

# 구조 확인
tree my_app/
```

### 2. 레시피 작성

```ruby
# my_app/recipes/default.rb
package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end
```

### 3. 테스트

```bash
# Test Kitchen으로 테스트
kitchen test

# 또는 수동 테스트
chef-solo -c solo.rb -j node.json
```

## 고급 사용법

### Berkshelf로 의존성 관리

```ruby
# Berksfile
source 'https://supermarket.chef.io'

cookbook 'nginx'
cookbook 'mysql'
```

```bash
# 의존성 설치
berks install
berks upload
```

### 멀티 노드 환경

```yaml
# docker-compose.yml
services:
  chef-workstation:
    build: .
    volumes:
      - ./chef-repo:/work

  node1:
    image: ubuntu:20.04
    command: tail -f /dev/null

  node2:
    image: ubuntu:20.04
    command: tail -f /dev/null
```

## 🔧 Troubleshooting

### Chef 라이선스 문제

**문제**: "Chef license not accepted"
```bash
# 해결책: .env 파일에서 라이선스 수락
CHEF_LICENSE=accept

# 또는 런타임에 설정
docker run -it --rm \
  -e CHEF_LICENSE=accept \
  chef-dev
```

### Cookbook 경로 문제

**문제**: "Cookbook not found"
```bash
# 해결책: 작업 디렉토리 확인
# Cookbooks는 /work/cookbooks 디렉토리에 있어야 함
docker run -it --rm \
  -v $(pwd)/my-cookbooks:/work/cookbooks \
  chef-dev
```

### Berkshelf 의존성 문제

**문제**: "Could not find cookbook in any of the sources"
```bash
# 해결책 1: Berksfile 경로 확인
cd /work
berks install

# 해결책 2: Berkshelf 캐시 삭제
rm -rf ~/.berkshelf
berks install
```

### Test Kitchen Docker 문제

**문제**: "Cannot connect to Docker daemon"
```bash
# 해결책: Docker socket 마운트
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/work \
  chef-dev

# 컨테이너 내에서
kitchen test
```

### 권한 문제

**문제**: "Permission denied" when creating files
```bash
# 해결책: 사용자 ID 매칭
docker run -it --rm \
  -v $(pwd):/work \
  -e CUSTOM_USER=developer \
  --user $(id -u):$(id -g) \
  chef-dev

# 또는 sudo 사용 (컨테이너 내에서)
sudo chown -R developer:developer /work
```

### Chef-solo 실행 문제

**문제**: "No such file or directory - solo.rb"
```bash
# 해결책: solo.rb 생성
cat > solo.rb <<'EOF'
file_cache_path "/tmp/chef"
cookbook_path "/work/cookbooks"
EOF

# 실행
chef-solo -c solo.rb -j node.json
```

### 성능 최적화

**Gem 설치 속도 향상**:
```bash
# 한국 미러 사용 (Dockerfile에 이미 포함)
# 카카오 APT 미러가 자동으로 설정됨
```

**Cookbook 개발 팁**:
```ruby
# ChefSpec으로 단위 테스트 (빠름)
rspec spec/unit/recipes/default_spec.rb

# Test Kitchen으로 통합 테스트 (느림, 필요시만)
kitchen test
```

### 디버깅

**로그 레벨 조정**:
```bash
# Chef 실행 시 verbose 모드
chef-client --local-mode --log_level debug

# 또는
chef-client -l debug -c solo.rb -j node.json
```

**Why-run 모드** (Dry-run):
```bash
# 실제 변경 없이 시뮬레이션
chef-client --local-mode --why-run --runlist 'recipe[my_cookbook]'
```

## 참고 자료

- [Chef 공식 문서](https://docs.chef.io/)
- [Chef Workstation](https://docs.chef.io/workstation/)
- [Chef Workstation Docker Hub](https://hub.docker.com/r/chef/chefworkstation)
- [knife-solo](https://github.com/matschaffer/knife-solo)
- [Test Kitchen](https://kitchen.ci/)
- [Berkshelf](https://docs.chef.io/berkshelf/)

## 라이선스

MIT

## 관련 프로젝트

- [ansible-dev](../ansible-dev/README.md) - Ansible 개발 환경
- [ruby-dev](../ruby-dev/README.md) - Ruby 개발 환경
