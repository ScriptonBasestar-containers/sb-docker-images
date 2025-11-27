# Metabase - Business Intelligence and Analytics

오픈소스 BI 및 데이터 분석 플랫폼

## Features

- 직관적인 쿼리 빌더 (No SQL required)
- 대시보드 및 시각화 (차트, 그래프, 테이블)
- 다양한 데이터베이스 지원 (MySQL, PostgreSQL, MongoDB, BigQuery 등)
- SQL 에디터 (고급 사용자용)
- 자동 질문 생성 (X-ray 기능)
- 이메일 및 Slack 알림
- 임베딩 지원 (대시보드를 다른 앱에 삽입)
- 사용자 권한 관리
- Self-hosted (데이터 완전 통제)

## Quick Start

```bash
# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인 (초기화 진행 상황 확인)
docker compose logs -f metabase

# 웹 UI 접속 (초기화 완료 후)
open http://localhost:3020
```

**Note**: 첫 시작 시 데이터베이스 초기화에 1-2분 소요됩니다.

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
METABASE_VERSION=latest
WEB_PORT=3020

# Database (Metabase metadata storage)
POSTGRES_VERSION=16-alpine
POSTGRES_DB=metabase
POSTGRES_USER=metabase
POSTGRES_PASSWORD=changeme  # SECURITY: 변경 필수!
```

### 초기 설정

첫 접속 시 Setup Wizard 진행:

1. http://localhost:3020 접속
2. Setup 화면:
   - **Language**: 한국어 선택 가능
   - **Account**: 관리자 계정 생성
   - **Database**: 분석할 데이터베이스 연결 (선택사항, 나중에 추가 가능)
   - **Preferences**: 사용 통계 수집 여부
3. 설정 완료 후 Metabase 대시보드로 이동

## Ports

- `3020`: Metabase Web UI (기본값, WEB_PORT로 변경 가능)
- `5432`: PostgreSQL (내부 네트워크, 외부 노출 안 됨)

## Volumes

- `metabase-data`: Metabase 애플리케이션 데이터
- `postgres-data`: PostgreSQL 메타데이터 저장소

## Connecting Data Sources

Metabase는 다양한 데이터베이스를 데이터 소스로 연결할 수 있습니다:

### 지원 데이터베이스

- **SQL Databases**: PostgreSQL, MySQL, MariaDB, SQL Server, Oracle
- **Cloud Databases**: Amazon Redshift, Google BigQuery, Snowflake
- **NoSQL**: MongoDB, DynamoDB
- **Others**: SQLite, H2, Presto, Druid

### 데이터베이스 연결

Admin → Databases → Add Database:

1. **Database type** 선택
2. **Connection details** 입력:
   - Host
   - Port
   - Database name
   - Username/Password
3. **Save** 클릭
4. 연결 테스트 및 스키마 스캔

### 예시: PostgreSQL 연결

```
Type: PostgreSQL
Name: Production DB
Host: postgres.example.com
Port: 5432
Database: production
Username: readonly_user
Password: ********
```

## Creating Questions and Dashboards

### Question (쿼리) 생성

1. **New → Question**
2. 방법 선택:
   - **Simple Question**: GUI 쿼리 빌더
   - **Custom Question**: SQL 에디터
   - **Native Query**: 데이터베이스별 쿼리
3. 데이터 선택 및 필터링
4. 시각화 선택 (테이블, 차트, 그래프 등)
5. 저장

### Dashboard 생성

1. **New → Dashboard**
2. 제목 및 설명 입력
3. **Add a Question** 클릭
4. 기존 Question 선택 또는 새로 생성
5. 위치 및 크기 조정
6. 필터 추가 (선택사항)
7. **Save**

### 시각화 타입

- **Number**: 단일 숫자
- **Trend**: 시간별 추세
- **Bar/Line/Area Chart**: 차트
- **Pie/Donut Chart**: 비율
- **Table**: 테이블
- **Map**: 지도 (위치 데이터)
- **Funnel**: 단계별 전환율
- **Gauge**: 게이지

## Advanced Features

### X-ray (자동 분석)

테이블 또는 필드를 자동으로 분석:

1. 테이블 클릭
2. **X-ray** 버튼 클릭
3. Metabase가 자동으로 인사이트 생성
4. 유용한 인사이트를 Dashboard에 추가

### SQL Editor

고급 쿼리 작성:

1. **New → SQL Query**
2. 데이터베이스 선택
3. SQL 쿼리 작성
4. **Run** 클릭
5. 결과를 시각화로 변환

### Filters and Parameters

동적 대시보드 생성:

1. Dashboard 편집
2. **Add a Filter** 클릭
3. 필터 타입 선택 (Date, Number, Text 등)
4. Question과 연결
5. 사용자가 필터를 조정하여 데이터 탐색

### Alerts

데이터 변화 시 알림:

1. Question에서 **Alert** 아이콘 클릭
2. 알림 조건 설정
3. 알림 방법 선택 (Email, Slack)
4. 수신자 지정
5. **Done**

## Deployment Options

### Development (현재 구성)
- PostgreSQL metadata storage
- Single container
- 빠른 시작

### Production

프로덕션 배포 시 고려사항:

1. **HTTPS 설정** (Nginx/Traefik 리버스 프록시):
   ```nginx
   server {
       listen 443 ssl http2;
       server_name analytics.example.com;

       location / {
           proxy_pass http://localhost:3020;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

2. **리소스 제한**:
   ```yaml
   # compose.yml에 추가
   metabase:
     deploy:
       resources:
         limits:
           memory: 2G
         reservations:
           memory: 1G
   ```

3. **백업 설정**:
   ```bash
   # PostgreSQL 백업 (메타데이터)
   docker compose exec postgres pg_dump -U metabase metabase \
     > metabase-backup-$(date +%Y%m%d).sql

   # 애플리케이션 데이터 백업
   docker run --rm \
     -v metabase_metabase-data:/data \
     -v $(pwd):/backup \
     alpine tar czf /backup/metabase-data-$(date +%Y%m%d).tar.gz /data
   ```

4. **환경변수 설정**:
   ```bash
   # .env 파일
   MB_SITE_NAME=Company Analytics
   MB_SITE_URL=https://analytics.example.com
   JAVA_OPTS=-Xmx2g -Xms512m
   ```

## Email Configuration

SMTP 설정 (.env 파일):

```bash
MB_EMAIL_SMTP_HOST=smtp.gmail.com
MB_EMAIL_SMTP_PORT=587
MB_EMAIL_SMTP_SECURITY=tls
MB_EMAIL_SMTP_USERNAME=your-email@gmail.com
MB_EMAIL_SMTP_PASSWORD=your-app-password
MB_EMAIL_FROM_ADDRESS=analytics@example.com
```

이메일 기능:
- Question/Dashboard 공유
- 정기 리포트 발송
- 알림 (Alert) 전송

## Embedding

대시보드를 다른 애플리케이션에 임베드:

1. **Admin → Settings → Embedding**
2. **Enable** 클릭
3. **Embedding secret key** 생성:
   ```bash
   openssl rand -base64 32
   ```
4. Dashboard에서 **Sharing** → **Embed** 클릭
5. iframe 코드 복사 또는 JWT 토큰 생성

### 임베딩 타입

- **Public**: 인증 없이 누구나 접근
- **Signed**: JWT 토큰으로 보안 임베딩

## Troubleshooting

### 컨테이너가 시작되지 않음

```bash
# 로그 확인
docker compose logs -f metabase

# PostgreSQL 연결 확인
docker compose exec postgres psql -U metabase -d metabase
```

### "Unable to connect to Metabase database"

데이터베이스 초기화 대기:

```bash
# PostgreSQL health check 확인
docker compose ps postgres

# 로그에서 "Metabase Initialization COMPLETE" 확인
docker compose logs metabase | grep -i "initialization complete"
```

### 데이터 소스 연결 실패

**호스트 확인**:
- Docker 네트워크 내부: 서비스명 사용 (`postgres`, `mysql`)
- 외부 데이터베이스: IP 또는 도메인

**방화벽**:
- 데이터베이스 포트가 열려있는지 확인

**권한**:
- 읽기 전용 사용자 권장
- 필요한 테이블/스키마에 대한 SELECT 권한

### 느린 성능

**Java 메모리 증가**:
```bash
JAVA_OPTS=-Xmx4g -Xms1g
```

**쿼리 최적화**:
- 인덱스 추가
- 필터 사용
- 불필요한 데이터 제외

**캐싱**:
- Admin → Caching → Enable caching
- Cache TTL 설정

## Maintenance

### 업그레이드

```bash
# 최신 이미지 다운로드
docker compose pull

# 컨테이너 재생성
docker compose up -d

# 로그 확인
docker compose logs -f metabase
```

**Important**: 메이저 버전 업그레이드 시 백업 필수!

### 백업

```bash
# PostgreSQL 메타데이터 백업
docker compose exec postgres pg_dump -U metabase metabase \
  > metabase-metadata-$(date +%Y%m%d).sql

# 애플리케이션 데이터 백업
docker run --rm \
  -v metabase_metabase-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/metabase-app-$(date +%Y%m%d).tar.gz /data
```

### 복원

```bash
# PostgreSQL 복원
docker compose down
docker compose up -d postgres
sleep 10
docker compose exec -T postgres psql -U metabase metabase \
  < metabase-metadata-20250127.sql
docker compose up -d metabase

# 애플리케이션 데이터 복원
docker run --rm \
  -v metabase_metabase-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/metabase-app-20250127.tar.gz -C /
```

## Security Best Practices

1. **HTTPS 필수**: 프로덕션 환경에서는 반드시 HTTPS 사용
2. **강력한 비밀번호**: 데이터베이스 및 관리자 계정
3. **읽기 전용 DB 사용자**: 분석용 데이터베이스 연결 시
4. **정기 백업**: 메타데이터 및 애플리케이션 데이터
5. **접근 제어**: 필요한 사용자에게만 권한 부여
6. **보안 임베딩**: Signed embedding 사용

## Makefile Commands

```bash
make help      # 사용 가능한 명령어 목록
make up        # 서비스 시작
make down      # 서비스 중지
make logs      # 로그 확인
make restart   # 서비스 재시작
make ps        # 컨테이너 상태 확인
make clean     # 모든 리소스 제거 (주의!)
```

## References

- **Official Site**: https://www.metabase.com/
- **Documentation**: https://www.metabase.com/docs/latest/
- **Docker Hub**: https://hub.docker.com/r/metabase/metabase
- **GitHub**: https://github.com/metabase/metabase
- **Community**: https://discourse.metabase.com/

## License

Metabase is licensed under AGPL License.
See: https://github.com/metabase/metabase/blob/master/LICENSE.txt

---

**Version**: 1.0.0
**Port**: 3020
**Category**: analytics
**Phase**: 14
