# RTMP Proxy

> 💡 **Quick Start**: This project does not have a standalone setup. Use the basic setup below for development and testing.

## 개요

RTMP Proxy는 하나의 스트림을 여러 스트리밍 플랫폼에 동시에 송출할 수 있게 해주는 RTMP 프록시 서버입니다:
- 📡 **다중 플랫폼 스트리밍**: 한 번의 스트리밍으로 여러 플랫폼 동시 송출
- 🎥 **RTMP 프로토콜**: 표준 RTMP 프로토콜 지원
- 🚀 **Nginx 기반**: Nginx RTMP 모듈 기반 고성능 프록시
- ⚡ **낮은 레이턴시**: 최소 지연시간으로 스트리밍
- 🔧 **유연한 설정**: 환경 변수로 엔드포인트 설정
- 🌐 **다양한 플랫폼**: Twitch, YouTube, Facebook 등 지원
- 🐳 **Docker 지원**: 컨테이너 환경에서 손쉽게 실행
- 🔒 **접근 제어**: IP 기반 접근 제어 지원

OBS 등의 방송 소프트웨어에서 한 번만 스트리밍하면 여러 플랫폼으로 동시에 전송됩니다.

### 지원 플랫폼

- Twitch
- YouTube Live
- Facebook Live
- 기타 RTMP를 지원하는 모든 플랫폼

## Deployment Options

### 🔧 Basic Setup (For Development)

**For development and testing only.**

## Default Configuration

**Default port:** 1935 (RTMP standard port - see [PORT_GUIDE.md](../PORT_GUIDE.md))

**Container name:** rtmp-proxy

Environment variables:
```bash
TWITCH_ENDPOINT=live-sel.twitch.tv/app
TWITCH_CODE=live_xxxxxxxxxx
YOUTUBE_ENDPOINT=a.rtmp.youtube.com/live2
YOUTUBE_CODE=xxxx-xxxx-xxxx-xxxx
HOST_IP=172.17.0.1
APPNAME=live
```

## Port Information

| Port | Service | Purpose |
|------|---------|---------|
| 1935 | RTMP | RTMP streaming (standard port) |
| 80 | HTTP | Health check and statistics |
| 8080 | HTTP | Management interface (optional) |

**Port conflicts:** See [PORT_GUIDE.md](../PORT_GUIDE.md) for port allocation details.

## 빠른 시작

### 필수 요구사항

- Docker 및 Docker Compose
- 스트리밍 소프트웨어 (OBS, XSplit 등)
- 방화벽에서 포트 1935 개방 (필요시)

### Docker Compose로 실행

```bash
# docker-compose.yml 파일 편집하여 환경 변수 설정
docker compose up -d

# 로그 확인
docker compose logs -f rtmp
```

### Docker 명령어로 실행

```bash
docker run --rm -d \
  -e TWITCH_ENDPOINT=live-sel.twitch.tv/app \
  -e TWITCH_CODE=live_xxxxxxxxxx \
  -e YOUTUBE_ENDPOINT=a.rtmp.youtube.com/live2 \
  -e YOUTUBE_CODE=xxxx-xxxx-xxxx-xxxx \
  -p 1935:1935 \
  scriptonbasestar/sb-rtmp-proxy-nginx:alpine
```

### 커스텀 설정 파일 사용

```bash
docker run --rm -d \
  -v $(pwd)/10-rtmp.conf:/etc/nginx/module.d/10-rtmp.conf \
  -p 1935:1935 \
  scriptonbasestar/sb-rtmp-proxy-nginx:alpine
```

## 서비스 구성

### 핵심 컴포넌트

- **Nginx**: 웹 서버 및 프록시
- **RTMP Module**: Nginx RTMP 모듈
- **Health Check**: 서비스 상태 모니터링

### 사용 가능한 이미지

- `nginx:alpine` - Alpine Linux 기반 (권장)
- `ubuntu:focal` - Ubuntu 기반

## 포트 정보

기본 포트 설정:

| 포트 | 프로토콜 | 서비스 | 설명 |
|------|---------|--------|------|
| 1935 | TCP | RTMP | RTMP 스트리밍 표준 포트 (권장 포트 사용 중) |
| 80 | TCP | HTTP | Health check 및 통계 (선택사항) |
| 8080 | TCP | HTTP | 관리 인터페이스 (선택사항) |

> ✅ **포트 설정**: 이미 RTMP 표준 포트(1935)를 사용하고 있습니다. ([포트 가이드](../PORT_GUIDE.md) 참조)
>
> **참고**: HTTP 포트(80)는 health check 용도로 사용되며, 필요에 따라 8080으로 변경할 수 있습니다.

**중요**: 방화벽 사용 시 포트 1935를 반드시 열어야 합니다.

포트 충돌 방지: [포트 가이드](../PORT_GUIDE.md)

## 환경 변수

주요 환경 변수 설정:

### Docker Compose 환경 변수

```yaml
environment:
  # Twitch 설정
  - TWITCH_ENDPOINT=live-sel.twitch.tv/app
  - TWITCH_CODE=live_xxxxxxxxxx_yyyyyyyyyyyyyyyyyyy

  # YouTube 설정
  - YOUTUBE_ENDPOINT=a.rtmp.youtube.com/live2
  - YOUTUBE_CODE=xxxx-xxxx-xxxx-xxxx

  # 호스트 IP (선택)
  - HOST_IP=172.17.0.1

  # 앱 이름 (선택)
  - APPNAME=live
```

### 환경 변수 설명

- **TWITCH_ENDPOINT**: Twitch 인제스트 서버 주소
- **TWITCH_CODE**: Twitch 스트림 키
- **YOUTUBE_ENDPOINT**: YouTube RTMP 서버 주소
- **YOUTUBE_CODE**: YouTube 스트림 키
- **HOST_IP**: 허용할 호스트 IP (보안)
- **APPNAME**: RTMP 애플리케이션 이름 (기본값: live)

## 사용법

### 1. 스트림 키 발급받기

#### Twitch

1. [Twitch 대시보드](https://dashboard.twitch.tv/) 접속
2. 설정 > 스트림 키 확인
3. 인제스트 서버: [Twitch 인제스트 목록](https://stream.twitch.tv/ingests/)

#### YouTube

1. [YouTube Studio](https://studio.youtube.com/) 접속
2. 라이브 스트리밍 > 스트림 키 확인
3. 서버 URL: `rtmp://a.rtmp.youtube.com/live2`

### 2. 환경 변수 설정

`docker-compose.yml` 파일 편집:

```yaml
version: "3.3"

services:
  rtmp:
    image: scriptonbasestar/sb-rtmp-proxy-nginx:alpine
    ports:
      - "1935:1935"
      - "8080:80"
    environment:
      - TWITCH_ENDPOINT=live-sel.twitch.tv/app
      - TWITCH_CODE=live_xxxxxxxxxxxxxxxxxxxx
      - YOUTUBE_ENDPOINT=a.rtmp.youtube.com/live2
      - YOUTUBE_CODE=xxxx-xxxx-xxxx-xxxx
    restart: unless-stopped
```

### 3. OBS 설정

1. **설정 > 방송** 메뉴 이동
2. **서비스**: 사용자 지정
3. **서버**: `rtmp://localhost/live` (또는 `rtmp://서버IP/live`)
4. **스트림 키**: 비워두기 (또는 임의의 값)

### 4. 스트리밍 시작

OBS에서 방송 시작 버튼을 클릭하면 설정된 모든 플랫폼으로 동시에 스트리밍됩니다.

## Docker 설정

### docker-compose.yml 예시

```yaml
version: "3.3"

services:
  rtmp:
    image: scriptonbasestar/sb-rtmp-proxy-nginx:alpine
    container_name: rtmp-proxy
    ports:
      - "1935:1935"
      - "8080:80"
    volumes:
      # 커스텀 설정 사용시
      - ./config/10-rtmp.conf:/etc/nginx/module.d/10-rtmp.conf
    environment:
      - TWITCH_ENDPOINT=live-sel.twitch.tv/app
      - TWITCH_CODE=${TWITCH_KEY}
      - YOUTUBE_ENDPOINT=a.rtmp.youtube.com/live2
      - YOUTUBE_CODE=${YOUTUBE_KEY}
      - HOST_IP=172.17.0.1
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80"]
      interval: 30s
      timeout: 10s
      retries: 3
```

### .env 파일 예시

보안을 위해 스트림 키는 별도 파일로 관리:

```bash
TWITCH_KEY=live_xxxxxxxxxxxxxxxxxxxx
YOUTUBE_KEY=xxxx-xxxx-xxxx-xxxx
```

### 빌드

```bash
# Alpine 버전 빌드
docker build -f nginx/Dockerfile -t rtmp-nginx:alpine .

# Ubuntu 버전 빌드
docker build -f ubuntu/Dockerfile -t rtmp-nginx:ubuntu .

# 빌드 스크립트 사용
./build.sh
```

## 고급 설정

### 커스텀 RTMP 설정

`10-rtmp.conf` 파일 생성:

```nginx
rtmp {
    server {
        listen 1935;
        chunk_size 4096;

        application live {
            live on;
            record off;

            # 접근 제어
            allow publish 127.0.0.1;
            allow publish 172.17.0.0/16;
            deny publish all;

            # 다중 플랫폼 푸시
            push rtmp://live-sel.twitch.tv/app/live_xxxxxxxxxxxxxxxxxxxx;
            push rtmp://a.rtmp.youtube.com/live2/xxxx-xxxx-xxxx-xxxx;
            push rtmp://live-api-s.facebook.com:80/rtmp/FB-xxxxxxxxxxxxxxxxxxxx;

            # 녹화 (선택)
            # record all;
            # record_path /var/recordings;
            # record_suffix -%Y%m%d-%H%M%S.flv;
        }
    }
}
```

### 추가 플랫폼 설정

Facebook Live 추가:

```nginx
push rtmp://live-api-s.facebook.com:80/rtmp/FB-xxxxxxxxxxxxxxxxxxxx;
```

커스텀 RTMP 서버 추가:

```nginx
push rtmp://custom.server.com:1935/live/stream_key;
```

## 문제 해결

### 스트리밍이 연결되지 않음

```bash
# 서비스 상태 확인
docker compose ps

# 로그 확인
docker compose logs -f rtmp

# 포트 확인
netstat -tuln | grep 1935
```

### 방화벽 설정

```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 1935/tcp

# firewalld (CentOS/RHEL)
sudo firewall-cmd --permanent --add-port=1935/tcp
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 1935 -j ACCEPT
```

### 특정 플랫폼만 작동하지 않음

1. 스트림 키가 올바른지 확인
2. 해당 플랫폼의 인제스트 서버가 정상인지 확인
3. 네트워크 연결 확인

```bash
# Twitch 연결 테스트
telnet live-sel.twitch.tv 1935

# YouTube 연결 테스트
telnet a.rtmp.youtube.com 1935
```

### 스트림 품질 문제

OBS 설정에서 비트레이트를 각 플랫폼의 권장 설정에 맞게 조정:

- **Twitch**: 3000-6000 kbps
- **YouTube**: 3000-9000 kbps
- **Facebook**: 3000-4000 kbps

### 레이턴시 문제

```nginx
# 10-rtmp.conf에서 버퍼 크기 조정
chunk_size 4096;  # 더 작은 값으로 레이턴시 감소

# 또는
chunk_size 8192;  # 더 큰 값으로 안정성 향상
```

### Docker 네트워크 문제

```bash
# 호스트 IP 확인
docker network inspect bridge | grep Gateway

# 환경 변수에 설정
HOST_IP=172.17.0.1
```

## 유용한 명령어

```bash
# 서비스 시작
docker compose up -d

# 서비스 중지
docker compose down

# 로그 실시간 확인
docker compose logs -f

# 컨테이너 재시작
docker compose restart rtmp

# 설정 리로드 (nginx)
docker compose exec rtmp nginx -s reload

# 설정 테스트
docker compose exec rtmp nginx -t

# 컨테이너 쉘 접속
docker compose exec rtmp sh
```

## 모니터링

### Health Check 엔드포인트

```bash
# HTTP 상태 확인
curl http://localhost:8080/

# Docker health check
docker compose ps
```

### 통계 페이지 (선택)

nginx.conf에 통계 모듈 추가:

```nginx
http {
    server {
        listen 8080;

        location /stat {
            rtmp_stat all;
            rtmp_stat_stylesheet stat.xsl;
        }

        location /stat.xsl {
            root /usr/share/nginx/html;
        }
    }
}
```

접속: `http://localhost:8080/stat`

## 성능 최적화

### 시스템 튜닝

```bash
# 최대 파일 디스크립터 증가
ulimit -n 65535

# docker-compose.yml에 추가
services:
  rtmp:
    ulimits:
      nofile:
        soft: 65535
        hard: 65535
```

### Nginx 워커 프로세스

```nginx
# nginx.conf
worker_processes auto;
worker_connections 1024;
```

## 참고 자료

- [nginx-rtmp-module GitHub](https://github.com/arut/nginx-rtmp-module)
- [Nginx RTMP 문서](https://github.com/arut/nginx-rtmp-module/wiki)
- [Twitch 인제스트 서버 목록](https://stream.twitch.tv/ingests/)
- [YouTube 라이브 스트리밍 가이드](https://support.google.com/youtube/answer/2474026)
- [OBS 설정 가이드](https://obsproject.com/wiki/)
- [RTMP 프로토콜 스펙](https://www.adobe.com/devnet/rtmp.html)
