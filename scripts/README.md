# Validation Scripts

이 디렉토리에는 저장소의 품질을 검증하기 위한 스크립트들이 포함되어 있습니다.

## 스크립트 목록

### 1. validate-compose.sh

Docker Compose 파일의 YAML 문법을 검증합니다.

**사용법:**
```bash
# 전체 저장소 검증
./scripts/validate-compose.sh

# 특정 디렉토리만 검증
./scripts/validate-compose.sh ./drupal
```

**검증 내용:**
- Docker Compose 파일 YAML 문법 유효성
- `compose.yml`, `compose.*.yml`, `docker-compose.yml` 파일 검증
- Docker가 설치된 경우: `docker compose config` 실행
- Docker가 없는 경우: Python YAML 파서로 기본 검증

**종료 코드:**
- `0`: 모든 파일이 유효함
- `1`: 하나 이상의 파일이 유효하지 않음

### 2. test-env-examples.sh

`.env.example` 파일의 형식을 검증합니다.

**사용법:**
```bash
# 전체 저장소 검증
./scripts/test-env-examples.sh

# 특정 디렉토리만 검증
./scripts/test-env-examples.sh ./drupal
```

**검증 내용:**
- `.env.example` 파일이 비어있지 않은지 확인
- 환경변수 형식 검증 (KEY=VALUE)
- 동일 디렉토리에 compose 파일 존재 여부 확인

**종료 코드:**
- `0`: 모든 파일이 유효함
- `1`: 하나 이상의 파일이 유효하지 않음

### 3. check-required-files.sh

각 이미지 디렉토리에 필수 파일이 있는지 확인합니다.

**사용법:**
```bash
# 전체 저장소 검사
./scripts/check-required-files.sh

# 특정 디렉토리만 검사
./scripts/check-required-files.sh ./drupal
```

**확인 항목:**
- **필수 파일:**
  - `compose.yml` 또는 `docker-compose.yml`
  - `README.md`

- **권장 파일:**
  - `Makefile`
  - `.env.example`
  - `.gitignore`

**종료 코드:**
- `0`: 항상 성공 (경고만 출력)

### 4. check-port-conflicts.sh

Docker Compose 파일에서 포트 충돌을 감지합니다.

**사용법:**
```bash
# 전체 저장소 검사
./scripts/check-port-conflicts.sh

# 특정 디렉토리만 검사
./scripts/check-port-conflicts.sh ./drupal
```

**검사 내용:**
- 모든 Docker Compose 파일에서 포트 매핑 추출
- 호스트 포트 충돌 감지
- 충돌 발생 시 파일 및 서비스 정보 제공
- 환경변수로 정의된 포트도 감지

**출력 정보:**
- 충돌하지 않는 포트: 초록색 ✓
- 충돌하는 포트: 빨간색 ⚠ CONFLICT (파일 및 서비스 정보 포함)
- 통계: 총 파일 수, 총 포트 수, 충돌 수

**종료 코드:**
- `0`: 항상 성공 (충돌 발견 시 경고만 출력)

**참고:**
- 포트 충돌은 서비스를 동시에 실행할 때만 문제가 됩니다
- 독립적으로 실행되는 서비스는 같은 포트를 사용해도 무방합니다

### 5. verify-health-checks.sh

데이터베이스 서비스의 health check 설정을 검증합니다.

**사용법:**
```bash
# 전체 저장소 검증
./scripts/verify-health-checks.sh

# 특정 디렉토리만 검증
./scripts/verify-health-checks.sh ./drupal
```

**검증 대상 서비스:**
- PostgreSQL / postgres / postgresql
- MariaDB / MySQL
- Redis
- MongoDB
- Elasticsearch
- RabbitMQ

**출력 정보:**
- Health check 있음: 초록색 ✓
- Health check 권장 (누락): 빨간색 ✗ (예제 설정 제공)
- Health check 선택사항: 파란색 ○

**제공 정보:**
- 각 서비스별 권장 health check 설정 예제
- Health check의 이점 설명
- 통계: 전체 서비스 수, health check 설정 여부

**종료 코드:**
- `0`: 항상 성공 (권장 사항만 출력)

**Health Check 이점:**
1. 의존성 서비스가 준비된 후 시작 보장
2. 컨테이너 오케스트레이션 안정성 향상
3. 장애 시 자동 재시작 가능
4. 모니터링 및 디버깅 향상

## 전체 검증 실행

모든 스크립트를 한 번에 실행하려면:

```bash
# 필수 검증 스크립트 (오류 발생 시 중단)
./scripts/validate-compose.sh && \
./scripts/test-env-examples.sh

# 권장 검증 스크립트 (경고만 출력)
./scripts/check-required-files.sh
./scripts/check-port-conflicts.sh
./scripts/verify-health-checks.sh

# 모든 스크립트 순차 실행
./scripts/validate-compose.sh && \
./scripts/test-env-examples.sh && \
./scripts/check-required-files.sh && \
./scripts/check-port-conflicts.sh && \
./scripts/verify-health-checks.sh
```

## CI/CD 통합

이 스크립트들은 GitHub Actions 또는 다른 CI/CD 시스템에서 사용할 수 있습니다.

**예제 GitHub Actions 워크플로우:**
```yaml
name: Validate

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      # 필수 검증 (실패 시 중단)
      - name: Validate Compose Files
        run: ./scripts/validate-compose.sh
      - name: Test .env.example Files
        run: ./scripts/test-env-examples.sh

      # 권장 검증 (경고만 출력)
      - name: Check Required Files
        run: ./scripts/check-required-files.sh
      - name: Check Port Conflicts
        run: ./scripts/check-port-conflicts.sh
      - name: Verify Health Checks
        run: ./scripts/verify-health-checks.sh
```

## 요구사항

### validate-compose.sh
- **선호:** Docker 설치
- **대체:** Python 3 (YAML 파싱용)
- **최소:** Bash 4.0+

### test-env-examples.sh
- Bash 4.0+

### check-required-files.sh
- Bash 4.0+
- `find` 명령어

### check-port-conflicts.sh
- Bash 4.0+
- `grep`, `sed` 명령어

### verify-health-checks.sh
- Bash 4.0+
- `grep`, `sed` 명령어

## 출력 형식

모든 스크립트는 색상 코드를 사용하여 결과를 출력합니다:

- 🟢 **녹색 (✓)**: 성공
- 🔴 **빨간색 (✗)**: 실패
- 🟡 **노란색 (⚠)**: 경고

## 문제 해결

### "permission denied" 오류

스크립트에 실행 권한이 없는 경우:
```bash
chmod +x scripts/*.sh
```

### Docker를 찾을 수 없음

`validate-compose.sh`는 Docker가 없어도 Python을 사용하여 기본 YAML 검증을 수행합니다:
```bash
# Python 설치 확인
python3 --version
```

### YAML 파싱 오류

Compose 파일에 문법 오류가 있는 경우 자세한 오류 메시지가 출력됩니다. 일반적인 문제:
- 들여쓰기 오류 (공백 vs 탭)
- 따옴표 누락
- 잘못된 YAML 구조

## 개선 사항 제안

이 스크립트들은 계속 개선될 수 있습니다. 제안 사항:
- 더 많은 검증 규칙 추가
- JSON 출력 형식 지원
- 자동 수정 기능
- 성능 최적화

Pull Request를 환영합니다!
