# Database (데이터베이스 & 캐시)

데이터베이스 및 캐싱 솔루션 - 데이터 저장 및 성능 최적화

## 📚 프로젝트 목록 (5개)

### [MariaDB](mariadb/)
**MySQL 호환 오픈소스 RDBMS**
- MySQL 드롭인 대체
- 향상된 성능 및 기능
- 커뮤니티 주도 개발
- Standalone 구성 제공

### [Memcached](memcached/)
**고성능 분산 메모리 캐싱**
- 인메모리 키-값 저장소
- 빠른 데이터 접근
- 수평 확장 가능
- 간단한 프로토콜

### [PostgreSQL Extensions](postgres-exts/)
**확장 기능이 포함된 PostgreSQL**
- PostGIS, TimescaleDB 등
- 다양한 확장 모듈
- 커스텀 빌드 이미지
- CI/CD 통합

### [Redis](redis/)
**인메모리 데이터 구조 저장소**
- 다양한 자료구조 지원
- Pub/Sub 메시징
- 영구 저장 옵션
- 클러스터링 지원

### [Berkeley DB](berkely-db/)
**Berkeley DB 빌드 이미지**
- 버전 4.8.30.NC / 5.3.28.NC
- Bitcoin Core 지갑 빌드 의존성
- 빌드 전용 (compose 미사용)

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/database/postgres-exts

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 데이터베이스 접속 확인
docker compose exec db psql -U postgres
```

## 📖 공통 기능

- ✅ 데이터 영구 저장 (볼륨)
- ✅ 백업/복원 지원
- ✅ 레플리케이션
- ✅ 성능 모니터링
- ✅ 보안 설정

## 🔗 관련 카테고리

- [CMS](../cms/) - 데이터베이스 사용 CMS
- [Community](../community/) - 포럼 플랫폼
- [Infrastructure](../infrastructure/) - 인프라 서비스

## 📝 참고사항

### RDBMS
- **MariaDB** - 범용 관계형 DB, MySQL 호환
- **PostgreSQL** - 확장 기능 강화 버전

### 캐시/인메모리
- **Redis** - 다목적 인메모리 저장소
- **Memcached** - 순수 캐싱 전용

### 프로덕션 배포 시
1. 데이터 볼륨 백업 전략 수립
2. 적절한 메모리/CPU 리소스 할당
3. 보안: 강력한 비밀번호 설정
4. 모니터링: 성능 메트릭 수집
5. 레플리케이션: 고가용성 구성
