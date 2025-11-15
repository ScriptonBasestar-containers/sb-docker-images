# Minio - S3 Compatible Object Storage

**Minio**는 AWS S3 호환 고성능 오브젝트 스토리지입니다. 클라우드 비용 절감과 데이터 주권 확보를 위한 자체 호스팅 솔루션입니다.

## 주요 기능

- **S3 호환**: AWS S3 API 완전 호환
- **고성능**: Sub-10ms 지연시간
- **경량**: 256MB RAM으로 실행 가능
- **확장성**: 단일 네임스페이스로 엑사바이트 확장
- **Multi-Cloud**: 하이브리드 클라우드 지원
- **Kubernetes Native**: K8s 환경 최적화

## Quick Start

### 1. 서비스 시작

```bash
make up
```

### 2. 웹 콘솔 접속

브라우저에서 http://localhost:9001 접속

**기본 Credentials**:
- Username: `minioadmin`
- Password: `minioadmin`

> **⚠️ 보안 경고**: 프로덕션 환경에서는 반드시 비밀번호를 변경하세요!

### 3. 버킷 생성 (자동)

초기 설정 시 자동으로 3개 버킷 생성:
- `backups` - 백업 데이터
- `media` - 미디어 파일 (공개 읽기)
- `uploads` - 업로드 파일

수동 생성:
```bash
make setup
```

버킷 목록 확인:
```bash
make buckets
```

## 시스템 요구사항

| 항목 | 사양 |
|------|------|
| **메모리** | 256MB 최소, 512MB 권장 |
| **CPU** | 1 코어 |
| **디스크** | 데이터 크기에 따라 가변 |
| **네트워크** | 1Gbps 권장 |

## 포트 설정

| 서비스 | 포트 | 용도 |
|--------|------|------|
| S3 API | 9000 | 오브젝트 스토리지 API |
| Web Console | 9001 | 관리 웹 UI |

## S3 클라이언트 사용

### AWS CLI

#### 1. 설치

```bash
# macOS
brew install awscli

# Ubuntu/Debian
sudo apt install awscli

# Python pip
pip install awscli
```

#### 2. 설정

```bash
aws configure
```

입력:
```
AWS Access Key ID: minioadmin
AWS Secret Access Key: minioadmin
Default region name: us-east-1
Default output format: json
```

#### 3. 사용 예제

```bash
# 버킷 목록
aws --endpoint-url http://localhost:9000 s3 ls

# 파일 업로드
aws --endpoint-url http://localhost:9000 s3 cp file.txt s3://backups/

# 파일 다운로드
aws --endpoint-url http://localhost:9000 s3 cp s3://backups/file.txt .

# 디렉토리 동기화
aws --endpoint-url http://localhost:9000 s3 sync ./local-dir s3://backups/remote-dir

# 파일 삭제
aws --endpoint-url http://localhost:9000 s3 rm s3://backups/file.txt
```

### Minio Client (mc)

#### 1. 설치

```bash
# macOS
brew install minio/stable/mc

# Linux
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/
```

#### 2. Alias 설정

```bash
mc alias set myminio http://localhost:9000 minioadmin minioadmin
```

#### 3. 사용 예제

```bash
# 버킷 목록
mc ls myminio

# 버킷 생성
mc mb myminio/new-bucket

# 파일 업로드
mc cp file.txt myminio/backups/

# 파일 다운로드
mc cp myminio/backups/file.txt .

# 디렉토리 미러링
mc mirror ./local-dir myminio/backups/remote-dir

# 버킷 정책 설정 (공개 읽기)
mc anonymous set download myminio/media

# 파일 공유 링크 생성 (7일)
mc share download myminio/backups/file.txt --expire 7d
```

### Python (boto3)

#### 1. 설치

```bash
pip install boto3
```

#### 2. 사용 예제

```python
import boto3
from botocore.client import Config

# Minio 클라이언트 생성
s3 = boto3.client(
    's3',
    endpoint_url='http://localhost:9000',
    aws_access_key_id='minioadmin',
    aws_secret_access_key='minioadmin',
    config=Config(signature_version='s3v4'),
    region_name='us-east-1'
)

# 버킷 목록
response = s3.list_buckets()
print('Buckets:', [bucket['Name'] for bucket in response['Buckets']])

# 파일 업로드
s3.upload_file('local-file.txt', 'backups', 'remote-file.txt')

# 파일 다운로드
s3.download_file('backups', 'remote-file.txt', 'local-file.txt')

# 파일 목록
response = s3.list_objects_v2(Bucket='backups')
for obj in response.get('Contents', []):
    print(f"{obj['Key']} - {obj['Size']} bytes")

# Presigned URL 생성 (1시간 유효)
url = s3.generate_presigned_url(
    'get_object',
    Params={'Bucket': 'backups', 'Key': 'file.txt'},
    ExpiresIn=3600
)
print(f"Download URL: {url}")
```

## 저장소 서비스 통합

### Nextcloud 통합

#### 1. External Storage 설정

Nextcloud 관리자:
1. Apps → External storage support 활성화
2. Settings → External storages → Add storage
3. 선택: Amazon S3

#### 2. S3 설정

```
Bucket: media
Hostname: minio:9000
Port: 9000
Region: us-east-1
Enable SSL: No
Enable Path Style: Yes
Access Key: minioadmin
Secret Key: minioadmin
```

#### 3. Docker Compose 통합

Nextcloud와 Minio를 같은 네트워크에 연결:

```yaml
# nextcloud/compose.yml
services:
  app:
    networks:
      - nextcloud
      - minio_minio  # Minio 네트워크 추가

networks:
  minio_minio:
    external: true
```

### Gitea 백업

#### 자동 백업 스크립트

`gitea/backup.sh`:

```bash
#!/bin/bash
set -e

BACKUP_DIR="/tmp/gitea-backup"
BUCKET="backups"
DATE=$(date +%Y%m%d-%H%M%S)

# Gitea 데이터 백업
docker exec gitea gitea dump -c /data/gitea/conf/app.ini -f /tmp/gitea-dump-$DATE.zip

# Minio에 업로드
docker cp gitea:/tmp/gitea-dump-$DATE.zip $BACKUP_DIR/
aws --endpoint-url http://localhost:9000 s3 cp $BACKUP_DIR/gitea-dump-$DATE.zip s3://$BUCKET/gitea/

# 정리
rm -f $BACKUP_DIR/gitea-dump-$DATE.zip
docker exec gitea rm -f /tmp/gitea-dump-$DATE.zip

# 30일 이상 된 백업 삭제
aws --endpoint-url http://localhost:9000 s3 ls s3://$BUCKET/gitea/ | \
  while read -r line; do
    createDate=$(echo $line | awk {'print $1" "$2'})
    createDate=$(date -d "$createDate" +%s)
    olderThan=$(date --date "30 days ago" +%s)
    if [[ $createDate -lt $olderThan ]]; then
      fileName=$(echo $line | awk {'print $4'})
      aws --endpoint-url http://localhost:9000 s3 rm s3://$BUCKET/gitea/$fileName
    fi
  done

echo "Backup completed: gitea-dump-$DATE.zip"
```

#### Cron 설정

```bash
# 매일 새벽 2시 백업
0 2 * * * /path/to/gitea/backup.sh >> /var/log/gitea-backup.log 2>&1
```

### WordPress 미디어 오프로드

#### 1. S3 플러그인 설치

WordPress 관리자:
1. Plugins → Add New
2. 검색: "WP Offload Media Lite"
3. 설치 및 활성화

#### 2. wp-config.php 설정

```php
// Minio S3 설정
define('AS3CF_SETTINGS', serialize(array(
    'provider' => 'aws',
    'access-key-id' => 'minioadmin',
    'secret-access-key' => 'minioadmin',
)));

define('AS3CF_BUCKET', 'media');
define('AS3CF_REGION', 'us-east-1');
define('AS3CF_ENDPOINT', 'http://minio:9000');
```

### PostgreSQL 백업

#### pg_dump → Minio

```bash
#!/bin/bash
set -e

DB_CONTAINER="gitea-db"
DB_NAME="gitea"
BUCKET="backups"
DATE=$(date +%Y%m%d-%H%M%S)

# PostgreSQL 덤프
docker exec $DB_CONTAINER pg_dump -U gitea $DB_NAME | gzip > /tmp/pg-dump-$DATE.sql.gz

# Minio 업로드
mc cp /tmp/pg-dump-$DATE.sql.gz myminio/$BUCKET/postgres/

# 정리
rm -f /tmp/pg-dump-$DATE.sql.gz

echo "Database backup completed: pg-dump-$DATE.sql.gz"
```

## 보안 설정

### 1. Credentials 변경

#### compose.yml 수정

```yaml
services:
  minio:
    environment:
      - MINIO_ROOT_USER=your-access-key
      - MINIO_ROOT_PASSWORD=your-secret-key-min-8-chars
```

#### .env 파일 사용 (권장)

`.env`:
```
MINIO_ROOT_USER=your-access-key
MINIO_ROOT_PASSWORD=your-secret-key
```

`compose.yml`:
```yaml
services:
  minio:
    env_file:
      - .env
```

### 2. TLS/HTTPS 설정

#### 자체 서명 인증서 생성

```bash
mkdir -p ./certs

# 인증서 생성
openssl req -new -x509 -nodes -days 365 \
  -keyout ./certs/private.key \
  -out ./certs/public.crt \
  -subj "/C=KR/ST=Seoul/L=Seoul/O=MyOrg/CN=minio.local"
```

#### compose.yml 수정

```yaml
services:
  minio:
    volumes:
      - ./data:/data
      - ./certs:/root/.minio/certs
    ports:
      - "9000:9000"
      - "9001:9001"
```

접속: https://localhost:9000

### 3. 버킷 정책

#### 익명 읽기 허용

```bash
mc anonymous set download myminio/media
```

#### 익명 쓰기 허용 (주의!)

```bash
mc anonymous set upload myminio/uploads
```

#### 정책 제거

```bash
mc anonymous set none myminio/media
```

### 4. 사용자 및 권한 관리

#### 읽기 전용 사용자 생성

```bash
# 사용자 생성
mc admin user add myminio readonly ReadOnlyPassword123

# 읽기 전용 정책 생성
cat > /tmp/readonly-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::backups/*",
        "arn:aws:s3:::backups"
      ]
    }
  ]
}
EOF

# 정책 적용
mc admin policy add myminio readonly-policy /tmp/readonly-policy.json
mc admin policy set myminio readonly-policy user=readonly
```

## 고급 설정

### 멀티노드 분산 모드

#### Docker Compose (2노드)

```yaml
services:
  minio1:
    image: minio/minio:latest
    command: server http://minio{1...2}/data{1...2} --console-address ":9001"
    environment:
      - MINIO_ROOT_USER=minioadmin
      - MINIO_ROOT_PASSWORD=minioadmin
    volumes:
      - ./data1-1:/data1
      - ./data1-2:/data2
    ports:
      - "9000:9000"
      - "9001:9001"
    networks:
      - minio

  minio2:
    image: minio/minio:latest
    command: server http://minio{1...2}/data{1...2}
    environment:
      - MINIO_ROOT_USER=minioadmin
      - MINIO_ROOT_PASSWORD=minioadmin
    volumes:
      - ./data2-1:/data1
      - ./data2-2:/data2
    networks:
      - minio
```

### 버전 관리 (Versioning)

```bash
# 버전 관리 활성화
mc version enable myminio/backups

# 버전 관리 상태 확인
mc version info myminio/backups

# 특정 버전 복원
mc cp --version-id VERSION_ID myminio/backups/file.txt ./file-restored.txt
```

### 라이프사이클 정책

#### 오래된 파일 자동 삭제

```bash
cat > /tmp/lifecycle.json <<EOF
{
  "Rules": [
    {
      "ID": "Delete old backups",
      "Status": "Enabled",
      "Expiration": {
        "Days": 30
      }
    }
  ]
}
EOF

mc ilm import myminio/backups < /tmp/lifecycle.json
```

### 리버스 프록시 (Nginx)

```nginx
upstream minio_s3 {
    server localhost:9000;
}

upstream minio_console {
    server localhost:9001;
}

server {
    listen 80;
    server_name minio.example.com;

    # S3 API
    location / {
        proxy_pass http://minio_s3;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # Large file uploads
        client_max_body_size 1000M;
    }
}

server {
    listen 80;
    server_name minio-console.example.com;

    # Web Console
    location / {
        proxy_pass http://minio_console;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## 모니터링

### 서버 정보

```bash
mc admin info myminio
```

### 서비스 상태

```bash
mc admin service status myminio
```

### 디스크 사용량

```bash
mc du myminio/backups
```

### Prometheus 메트릭

Minio는 `/minio/v2/metrics/cluster` 엔드포인트에서 Prometheus 메트릭 제공:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'minio'
    metrics_path: '/minio/v2/metrics/cluster'
    scheme: 'http'
    static_configs:
      - targets: ['minio:9000']
```

## 데이터 백업

### Minio 데이터 백업

```bash
# 서비스 중지
make down

# 데이터 백업
tar czf minio-backup-$(date +%Y%m%d).tar.gz data/

# 서비스 재시작
make up
```

### Minio 데이터 복원

```bash
make down
tar xzf minio-backup-YYYYMMDD.tar.gz
make up
```

### 원격 백업 (Minio → AWS S3)

```bash
# AWS S3 alias 설정
mc alias set aws-s3 https://s3.amazonaws.com AWS_ACCESS_KEY AWS_SECRET_KEY

# 미러링
mc mirror myminio/backups aws-s3/my-backup-bucket
```

## 문제 해결

### 1. 권한 오류

```bash
# 데이터 디렉토리 권한 수정
sudo chown -R 1000:1000 data/
```

### 2. 포트 충돌

```yaml
# compose.yml에서 포트 변경
ports:
  - "19000:9000"  # S3 API
  - "19001:9001"  # Console
```

### 3. 메모리 부족

```yaml
# compose.yml에 메모리 제한 추가
services:
  minio:
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

### 4. 느린 업로드 속도

```yaml
# compose.yml에 네트워크 설정 추가
networks:
  minio:
    driver: bridge
    driver_opts:
      com.docker.network.driver.mtu: 1500
```

## 성능 최적화

### 1. 대용량 파일 처리

```bash
# 멀티파트 업로드 크기 조정 (기본: 16MB)
mc admin config set myminio api requests_max=1000
```

### 2. 캐시 설정

```yaml
services:
  minio:
    environment:
      - MINIO_CACHE=on
      - MINIO_CACHE_DRIVES=/cache
      - MINIO_CACHE_EXPIRY=90
    volumes:
      - ./cache:/cache
```

### 3. 압축 활성화

```bash
mc admin config set myminio compression enable=on
```

## Makefile 명령어

```bash
make help     # 도움말 표시
make up       # 서비스 시작
make down     # 서비스 중지
make logs     # 로그 확인
make ps       # 컨테이너 상태
make restart  # 서비스 재시작
make test     # compose 파일 검증
make setup    # 버킷 초기 설정
make buckets  # 버킷 목록 확인
make clean    # 모든 데이터 삭제 (주의!)
```

## 참고 자료

### 공식 문서
- [Minio 공식 사이트](https://min.io/)
- [Minio 문서](https://min.io/docs/minio/linux/index.html)
- [S3 API 호환성](https://min.io/docs/minio/linux/integrations/aws-cli-with-minio.html)
- [Kubernetes 배포](https://min.io/docs/minio/kubernetes/upstream/index.html)

### 클라이언트
- [AWS CLI](https://aws.amazon.com/cli/)
- [Minio Client (mc)](https://min.io/docs/minio/linux/reference/minio-mc.html)
- [Python boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

### 통합
- [Nextcloud External Storage](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage_configuration_gui.html)
- [WordPress S3 Plugin](https://wordpress.org/plugins/amazon-s3-and-cloudfront/)
- [Veeam Backup](https://www.veeam.com/kb2691)

## Use Cases

### 개발/테스트
- **S3 API 개발**: AWS S3 대신 로컬 테스트
- **클라우드 마이그레이션**: 사전 검증
- **비용 절감**: 개발 환경 클라우드 비용 제로

### 프로덕션
- **백업 스토리지**: 데이터베이스, 파일 백업
- **미디어 스토리지**: 이미지, 비디오, 오디오
- **정적 자산**: CDN 대체
- **데이터 레이크**: 로그, 분석 데이터

### 하이브리드 클라우드
- **온프레미스 → 클라우드**: 점진적 마이그레이션
- **클라우드 → 온프레미스**: 데이터 주권 확보
- **멀티 클라우드**: 벤더 락인 방지

## 라이선스

Minio는 GNU AGPLv3 라이선스로 배포됩니다. 상업적 라이선스도 제공됩니다.

## 보안 고지

**⚠️ 2025 중요 업데이트**:
- Minio가 source-only 배포로 전환
- 공식 Docker 이미지에 알려진 CVE 존재 가능
- 프로덕션 사용 시 최신 보안 패치 확인 필수

**권장사항**:
- 정기적인 보안 업데이트 확인
- 기본 credentials 즉시 변경
- TLS/HTTPS 활성화
- 방화벽 설정 (9000, 9001 포트)
- 정기적인 백업

## 관련 프로젝트

- **Seaweedfs**: 대안 오브젝트 스토리지
- **Ceph**: 분산 스토리지 시스템
- **OpenIO**: 소프트웨어 정의 스토리지
