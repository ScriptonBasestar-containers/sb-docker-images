# Devpi Docker Container

devpi PyPI staging server and packaging/testing/release tool을 위한 Docker 컨테이너입니다.

## 특징

- Python 3.12 기반
- 멀티 스테이지 빌드로 최적화된 이미지 크기
- 비 root 사용자로 실행하여 보안 강화
- 헬스 체크 기능 포함
- 데이터 영속성을 위한 볼륨 마운트
- **devpi-web 포함**: 웹 인터페이스와 패키지 검색 기능 제공
- Semantic UI 테마 적용

## 사용법

### 1. 환경 준비

```bash
# devpi 저장소 clone 및 환경 준비
make prepare

# 디렉토리 설정
make setup
```

### 2. Docker 이미지 빌드

```bash
# 기본 빌드 (웹 인터페이스 포함)
make build

# 모든 플러그인 포함 빌드
make build-full

# 최소 빌드 (웹 인터페이스 없음)
make build-minimal

# 커스텀 빌드 (특정 플러그인 선택)
make build-custom web=true constrained=true jenkins=false

# 캐시 없이 빌드
make build-no-cache
```

### 3. 서버 실행

```bash
# devpi 서버 시작
make server-up

# Docker Compose 사용 (기본 설정)
docker-compose up -d

# Docker Compose로 특정 플러그인 활성화
INSTALL_CONSTRAINED=true INSTALL_JENKINS=true docker-compose up --build -d
```

### 4. 서버 관리

```bash
# 서버 중지
make server-down

# 로그 확인
make server-logs

# 컨테이너 접속
make server-enter

# 서버 재시작
make server-restart
```

### 5. 개발용 명령

```bash
# 개발 환경 빌드 및 실행
make dev-run

# 모든 리소스 정리
make dev-clean
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

### 환경변수 사용 예시
```bash
# .env 파일 생성
cat > .env << EOF
INSTALL_WEB=true
INSTALL_CONSTRAINED=true
INSTALL_JENKINS=true
DEVPI_WEB_THEME=semantic-ui
EOF

# Docker Compose 실행
docker-compose up --build -d
```

## 볼륨

- `/app/data`: devpi 서버 데이터
- `/app/logs`: 로그 파일

## 도움말

```bash
make help
``` 