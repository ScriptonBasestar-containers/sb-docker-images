# Answer - Q&A Platform

오픈소스 Q&A 커뮤니티 플랫폼 (Stack Overflow 대안)

## Features

- 질문 & 답변 시스템
- 투표 및 베스트 답변 선택
- 태그 기반 분류
- 사용자 평판 시스템 (Reputation)
- 검색 및 필터링
- 마크다운 에디터
- 알림 시스템
- 다국어 지원 (한국어 포함)
- Apache Software Foundation 프로젝트
- Self-hosted (데이터 완전 통제)

## Quick Start

```bash
# 환경변수 설정
cp .env.example .env
vim .env

# 서비스 시작
docker compose up -d

# 로그 확인
docker compose logs -f

# 웹 UI 접속 및 설치
open http://localhost:8400/install
```

## Installation Wizard

첫 접속 시 http://localhost:8400/install로 이동하여 설치 진행:

### Step 1: Database Configuration

```
Database Type: PostgreSQL
Host: postgres
Port: 5432
Database: answer (또는 .env의 POSTGRES_DB 값)
Username: answer (또는 .env의 POSTGRES_USER 값)
Password: changeme (또는 .env의 POSTGRES_PASSWORD 값)
```

### Step 2: Site Configuration

- **Site Name**: 커뮤니티 이름
- **Site URL**: http://localhost:8400 (프로덕션: 실제 도메인)
- **Contact Email**: 관리자 이메일
- **Language**: 한국어 선택 가능

### Step 3: Admin Account

- **Username**: 관리자 사용자명
- **Email**: 관리자 이메일
- **Password**: 관리자 비밀번호 (8자 이상)

### Step 4: Complete

설치 완료 후 http://localhost:8400로 이동하여 로그인

## Configuration

### 환경변수 (.env)

주요 설정 항목:

```bash
# Application
ANSWER_VERSION=latest
WEB_PORT=8400

# Database
POSTGRES_VERSION=16-alpine
POSTGRES_DB=answer
POSTGRES_USER=answer
POSTGRES_PASSWORD=changeme  # SECURITY: 변경 필수!
```

## Ports

- `8400`: Answer Web UI (기본값, WEB_PORT로 변경 가능)
- `5432`: PostgreSQL (내부 네트워크, 외부 노출 안 됨)

## Volumes

- `answer-data`: Answer 애플리케이션 데이터 및 업로드 파일
- `postgres-data`: PostgreSQL 데이터베이스

## Using Answer

### 질문 작성

1. **Ask Question** 클릭
2. 제목 입력 (명확하고 구체적으로)
3. 내용 작성 (마크다운 지원)
4. 태그 추가 (최대 5개)
5. **Post Question** 클릭

### 답변 작성

1. 질문 페이지 접속
2. 답변 작성 (마크다운 지원)
3. **Post Answer** 클릭
4. 다른 사용자가 투표 및 베스트 답변 선택

### 태그 관리

Admin → Tags:
- 새 태그 생성
- 태그 설명 추가
- 태그 병합/삭제
- 태그별 권한 설정

### 사용자 평판 시스템

활동에 따라 평판(Reputation) 획득:
- **질문 작성**: +5
- **답변 작성**: +10
- **답변이 채택됨**: +15
- **업보트 받음**: +10
- **다운보트 받음**: -2

평판에 따른 권한 확대:
- 50: 댓글 작성
- 100: 다운보트
- 500: 태그 생성
- 1000: 편집 권한

## Admin Settings

Admin → Settings:

### General

- **Site Information**: 이름, URL, 설명
- **Interface**: 로고, 파비콘
- **Language**: 기본 언어 설정

### Users

- 사용자 관리
- 역할 및 권한 설정
- 사용자 정지/차단

### Content

- 질문 & 답변 설정
- 태그 설정
- 에디터 설정 (마크다운 옵션)

### Email

SMTP 설정:
```
SMTP Host: smtp.gmail.com
SMTP Port: 587
Username: your-email@gmail.com
Password: your-app-password
From Email: noreply@example.com
```

### Customize

- CSS 커스터마이징
- 헤더/푸터 수정
- 사이드바 위젯

## Deployment Options

### Development (현재 구성)
- PostgreSQL database
- Single container
- 빠른 시작

### Production

프로덕션 배포 시 고려사항:

1. **HTTPS 설정** (Nginx/Traefik 리버스 프록시):
   ```nginx
   server {
       listen 443 ssl http2;
       server_name qa.example.com;

       location / {
           proxy_pass http://localhost:8400;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```

2. **Site URL 업데이트**:
   Admin → Settings → General → Site URL:
   ```
   https://qa.example.com
   ```

3. **백업 설정**:
   ```bash
   # PostgreSQL 백업
   docker compose exec postgres pg_dump -U answer answer \
     > answer-db-backup-$(date +%Y%m%d).sql

   # 애플리케이션 데이터 백업
   docker run --rm \
     -v answer_answer-data:/data \
     -v $(pwd):/backup \
     alpine tar czf /backup/answer-data-$(date +%Y%m%d).tar.gz /data
   ```

4. **리소스 제한**:
   ```yaml
   # compose.yml에 추가
   answer:
     deploy:
       resources:
         limits:
           memory: 1G
         reservations:
           memory: 512M
   ```

## Advanced Features

### API Access

Answer provides RESTful API:
- Admin → Settings → API
- Generate API key
- Documentation: https://answer.apache.org/docs/api

### Plugins

Answer supports plugins for extended functionality:
- Admin → Plugins
- Install community plugins
- Configure plugin settings

### Markdown Extensions

지원하는 마크다운 기능:
- 코드 하이라이팅
- 테이블
- 이미지 업로드
- 수식 (LaTeX)
- 인용문
- 리스트

### Search

강력한 검색 기능:
- 키워드 검색
- 태그 필터
- 사용자 필터
- 날짜 범위
- 정렬 (관련성, 날짜, 투표)

## Troubleshooting

### Installation wizard가 표시되지 않음

```bash
# 로그 확인
docker compose logs -f answer

# 컨테이너 재시작
docker compose restart answer

# http://localhost:8400/install 직접 접속
```

### 데이터베이스 연결 실패

설치 시 데이터베이스 설정 확인:
```
Host: postgres (서비스명, localhost 아님!)
Port: 5432
Database: .env 파일의 POSTGRES_DB 값과 일치
Username: .env 파일의 POSTGRES_USER 값과 일치
Password: .env 파일의 POSTGRES_PASSWORD 값과 일치
```

PostgreSQL 상태 확인:
```bash
docker compose ps postgres
docker compose logs postgres
```

### "Permission denied" 에러

볼륨 권한 확인:
```bash
docker compose exec answer ls -la /data
```

### 이미지 업로드 실패

파일 크기 제한 확인:
- Admin → Settings → Content → Upload
- Max file size 증가

스토리지 공간 확인:
```bash
df -h
```

### 이메일 발송 실패

SMTP 설정 확인:
- Admin → Settings → Email
- "Test SMTP" 클릭
- 로그에서 에러 메시지 확인

```bash
docker compose logs -f answer | grep -i smtp
```

## Maintenance

### 업그레이드

```bash
# 백업 먼저!
# PostgreSQL 백업
docker compose exec postgres pg_dump -U answer answer > backup.sql

# 최신 이미지 다운로드
docker compose pull

# 컨테이너 재생성
docker compose up -d

# 로그 확인
docker compose logs -f answer
```

### 백업

```bash
# PostgreSQL 백업
docker compose exec postgres pg_dump -U answer answer \
  > answer-backup-$(date +%Y%m%d).sql

# 애플리케이션 데이터 백업
docker run --rm \
  -v answer_answer-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/answer-app-$(date +%Y%m%d).tar.gz /data
```

### 복원

```bash
# PostgreSQL 복원
docker compose down
docker compose up -d postgres
sleep 10
docker compose exec -T postgres psql -U answer answer < backup.sql
docker compose up -d answer

# 애플리케이션 데이터 복원
docker run --rm \
  -v answer_answer-data:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/answer-app-20250127.tar.gz -C /
```

## Best Practices

### 커뮤니티 관리

1. **가이드라인 설정**: 명확한 커뮤니티 규칙
2. **태그 구조화**: 일관된 태그 네이밍
3. **모더레이션**: 활발한 콘텐츠 관리
4. **사용자 인센티브**: 배지 및 평판 시스템 활용

### 콘텐츠 품질

1. **질문 가이드**: 좋은 질문 작성 팁 제공
2. **답변 품질**: 베스트 답변 장려
3. **중복 방지**: 검색 및 유사 질문 추천
4. **태그 관리**: 정기적인 태그 정리

### SEO 최적화

1. **명확한 제목**: 검색 친화적인 질문 제목
2. **태그 활용**: 관련 키워드로 태그 설정
3. **메타 설정**: Admin → Settings → SEO
4. **사이트맵**: 자동 생성됨

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

- **Official Site**: https://answer.apache.org/
- **Documentation**: https://answer.apache.org/docs
- **Docker Hub**: https://hub.docker.com/r/apache/answer
- **GitHub**: https://github.com/apache/incubator-answer
- **Community**: https://meta.answer.dev/

## License

Answer is licensed under Apache License 2.0.
See: https://github.com/apache/incubator-answer/blob/main/LICENSE

---

**Version**: 1.0.0
**Port**: 8400
**Category**: community
**Phase**: 14
