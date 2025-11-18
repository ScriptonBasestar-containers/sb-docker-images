# Jenkins Standalone Configuration

완전한 독립 실행 가능한 Jenkins CI/CD 자동화 서버 구성

## 개요

이 standalone 구성은 Jenkins를 모든 필수 설정과 함께 즉시 실행할 수 있도록 구성되어 있습니다.

### 포함된 서비스

- **Jenkins LTS (JDK 21)**: CI/CD 자동화 서버 (포트 8080, 50000)
- **Optional Docker-in-Docker**: Docker 빌드 지원 (설정 시)

## 빠른 시작

### 1. 환경 변수 설정 (선택사항)

```bash
# .env 파일 생성
cp .env.example .env

# 필요한 경우 포트 및 JVM 메모리 설정 수정
```

### 2. Jenkins 시작

```bash
# 서비스 시작
make up
```

첫 실행 시 Jenkins 초기화에 1-2분 소요됩니다.

### 3. 초기 관리자 비밀번호 확인

```bash
# 초기 비밀번호 출력
make initial-password
```

### 4. 웹 브라우저에서 접속

```
http://localhost:8080
```

### 5. 초기 설정 완료

1. 초기 관리자 비밀번호 입력
2. "Install suggested plugins" 선택 (권장)
3. 첫 번째 관리자 계정 생성
4. Jenkins URL 확인
5. 설정 완료!

## 사용 가능한 명령어

### 서비스 관리

```bash
# Jenkins 시작
make up

# Jenkins 중지
make down

# 로그 확인
make logs

# Jenkins 재시작
make restart

# 실행 중인 컨테이너 확인
make ps
```

### 접속 및 관리

```bash
# 초기 관리자 비밀번호 확인
make initial-password

# Jenkins 컨테이너 쉘 접속
make shell
```

### 백업 및 복원

```bash
# Jenkins 전체 백업
make backup

# 백업에서 복원
make restore
```

### 데이터 정리

```bash
# 모든 데이터 삭제 (⚠️ 주의: 복구 불가능)
make clean
```

## 서비스 구성

### 기본 구성

```
┌─────────────────┐
│    Jenkins      │ :8080 (Web)
│   LTS (JDK 21)  │ :50000 (Agent)
└─────────────────┘
```

### Docker-in-Docker 구성 (선택사항)

```
┌─────────────────┐
│    Jenkins      │ :8080, :50000
│   LTS (JDK 21)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Docker-in-     │
│   Docker (DinD) │
└─────────────────┘
```

### 포트

| 서비스 | 내부 포트 | 외부 포트 | 용도 |
|--------|----------|----------|------|
| Jenkins Web | 8080 | 8080 | 웹 인터페이스 |
| Jenkins Agent | 50000 | 50000 | 분산 빌드 에이전트 |

### 볼륨

| 볼륨 | 용도 |
|------|------|
| jenkins-home | Jenkins 홈 디렉토리 (설정, 플러그인, 작업 등) |
| jenkins-logs | Jenkins 로그 파일 |

## Docker-in-Docker 설정

Jenkins에서 Docker 빌드를 실행하려면 Docker-in-Docker를 활성화할 수 있습니다.

### 1. compose.yml 수정

```yaml
# compose.yml에서 docker-dind 서비스 주석 해제
services:
  docker-dind:
    image: docker:27-dind
    # ... (전체 서비스 설정 주석 해제)
```

### 2. 볼륨 주석 해제

```yaml
volumes:
  jenkins-docker-certs:
    driver: local
  jenkins-docker-data:
    driver: local
```

### 3. Jenkins 재시작

```bash
make down
make up
```

### 4. Jenkins에서 Docker Cloud 설정

1. **Docker Pipeline 플러그인 설치**
   - Manage Jenkins > Manage Plugins
   - Available 탭에서 "Docker Pipeline" 검색 및 설치

2. **Docker Cloud 추가**
   - Manage Jenkins > Manage Nodes and Clouds > Configure Clouds
   - Add a new cloud > Docker
   - Docker Host URI: `tcp://docker-dind:2376`
   - Server credentials: `/certs/client`에서 자동 설정

3. **Dockerfile 빌드 예시**

```groovy
// Jenkinsfile
pipeline {
    agent {
        docker {
            image 'maven:3.8.1-jdk-11'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
    }
}
```

## Jenkins 설정

### 플러그인 관리

```bash
# 웹 UI에서
1. Manage Jenkins > Manage Plugins
2. Updates 탭: 업데이트 가능한 플러그인 확인
3. Available 탭: 새 플러그인 설치
4. Installed 탭: 설치된 플러그인 관리
```

**권장 플러그인:**
- Git Plugin
- Pipeline
- Docker Pipeline (Docker 빌드 시)
- Blue Ocean (모던 UI)
- GitHub Integration Plugin
- Slack Notification Plugin
- Email Extension Plugin

### 사용자 및 권한 관리

```bash
# 웹 UI에서
1. Manage Jenkins > Manage Users
2. Create User: 새 사용자 생성
3. Configure Global Security
   - Security Realm: Jenkins' own user database
   - Authorization: Matrix-based security (권장)
```

### Job 생성

#### Freestyle Project

1. New Item > Freestyle project
2. Source Code Management: Git 저장소 URL
3. Build Triggers: 빌드 트리거 설정 (예: GitHub hook)
4. Build Steps: 빌드 스크립트 추가
5. Post-build Actions: 알림, 아티팩트 저장 등

#### Pipeline Project

1. New Item > Pipeline
2. Pipeline script 작성 또는 Jenkinsfile from SCM

```groovy
// 간단한 Pipeline 예시
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your/repo.git'
            }
        }

        stage('Build') {
            steps {
                sh './build.sh'
            }
        }

        stage('Test') {
            steps {
                sh './test.sh'
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        success {
            echo 'Build succeeded!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}
```

### Credentials 관리

```bash
# 웹 UI에서
1. Manage Jenkins > Manage Credentials
2. Add Credentials:
   - Username with password
   - SSH Username with private key
   - Secret text
   - Secret file
```

**Pipeline에서 사용:**

```groovy
pipeline {
    agent any

    environment {
        DB_PASSWORD = credentials('database-password-id')
    }

    stages {
        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-credentials',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'git clone https://$USER:$PASS@github.com/repo.git'
                }
            }
        }
    }
}
```

## 백업 및 복원

### 자동 백업

```bash
# 매일 자동 백업 설정 (cron)
0 2 * * * cd /path/to/jenkins/standalone && make backup
```

### 수동 백업

```bash
# Jenkins 전체 백업
make backup

# 백업 파일은 ./backups/ 디렉토리에 저장됨
# 파일명 형식: jenkins-backup-YYYYMMDD-HHMMSS.tar.gz
```

### 백업 복원

```bash
# 대화형 복원
make restore

# 프롬프트에서 백업 파일명 입력
# 예: jenkins-backup-20250117-020000.tar.gz
```

### 중요한 백업 항목

Jenkins 홈 디렉토리 (`/var/jenkins_home`) 포함 항목:
- **jobs/**: 모든 작업 설정 및 빌드 히스토리
- **plugins/**: 설치된 플러그인
- **users/**: 사용자 설정
- **secrets/**: 암호화 키
- **config.xml**: Jenkins 전역 설정
- **credentials.xml**: 저장된 자격 증명

## 문제 해결

### Jenkins가 시작되지 않는 경우

```bash
# 로그 확인
make logs

# 일반적인 원인:
# 1. 포트 충돌 (8080, 50000)
# 2. 메모리 부족
# 3. 권한 문제
```

### 초기 비밀번호를 찾을 수 없는 경우

```bash
# Jenkins가 완전히 시작될 때까지 대기 (1-2분)
make logs

# "Jenkins is fully up and running" 메시지 확인 후
make initial-password
```

### 메모리 부족 오류

`.env` 파일에서 JVM 메모리 증가:

```bash
JAVA_OPTS_XMS=-Xms1g
JAVA_OPTS_XMX=-Xmx4g
```

```bash
# 재시작
make down
make up
```

### 플러그인 설치 실패

```bash
# 프록시 설정이 필요한 경우
1. Manage Jenkins > Manage Plugins > Advanced
2. HTTP Proxy Configuration 설정
3. Test URL: https://updates.jenkins.io/update-center.json
```

### 빌드가 실패하는 경우

```bash
# 빌드 로그 확인
# Jenkins UI > 해당 Job > 빌드 번호 클릭 > Console Output

# 권한 문제 확인
make shell
ls -la /var/jenkins_home/workspace/
```

### Docker-in-Docker 연결 실패

```bash
# docker-dind 서비스 상태 확인
docker compose ps docker-dind

# 로그 확인
docker compose logs docker-dind

# 네트워크 연결 확인
docker compose exec jenkins ping docker-dind
```

### 디스크 공간 부족

```bash
# 오래된 빌드 정리
# Jenkins UI > Job 설정 > Discard old builds 활성화

# 수동 정리
make shell
du -sh /var/jenkins_home/jobs/*/builds/*
# 불필요한 빌드 디렉토리 삭제
```

## 고급 설정

### Nginx 리버스 프록시 (HTTPS)

```nginx
# nginx.conf
server {
    listen 80;
    server_name jenkins.example.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name jenkins.example.com;

    ssl_certificate /etc/ssl/certs/jenkins.crt;
    ssl_certificate_key /etc/ssl/private/jenkins.key;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support (for Blue Ocean)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### JVM 튜닝

`.env` 파일에서 추가 JVM 옵션:

```bash
JAVA_OPTS=-Xms1g -Xmx4g -XX:MaxPermSize=512m -Djava.awt.headless=true
```

### 분산 빌드 (Agent 설정)

1. **Static Agent 추가:**
   - Manage Jenkins > Manage Nodes and Clouds > New Node
   - Node name, Remote root directory 설정
   - Launch method: Launch agent via SSH

2. **Dynamic Agent (Docker):**
   - Docker Cloud 설정 (위 Docker-in-Docker 섹션 참조)
   - Agent template 생성

## 보안 권장사항

### 1. 접근 제어

```bash
# Matrix-based security 설정
1. Manage Jenkins > Configure Global Security
2. Authorization: Matrix-based security
3. 역할별 권한 할당:
   - Admin: 모든 권한
   - Developer: Job 생성/빌드
   - Viewer: 읽기 전용
```

### 2. CSRF 보호

```bash
# Manage Jenkins > Configure Global Security
- Enable "Prevent Cross Site Request Forgery exploits"
```

### 3. Agent-Master 보안

```bash
# Manage Jenkins > Configure Global Security > Agents
- TCP port for inbound agents: Fixed (50000)
- Agent protocols: JNLP4 only
```

### 4. 플러그인 보안

- 신뢰할 수 있는 소스의 플러그인만 설치
- 정기적으로 플러그인 업데이트
- 사용하지 않는 플러그인 제거

### 5. Credentials 보안

- 평문 비밀번호 저장 금지
- Jenkins Credentials plugin 사용
- Credential binding으로 Pipeline에서 안전하게 사용

## 성능 최적화

### 1. 동시 실행 작업 수 조정

```bash
# Manage Jenkins > Configure System
- # of executors: CPU 코어 수와 동일하게 설정
```

### 2. 빌드 히스토리 관리

```bash
# Job 설정 > Discard old builds
- Days to keep builds: 30
- Max # of builds to keep: 50
```

### 3. 워크스페이스 정리

```bash
# Job 설정 > Build Environment
- Delete workspace before build starts (필요시)
```

### 4. 빌드 캐싱

```groovy
// Jenkinsfile에서 캐싱 활용
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Maven 로컬 저장소 캐싱
                withMaven(maven: 'Maven 3', mavenLocalRepo: '.m2/repository') {
                    sh 'mvn clean install'
                }
            }
        }
    }
}
```

## 참고 자료

- [Jenkins 공식 문서](https://www.jenkins.io/doc/)
- [Jenkins Pipeline 문서](https://www.jenkins.io/doc/book/pipeline/)
- [Docker Plugin 문서](https://plugins.jenkins.io/docker-plugin/)
- [Blue Ocean 문서](https://www.jenkins.io/doc/book/blueocean/)
- [Jenkins Best Practices](https://www.jenkins.io/doc/book/using/best-practices/)
- [포트 가이드](../../PORT_GUIDE.md)

## 라이센스

Jenkins는 MIT License를 따릅니다.
