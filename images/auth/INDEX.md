# Auth (인증 및 보안)

인증, 인가, ID 관리 시스템 - 보안 및 액세스 제어

## 📚 프로젝트 목록 (2개)

### [Home Assistant](home-assistant/)
**오픈소스 홈 자동화 플랫폼**
- IoT 기기 통합
- 자동화 규칙 설정
- 사용자 인증 시스템
- Python 기반

### [Ory Kratos](kratos/)
**클라우드 네이티브 ID 및 사용자 관리**
- 헤드리스 인증 시스템
- 다중 인증 방식 지원
- Self-service 계정 관리
- API 우선 설계
- Go 기반

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/auth/kratos

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# Kratos 상태 확인
curl http://localhost:4433/health/ready
```

## 📖 공통 기능

- ✅ 사용자 인증
- ✅ 세션 관리
- ✅ 비밀번호 보안
- ✅ 다중 인증 (MFA)
- ✅ API 통합

## 🔗 관련 카테고리

- [CMS](../cms/) - 사용자 관리 통합
- [Community](../community/) - 포럼 인증
- [Infrastructure](../infrastructure/) - 보안 인프라

## 📝 참고사항

### ID 관리
- **Ory Kratos** - 현대적인 헤드리스 인증, API 우선

### 홈 자동화
- **Home Assistant** - IoT 통합 및 자동화, 인증 시스템 내장

### 프로덕션 배포 시
1. HTTPS 필수 (인증 정보 보호)
2. 강력한 비밀번호 정책 적용
3. MFA 활성화 권장
4. 세션 타임아웃 설정
5. 보안 감사 로그 활성화
6. 정기 보안 업데이트
