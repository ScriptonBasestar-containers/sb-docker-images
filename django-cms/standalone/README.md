# Django CMS Standalone Configuration

완전한 독립 실행형 Django CMS 인스턴스

## 개요

이 standalone 구성은 Django CMS를 PostgreSQL과 함께 즉시 실행할 수 있는 완전한 패키지입니다.

### 포함된 서비스

- **Web**: Django CMS 애플리케이션 (포트 8000)
- **PostgreSQL**: 데이터베이스

## 빠른 시작

### 1. 환경 변수 설정

```bash
# .env.example을 .env로 복사
cp .env.example .env

# SECRET_KEY 생성
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
# 출력된 값을 .env의 SECRET_KEY에 복사
```

### 2. .env 파일 수정

```bash
# 필수 설정
SECRET_KEY=your_generated_secret_key_here
POSTGRES_PASSWORD=strong_password_here
ALLOWED_HOSTS=cms.example.com  # 실제 도메인으로 변경
```

### 3. 서비스 시작

```bash
# 모든 서비스 시작
docker compose up -d

# 데이터베이스 마이그레이션
docker compose exec web python manage.py migrate

# 관리자 계정 생성
docker compose exec web python manage.py createsuperuser

# 정적 파일 수집
docker compose exec web python manage.py collectstatic --noinput
```

### 4. 접속

- **웹사이트**: http://localhost:8000
- **관리자 패널**: http://localhost:8000/admin

## 포트 정보

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 8000 | Web | Django CMS 웹 인터페이스 |

포트는 `.env` 파일에서 변경할 수 있습니다:
```bash
DJANGO_CMS_WEB_PORT=8000
```

## 주요 명령어

### 사용자 관리

```bash
# 슈퍼유저 생성
docker compose exec web python manage.py createsuperuser

# 사용자 비밀번호 변경
docker compose exec web python manage.py changepassword username
```

### 데이터베이스 관리

```bash
# 마이그레이션 생성
docker compose exec web python manage.py makemigrations

# 마이그레이션 실행
docker compose exec web python manage.py migrate

# 데이터베이스 백업
docker compose exec postgres pg_dump -U postgres djangocms > backup.sql

# 데이터베이스 복원
cat backup.sql | docker compose exec -T postgres psql -U postgres djangocms
```

### 정적 파일 관리

```bash
# 정적 파일 수집
docker compose exec web python manage.py collectstatic --noinput

# 정적 파일 삭제 후 재수집
docker compose exec web python manage.py collectstatic --clear --noinput
```

### Django Shell

```bash
# Django shell 실행
docker compose exec web python manage.py shell

# Python shell에서 작업
>>> from cms.models import Page
>>> Page.objects.all()
```

### 서비스 관리

```bash
# 로그 확인
docker compose logs -f

# 웹 서비스 재시작
docker compose restart web

# 모든 서비스 중지
docker compose down

# 볼륨 포함 완전 삭제
docker compose down -v
```

## 플러그인 설치

### Django CMS 플러그인 추가

```bash
# 컨테이너 내부 진입
docker compose exec web bash

# pip으로 플러그인 설치
pip install djangocms-text-ckeditor
pip install djangocms-link
pip install djangocms-picture
pip install djangocms-video

# settings.py에 INSTALLED_APPS 추가 필요
# 마이그레이션 실행
python manage.py migrate
```

### 권장 플러그인

- **djangocms-text-ckeditor**: 리치 텍스트 에디터
- **djangocms-link**: 링크 플러그인
- **djangocms-picture**: 이미지 플러그인
- **djangocms-video**: 비디오 플러그인
- **djangocms-file**: 파일 다운로드 플러그인
- **djangocms-googlemap**: Google 지도 플러그인

## 프로덕션 배포

### 1. 환경 설정

```bash
# DEBUG를 False로 설정
DEBUG=False

# ALLOWED_HOSTS 설정
ALLOWED_HOSTS=cms.example.com,www.cms.example.com

# 강력한 SECRET_KEY 사용
SECRET_KEY=$(python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
```

### 2. 정적 파일 서빙

```bash
# Nginx 또는 Whitenoise 사용 권장
# S3나 CDN 사용도 고려

# Whitenoise 설치 예시:
pip install whitenoise
# settings.py의 MIDDLEWARE에 추가:
# 'whitenoise.middleware.WhiteNoiseMiddleware',
```

### 3. 데이터베이스 최적화

```bash
# PostgreSQL 성능 튜닝
# docker-compose.yml의 postgres 서비스에 추가:
# command: postgres -c shared_buffers=256MB -c max_connections=200
```

### 4. 이메일 설정

```bash
# SMTP 설정 (환경 변수로 추가)
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your-email@gmail.com
EMAIL_HOST_PASSWORD=your-app-password
DEFAULT_FROM_EMAIL=noreply@cms.example.com
```

## 유지보수

### 정기 작업

```bash
# 주간: 데이터베이스 백업
docker compose exec postgres pg_dump -U postgres djangocms > backup-$(date +%Y%m%d).sql

# 월간: 미사용 세션 정리
docker compose exec web python manage.py clearsessions
```

### 업데이트

```bash
# 이미지 업데이트
docker compose pull

# 서비스 재시작
docker compose down
docker compose up -d

# 마이그레이션 실행
docker compose exec web python manage.py migrate

# 정적 파일 재수집
docker compose exec web python manage.py collectstatic --noinput
```

## 문제 해결

### 정적 파일이 로드되지 않음

```bash
# STATIC_ROOT 확인
docker compose exec web python manage.py diffsettings | grep STATIC

# 정적 파일 재수집
docker compose exec web python manage.py collectstatic --clear --noinput

# Nginx 설정 확인 (리버스 프록시 사용시)
```

### 데이터베이스 연결 오류

```bash
# PostgreSQL 상태 확인
docker compose ps postgres

# 데이터베이스 재시작
docker compose restart postgres

# 연결 테스트
docker compose exec postgres psql -U postgres -d djangocms
```

### 마이그레이션 충돌

```bash
# 마이그레이션 상태 확인
docker compose exec web python manage.py showmigrations

# 마이그레이션 가짜 적용 (주의!)
docker compose exec web python manage.py migrate --fake app_name migration_name

# 마이그레이션 재생성
docker compose exec web python manage.py makemigrations --merge
```

## 보안 권장사항

1. ✅ DEBUG=False in production
2. ✅ 강력한 SECRET_KEY 사용
3. ✅ ALLOWED_HOSTS 올바르게 설정
4. ✅ HTTPS 사용 (Let's Encrypt)
5. ✅ 정기적인 백업
6. ✅ 소프트웨어 업데이트
7. ✅ CSRF/XSS 보호 활성화
8. ✅ 적절한 파일 권한 설정

## 참고 자료

- [Django CMS 공식 문서](https://docs.django-cms.org/)
- [Django 공식 문서](https://docs.djangoproject.com/)
- [Django 보안 체크리스트](https://docs.djangoproject.com/en/stable/howto/deployment/checklist/)
- [Django CMS 플러그인](https://marketplace.django-cms.org/)

## 라이선스

Django CMS는 BSD 라이선스를 따릅니다.
