# MailSlurper

> 💡 **Quick Start**: For production deployment, use the [standalone setup](standalone/README.md) - it includes comprehensive documentation for application integration, API usage, and testing!

## 개요

MailSlurper는 로컬 개발 및 테스트를 위한 간단한 SMTP 메일 서버입니다:
- 📧 **SMTP 서버**: 애플리케이션에서 발송한 이메일 수신
- 🌐 **웹 UI**: 받은 이메일을 브라우저에서 확인
- 🔌 **REST API**: 이메일 조회 및 관리 API 제공
- 💾 **SQLite 기반**: 경량 데이터베이스로 이메일 저장
- 🚫 **실제 발송 없음**: 이메일이 외부로 전송되지 않음
- ⚡ **간편한 설정**: 복잡한 설정 없이 즉시 사용 가능
- 🐳 **Docker 지원**: 컨테이너 환경에서 손쉽게 실행
- 🔍 **검색 및 필터링**: 이메일 검색 및 관리 기능

개발 중인 애플리케이션의 이메일 기능을 테스트할 때 이상적입니다.

## Deployment Options

### ✅ Standalone (Recommended for Production)

Complete production-ready setup:

```bash
cd standalone/
make up
```

**What's included:**
- ✅ MailSlurper SMTP server
- ✅ Web UI for email viewing
- ✅ REST API for email management
- ✅ Environment variable configuration

**Access:**
- Web UI: http://localhost:8085
- API: http://localhost:8080
- SMTP: localhost:2500

📚 **See [standalone/README.md](./standalone/README.md) for complete setup guide.**

---

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default ports:**
- SMTP: 2500
- API: 8080
- Web UI: 8085 (see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** mailslurper

Environment variables:
```bash
SMTP_PORT=2500
API_PORT=8080
WEB_PORT=8085
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 2500 | SMTP | Email receiving server |
| 8080 | API | REST API endpoint |
| 8085 | Web UI | Email viewing interface |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## 빠른 시작

### 방법 1: Docker 이미지 직접 실행 (권장)

```bash
# MailSlurper 실행
docker run -d \
  --name mailslurper \
  -p 2500:2500 \
  -p 8080:8080 \
  -p 8085:8085 \
  scriptonbasestar/mailslurper

# 웹 UI 접속
http://localhost:8085
```

### 방법 2: 소스에서 빌드

```bash
# 1. MailSlurper 소스코드 클론 (최초 1회만)
make init

# 2. Docker 이미지 빌드
make build

# 3. 컨테이너 실행
docker run -d \
  --name mailslurper \
  -p 2500:2500 \
  -p 8080:8080 \
  -p 8085:8085 \
  scriptonbasestar/mailslurper
```

## 사용 가능한 명령어

```bash
make init     # MailSlurper 소스코드 클론
make build    # Docker 이미지 빌드 (ARM64, AMD64 멀티 아키텍처)
```

## 서비스 구성

MailSlurper는 단일 서비스로 다음 컴포넌트를 포함합니다:

- **SMTP Server**: 이메일 수신 서버
- **API Server**: REST API 제공
- **Web UI**: 이메일 확인용 웹 인터페이스

## 포트 정보

| 포트 | 서비스 | 설명 |
|------|--------|------|
| 2500 | SMTP | 애플리케이션에서 이메일 전송 시 사용 |
| 8080 | API | REST API 엔드포인트 |
| 8085 | Web UI | 이메일 확인용 웹 인터페이스 (현재 설정) |

> ⚠️ **포트 충돌 주의**: 현재 8085 포트를 Web UI에 사용하고 있습니다.
>
> **권장 포트**: 8810 ([포트 가이드](../PORT_GUIDE.md) 참조)
>
> **포트 변경 방법**:
> ```bash
> # Docker run 시 포트 변경
> docker run -d \
>   --name mailslurper \
>   -p 2500:2500 \
>   -p 8080:8080 \
>   -p 8810:8085 \
>   scriptonbasestar/mailslurper
> ```

포트 충돌 방지: [포트 가이드](../PORT_GUIDE.md)

## 환경 변수

MailSlurper는 설정 파일 기반으로 동작하며, 주요 설정은 다음과 같습니다:

- **wwwAddress**: 웹 UI 주소 (기본값: 0.0.0.0)
- **wwwPort**: 웹 UI 포트 (기본값: 8085)
- **serviceAddress**: API 주소 (기본값: 0.0.0.0)
- **servicePort**: API 포트 (기본값: 8080)
- **smtpAddress**: SMTP 주소 (기본값: 0.0.0.0)
- **smtpPort**: SMTP 포트 (기본값: 2500)

## 사용법

### 1. 애플리케이션에서 SMTP 설정

애플리케이션의 SMTP 설정을 다음과 같이 변경:

```yaml
# 예: Rails config/environments/development.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'localhost',
  port: 2500,
  domain: 'localhost'
}
```

```python
# 예: Python (Flask/Django)
MAIL_SERVER = 'localhost'
MAIL_PORT = 2500
MAIL_USE_TLS = False
MAIL_USE_SSL = False
```

```javascript
// 예: Node.js (Nodemailer)
const transporter = nodemailer.createTransport({
  host: 'localhost',
  port: 2500,
  secure: false,
  tls: {
    rejectUnauthorized: false
  }
});
```

```php
// 예: PHP
ini_set('SMTP', 'localhost');
ini_set('smtp_port', '2500');
```

### 2. 이메일 발송 테스트

```bash
# 애플리케이션에서 이메일 발송
# 예: 회원가입, 비밀번호 재설정 등

# 웹 UI에서 확인
http://localhost:8085
```

### 3. API로 이메일 확인

```bash
# 모든 이메일 목록 조회
curl http://localhost:8080/mail

# 특정 이메일 조회
curl http://localhost:8080/mail/{id}

# 이메일 삭제
curl -X DELETE http://localhost:8080/mail/{id}

# 모든 이메일 삭제
curl -X DELETE http://localhost:8080/mail
```

### 4. Docker Compose와 함께 사용

```yaml
# docker-compose.yml
services:
  app:
    image: your-app
    environment:
      SMTP_HOST: mailslurper
      SMTP_PORT: 2500
    depends_on:
      - mailslurper
    networks:
      - app-network

  mailslurper:
    image: scriptonbasestar/mailslurper
    ports:
      - "2500:2500"
      - "8080:8080"
      - "8085:8085"
    networks:
      - app-network

networks:
  app-network:
```

### 5. 다른 포트로 실행

```bash
# 포트 충돌 시 다른 포트 사용
docker run -d \
  --name mailslurper \
  -p 2501:2500 \
  -p 8081:8080 \
  -p 8810:8085 \
  scriptonbasestar/mailslurper

# 애플리케이션 SMTP 설정도 변경 필요
# SMTP_PORT: 2501
# WEB_UI: http://localhost:8810
```

## 기술 스택

- **Go**: MailSlurper는 Go로 작성됨
- **SQLite**: 이메일 저장용 경량 데이터베이스
- **Web UI**: HTML/CSS/JavaScript

## 문제 해결

### 소스코드가 없다는 에러

```bash
# mailslurper 디렉토리가 없으면
make init
```

### 빌드 에러

```bash
# 최신 소스 다시 받기
rm -rf mailslurper
make init
make build
```

### 이메일이 수신되지 않음

```bash
# 1. MailSlurper가 실행 중인지 확인
docker ps | grep mailslurper

# 2. 로그 확인
docker logs mailslurper

# 3. SMTP 포트 확인
docker port mailslurper 2500

# 4. 애플리케이션 SMTP 설정 확인
# - 호스트: localhost (또는 컨테이너명)
# - 포트: 2500
# - TLS/SSL: 비활성화
```

### 웹 UI 접속 안 됨

```bash
# 1. 포트 확인
docker port mailslurper

# 2. 브라우저 캐시 삭제 후 재접속
# Ctrl + Shift + R (강력 새로고침)

# 3. 다른 브라우저로 시도
http://localhost:8085
```

### 포트가 이미 사용 중

```bash
# 사용 중인 포트 확인
sudo lsof -i :8085
sudo lsof -i :2500

# 다른 포트로 실행
docker run -d \
  --name mailslurper \
  -p 2501:2500 \
  -p 8081:8080 \
  -p 8810:8085 \
  scriptonbasestar/mailslurper
```

### Docker 네트워크 이슈

```bash
# 같은 네트워크에 있는지 확인
docker network inspect bridge

# 네트워크 생성 및 연결
docker network create dev-network
docker run -d \
  --name mailslurper \
  --network dev-network \
  -p 2500:2500 \
  -p 8085:8085 \
  scriptonbasestar/mailslurper
```

## 다른 프로젝트에서 사용

### Ory Kratos와 함께 사용

```bash
# kratos 디렉토리의 compose.yml에 이미 포함됨
cd ../kratos
make run

# MailSlurper 접속 (kratos에서는 다른 포트 사용)
http://localhost:4437
```

### WordPress/Joomla/Drupal과 함께 사용

```yaml
# docker-compose.yml에 추가
services:
  mailslurper:
    image: scriptonbasestar/mailslurper
    ports:
      - "2500:2500"
      - "8085:8085"
    networks:
      - app-network
```

SMTP 플러그인 설정:
- SMTP 호스트: mailslurper
- SMTP 포트: 2500
- 암호화: 없음
- 인증: 불필요

## 참고 자료

### 공식 문서
- [MailSlurper GitHub](https://github.com/mailslurper/mailslurper)
- [MailSlurper 설정 가이드](https://github.com/mailslurper/mailslurper/wiki/Configuration-File)

### 대안 도구
- [MailHog](https://github.com/mailhog/MailHog) - 유사한 기능의 메일 테스트 도구
- [MailCatcher](https://mailcatcher.me/) - Ruby 기반 메일 캐처
- [Mailtrap](https://mailtrap.io/) - 클라우드 기반 이메일 테스트

### 활용 예제
- [Rails with MailSlurper](https://github.com/mailslurper/mailslurper/wiki/Using-MailSlurper-with-Ruby-on-Rails)
- [Django with MailSlurper](https://github.com/mailslurper/mailslurper/wiki/Using-MailSlurper-with-Django)
- [PHP with MailSlurper](https://github.com/mailslurper/mailslurper/wiki/Using-MailSlurper-with-PHP)

## 보안 주의사항

MailSlurper는 개발/테스트 전용입니다:

1. **프로덕션 사용 금지**: 실제 서비스에서 사용하지 마세요
2. **외부 노출 금지**: 방화벽으로 외부 접근 차단
3. **민감 정보 주의**: 실제 고객 정보 사용 금지
4. **정기적 삭제**: 테스트 이메일은 정기적으로 삭제

## 라이선스

MailSlurper는 MIT 라이선스로 배포됩니다.
