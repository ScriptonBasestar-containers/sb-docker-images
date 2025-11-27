# Monitoring (모니터링 & 관측성)

모니터링 및 관측성 도구 - 서비스 헬스 체크, 업타임 모니터링, 알림

## 📚 프로젝트 목록 (준비 중)

### [Uptime Kuma](uptime-kuma/) 🚧 **Coming Soon**
**Self-hosted Uptime Monitoring (Upptime 대안)**
- 실시간 서비스 모니터링
- HTTP(S), TCP, Ping, DNS 체크
- 다양한 알림 채널 (Slack, Discord, Email 등)
- 깔끔한 상태 페이지
- SQLite 기반 (경량)
- Port: 3011

## 🎯 카테고리 특징

### 주요 기능
- **업타임 모니터링**: 웹사이트, API, 서버 가용성 체크
- **다양한 프로토콜**: HTTP(S), TCP, Ping, DNS, MongoDB 등
- **알림**: Slack, Discord, Telegram, Email, Webhook
- **상태 페이지**: Public/Private 상태 페이지 생성
- **인증서 모니터링**: SSL 인증서 만료 알림
- **메트릭**: 응답 시간, 가동률 통계

### 사용 사례
- **웹사이트 모니터링**: 24/7 가용성 체크
- **API 엔드포인트**: Health check 자동화
- **SSL 인증서**: 만료 전 알림
- **서버 헬스**: Ping, TCP 포트 체크
- **상태 페이지**: 고객용 공개 상태 페이지

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/monitoring/uptime-kuma

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# 웹 UI 접속
open http://localhost:3011

# 초기 설정
# - 관리자 계정 생성
# - 모니터 추가
# - 알림 채널 설정
```

## 📖 공통 구성

모든 프로젝트는 다음을 포함합니다:
- ✅ 환경변수 템플릿 (.env.example)
- ✅ Docker Compose 구성
- ✅ Makefile 자동화
- ✅ README 문서화
- ✅ Health checks
- ✅ 데이터 영속성 (볼륨)

## 🔗 관련 카테고리

- [Infrastructure](../infrastructure/) - 인프라 서비스
- [Automation](../automation/) - 워크플로우 자동화
- [DevTools](../devtools/) - 개발 도구

## 🆚 비교: Monitoring Tools

| 기능 | Uptime Kuma | Upptime | Prometheus | Grafana |
|------|------------|---------|-----------|---------|
| Self-hosted | ✅ | ✅ (GitHub) | ✅ | ✅ |
| 사용 난이도 | ⭐ (쉬움) | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 업타임 모니터링 | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ |
| 메트릭 수집 | ⭐ | ⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 알림 | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| 상태 페이지 | ⭐⭐⭐ | ⭐⭐⭐ | ❌ | ⭐⭐ |
| 리소스 사용 | 낮음 | 매우 낮음 | 중간 | 중간 |
| 설정 복잡도 | 낮음 | 낮음 | 높음 | 높음 |

### Uptime Kuma 추천 대상
- 간단한 업타임 모니터링 필요
- 빠른 설정 및 시작
- 다양한 알림 채널 활용
- 상태 페이지 공개 필요
- 경량 솔루션 선호

### Prometheus + Grafana 추천 대상
- 복잡한 메트릭 수집
- 커스텀 대시보드
- 대규모 인프라 모니터링
- 장기 데이터 보관

## 📝 Uptime Kuma 주요 기능

### 모니터 타입
- **HTTP(S)**: 웹사이트, API 체크
- **TCP Port**: 포트 가용성 체크
- **Ping**: ICMP ping
- **DNS**: DNS 조회
- **MongoDB**: MongoDB 연결 체크
- **Keyword**: 페이지에 특정 키워드 존재 확인

### 알림 채널 (60+)
**메신저**:
- Slack, Discord, Telegram, Microsoft Teams
- Mattermost, Rocket.Chat
- Signal, LINE, WeChat

**이메일**:
- SMTP, Gmail, Outlook
- SendGrid, Mailgun

**인시던트 관리**:
- PagerDuty, Opsgenie
- Pushover, Pushbullet

**기타**:
- Webhook, Custom
- Gotify, Apprise

### 상태 페이지
- 공개/비공개 설정
- 커스텀 도메인
- 다크/라이트 테마
- 사건 타임라인
- 가동률 통계

## 📝 프로덕션 배포 시 고려사항

### 보안
1. **인증 필수**: 관리자 계정 설정
2. **HTTPS**: 리버스 프록시로 SSL/TLS
3. **상태 페이지 접근 제어**: Public/Private 설정
4. **API 키 보호**: 환경변수로 관리

### 성능
1. **체크 간격**: 필요에 따라 조정 (기본: 60초)
2. **데이터 보관**: 오래된 데이터 정리
3. **동시 체크**: 많은 모니터 사용 시 간격 분산

### 백업
1. **데이터베이스**: SQLite 파일 정기 백업
2. **설정**: 모니터/알림 설정 export

### 고가용성
1. **데이터 영속성**: 볼륨 마운트
2. **Restart 정책**: always
3. **헬스 체크**: Docker health check

## 🔧 모니터 설정 예시

### 웹사이트 모니터링
```yaml
Name: My Website
Type: HTTP(S)
URL: https://example.com
Method: GET
Expected Status Codes: 200-299
Check Interval: 60s
Retries: 3
```

### API Health Check
```yaml
Name: API Health
Type: HTTP(S)
URL: https://api.example.com/health
Method: GET
Expected Status Codes: 200
Check Interval: 30s
Keyword: "healthy"
```

### SSL 인증서 모니터링
```yaml
Name: SSL Certificate
Type: HTTP(S)
URL: https://example.com
Certificate Expiry: Enable
Alert Days Before: 14
```

## 🔧 트러블슈팅

### 일반적인 문제

**Q: 모니터가 Down으로 표시됨**
```bash
# 로그 확인
docker compose logs -f uptime-kuma

# 네트워크 연결 확인
docker compose exec uptime-kuma ping example.com

# DNS 확인
docker compose exec uptime-kuma nslookup example.com
```

**Q: 알림이 오지 않음**
- 알림 채널 설정 확인
- 테스트 알림 전송 시도
- 로그에서 에러 확인

**Q: 데이터가 사라짐**
- 볼륨 마운트 확인
- SQLite 파일 경로 확인

## 📚 추가 리소스

### Uptime Kuma
- 공식 사이트: https://uptime.kuma.pet/
- GitHub: https://github.com/louislam/uptime-kuma
- Demo: https://demo.uptime.kuma.pet/
- Docker Hub: https://hub.docker.com/r/louislam/uptime-kuma

### 대안 솔루션
- **Upptime**: GitHub Actions 기반 (무료)
- **Prometheus + Grafana**: 엔터프라이즈급
- **Pingdom**: 상용 SaaS
- **StatusCake**: 상용 SaaS

---

**카테고리 생성일**: 2025-11-27 (Phase 14)
**프로젝트 상태**: 준비 중
**예상 완료**: Phase 14 완료 시
