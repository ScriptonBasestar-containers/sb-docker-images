# TSBoard

TypeScript 기반 모던 게시판 시스템

## 개요

TSBoard는 TypeScript로 개발된 현대적인 게시판 시스템입니다. 프론트엔드는 TypeScript/Vue.js로, 백엔드는 Go로 구현되어 있어 높은 성능과 안정성을 제공합니다. 한국형 커뮤니티 사이트 구축에 최적화되어 있으며, 반응형 디자인을 지원합니다.

## 빠른 시작

```bash
# 소스 코드 다운로드
make prepare

# Docker Compose로 실행
docker compose up -d

# 웹 브라우저로 접속
# http://localhost:8910
```

## 서비스 구성

- **frontend**: TSBoard 프론트엔드 (TypeScript/Vue.js, 포트 8910)
- **backend**: Go API 서버 (포트 3100)
- **db**: MySQL 8.4 데이터베이스

## 포트

| 포트 | 서비스 | 용도 |
|------|--------|------|
| 8910 | frontend | 웹 사이트 (Nginx) |
| 3100 | backend | API 서버 (Go) |
| 3306 | db | 데이터베이스 (선택사항) |

포트 충돌 방지: [포트 가이드](../docs/PORT_GUIDE.md)

※ 참고: compose.yml에서는 80/3100 포트를 사용하지만, PORT_GUIDE.md의 표준에 따라 8910 포트 사용을 권장합니다.

## 환경 변수

compose.yml에서 설정:

```yaml
environment:
  # 백엔드 설정
  - DATABASE_URL=${DATABASE_URL}
```

## 디렉토리 구조

```
tsboard/
├── compose.yml                      # Docker Compose 설정
├── dockerfiles/
│   ├── frontend-tsboard.dockerfile  # 프론트엔드 Dockerfile
│   └── backend-goapi.dockerfile     # 백엔드 Dockerfile
├── Makefile                         # 빌드 스크립트
├── README.md                        # 이 문서
└── repos/
    ├── tsboard/                     # 프론트엔드 소스
    └── goapi/                       # 백엔드 소스
```

## 설치 방법

### 1. 소스 코드 다운로드

```bash
# Makefile을 사용한 자동 다운로드
make prepare

# 또는 수동 다운로드
git clone https://github.com/sirini/tsboard.git repos/tsboard
git clone https://github.com/sirini/goapi.git repos/goapi
```

### 2. 환경 변수 설정

.env 파일 생성:

```bash
# .env
DATABASE_URL=root:example@tcp(db:3306)/tsboard?charset=utf8mb4&parseTime=True&loc=Local
```

### 3. Docker 이미지 빌드 및 실행

```bash
# Docker Compose로 빌드 및 실행
docker compose up -d --build
```

### 4. 데이터베이스 초기화

```bash
# 데이터베이스 마이그레이션 (필요시)
docker compose exec backend ./goapi migrate
```

## 사용법

### 메인 페이지

```
URL: http://localhost:8910
```

### 관리자 페이지

```
URL: http://localhost:8910/admin
ID: 초기 설정 시 생성한 관리자 ID
PW: 초기 설정 시 설정한 비밀번호
```

### API 서버 접속

```
URL: http://localhost:3100
API 문서: http://localhost:3100/swagger (가능한 경우)
```

### 프론트엔드 개발 모드

```bash
# 프론트엔드 컨테이너 내에서 개발 서버 실행
docker compose exec frontend npm run dev
```

### 백엔드 로그 확인

```bash
docker compose logs -f backend
```

## 데이터베이스 관리

### 데이터베이스 백업

```bash
# 백업
docker compose exec db mysqldump -u root -pexample tsboard > backup.sql

# 복원
docker compose exec -T db mysql -u root -pexample tsboard < backup.sql
```

### 데이터베이스 접속

```bash
docker compose exec db mysql -u root -pexample tsboard
```

## 볼륨

기본 볼륨 설정 없음 (필요시 추가):

```yaml
volumes:
  - mysql-data:/var/lib/mysql          # 데이터베이스
  - frontend-node-modules:/app/node_modules  # Node.js 모듈
  - backend-data:/app/data             # 백엔드 데이터
```

## 네트워크

기본 네트워크 사용

## 문제 해결

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f

# 특정 서비스 로그
docker compose logs -f frontend
docker compose logs -f backend

# 컨테이너 재시작
docker compose restart
```

### 프론트엔드 빌드 오류

```bash
# 프론트엔드 컨테이너 재빌드
docker compose build --no-cache frontend

# Node 모듈 재설치
docker compose exec frontend npm install
```

### 백엔드 연결 실패

```bash
# 백엔드 컨테이너 상태 확인
docker compose ps backend

# 백엔드 재시작
docker compose restart backend

# Go 모듈 다운로드
docker compose exec backend go mod download
```

### 데이터베이스 연결 실패

```bash
# MySQL 컨테이너 상태 확인
docker compose ps db

# 재시작
docker compose restart db

# DATABASE_URL 확인
docker compose exec backend env | grep DATABASE_URL
```

### 포트 충돌

```yaml
# compose.yml의 포트 변경
services:
  frontend:
    ports:
      - "8911:80"  # 기본 8910 대신 8911 사용
  backend:
    ports:
      - "3101:3100"  # 기본 3100 대신 3101 사용
```

## 포트 변경 방법

PORT_GUIDE.md의 표준 포트(8910)로 변경:

```yaml
# compose.yml 수정
services:
  frontend:
    ports:
      - "8910:80"  # 기존 80:80에서 변경
```

## 개발 환경

### 프론트엔드 개발

```bash
# 컨테이너 내부 접속
docker compose exec frontend sh

# 의존성 설치
npm install

# 개발 서버 실행
npm run dev

# 빌드
npm run build
```

### 백엔드 개발

```bash
# 컨테이너 내부 접속
docker compose exec backend sh

# Go 모듈 다운로드
go mod download

# 빌드
go build -o goapi

# 실행
./goapi
```

### 로그 확인

```bash
# 모든 서비스 로그
docker compose logs -f

# 프론트엔드 로그
docker compose logs -f frontend

# 백엔드 로그
docker compose logs -f backend

# 데이터베이스 로그
docker compose logs -f db
```

## 기능

### 주요 기능

- 게시판 생성 및 관리
- 게시글 작성/수정/삭제
- 댓글 기능
- 사용자 인증 및 권한 관리
- 파일 첨부
- 검색 기능
- 반응형 디자인
- 실시간 알림 (WebSocket)

### 기술적 특징

- TypeScript로 작성된 타입 안전 코드
- Vue.js 기반 SPA (Single Page Application)
- Go로 구현된 고성능 백엔드 API
- RESTful API 설계
- JWT 기반 인증
- MySQL 데이터베이스

## 프로덕션 배포

### 1. 환경 변수 설정

```bash
# .env.production
DATABASE_URL=user:password@tcp(db-host:3306)/tsboard?charset=utf8mb4&parseTime=True&loc=Local
```

### 2. 프론트엔드 빌드

```bash
docker compose exec frontend npm run build
```

### 3. HTTPS 설정

Nginx 리버스 프록시 사용 권장:

```nginx
server {
    listen 443 ssl;
    server_name yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8910;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /api {
        proxy_pass http://localhost:3100;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 보안 설정

### 1. 데이터베이스 비밀번호 변경

```yaml
# compose.yml
services:
  db:
    environment:
      MYSQL_ROOT_PASSWORD: 강력한비밀번호
```

### 2. JWT Secret 설정

백엔드 설정 파일에서 JWT Secret 변경

### 3. CORS 설정

프로덕션 도메인만 허용하도록 백엔드 CORS 설정 변경

## 기술 스택

### 프론트엔드
- **TypeScript**: 타입 안전 JavaScript
- **Vue.js**: 프로그레시브 JavaScript 프레임워크
- **Vite**: 빌드 도구
- **Nginx**: 웹 서버

### 백엔드
- **Go**: 고성능 백엔드 언어
- **Gin**: Go 웹 프레임워크
- **GORM**: Go ORM

### 데이터베이스
- **MySQL**: 8.4

## 참고 자료

- [TSBoard GitHub](https://github.com/sirini/tsboard)
- [GoAPI GitHub](https://github.com/sirini/goapi)
- [Vue.js 문서](https://vuejs.org/)
- [Go 문서](https://golang.org/doc/)
- [Gin 문서](https://gin-gonic.com/)

## 관련 프로젝트

- [gnuboard5](../gnuboard5/README.md) - 그누보드5 (PHP)
- [gnuboard6](../gnuboard6/README.md) - 그누보드6 (Python)
- [xpressengine](../xpressengine/README.md) - XE3 (PHP/Laravel)

## 라이선스

TSBoard의 라이선스는 각 저장소를 참조하세요.

## 주의사항

- TSBoard는 현재 개발 중인 프로젝트입니다.
- 프로덕션 사용 전 충분한 테스트가 필요합니다.
- 소스 코드는 외부 저장소(GitHub)에서 클론하여 사용합니다.
- 프론트엔드와 백엔드가 분리되어 있어 각각 별도로 관리됩니다.
- 환경 변수 설정이 올바르지 않으면 데이터베이스 연결에 실패할 수 있습니다.
