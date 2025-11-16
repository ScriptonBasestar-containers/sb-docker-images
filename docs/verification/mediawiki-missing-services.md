# MediaWiki - Missing Database and Cache Services

## 문제 요약
MediaWiki compose.yml에 MariaDB와 Redis 서비스 정의가 누락됨

## 발견 일시
- 2025-11-16

## 에러 내용
```
service "mediawiki" depends on undefined service "redis": invalid compose project
```

## 원인 분석
compose.yml에 mediawiki 서비스가 다음을 의존하지만 정의되지 않음:
- `mariadb` (데이터베이스)
- `redis` (캐시)

## 현재 상태
- MediaWiki 서비스: ✅ 정의됨
- MariaDB 서비스: ❌ 누락
- Redis 서비스: ❌ 누락

## 필요한 수정 사항

동일한 MariaDB/Redis 구성 필요 (WordPress와 유사)

## 포트 충돌 확인
- MediaWiki 포트: 8080 (충돌 가능성)
- **권장**: 8086으로 변경

## 참고
- Wikipedia에서 사용하는 공식 위키 엔진
- PHP 기반 애플리케이션
