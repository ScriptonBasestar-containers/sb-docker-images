# Automation (워크플로우 자동화)

워크플로우 자동화 및 통합 도구 - No-code/Low-code 자동화 플랫폼

## 📚 프로젝트 목록 (준비 중)

### [n8n](n8n/) 🚧 **Coming Soon**
**Workflow Automation Platform (Zapier/Make 대안)**
- 노코드 워크플로우 자동화
- 200+ 서비스 통합 (API, Database, Cloud)
- 비주얼 워크플로우 빌더
- 셀프호스트 가능
- Port: 5678

## 🎯 카테고리 특징

### 주요 기능
- **시각적 워크플로우**: 드래그 앤 드롭으로 자동화 구축
- **다양한 통합**: API, 데이터베이스, 클라우드 서비스 연결
- **스케줄링**: Cron 기반 작업 스케줄링
- **조건 분기**: If/Else, Switch 등 로직 구성
- **에러 핸들링**: 재시도, 에러 알림
- **데이터 변환**: JSON, XML, CSV 처리

### 사용 사례
- **DevOps 자동화**: CI/CD 통합, 알림, 모니터링
- **데이터 동기화**: DB → Spreadsheet, API → Database
- **알림 자동화**: Slack, Discord, Email 알림
- **백업 자동화**: 정기적 데이터 백업
- **보고서 생성**: 데이터 수집 → 분석 → 리포트

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/automation/n8n

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# 웹 UI 접속
open http://localhost:5678
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

- [DevTools](../devtools/) - 개발 도구
- [Infrastructure](../infrastructure/) - 인프라 서비스
- [Monitoring](../monitoring/) - 모니터링 도구

## 🆚 비교: Automation Platforms

| 기능 | n8n | Zapier | Make (Integromat) |
|------|-----|--------|-------------------|
| Self-hosted | ✅ | ❌ | ❌ |
| 오픈소스 | ✅ | ❌ | ❌ |
| 무료 | ✅ | ⭐ | ⭐ |
| 통합 수 | 200+ | 5000+ | 1000+ |
| 시각적 편집 | ✅ | ✅ | ✅ |
| 코드 지원 | ✅ (JavaScript) | ❌ | ⭐ |
| 데이터 프라이버시 | ⭐⭐⭐ | ⭐ | ⭐ |
| 복잡한 워크플로우 | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ |

### n8n 추천 대상
- 데이터 프라이버시 중요
- 복잡한 워크플로우 필요
- 코드 커스터마이징 필요
- 셀프호스트 선호
- 무제한 워크플로우 실행

### Zapier/Make 추천 대상
- 빠른 시작 필요
- 클라우드 서비스 선호
- 간단한 워크플로우
- 관리 부담 최소화

## 📝 n8n 주요 통합

### DevOps & Development
- GitHub, GitLab, Bitbucket
- Jira, Linear, Asana
- Slack, Discord, Microsoft Teams
- Jenkins, CircleCI

### Database & Storage
- PostgreSQL, MySQL, MongoDB
- Redis, Elasticsearch
- Google Sheets, Airtable
- AWS S3, Dropbox, Google Drive

### Cloud & API
- AWS (Lambda, S3, DynamoDB)
- Google Cloud, Azure
- HTTP Request, Webhook
- GraphQL, REST API

### Productivity
- Gmail, Outlook
- Notion, Trello
- Calendly, Google Calendar

## 📝 프로덕션 배포 시 고려사항

### 보안
1. **인증 설정**: Basic Auth 또는 외부 인증 (OAuth)
2. **HTTPS 필수**: 리버스 프록시로 SSL/TLS
3. **환경변수 보호**: 민감한 정보는 Secret으로 관리
4. **Webhook 보안**: Webhook URL 보호

### 성능
1. **Queue Mode**: 대규모 워크플로우 처리 시 활성화
2. **Database**: PostgreSQL 사용 권장 (SQLite는 개발 전용)
3. **리소스 할당**: 복잡한 워크플로우는 충분한 메모리 할당

### 백업
1. **워크플로우 백업**: 정기적 export
2. **데이터베이스 백업**: PostgreSQL 백업
3. **자격증명**: 별도 안전하게 보관

### 모니터링
1. **실행 로그**: 워크플로우 실행 이력 모니터링
2. **에러 알림**: 실패 시 Slack/Email 알림 설정
3. **헬스 체크**: /healthz 엔드포인트 활용

## 🔧 트러블슈팅

### 일반적인 문제

**Q: 워크플로우 실행 실패**
```bash
# 로그 확인
docker compose logs -f n8n

# 워크플로우 실행 이력 확인
# n8n UI → Executions 탭
```

**Q: 느린 성능**
- Queue mode 활성화
- PostgreSQL로 전환 (SQLite 사용 중인 경우)
- 메모리 할당 증가

**Q: Webhook이 작동하지 않음**
- Webhook URL이 외부 접근 가능한지 확인
- HTTPS 설정 확인
- 방화벽 설정 확인

## 📚 추가 리소스

### n8n
- 공식 사이트: https://n8n.io/
- 문서: https://docs.n8n.io/
- GitHub: https://github.com/n8n-io/n8n
- Community: https://community.n8n.io/

### 학습 자료
- Workflows: https://n8n.io/workflows/
- Tutorials: https://docs.n8n.io/courses/
- YouTube: n8n official channel

---

**카테고리 생성일**: 2025-11-27 (Phase 14)
**프로젝트 상태**: 준비 중
**예상 완료**: Phase 14 완료 시
