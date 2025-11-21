# Django CMS

Django CMS 개발 환경

> 💡 **Quick Start**: For production deployment with database and caching, use the [standalone setup](standalone/README.md) - it includes PostgreSQL and comprehensive documentation!

## 개요

Django CMS는 Django 기반의 오픈소스 콘텐츠 관리 시스템(CMS)입니다:
- 🐍 Django 프레임워크 기반
- 🎨 강력한 플러그인 시스템
- ✍️ 인라인 편집 기능
- 📱 반응형 디자인 지원
- 🔍 SEO 친화적
- 🌐 다국어 지원
- 👥 세밀한 권한 관리

이 프로젝트는 Django CMS의 개발 및 테스트를 위한 Docker 환경을 제공합니다.

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ Django CMS backend server
- ✅ PostgreSQL 13.5 with health check
- ✅ Frontend development server
- ✅ Standardized Makefile

**Access:** http://localhost:8000

📚 **See [standalone/README.md](standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.** Uses minimal configuration with external services.

## Quick Start (Basic Setup)

```bash
# 컨테이너 시작
docker-compose up -d

# 데이터베이스 마이그레이션
docker-compose exec web python manage.py migrate

# 관리자 계정 생성
docker-compose exec web python manage.py createsuperuser

# 접속
# http://localhost:8000 - Django CMS
```

## 서비스 구성

compose.yml에는 다음 서비스들이 포함되어 있습니다:

- **web**: Django CMS 백엔드 서버 (포트 8000)
- **frontend**: 프론트엔드 개발 서버 (포트 8090)
- **db**: PostgreSQL 13.5 데이터베이스 (포트 5432)

## Default Configuration

**Default ports:**
- Backend: 8000 (recommended port - see [PORT_GUIDE.md](../PORT_GUIDE.md))
- Frontend: 8090

**Container names:** web, frontend, db

Environment variables (from `backend/.local-env`):

```bash
DATABASE_URL=postgres://postgres@db:5432/db
DEBUG=True
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1
FRONTEND_URL=http://localhost:8090
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 8000 | web | Django backend server |
| 8090 | frontend | Frontend development server |
| 5432 | db | PostgreSQL (internal) |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## 환경 변수

환경 변수는 `backend/.local-env` 파일에서 설정:

```bash
# 데이터베이스 설정
DATABASE_URL=postgres://postgres@db:5432/db

# Django 설정
DEBUG=True
SECRET_KEY=your-secret-key-here
ALLOWED_HOSTS=localhost,127.0.0.1

# 프론트엔드 설정
FRONTEND_URL=http://localhost:8090
```

## 디렉토리 구조

```
django-cms/
├── docker-compose.yml     # Docker Compose 설정
├── Dockerfile             # 백엔드 Dockerfile
├── frontend.Dockerfile    # 프론트엔드 Dockerfile
├── backend/               # Django 백엔드 코드
│   ├── .local-env        # 환경 변수
│   └── manage.py         # Django 관리 스크립트
├── frontend/              # 프론트엔드 코드
│   ├── webpack.config.js
│   └── package.json
└── data/                  # 데이터 저장소
```

## 개발 가이드

### 백엔드 개발

```bash
# Django 쉘 실행
docker-compose exec web python manage.py shell

# 앱 생성
docker-compose exec web python manage.py startapp myapp

# 마이그레이션 생성
docker-compose exec web python manage.py makemigrations

# 마이그레이션 적용
docker-compose exec web python manage.py migrate

# 정적 파일 수집
docker-compose exec web python manage.py collectstatic
```

### 프론트엔드 개발

```bash
# 프론트엔드 컨테이너 접속
docker-compose exec frontend sh

# 패키지 설치
docker-compose exec frontend yarn install

# 빌드
docker-compose exec frontend yarn build
```

### 로그 확인

```bash
# 전체 로그
docker-compose logs -f

# 특정 서비스 로그
docker-compose logs -f web
docker-compose logs -f frontend
```

## 볼륨

```yaml
volumes:
  - .:/app:rw           # 소스 코드 (읽기/쓰기)
  - ./data:/data:rw     # 데이터 저장소
  - /app/node_modules/  # 프론트엔드 의존성 (호스트와 분리)
```

## 데이터베이스

### PostgreSQL 연결

```bash
# PostgreSQL 접속
docker-compose exec db psql -U postgres -d db

# 데이터베이스 백업
docker-compose exec db pg_dump -U postgres db > backup.sql

# 데이터베이스 복원
docker-compose exec -T db psql -U postgres db < backup.sql
```

### 데이터베이스 초기화

```bash
# 데이터베이스 삭제 및 재생성
docker-compose down -v
docker-compose up -d db
docker-compose exec web python manage.py migrate
```

## Live Mode

Live 모드로 실행하려면:

1. `.dockerignore`에서 `/static_collected` 제거
2. [Divio 가이드](https://docs.divio.com/en/latest/how-to/local-in-live-configuration/) 참조

## 문제 해결

### 포트가 이미 사용 중

```bash
# 포트 사용 확인
sudo lsof -i :8000
sudo lsof -i :8090

# 다른 포트로 실행
docker-compose run -p 8001:80 web
```

### 데이터베이스 연결 실패

```bash
# 데이터베이스 서비스 재시작
docker-compose restart db

# 연결 테스트
docker-compose exec web python manage.py dbshell
```

### 프론트엔드 빌드 실패

```bash
# node_modules 재설치
docker-compose exec frontend rm -rf node_modules
docker-compose exec frontend yarn install

# 또는 컨테이너 재빌드
docker-compose build frontend
docker-compose up -d frontend
```

### 권한 문제

```bash
# 호스트에서 권한 수정
sudo chown -R $(id -u):$(id -g) .
```

## 프로덕션 배포

프로덕션 환경에서는:

1. `DEBUG=False` 설정
2. `SECRET_KEY` 변경
3. `ALLOWED_HOSTS` 설정
4. HTTPS 사용
5. 정적 파일을 CDN이나 웹 서버에서 제공

```bash
# 프로덕션 모드 실행 예시
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## 기술 스택

- **Django**: Python 웹 프레임워크
- **Django CMS**: 콘텐츠 관리 시스템
- **PostgreSQL 13.5**: 데이터베이스
- **Webpack**: 프론트엔드 번들러
- **Node.js**: 프론트엔드 빌드 도구

## 참고 자료

- [Django CMS 공식 문서](https://docs.django-cms.org/)
- [Django 공식 문서](https://docs.djangoproject.com/)
- [Divio Cloud](https://www.divio.com/)
- [Docker Compose 가이드](https://docs.docker.com/compose/)

## 관련 프로젝트

- [wordpress](../wordpress/README.md) - WordPress CMS
- [joomla](../joomla/README.md) - Joomla CMS
- [drupal](../drupal/README.md) - Drupal CMS

## 라이선스

프로젝트에 따라 다름 (Django CMS는 BSD 라이선스)
