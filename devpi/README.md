# DevPI - Python Package Index Server

Private Python Package Index (PyPI) 서버를 위한 Docker 이미지

## 개요

DevPI는 Python 패키지를 위한 강력한 프라이빗 패키지 인덱스 서버입니다. PyPI 미러링, 캐싱, 패키지 업로드 및 배포를 지원하며, 팀 내부 Python 패키지 관리에 최적화되어 있습니다.

## 특징

- **Python 3.12**: 최신 Python 3.12 slim 이미지 기반
- **웹 인터페이스**: devpi-web으로 패키지 검색 및 브라우징
- **플러그인 시스템**: 5가지 옵셔널 플러그인 지원
  - devpi-web (기본): 웹 UI 제공
  - devpi-constrained: 의존성 제약 관리
  - devpi-findlinks: 외부 패키지 링크 관리
  - devpi-jenkins: Jenkins CI/CD 통합
  - devpi-lockdown: 보안 강화 및 권한 관리
- **PyPI 미러링**: 외부 PyPI 패키지 캐싱
- **빌드 방식 선택**: PyPI 또는 소스에서 빌드 가능
- **헬스체크**: 자동 상태 모니터링
- **비 root 사용자**: 보안을 위한 devpi 전용 사용자

## 빠른 시작

### Docker Compose로 실행 (권장)

```bash
# 기본 실행 (devpi-web 포함)
docker compose up -d

# 로그 확인
docker compose logs -f

# 웹 브라우저에서 접속
# http://localhost:3141
```

### 플러그인과 함께 빌드

```bash
# 모든 플러그인 활성화
INSTALL_CONSTRAINED=true \
INSTALL_FINDLINKS=true \
INSTALL_JENKINS=true \
INSTALL_LOCKDOWN=true \
docker compose up --build -d

# 특정 플러그인만 활성화
INSTALL_JENKINS=true docker compose up --build -d
```

### Makefile 사용

```bash
# 소스에서 빌드
make prepare        # devpi 저장소 클론
make source build   # 이미지 빌드

# PyPI에서 빌드
make pypi-build

# 서버 관리
make server-up      # 서버 시작
make server-logs    # 로그 확인
make server-enter   # 컨테이너 접속
make server-down    # 서버 중지
```

## 서비스 구성

### 포트 정보

| 포트 | 용도 | 설명 |
|------|------|------|
| 3141 | HTTP | DevPI 웹 인터페이스 및 API |

> **포트 번호**: DevPI의 전통적인 포트 번호는 π(파이)의 근사값인 3141입니다.
>
> **포트 충돌 방지**: 다른 프로젝트와 동시 실행 시 포트를 변경하세요.
> 자세한 내용은 [PORT_GUIDE.md](../docs/PORT_GUIDE.md)를 참조하세요.

### 볼륨

- `/app/data`: DevPI 서버 데이터 (패키지, 인덱스, 설정)
- `/app/logs`: 서버 로그 파일

## 환경 변수

### 빌드 시 변수 (ARG)

```dockerfile
ARG PORT=3141                     # 서버 포트
ARG INSTALL_WEB=true              # 웹 인터페이스
ARG INSTALL_CONSTRAINED=false     # 제약 조건 플러그인
ARG INSTALL_FINDLINKS=false       # Findlinks 플러그인
ARG INSTALL_JENKINS=false         # Jenkins 플러그인
ARG INSTALL_LOCKDOWN=false        # Lockdown 플러그인
```

### 런타임 변수 (ENV)

compose.yml에서 설정:

```yaml
environment:
  - DEVPI_HOST=0.0.0.0           # 서버 바인드 주소
  - DEVPI_PORT=3141              # 서버 포트
  # - DEVPI_WEB_THEME=semantic-ui  # 웹 테마 (선택사항)
```

## 디렉토리 구조

```
devpi/
├── compose.yml              # Docker Compose 설정
├── Makefile                 # 메인 빌드 스크립트
├── Makefile.pypi.mk         # PyPI 빌드 스크립트
├── Makefile.source.mk       # 소스 빌드 스크립트
├── .env.sample              # 환경 변수 예제
├── pypi/
│   └── Dockerfile           # PyPI 기반 이미지
├── source/
│   └── Dockerfile           # 소스 기반 이미지
├── files/
│   └── entrypoint.sh        # 엔트리포인트 스크립트
├── devpi_data/              # 서버 데이터 (자동 생성)
└── logs/                    # 로그 파일 (자동 생성)
```

## 사용법

### 1. 초기 설정

DevPI 서버는 첫 실행 시 자동으로 초기화됩니다:

```bash
# 서버 시작
docker compose up -d

# 초기화 로그 확인
docker compose logs -f

# 컨테이너 접속
docker compose exec devpi bash
```

### 2. 클라이언트 설정

#### devpi 클라이언트 설치

```bash
# 로컬 머신에 설치
pip install devpi-client
```

#### 서버 설정

```bash
# devpi 서버 URL 설정
devpi use http://localhost:3141

# root 사용자로 로그인 (초기 비밀번호 없음)
devpi login root --password=''

# 비밀번호 설정
devpi user -m root password=yourpassword

# 인덱스 생성
devpi index -c dev bases=root/pypi
devpi use dev
```

### 3. 패키지 업로드

```bash
# 인덱스 선택
devpi use http://localhost:3141/root/dev

# 로그인
devpi login root

# 패키지 업로드
devpi upload

# 또는 setup.py 사용
python setup.py sdist bdist_wheel
devpi upload --from-dir dist/
```

### 4. 패키지 설치

```bash
# pip 설정
pip install --index-url http://localhost:3141/root/dev/+simple/ mypackage

# pip.conf에 설정 (영구적)
# ~/.pip/pip.conf 또는 프로젝트 루트/pip.conf
[global]
index-url = http://localhost:3141/root/dev/+simple/

# requirements.txt에서 설치
pip install -r requirements.txt
```

### 5. PyPI 미러 사용

```bash
# PyPI 캐시로 사용
pip install --index-url http://localhost:3141/root/pypi/+simple/ requests

# 인덱스 정보 확인
devpi use http://localhost:3141
devpi index root/pypi
```

### 6. 웹 인터페이스

웹 브라우저에서 http://localhost:3141 접속:

- 패키지 검색 및 브라우징
- 인덱스 관리
- 패키지 메타데이터 확인
- 통계 및 다운로드 기록

## 플러그인 상세

### devpi-web (기본 포함)

웹 인터페이스 제공:

```bash
# 기본적으로 활성화됨
docker compose up -d
```

기능:
- 패키지 검색 및 브라우징
- 메타데이터 확인
- 다운로드 통계
- Semantic UI 테마

### devpi-constrained

의존성 제약 조건 관리:

```bash
# 빌드 시 활성화
INSTALL_CONSTRAINED=true docker compose up --build -d
```

사용 예:
```bash
# 제약 파일 업로드
devpi upload --with-constraints constraints.txt
```

### devpi-findlinks

외부 패키지 링크 관리:

```bash
# 빌드 시 활성화
INSTALL_FINDLINKS=true docker compose up --build -d
```

### devpi-jenkins

Jenkins CI/CD 통합:

```bash
# 빌드 시 활성화
INSTALL_JENKINS=true docker compose up --build -d
```

Jenkins에서 사용:
- 빌드 아티팩트 자동 업로드
- 테스트 결과 통합
- 릴리즈 자동화

### devpi-lockdown

보안 및 권한 관리:

```bash
# 빌드 시 활성화
INSTALL_LOCKDOWN=true docker compose up --build -d
```

기능:
- 업로드 권한 제어
- 다운로드 제한
- IP 화이트리스트

## 빌드 방식

### 1. PyPI에서 빌드 (권장)

PyPI에서 안정적인 릴리즈 설치:

```bash
# Makefile 사용
make pypi-build

# 또는 직접 빌드
docker build -t devpi/server:latest -f pypi/Dockerfile .
```

### 2. 소스에서 빌드

최신 개발 버전 설치:

```bash
# 저장소 클론
make prepare

# 빌드
make source build

# 정리
make clean
```

## 문제 해결

### 초기화 실패

```bash
# 데이터 디렉토리 삭제 후 재시작
docker compose down
sudo rm -rf devpi_data
docker compose up -d
```

### 권한 오류

```bash
# 볼륨 디렉토리 권한 설정
sudo chown -R 999:999 devpi_data logs

# 또는 컨테이너 내부에서
docker compose exec devpi chown -R devpi:devpi /app/data /app/logs
```

### 패키지 업로드 실패

```bash
# 로그인 상태 확인
devpi use
devpi login root

# 인덱스 권한 확인
devpi index root/dev
```

### 웹 인터페이스 접속 불가

```bash
# devpi-web 설치 확인
docker compose exec devpi pip list | grep devpi-web

# 재빌드 (web 활성화)
INSTALL_WEB=true docker compose up --build -d
```

### 포트 충돌

```yaml
# compose.yml 수정
ports:
  - "8610:3141"  # 8610 사용 (PORT_GUIDE.md 참조)
```

또는:

```bash
# 환경 변수로 변경
DEVPI_PORT=8610 docker compose up -d
```

### 메모리 부족

```yaml
# compose.yml에 리소스 제한 추가
services:
  devpi:
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

## 고급 사용법

### 1. 멀티 인덱스 설정

```bash
# 개발 인덱스
devpi index -c dev bases=root/pypi

# 프로덕션 인덱스
devpi index -c prod bases=root/pypi

# 테스트 인덱스
devpi index -c test bases=root/dev
```

### 2. 사용자 관리

```bash
# 새 사용자 생성
devpi user -c alice password=secret email=alice@example.com

# 사용자 권한 부여
devpi index root/dev acl_upload=alice

# 사용자로 로그인
devpi login alice --password=secret
```

### 3. 복제 및 미러링

```bash
# 다른 devpi 서버로부터 복제
devpi index -c mirror bases=http://other-devpi:3141/root/dev
```

### 4. 백업 및 복원

```bash
# 백업
tar -czf devpi-backup-$(date +%Y%m%d).tar.gz devpi_data/

# 복원
docker compose down
tar -xzf devpi-backup-20240101.tar.gz
docker compose up -d
```

### 5. Nginx 리버스 프록시

```nginx
# nginx.conf
server {
    listen 80;
    server_name pypi.example.com;

    location / {
        proxy_pass http://localhost:3141;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 6. 토큰 인증

```bash
# API 토큰 생성
devpi login root
devpi index root/dev

# 토큰으로 업로드
devpi upload --token=<your-token>
```

## CI/CD 통합

### GitHub Actions 예제

```yaml
# .github/workflows/publish.yml
name: Publish to DevPI

on:
  push:
    tags:
      - 'v*'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Install devpi-client
        run: pip install devpi-client

      - name: Upload to DevPI
        env:
          DEVPI_USER: ${{ secrets.DEVPI_USER }}
          DEVPI_PASSWORD: ${{ secrets.DEVPI_PASSWORD }}
        run: |
          devpi use http://devpi.example.com:3141
          devpi login $DEVPI_USER --password=$DEVPI_PASSWORD
          devpi use root/dev
          python setup.py sdist bdist_wheel
          devpi upload --from-dir dist/
```

### GitLab CI 예제

```yaml
# .gitlab-ci.yml
publish:
  stage: deploy
  image: python:3.12
  script:
    - pip install devpi-client
    - devpi use http://devpi.example.com:3141
    - devpi login $DEVPI_USER --password=$DEVPI_PASSWORD
    - devpi use root/prod
    - python setup.py sdist bdist_wheel
    - devpi upload --from-dir dist/
  only:
    - tags
```

### Jenkins Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'python setup.py sdist bdist_wheel'
            }
        }

        stage('Upload') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'devpi-credentials',
                    usernameVariable: 'DEVPI_USER',
                    passwordVariable: 'DEVPI_PASSWORD'
                )]) {
                    sh '''
                        pip install devpi-client
                        devpi use http://localhost:3141
                        devpi login $DEVPI_USER --password=$DEVPI_PASSWORD
                        devpi use root/dev
                        devpi upload --from-dir dist/
                    '''
                }
            }
        }
    }
}
```

## 성능 최적화

### 1. 캐시 설정

```bash
# 컨테이너 접속
docker compose exec devpi bash

# 인덱스 설정 조정
devpi index root/pypi mirror_cache_expiry=3600
```

### 2. 리소스 제한

```yaml
# compose.yml
services:
  devpi:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 2G
        reservations:
          cpus: '1.0'
          memory: 1G
```

### 3. 볼륨 성능

```yaml
# SSD 사용 권장
volumes:
  - type: bind
    source: /fast/ssd/devpi_data
    target: /app/data
```

## 보안 권장사항

1. **초기 비밀번호 변경**: root 사용자 비밀번호 즉시 설정
2. **HTTPS 사용**: Nginx/Traefik으로 SSL/TLS 적용
3. **방화벽 설정**: 필요한 IP만 접근 허용
4. **정기 백업**: 데이터 손실 방지
5. **업데이트**: 정기적인 devpi 및 플러그인 업데이트
6. **토큰 사용**: 비밀번호 대신 API 토큰 사용

## Makefile 명령어

```bash
make help              # 사용 가능한 명령어 목록
make prepare           # devpi 저장소 클론
make clean             # 클론된 저장소 정리
make pypi-build        # PyPI에서 빌드
make source build      # 소스에서 빌드
make server-up         # 서버 시작
make server-down       # 서버 중지
make server-logs       # 로그 확인
make server-enter      # 컨테이너 접속
```

## 참고 자료

- [DevPI 공식 문서](https://devpi.net/docs/devpi/devpi/stable/+doc/index.html)
- [DevPI GitHub](https://github.com/devpi/devpi)
- [devpi-web](https://github.com/devpi/devpi-web)
- [devpi-client 문서](https://devpi.net/docs/devpi/devpi/stable/+doc/userman/devpi_um_installation.html)
- [Python 패키징 가이드](https://packaging.python.org/)

## 관련 프로젝트

- [jenkins](../jenkins/README.md) - Jenkins CI/CD 서버
- [jupyter](../jupyter/README.md) - Jupyter Notebook
- [jupyter2](../jupyter2/README.md) - Jupyter Lab

## 라이선스

DevPI는 MIT 라이선스를 따릅니다.
