# Squid Proxy Server

고성능 캐싱 및 포워드 프록시 서버

## 개요

Squid는 웹 객체를 캐싱하고 네트워크 성능을 향상시키는 오픈소스 프록시 서버입니다. HTTP, HTTPS, FTP 프로토콜을 지원하며, 대역폭 절약과 응답 시간 단축에 효과적입니다.

### 주요 기능

- HTTP/HTTPS/FTP 프록시 및 캐싱
- 접근 제어 및 보안
- 대역폭 제한 및 관리
- 다양한 인증 방식 지원
- 계층적 캐싱 구조
- SSL/TLS 지원
- 로깅 및 모니터링

### 사용 사례

- 기업 네트워크 프록시
- 콘텐츠 캐싱 서버
- 웹 필터링 및 보안
- 대역폭 최적화
- 패키지 저장소 캐싱 (apt, yum 등)

## 빠른 시작

### 필수 요구사항

- Docker
- 2GB 이상의 디스크 공간 (캐시용)

### Docker로 실행

```bash
# 기본 실행
docker run --rm -d \
  -p 3128:3128 \
  scriptonbasestar/sb-docker-squid:latest

# 볼륨 마운트하여 실행
docker run --rm -d \
  -v vol_cache:/var/spool/squid \
  -v vol_conf:/etc/squid/conf.d \
  -p 3128:3128 \
  scriptonbasestar/sb-docker-squid:latest
```

### 프록시 설정

클라이언트에서 프록시 설정:

```bash
# 환경 변수로 설정 (Linux/Mac)
export http_proxy=http://localhost:3128
export https_proxy=http://localhost:3128

# wget 사용 예시
wget http://example.com

# curl 사용 예시
curl -x http://localhost:3128 http://example.com
```

## 서비스 구성

### 핵심 컴포넌트

- **Squid Daemon**: 메인 프록시 서버
- **Cache Manager**: 캐시 관리
- **Access Control**: 접근 제어 시스템
- **Log System**: 로그 및 모니터링

### 기반 이미지

- Ubuntu 20.04 (Focal)
- Squid 4.10

## 포트 정보

기본 포트 설정:

| 포트 | 프로토콜 | 서비스 | 설명 |
|------|---------|--------|------|
| 3128 | TCP | HTTP | 기본 프록시 포트 |
| 3129 | TCP | ICP | 캐시 간 통신 (선택) |

## 디렉토리 구조

### 볼륨 디렉토리

| 경로 | 용도 | 설명 |
|------|------|------|
| `/etc/squid/conf.d` | 설정 파일 | 사용자 정의 설정 |
| `/etc/squid/sb-conf.d` | 내부 설정 | 시스템 기본 설정 |
| `/var/spool/squid` | 캐시 디렉토리 | 캐싱된 객체 저장 |
| `/var/log/squid` | 로그 디렉토리 | 접근 및 캐시 로그 |

## 설정

### 기본 설정

이 Docker 이미지는 기본적으로 내부 네트워크 접속을 허용합니다:

```bash
# /etc/squid/sb-conf.d/localnet.conf
http_access allow localnet
```

**주의**: 공식 Squid 설치에는 이 설정이 없지만, 이 컨테이너에는 추가되어 있습니다.

### 커스텀 설정 추가

`/etc/squid/conf.d` 디렉토리에 설정 파일을 추가하면 자동으로 로드됩니다.

예시 - `cache.conf` 파일:

```bash
# 캐시 메모리
cache_mem 1024 MB
minimum_object_size 0 bytes
maximum_object_size_in_memory 512 KB
maximum_object_size 4096 MB

# 캐시 디렉토리
cache_dir ufs /var/spool/squid 5000 16 256

# 캐시 정책
refresh_pattern ^ftp:           1440    20%     10080
refresh_pattern ^gopher:        1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
refresh_pattern .               0       20%     4320
```

### ACL (Access Control List) 설정

접근 제어 예시:

```bash
# 특정 도메인 차단
acl blocked_sites dstdomain .facebook.com .twitter.com
http_access deny blocked_sites

# 특정 IP 허용
acl allowed_ips src 192.168.1.0/24
http_access allow allowed_ips

# 작업 시간대 제한
acl work_hours time MTWHF 09:00-18:00
http_access allow work_hours
http_access deny all
```

### 캐싱 설정

파일 타입별 캐싱:

```bash
# ACL 정의
acl image_files urlpath_regex \.(jpeg|jpg|png|gif|bmp)$
acl archive_files urlpath_regex \.(zip|tar|gz|iso|deb|rpm)$
acl debian_repos dstdomain .debian.org .ubuntu.com

# 캐싱 규칙
cache allow image_files
cache allow archive_files
cache allow debian_repos
cache deny all
```

## 사용법

### 클라이언트 설정

#### Linux/Mac 환경 변수

```bash
# Bash/Zsh 설정 (~/.bashrc 또는 ~/.zshrc)
export http_proxy="http://proxy-server:3128"
export https_proxy="http://proxy-server:3128"
export ftp_proxy="http://proxy-server:3128"
export no_proxy="localhost,127.0.0.1,192.168.0.0/16"
```

#### apt (Debian/Ubuntu)

```bash
# /etc/apt/apt.conf.d/proxy.conf
Acquire::http::Proxy "http://proxy-server:3128";
Acquire::https::Proxy "http://proxy-server:3128";
```

#### yum (CentOS/RHEL)

```bash
# /etc/yum.conf
proxy=http://proxy-server:3128
```

#### Docker 데몬

```json
# /etc/docker/daemon.json
{
  "proxies": {
    "http-proxy": "http://proxy-server:3128",
    "https-proxy": "http://proxy-server:3128",
    "no-proxy": "localhost,127.0.0.1"
  }
}
```

#### 브라우저 설정

Firefox, Chrome 등의 브라우저 설정:

1. 설정 > 네트워크 설정
2. 수동 프록시 구성
3. HTTP 프록시: `proxy-server`, 포트: `3128`

### 캐시 관리

```bash
# 캐시 초기화
docker exec squid-container squid -z

# 캐시 통계 확인
docker exec squid-container squidclient -h localhost mgr:info

# 캐시된 객체 수 확인
docker exec squid-container squidclient -h localhost mgr:storedir
```

## Docker 설정

### docker-compose.yml 예시

```yaml
version: '3.8'

services:
  squid:
    image: scriptonbasestar/sb-docker-squid:latest
    container_name: squid-proxy
    ports:
      - "3128:3128"
    volumes:
      # 캐시 저장소
      - squid-cache:/var/spool/squid
      # 사용자 정의 설정
      - ./config:/etc/squid/conf.d
      # 로그 (선택)
      - ./logs:/var/log/squid
    environment:
      - TZ=Asia/Seoul
    restart: unless-stopped

volumes:
  squid-cache:
    driver: local
```

### Makefile 사용

프로젝트에 포함된 Makefile 사용:

```bash
# 빌드
make build

# 실행
make run

# 캐시 설정 포함 실행
make run-cache
```

## 빌드

### Docker 이미지 빌드

```bash
# 기본 빌드
docker build -t squid:latest .

# 특정 버전
docker build --build-arg SQUID_VERSION=4.10 -t squid:4.10 .
```

## 문제 해결

### 프록시 연결 실패

```bash
# 서비스 상태 확인
docker ps | grep squid

# 로그 확인
docker logs squid-container

# 포트 확인
netstat -tuln | grep 3128
```

### 캐시 공간 부족

```bash
# 캐시 디렉토리 용량 확인
docker exec squid-container du -sh /var/spool/squid

# 캐시 정리
docker exec squid-container squid -k rotate

# 오래된 캐시 삭제
docker exec squid-container squid -k purge
```

### 설정 오류

```bash
# 설정 파일 문법 검사
docker exec squid-container squid -k parse

# 또는
docker exec squid-container squid -k check
```

### 접근 거부 (Access Denied)

ACL 설정 확인:

```bash
# 로그에서 거부된 요청 확인
docker exec squid-container tail -f /var/log/squid/access.log | grep DENIED

# localnet ACL 확인
docker exec squid-container grep -r "localnet" /etc/squid/
```

### 성능 문제

```bash
# 메모리 사용량 확인
docker stats squid-container

# 캐시 히트율 확인
docker exec squid-container squidclient mgr:info | grep "Request Hit Ratios"
```

## 성능 최적화

### 캐시 크기 조정

```bash
# cache.conf 또는 squid.conf
cache_mem 2048 MB
cache_dir ufs /var/spool/squid 10000 16 256
maximum_object_size 8192 MB
```

### 메모리 풀

```bash
memory_pools on
memory_pools_limit 512 MB
```

### 워커 프로세스

```bash
# CPU 코어 수에 맞게 조정
workers 4
```

### DNS 캐싱

```bash
dns_nameservers 8.8.8.8 8.8.4.4
positive_dns_ttl 6 hours
negative_dns_ttl 1 minute
```

## 로그 및 모니터링

### 로그 파일

```bash
# 접근 로그
tail -f /var/log/squid/access.log

# 캐시 로그
tail -f /var/log/squid/cache.log

# 저장 로그
tail -f /var/log/squid/store.log
```

### 통계 조회

```bash
# 일반 정보
squidclient mgr:info

# 캐시 통계
squidclient mgr:mem

# 네트워크 통계
squidclient mgr:ipcache
```

### 로그 로테이션

```bash
# logrotate 설정
/var/log/squid/*.log {
    daily
    rotate 7
    compress
    delaycompress
    notifempty
    sharedscripts
    postrotate
        squid -k rotate
    endscript
}
```

## 보안

### 인증 설정

Basic 인증 예시:

```bash
# htpasswd로 사용자 생성
htpasswd -c /etc/squid/passwords username

# squid.conf 설정
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm Squid Proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
```

### SSL 범핑 (HTTPS 검사)

```bash
# SSL 인증서 생성 (선택)
http_port 3128 ssl-bump cert=/etc/squid/ssl/cert.pem key=/etc/squid/ssl/key.pem

# SSL 범핑 설정
ssl_bump server-first all
sslcrtd_program /usr/lib/squid/security_file_certgen -s /var/spool/squid/ssl_db -M 4MB
```

## 예시 설정

### 패키지 저장소 캐싱

Debian/Ubuntu 패키지 캐싱:

```bash
# APT 캐싱 최적화
refresh_pattern deb$   129600 100% 129600
refresh_pattern udeb$  129600 100% 129600
refresh_pattern tar.gz$  129600 100% 129600
refresh_pattern tar.xz$  129600 100% 129600

acl apt_packages urlpath_regex \.deb$
cache allow apt_packages
```

### Docker 레지스트리 캐싱

```bash
maximum_object_size 1024 MB
cache_dir ufs /var/spool/squid 20000 16 256

refresh_pattern registry.hub.docker.com 10080 95% 43200
```

## 유용한 명령어

```bash
# 서비스 제어
docker exec squid-container squid -k reconfigure  # 설정 리로드
docker exec squid-container squid -k rotate       # 로그 로테이션
docker exec squid-container squid -k shutdown     # 종료
docker exec squid-container squid -k restart      # 재시작

# 캐시 관리
docker exec squid-container squid -z              # 캐시 디렉토리 초기화

# 디버깅
docker exec -it squid-container bash              # 쉘 접속
docker exec squid-container squid -v              # 버전 확인
```

## 참고 자료

- [Squid 공식 홈페이지](http://www.squid-cache.org/)
- [Squid 공식 문서](http://www.squid-cache.org/Doc/)
- [Squid 위키](https://wiki.squid-cache.org/)
- [설정 참고 가이드](https://wiki.squid-cache.org/SquidFaq/ConfiguringSquid)
- [ACL 가이드](https://wiki.squid-cache.org/SquidFaq/SquidAcl)
- [캐싱 최적화](https://wiki.squid-cache.org/SquidFaq/CachingOptimization)
- [Ubuntu Squid 패키지](https://packages.ubuntu.com/focal/squid)
