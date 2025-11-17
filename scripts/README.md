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

## 전체 검증 실행

모든 스크립트를 한 번에 실행하려면:

```bash
# 각 스크립트 순차 실행
./scripts/validate-compose.sh && \
./scripts/test-env-examples.sh && \
./scripts/check-required-files.sh
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
      - name: Validate Compose Files
        run: ./scripts/validate-compose.sh
      - name: Test .env.example Files
        run: ./scripts/test-env-examples.sh
      - name: Check Required Files
        run: ./scripts/check-required-files.sh
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
