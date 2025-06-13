# Devpi Docker Container

- by Source
- by Pypi

## 특징

- Python 3.12 기반
- 옵셔널 설치기능(ui, constrained, findlinks, jenkins, lockdown)

## Dev

### 1. Prepare & Clean

소스코드 받기 등 전체적으로 한번하는 작업

```bash
# devpi 저장소 clone 및 환경 준비
make prepare
make clean
```

### 2. Build & Push

두개 명령어 패턴이 다른것은 실수 아님
```bash
make pypi-build
make source build
```

### 3. Server

```bash
# devpi 서버 시작
make setup
make server-up
make server-logs
make server-enter
make server-down
make teardown

# Docker Compose 사용 (기본 설정)
docker-compose up -d

# Docker Compose로 특정 플러그인 활성화
INSTALL_CONSTRAINED=true INSTALL_JENKINS=true docker-compose up --build -d
```

## 접속 정보

- **Server URL**: http://localhost:3141
- **Web Interface**: http://localhost:3141 (devpi-web 포함)
- **데이터 디렉토리**: `./devpi_data`
- **로그 디렉토리**: `./logs`

## 웹 인터페이스 기능

- 📦 패키지 검색 및 브라우징
- 🔍 고급 검색 기능
- 📊 패키지 통계 및 메타데이터 확인
- 📋 인덱스 관리
- 🎨 Semantic UI 테마로 현대적인 디자인

## 사용 가능한 플러그인

### 🌐 devpi-web (기본 포함)
- 웹 인터페이스 제공
- 패키지 검색 및 브라우징

### 🔒 devpi-constrained
- 의존성 제약 조건 관리
- 버전 제한 및 호환성 검사

### 🔗 devpi-findlinks
- findlinks 지원으로 외부 패키지 링크 관리
- 커스텀 패키지 저장소 연동

### 🏗️ devpi-jenkins
- Jenkins CI/CD 시스템과의 통합
- 자동화된 빌드 및 배포 지원

### 🛡️ devpi-lockdown
- 보안 강화 기능
- 액세스 제어 및 권한 관리

## 환경 변수

### 서버 설정
- `DEVPI_HOST`: 서버 호스트 (기본값: 0.0.0.0)
- `DEVPI_PORT`: 서버 포트 (기본값: 3141)
- `DEVPI_WEB_THEME`: 웹 테마 (기본값: semantic-ui)

### 플러그인 제어 (빌드 시)
- `INSTALL_WEB`: devpi-web 설치 (기본값: true)
- `INSTALL_CONSTRAINED`: devpi-constrained 설치 (기본값: false)
- `INSTALL_FINDLINKS`: devpi-findlinks 설치 (기본값: false)
- `INSTALL_JENKINS`: devpi-jenkins 설치 (기본값: false)
- `INSTALL_LOCKDOWN`: devpi-lockdown 설치 (기본값: false)
