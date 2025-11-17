# Chef Development Environment

Chef/Chef DK 개발 환경을 위한 Docker 이미지

## 개요

Chef Development Kit (ChefDK)와 knife-solo가 포함된 개발 환경 이미지입니다. Chef 레시피 개발 및 테스트에 사용됩니다.

## 특징

- **Chef DK**: Chef Development Kit 포함
- **knife-solo**: Solo 모드로 Chef 실행 가능
- **개발 도구**: build-essential, tree, nano 등 기본 도구 포함
- **사용자 설정**: 커스텀 사용자로 실행 (sudo 권한)
- **한국 미러**: 빠른 패키지 다운로드를 위한 카카오 미러 사용

## 빠른 시작

### 이미지 빌드

```bash
# 기본 빌드
./build.sh

# 또는 직접 빌드
docker build -t chef-dev .
```

### 컨테이너 실행

```bash
# 기본 실행
docker run -it --rm \
  -v $(pwd)/cookbooks:/work \
  chef-dev

# 포트 매핑과 함께
docker run -it --rm \
  -v $(pwd)/cookbooks:/work \
  -p 8080:8080 \
  chef-dev
```

## 환경 변수

`.env` 파일에서 설정:

```bash
CHEF_VERSION=3.4.28      # Chef DK 버전
CUSTOM_USER=developer    # 컨테이너 내 사용자명
```

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

Dockerfile의 `ARG CHEF_VERSION`을 수정하여 Chef DK 버전 변경:

```dockerfile
ARG CHEF_VERSION=3.4.28  # 원하는 버전으로 변경
```

사용 가능한 버전은 [Docker Hub](https://hub.docker.com/r/chef/chefdk/tags)에서 확인하세요.

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

## 참고 자료

- [Chef 공식 문서](https://docs.chef.io/)
- [Chef DK](https://docs.chef.io/workstation/)
- [knife-solo](https://github.com/matschaffer/knife-solo)
- [Test Kitchen](https://kitchen.ci/)
- [Berkshelf](https://docs.chef.io/berkshelf/)

## 라이선스

MIT

## 관련 프로젝트

- [ansible-dev](../ansible-dev/README.md) - Ansible 개발 환경
- [ruby-dev](../ruby-dev/README.md) - Ruby 개발 환경
