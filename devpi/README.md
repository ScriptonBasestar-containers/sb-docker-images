# Devpi Docker Container

devpi PyPI staging server and packaging/testing/release tool을 위한 Docker 컨테이너입니다.

## 특징

- Python 3.11 기반
- 멀티 스테이지 빌드로 최적화된 이미지 크기
- 비 root 사용자로 실행하여 보안 강화
- 헬스 체크 기능 포함
- 데이터 영속성을 위한 볼륨 마운트

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
# 이미지 빌드
make build

# 캐시 없이 빌드
make build-no-cache
```

### 3. 서버 실행

```bash
# devpi 서버 시작
make server-up

# Docker Compose 사용
docker-compose up -d
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

- **URL**: http://localhost:3141
- **데이터 디렉토리**: `./devpi_data`
- **로그 디렉토리**: `./logs`

## 환경 변수

- `DEVPI_HOST`: 서버 호스트 (기본값: 0.0.0.0)
- `DEVPI_PORT`: 서버 포트 (기본값: 3141)

## 볼륨

- `/app/data`: devpi 서버 데이터
- `/app/logs`: 로그 파일

## 도움말

```bash
make help
``` 