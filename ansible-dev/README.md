# Ansible Development Environment

Ansible playbook 개발 및 실행을 위한 Docker 이미지

## 개요

Ansible은 인프라 자동화, 구성 관리, 애플리케이션 배포를 위한 강력한 오픈소스 도구입니다. 이 이미지는 Alpine Linux 기반으로 경량화되었으며, Ansible과 필요한 Python 라이브러리를 포함하여 즉시 사용할 수 있습니다.

## 특징

- **Alpine Linux 3.20**: 경량 Linux 배포판 기반
- **Ansible 2.18**: 최신 Ansible 버전
- **필수 도구 포함**:
  - bash, curl, tar, nano
  - openssh-client, sshpass
  - git, openssl
  - Python 3 및 주요 라이브러리
- **AWS 지원**: boto3 라이브러리 포함
- **최적화된 설정**: SSH pipelining, 스마트 팩트 수집
- **작업 디렉토리**: /playbooks

## 빠른 시작

### 이미지 빌드

```bash
# Makefile 사용
make build

# 또는 직접 빌드
docker build -t ansible-dev -f alpine/Dockerfile .
```

### 기본 실행

```bash
# 현재 디렉토리의 playbook 실행
docker run --rm \
  -v $(pwd):/playbooks \
  ansible-dev site.yml

# SSH 키 마운트
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts
```

### 인벤토리와 함께 실행

```bash
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev -i inventory/production site.yml --check
```

## 서비스 구성

### 포트 정보

Ansible은 일반적으로 클라이언트 도구로 사용되며 포트를 직접 노출하지 않습니다. 대상 서버로의 SSH 연결(포트 22)을 사용합니다.

> **참고**: 웹 기반 관리가 필요한 경우 AWX (Ansible Tower의 오픈소스 버전)를 고려하세요.
>
> 포트 할당 정보는 [PORT_GUIDE.md](../docs/PORT_GUIDE.md)를 참조하세요.

### 볼륨

- `/playbooks`: Ansible playbook 작업 디렉토리
- `/root/.ssh`: SSH 키 디렉토리 (읽기 전용 권장)
- `/ansible/playbooks/roles`: Ansible roles 디렉토리

## 환경 변수

### Ansible 설정

Dockerfile에 사전 설정된 환경 변수:

```dockerfile
ANSIBLE_VERSION=2.18                    # Ansible 버전
ANSIBLE_GATHERING=smart                 # 팩트 수집 모드
ANSIBLE_HOST_KEY_CHECKING=false         # SSH 호스트 키 검증 비활성화
ANSIBLE_RETRY_FILES_ENABLED=false       # 재시도 파일 비활성화
ANSIBLE_ROLES_PATH=/ansible/playbooks/roles  # Roles 경로
ANSIBLE_SSH_PIPELINING=True             # SSH 파이프라이닝 활성화
ANSIBLE_LIBRARY=/ansible/library        # 커스텀 모듈 경로
EDITOR=nano                             # 기본 에디터
```

### 런타임 오버라이드

```bash
# 환경 변수 오버라이드
docker run --rm \
  -e ANSIBLE_HOST_KEY_CHECKING=true \
  -e ANSIBLE_GATHERING=explicit \
  -v $(pwd):/playbooks \
  ansible-dev site.yml
```

## 디렉토리 구조

```
ansible-dev/
├── Makefile                # 빌드 스크립트
├── LICENSE                 # 라이선스 파일
├── alpine/
│   └── Dockerfile          # Alpine 기반 Dockerfile
└── README.md               # 이 문서
```

## 사용법

### 1. Playbook 작성

```yaml
# site.yml
---
- name: Configure web servers
  hosts: webservers
  become: yes

  tasks:
    - name: Install nginx
      package:
        name: nginx
        state: present

    - name: Start nginx
      service:
        name: nginx
        state: started
        enabled: yes
```

### 2. 인벤토리 작성

```ini
# inventory/hosts
[webservers]
web1.example.com
web2.example.com

[databases]
db1.example.com

[all:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3
```

### 3. Playbook 실행

```bash
# 기본 실행
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts

# 체크 모드 (Dry-run)
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts --check

# 특정 태그만 실행
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts --tags nginx

# Verbose 모드
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts -vvv
```

### 4. Ad-hoc 명령

```bash
# ansible 명령 실행
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  --entrypoint ansible \
  ansible-dev all -i inventory/hosts -m ping

# 패키지 업데이트
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  --entrypoint ansible \
  ansible-dev webservers -i inventory/hosts -m apt -a "update_cache=yes" --become

# 서비스 재시작
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  --entrypoint ansible \
  ansible-dev webservers -i inventory/hosts -m service -a "name=nginx state=restarted" --become
```

### 5. Shell 접속

```bash
# 대화형 셸
docker run -it --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  --entrypoint /bin/bash \
  ansible-dev

# 컨테이너 내에서
ansible --version
ansible-playbook --help
ansible-galaxy --help
```

### 6. Ansible Vault 사용

```bash
# Vault 파일 생성
docker run -it --rm \
  -v $(pwd):/playbooks \
  --entrypoint ansible-vault \
  ansible-dev create secrets.yml

# Vault 파일과 함께 playbook 실행
docker run -it --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts --ask-vault-pass

# Vault 비밀번호 파일 사용
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts --vault-password-file .vault_pass
```

### 7. Ansible Galaxy Roles

```bash
# Role 설치
docker run --rm \
  -v $(pwd):/playbooks \
  --entrypoint ansible-galaxy \
  ansible-dev install geerlingguy.nginx

# requirements.yml에서 설치
docker run --rm \
  -v $(pwd):/playbooks \
  --entrypoint ansible-galaxy \
  ansible-dev install -r requirements.yml
```

## 포함된 패키지

### 시스템 도구

- **bash**: Bash 쉘
- **curl**: HTTP 클라이언트
- **tar**: 압축 도구
- **nano**: 텍스트 에디터
- **openssh-client**: SSH 클라이언트
- **sshpass**: 비밀번호 기반 SSH 인증
- **git**: 버전 관리
- **openssl**: SSL/TLS 도구

### Python 라이브러리

- **python3**: Python 3 인터프리터
- **py3-dateutil**: 날짜/시간 처리
- **py3-httplib2**: HTTP 라이브러리
- **py3-jinja2**: 템플릿 엔진
- **py3-paramiko**: SSH 라이브러리
- **py3-boto3**: AWS SDK
- **py3-pip**: Python 패키지 관리자
- **py3-setuptools**: 패키지 설치 도구
- **py3-yaml**: YAML 파서
- **ca-certificates**: SSL 인증서

## 문제 해결

### SSH 연결 실패

```bash
# 호스트 키 검증 활성화
docker run --rm \
  -e ANSIBLE_HOST_KEY_CHECKING=true \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts

# SSH 에이전트 포워딩
docker run --rm \
  -v $(pwd):/playbooks \
  -v $SSH_AUTH_SOCK:/ssh-agent \
  -e SSH_AUTH_SOCK=/ssh-agent \
  ansible-dev site.yml -i inventory/hosts
```

### 권한 문제

```bash
# SSH 키 권한 확인
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# 컨테이너 내부에서 확인
docker run -it --rm \
  -v ~/.ssh:/root/.ssh:ro \
  --entrypoint /bin/bash \
  ansible-dev -c "ls -la /root/.ssh"
```

### Python 인터프리터 오류

```yaml
# inventory에 Python 경로 지정
[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

또는 playbook에서:

```yaml
- hosts: all
  vars:
    ansible_python_interpreter: /usr/bin/python3
```

### 팩트 수집 느림

```bash
# 팩트 수집 비활성화
docker run --rm \
  -e ANSIBLE_GATHERING=explicit \
  -v $(pwd):/playbooks \
  ansible-dev site.yml -i inventory/hosts
```

또는 playbook에서:

```yaml
- hosts: all
  gather_facts: no
```

### 추가 Python 패키지 필요

```bash
# 컨테이너 내부에서 설치
docker run -it --rm \
  -v $(pwd):/playbooks \
  --entrypoint /bin/bash \
  ansible-dev

# pip로 설치
pip install netaddr
```

또는 커스텀 이미지 빌드:

```dockerfile
# Dockerfile.custom
FROM ansible-dev
RUN pip install netaddr ansible-lint
```

## 고급 사용법

### 1. Docker Compose 사용

```yaml
# docker-compose.yml
version: '3.8'

services:
  ansible:
    image: ansible-dev
    build:
      context: .
      dockerfile: alpine/Dockerfile
    volumes:
      - ./playbooks:/playbooks
      - ~/.ssh:/root/.ssh:ro
    environment:
      - ANSIBLE_HOST_KEY_CHECKING=false
      - ANSIBLE_GATHERING=smart
    command: site.yml -i inventory/hosts
```

실행:

```bash
docker-compose run ansible site.yml -i inventory/hosts
```

### 2. AWS 리소스 관리

```yaml
# aws-playbook.yml
---
- name: Manage AWS EC2 instances
  hosts: localhost
  connection: local
  gather_facts: no

  tasks:
    - name: Launch EC2 instance
      amazon.aws.ec2_instance:
        key_name: mykey
        instance_type: t2.micro
        image_id: ami-0c55b159cbfafe1f0
        wait: yes
        region: us-east-1
        count: 1
        state: present
      environment:
        AWS_ACCESS_KEY_ID: "{{ aws_access_key }}"
        AWS_SECRET_ACCESS_KEY: "{{ aws_secret_key }}"
```

실행:

```bash
docker run --rm \
  -v $(pwd):/playbooks \
  -e AWS_ACCESS_KEY_ID=your_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret \
  ansible-dev aws-playbook.yml
```

### 3. 멀티스테이지 실행

```bash
# 개발 환경
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/dev

# 프로덕션 환경
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/prod --check
```

### 4. 커스텀 모듈 사용

```bash
# 디렉토리 구조
# playbooks/
# ├── library/          # 커스텀 모듈
# │   └── my_module.py
# ├── site.yml
# └── inventory/

docker run --rm \
  -v $(pwd):/playbooks \
  -e ANSIBLE_LIBRARY=/playbooks/library \
  ansible-dev site.yml -i inventory/hosts
```

### 5. 병렬 실행

```bash
# 10개 호스트 동시 실행
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  ansible-dev site.yml -i inventory/hosts --forks 10
```

### 6. 콜백 플러그인

```bash
# JSON 출력
docker run --rm \
  -v $(pwd):/playbooks \
  -v ~/.ssh:/root/.ssh:ro \
  -e ANSIBLE_STDOUT_CALLBACK=json \
  ansible-dev site.yml -i inventory/hosts
```

## CI/CD 통합

### GitLab CI 예제

```yaml
# .gitlab-ci.yml
stages:
  - test
  - deploy

test:
  stage: test
  image: ansible-dev
  script:
    - ansible-playbook site.yml -i inventory/dev --syntax-check
    - ansible-playbook site.yml -i inventory/dev --check

deploy:
  stage: deploy
  image: ansible-dev
  script:
    - mkdir -p /root/.ssh
    - echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
    - chmod 600 /root/.ssh/id_rsa
    - ansible-playbook site.yml -i inventory/prod
  only:
    - main
```

### GitHub Actions 예제

```yaml
# .github/workflows/ansible.yml
name: Ansible Deployment

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run Ansible Playbook
        run: |
          docker run --rm \
            -v $(pwd):/playbooks \
            -e ANSIBLE_HOST_KEY_CHECKING=false \
            ansible-dev site.yml -i inventory/prod
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
```

### Jenkins Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Syntax Check') {
            steps {
                sh '''
                    docker run --rm \
                      -v $(pwd):/playbooks \
                      ansible-dev site.yml --syntax-check
                '''
            }
        }

        stage('Dry Run') {
            steps {
                sh '''
                    docker run --rm \
                      -v $(pwd):/playbooks \
                      -v /root/.ssh:/root/.ssh:ro \
                      ansible-dev site.yml -i inventory/prod --check
                '''
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    docker run --rm \
                      -v $(pwd):/playbooks \
                      -v /root/.ssh:/root/.ssh:ro \
                      ansible-dev site.yml -i inventory/prod
                '''
            }
        }
    }
}
```

## 모범 사례

### 1. 디렉토리 구조

```
playbooks/
├── ansible.cfg           # Ansible 설정
├── site.yml              # 메인 playbook
├── inventory/
│   ├── dev
│   ├── staging
│   └── prod
├── group_vars/
│   ├── all.yml
│   ├── webservers.yml
│   └── databases.yml
├── host_vars/
│   └── web1.example.com.yml
├── roles/
│   ├── common/
│   ├── nginx/
│   └── mysql/
├── library/              # 커스텀 모듈
├── filter_plugins/       # 커스텀 필터
└── requirements.yml      # Galaxy roles
```

### 2. Ansible 설정 파일

```ini
# ansible.cfg
[defaults]
inventory = ./inventory/hosts
roles_path = ./roles
host_key_checking = False
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

[ssh_connection]
pipelining = True
control_path = /tmp/ansible-ssh-%%h-%%p-%%r
```

### 3. 보안

- SSH 키를 읽기 전용으로 마운트
- Ansible Vault로 민감 정보 암호화
- 환경별 인벤토리 분리
- 프로덕션 배포 전 --check 모드 실행

## 참고 자료

- [Ansible 공식 문서](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Alpine Linux](https://alpinelinux.org/)

## 관련 프로젝트

- [chef-dev](../chef-dev/README.md) - Chef 개발 환경
- [jenkins](../jenkins/README.md) - Jenkins CI/CD 서버
- [ruby-dev](../ruby-dev/README.md) - Ruby 개발 환경

## 라이선스

이 프로젝트는 LICENSE 파일에 명시된 라이선스를 따릅니다.
