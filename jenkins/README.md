# Jenkins CI/CD Server

Jenkins를 위한 Docker 이미지 - LTS 버전과 JDK 21 포함

## 개요

Jenkins는 가장 널리 사용되는 오픈소스 CI/CD(지속적 통합/배포) 도구입니다. 이 이미지는 Jenkins LTS 버전에 JDK 21과 필수 플러그인을 포함하여 바로 사용할 수 있도록 구성되었습니다.

## 특징

- **Jenkins LTS**: 안정적인 Long-Term Support 버전
- **JDK 21**: 최신 Java 21 LTS 버전 포함
- **사전 설치된 플러그인**: 88개의 필수 플러그인 자동 설치
  - Git, GitHub 통합
  - Pipeline (Workflow Aggregator)
  - Credentials 관리
  - Dark Theme
  - 이메일 알림 등
- **Root 권한**: Docker-in-Docker 및 시스템 작업 가능
- **한국 시간대**: Asia/Seoul 타임존 설정

## 빠른 시작

### Docker Compose로 실행 (권장)

```bash
# 컨테이너 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# 초기 관리자 비밀번호 확인
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

웹 브라우저에서 http://localhost:8180 접속

## Standalone 구성

완전한 독립 실행 가능한 Jenkins CI/CD 서버 구성이 `standalone/` 디렉토리에 제공됩니다.

### 특징

- **Jenkins LTS (JDK 21)**: 공식 이미지 사용
- **영구 데이터 저장**: jenkins-home 볼륨
- **선택적 Docker-in-Docker**: Docker 빌드 지원
- **환경 변수 지원**: .env 파일을 통한 유연한 설정
- **완전한 문서**: 설치, 플러그인 관리, 백업/복원, 문제 해결

### 사용법

```bash
# standalone 디렉토리로 이동
cd standalone/

# 환경 변수 설정 (선택사항)
cp .env.example .env

# Jenkins 시작
make up

# 초기 관리자 비밀번호 확인
make initial-password

# 웹 브라우저에서 접속
# http://localhost:8080
```

자세한 내용은 [standalone/README.md](./standalone/README.md)를 참조하세요.

### 직접 실행

```bash
# 공식 이미지 사용
docker run -d \
  --name jenkins \
  -p 8180:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk21

# 커스텀 이미지 빌드 및 실행
make jenkins-build
docker run -d \
  --name jenkins \
  -p 8180:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins
```

## 서비스 구성

### 포트 정보

| 포트 | 용도 | 설명 |
|------|------|------|
| 8180 | Web UI | Jenkins 웹 인터페이스 (JENKINS_HTTP_PORT로 변경 가능) |
| 50000 | Agent | Jenkins Agent 통신 포트 (JNLP, JENKINS_AGENT_PORT로 변경 가능) |

> ✅ **포트 설정**: 기본 포트는 8180입니다. 환경변수로 변경 가능합니다.
> 자세한 내용은 [PORT_GUIDE.md](../PORT_GUIDE.md)를 참조하세요.

### 볼륨

- `/var/jenkins_home`: Jenkins 설정 및 데이터 저장
  - 작업 구성
  - 빌드 기록
  - 플러그인
  - 사용자 설정

## 환경 변수

compose.yml에서 설정:

```yaml
environment:
  - TZ=Asia/Seoul              # 타임존 설정
  - JAVA_OPTS=-Xmx2048m        # JVM 메모리 설정 (선택사항)
  - JENKINS_OPTS=--prefix=/jenkins  # Jenkins URL 경로 (선택사항)
```

## 디렉토리 구조

```
jenkins/
├── compose.yml                           # Docker Compose 설정
├── Makefile                              # 빌드/배포 스크립트
├── dockerfiles/
│   └── jenkins-lts-jdk21-plugin.dockerfile  # 커스텀 이미지 Dockerfile
├── conf/
│   ├── plugins.txt                       # 플러그인 목록 (88개)
│   └── plugins-suggestion.txt            # 추가 권장 플러그인
└── tmp/jenkins/config/                   # Jenkins 데이터 (자동 생성)
```

## 사용법

### 1. 초기 설정

1. Jenkins 시작 후 웹 브라우저에서 http://localhost:8180 접속
2. 초기 관리자 비밀번호 입력:

```bash
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

3. 플러그인 설치 선택 (이미 88개 플러그인 설치됨)
4. 관리자 계정 생성
5. Jenkins URL 확인 및 설정 완료

### 2. 첫 번째 Pipeline 작성

Jenkins 대시보드에서:
1. "New Item" 클릭
2. "Pipeline" 선택
3. Pipeline 스크립트 작성:

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'echo "Hello from Jenkins!"'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
```

### 3. GitHub 연동

1. GitHub Personal Access Token 생성
2. Jenkins > Manage Jenkins > Credentials
3. Global credentials 추가 (Kind: Username with password)
4. 새 Pipeline Job 생성
5. Pipeline 설정에서 "Pipeline script from SCM" 선택
6. Git 선택 후 Repository URL 입력
7. Credentials 선택

### 4. 플러그인 관리

#### 설치된 플러그인 목록 확인

Jenkins > Manage Jenkins > Script Console에서 실행:

```groovy
// 플러그인 목록 (이름과 버전)
Jenkins.instance.pluginManager.plugins.each {
    println "${it.shortName}:${it.version}"
}
```

#### 새 플러그인 설치

1. Jenkins > Manage Jenkins > Manage Plugins
2. "Available" 탭에서 플러그인 검색
3. 체크박스 선택 후 "Install without restart"

또는 `conf/plugins.txt`에 플러그인 추가 후 재빌드:

```bash
make jenkins-build
docker compose up -d --force-recreate
```

### 5. Docker-in-Docker 설정 (선택사항)

Jenkins에서 Docker 명령 실행이 필요한 경우:

```yaml
# compose.yml
services:
  jenkins:
    # ...
    volumes:
      - ./tmp/jenkins/config:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock  # 주석 제거
```

컨테이너 내부에서 Docker CLI 설치:

```bash
docker compose exec jenkins bash

# Docker CLI 설치
apt-get update
apt-get install -y docker.io
```

## 커스텀 이미지 빌드

### 1. 플러그인 커스터마이징

`conf/plugins.txt` 편집:

```bash
# 플러그인 추가
echo "docker-workflow" >> conf/plugins.txt
echo "kubernetes" >> conf/plugins.txt
```

### 2. 이미지 빌드

```bash
# Makefile 사용
make jenkins-build

# 또는 직접 빌드
docker build \
  -t jenkins \
  -f dockerfiles/jenkins-lts-jdk21-plugin.dockerfile \
  .
```

### 3. 레지스트리에 푸시

```bash
# 태그 지정
make jenkins-tag

# 푸시
make jenkins-push
```

## 문제 해결

### 초기 비밀번호를 찾을 수 없음

```bash
# 컨테이너 로그에서 확인
docker compose logs jenkins | grep -A 5 "password"

# 또는 파일에서 직접 확인
docker compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 메모리 부족 오류

JVM 메모리 증가:

```yaml
# compose.yml
environment:
  - JAVA_OPTS=-Xmx2048m -Xms1024m
```

### 플러그인 설치 실패

```bash
# 수동으로 플러그인 재설치
docker compose exec jenkins bash
jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
```

### 포트 충돌

환경 변수로 포트 변경:

```bash
# .env.example 파일 참조
JENKINS_HTTP_PORT=8180
JENKINS_AGENT_PORT=50000

# compose.yml에서는 이미 환경변수로 설정됨
ports:
  - "${JENKINS_HTTP_PORT:-8180}:8080"
  - "${JENKINS_AGENT_PORT:-50000}:50000"
```

### 권한 문제

```bash
# 볼륨 디렉토리 권한 설정
sudo chown -R 1000:1000 ./tmp/jenkins/config

# 또는 컨테이너 내부에서
docker compose exec jenkins chown -R jenkins:jenkins /var/jenkins_home
```

### Docker 소켓 권한 오류

```bash
# 호스트에서 jenkins 사용자에게 docker 그룹 권한 부여
docker compose exec jenkins bash
groupadd -g $(stat -c '%g' /var/run/docker.sock) docker
usermod -aG docker jenkins
```

## 사전 설치된 플러그인

### 핵심 플러그인 (88개)

**소스 관리**
- git, git-client
- github, github-api, github-branch-source

**Pipeline**
- workflow-aggregator (Pipeline 기본)
- pipeline-model-definition
- pipeline-stage-view
- pipeline-graph-view

**인증/권한**
- credentials, credentials-binding
- matrix-auth
- ldap, pam-auth

**빌드 도구**
- gradle
- ant
- junit

**알림**
- email-ext
- mailer

**UI/테마**
- dark-theme
- theme-manager
- bootstrap5-api
- font-awesome-api

전체 목록은 `conf/plugins.txt` 참조

## 고급 사용법

### 1. 분산 빌드 (Agent 설정)

Jenkins Agent 노드 추가:

```yaml
# docker-compose.yml
services:
  jenkins:
    # ... 기존 설정

  jenkins-agent:
    image: jenkins/inbound-agent
    environment:
      - JENKINS_URL=http://jenkins:8080
      - JENKINS_SECRET=<agent-secret>
      - JENKINS_AGENT_NAME=agent1
    depends_on:
      - jenkins
```

### 2. Jenkinsfile 예제

```groovy
// Jenkinsfile
pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'ghcr.io'
        IMAGE_NAME = 'myapp'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
            }
        }

        stage('Test') {
            steps {
                sh 'docker run --rm ${IMAGE_NAME}:${BUILD_NUMBER} npm test'
            }
        }

        stage('Push') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                    docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

### 3. 백업 및 복원

```bash
# 백업
tar -czf jenkins-backup-$(date +%Y%m%d).tar.gz ./tmp/jenkins/config/

# 복원
docker compose down
tar -xzf jenkins-backup-20240101.tar.gz
docker compose up -d
```

### 4. SSL/TLS 설정

Nginx 리버스 프록시 사용:

```nginx
# nginx.conf
server {
    listen 443 ssl;
    server_name jenkins.example.com;

    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;

    location / {
        proxy_pass http://localhost:8180;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 성능 최적화

### 1. JVM 튜닝

```yaml
environment:
  - JAVA_OPTS=-Xmx4096m -Xms2048m -XX:+UseG1GC -XX:MaxGCPauseMillis=100
```

### 2. 빌드 기록 정리

Jenkins > Manage Jenkins > System Configuration:
- Discard Old Builds 활성화
- Days to keep builds: 30
- Max # of builds to keep: 100

### 3. 워크스페이스 정리

Pipeline에서 ws-cleanup 플러그인 사용:

```groovy
post {
    always {
        cleanWs()
    }
}
```

## 보안 권장사항

1. **초기 비밀번호 즉시 변경**
2. **Matrix-based security 활성화**: Manage Jenkins > Security
3. **CSRF Protection 활성화** (기본값)
4. **Agent → Controller Security 강화**
5. **정기적인 플러그인 업데이트**
6. **불필요한 플러그인 제거**

## 참고 자료

- [Jenkins 공식 문서](https://www.jenkins.io/doc/)
- [Jenkins Docker Hub](https://hub.docker.com/r/jenkins/jenkins)
- [Jenkins 플러그인 검색](https://plugins.jenkins.io/)
- [Pipeline 문법](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [jenkinsci/docker GitHub](https://github.com/jenkinsci/docker)
- [플러그인 목록 가져오기](https://stackoverflow.com/questions/9815273/how-to-get-a-list-of-installed-jenkins-plugins-with-name-and-version-pair)

## 관련 프로젝트

- [ansible-dev](../ansible-dev/README.md) - Ansible 개발 환경
- [ruby-dev](../ruby-dev/README.md) - Ruby 개발 환경
- [jupyter](../jupyter/README.md) - Jupyter Notebook

## 라이선스

Jenkins는 MIT 라이선스를 따릅니다.
