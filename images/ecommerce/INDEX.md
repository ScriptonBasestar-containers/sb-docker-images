# E-commerce (전자상거래)

오픈소스 전자상거래 플랫폼 - 온라인 쇼핑몰 구축

## 📚 프로젝트 목록 (2개)

### [Solidus](solidus/)
**Ruby on Rails 기반 전자상거래 플랫폼**
- Spree에서 파생된 커뮤니티 주도 프로젝트
- 유연한 아키텍처
- 확장 가능한 구조
- API 우선 설계
- Rails 기반

### [Spree](spree/)
**오픈소스 전자상거래 솔루션**
- Ruby on Rails 기반
- 모듈식 구조
- 다국어/다통화 지원
- 풍부한 확장 기능
- 커뮤니티 에코시스템

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/ecommerce/solidus

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 샘플 데이터 로드 (선택)
docker compose exec web bundle exec rake db:seed
```

## 📖 공통 기능

- ✅ 제품 관리
- ✅ 주문 처리
- ✅ 결제 게이트웨이 통합
- ✅ 재고 관리
- ✅ 프로모션/할인
- ✅ 배송 관리
- ✅ 다국어/다통화 지원

## 🔗 관련 카테고리

- [CMS](../cms/) - 컨텐츠 관리
- [Database](../database/) - 데이터베이스
- [Infrastructure](../infrastructure/) - 스토리지 통합

## 📝 참고사항

### Ruby on Rails 기반
- **Solidus** - 커뮤니티 주도, 최신 Rails 사용
- **Spree** - 원조 플랫폼, 성숙한 에코시스템

### 주요 차이점
- Solidus: Spree에서 포크, 더 현대적인 접근
- Spree: 더 오래된 역사, 광범위한 확장 라이브러리

### 프로덕션 배포 시
1. **보안**: PCI DSS 준수 (결제 정보 처리)
2. **성능**: 캐싱 (Redis) 및 CDN 활용
3. **백업**: 주문/고객 데이터 정기 백업
4. **결제**: 신뢰할 수 있는 결제 게이트웨이 연동
5. **모니터링**: 주문 처리 및 결제 에러 추적
6. **확장**: 트래픽 증가 대비 수평 확장 계획
