# Blockchain (블록체인 플랫폼)

블록체인 노드 및 개발 환경 - 탈중앙화 애플리케이션 개발

## 📚 프로젝트 목록 (3개)

### [Docker Bitcoin](docker-bitcoin/)
**비트코인 풀노드 환경**
- Bitcoin Core 실행
- 블록체인 동기화
- RPC API 제공
- 테스트넷/메인넷 지원

### [Docker Ethereum](docker-ethereum/)
**이더리움 노드 환경**
- Geth/OpenEthereum 지원
- 스마트 컨트랙트 테스트
- JSON-RPC API
- 개발용 네트워크

### [Ignite](ignite/)
**Cosmos SDK 블록체인 개발 도구**
- 블록체인 프로젝트 스캐폴딩
- 빠른 프로토타입 개발
- IBC 프로토콜 지원
- Go 기반 개발

## 🚀 빠른 시작

```bash
# 프로젝트 선택 및 이동
cd images/blockchain/docker-ethereum

# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작 (개발 모드)
docker compose up -d

# 노드 동기화 상태 확인
docker compose exec eth geth attach
```

## 📖 공통 기능

- ✅ 블록체인 노드 실행
- ✅ RPC/API 인터페이스
- ✅ 개발용 네트워크
- ✅ 지갑 관리
- ✅ 스마트 컨트랙트 배포

## 🔗 관련 카테고리

- [Devtools](../devtools/) - 개발 도구
- [Infrastructure](../infrastructure/) - 인프라 서비스
- [Database](../database/) - 데이터 저장

## 📝 참고사항

### 레이어1 블록체인
- **Bitcoin** - 최초의 블록체인, 디지털 화폐
- **Ethereum** - 스마트 컨트랙트 플랫폼

### 블록체인 개발 프레임워크
- **Ignite** - Cosmos SDK 기반 신규 체인 개발

### 프로덕션 배포 시
1. **스토리지**: 충분한 디스크 공간 확보 (메인넷 동기화)
   - Bitcoin: ~500GB+
   - Ethereum: ~1TB+
2. **네트워크**: 안정적인 인터넷 연결
3. **보안**: RPC 포트 접근 제한, 방화벽 설정
4. **백업**: 지갑 키 안전하게 보관
5. **모니터링**: 동기화 상태 및 피어 연결 확인
6. **리소스**: CPU/메모리 충분히 할당
