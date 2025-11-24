# Home Assistant - EXPERIMENTAL / NOT RECOMMENDED

> **⚠️ 중요 경고**: 이 디렉토리는 **참조용 예제**입니다.
> Docker Container 모드는 Home Assistant의 **권장 설치 방법이 아닙니다**.

## 왜 권장하지 않는가?

### 1. Add-on 지원 불가 ❌
Docker Container 모드에서는 Home Assistant의 핵심 기능인 **Add-on을 사용할 수 없습니다**.

- **Add-on이란?**: 원클릭으로 설치 가능한 보조 서비스
  - Mosquitto MQTT Broker
  - Node-RED
  - Visual Studio Code
  - File Editor
  - Samba Share
  - 등 200+ 공식/커뮤니티 Add-on

- **Docker Container 모드**: Add-on 전체 사용 불가
- **대안**: 각 서비스를 별도 Docker 컨테이너로 수동 구성 (복잡함)

### 2. 하드웨어 의존성 🔌
스마트 홈 기기 제어를 위해 USB 동글이 필요합니다:

- **Zigbee**: Philips Hue, IKEA TRÅDFRI 등
- **Z-Wave**: 스마트 잠금장치, 센서 등
- **Bluetooth**: 블루투스 기기

Docker에서 USB 장치를 패스스루하는 것은 복잡하고 오류가 발생하기 쉽습니다.

### 3. 높은 리소스 사용 💾
| 항목 | 요구사항 | 일반적인 사용 |
|------|---------|--------------|
| **메모리** | 2GB 최소 | 4-8GB |
| **CPU** | 2코어 최소 | 4코어 권장 |
| **스토리지** | 32GB+ | DB 증가로 계속 확장 |

이는 이 저장소의 다른 경량 서비스들(256MB-1GB)과 비교해 4-10배 무겁습니다.

### 4. 네트워크 복잡성 🌐
- **mDNS 디바이스 검색**: host 네트워크 모드 필요
- **SSDP**: 일부 기기 자동 검색 불가
- **포트 포워딩**: bridge 모드에서 수동 설정 필요

## 권장 설치 방법

### ✅ Home Assistant OS (공식 권장)

**장점**:
- Add-on 전체 지원
- 자동 업데이트
- 최적화된 성능
- 공식 지원 및 문서
- 설정 간소화

**지원 플랫폼**:
- Raspberry Pi 4/5 (가장 인기)
- ODROID
- Tinkerboard
- x86-64 (일반 PC/서버)
- 가상 머신 (VirtualBox, VMware, Proxmox)

**설치 가이드**: https://www.home-assistant.io/installation/

---

## Docker Container 모드 사용 (비권장)

이 섹션은 **교육/참조 목적**입니다. 프로덕션 사용을 권장하지 않습니다.

### 최소 요구사항

```
✅ Docker Engine 24.0+
✅ Docker Compose V2
✅ 2GB+ RAM
✅ 32GB+ 스토리지
⚠️ USB 장치 (선택, Zigbee/Z-Wave 사용 시)
```

### 기본 설치

```bash
# 1. 설정 디렉토리 생성
mkdir -p config

# 2. 컨테이너 시작
docker compose up -d

# 3. 로그 확인
docker compose logs -f

# 4. 웹 UI 접속
# http://localhost:8123 (host 모드)
# 또는 http://<서버IP>:8123
```

### 초기 설정

1. **계정 생성**: 첫 접속 시 관리자 계정 생성
2. **위치 설정**: 집 위치 설정 (날씨, 일출/일몰 등)
3. **통합 추가**: Settings → Devices & Services → Add Integration

### USB 장치 설정

#### 1. 장치 확인

```bash
# USB 장치 목록
ls -l /dev/tty*

# 예제 출력:
# /dev/ttyUSB0  <- Zigbee 동글
# /dev/ttyACM0  <- Z-Wave 동글
```

#### 2. compose.yml 수정

```yaml
services:
  homeassistant:
    # ... 기존 설정 ...
    devices:
      - /dev/ttyUSB0:/dev/ttyUSB0
    privileged: true  # USB 접근 권한
```

#### 3. 재시작

```bash
docker compose down
docker compose up -d
```

### PostgreSQL 백엔드 (선택)

기본 SQLite 대신 PostgreSQL 사용 (장기 데이터 저장 시 성능 향상):

#### 1. compose.yml 수정

```yaml
services:
  homeassistant:
    depends_on:
      - db
    networks:
      - homeassistant

  db:
    image: postgres:16-alpine
    restart: unless-stopped
    environment:
      POSTGRES_DB: homeassistant
      POSTGRES_USER: homeassistant
      POSTGRES_PASSWORD: homeassistant
    volumes:
      - ./postgres:/var/lib/postgresql/data
    networks:
      - homeassistant

networks:
  homeassistant:
    driver: bridge
```

#### 2. configuration.yaml 설정

`config/configuration.yaml`:

```yaml
recorder:
  db_url: postgresql://homeassistant:homeassistant@db:5432/homeassistant
  purge_keep_days: 7
  commit_interval: 1
```

#### 3. 재시작

```bash
docker compose restart homeassistant
```

### Add-on 대체 방법

Docker Container 모드에서 Add-on을 사용할 수 없으므로, 각 서비스를 별도 컨테이너로 구성해야 합니다.

#### MQTT Broker (Mosquitto)

```yaml
# compose.yml에 추가
  mosquitto:
    image: eclipse-mosquitto:latest
    restart: unless-stopped
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ./mosquitto/config:/mosquitto/config
      - ./mosquitto/data:/mosquitto/data
      - ./mosquitto/log:/mosquitto/log
    networks:
      - homeassistant
```

Home Assistant 설정:
- Settings → Devices & Services → Add Integration → MQTT
- Broker: `mosquitto`, Port: `1883`

#### Node-RED

```yaml
# compose.yml에 추가
  nodered:
    image: nodered/node-red:latest
    restart: unless-stopped
    ports:
      - "1880:1880"
    volumes:
      - ./nodered:/data
    networks:
      - homeassistant
```

접속: http://localhost:1880

#### File Editor (VS Code Server)

```yaml
# compose.yml에 추가
  code-server:
    image: codercom/code-server:latest
    restart: unless-stopped
    ports:
      - "8443:8080"
    volumes:
      - ./config:/home/coder/config
    environment:
      - PASSWORD=your-password
    networks:
      - homeassistant
```

접속: http://localhost:8443

### 네트워크 모드 선택

#### Host 네트워크 (권장)

**장점**:
- mDNS 디바이스 자동 검색
- SSDP 지원
- 복잡한 포트 매핑 불필요

**단점**:
- 다른 컨테이너와 격리 안됨
- 포트 충돌 가능

```yaml
services:
  homeassistant:
    network_mode: host
    # ports 섹션 제거
```

#### Bridge 네트워크

**장점**:
- 컨테이너 격리
- 다른 서비스와 통합 용이

**단점**:
- mDNS 작동 안 함
- 일부 디바이스 검색 불가

```yaml
services:
  homeassistant:
    networks:
      - homeassistant
    ports:
      - "8123:8123"

networks:
  homeassistant:
    driver: bridge
```

### 백업

#### 수동 백업

```bash
# 컨테이너 중지
docker compose down

# 설정 백업
tar czf homeassistant-backup-$(date +%Y%m%d).tar.gz config/

# 재시작
docker compose up -d
```

#### 복원

```bash
docker compose down
tar xzf homeassistant-backup-YYYYMMDD.tar.gz
docker compose up -d
```

### 업데이트

```bash
# 최신 이미지 다운로드
docker compose pull

# 재시작
docker compose down
docker compose up -d

# 이전 이미지 정리
docker image prune -f
```

## 문제 해결

### 1. USB 장치 인식 안 됨

```bash
# 컨테이너 내부에서 확인
docker exec -it homeassistant ls -l /dev/tty*

# 권한 확인
ls -l /dev/ttyUSB0

# 그룹 추가 (호스트에서)
sudo usermod -a -G dialout $USER
```

### 2. 디바이스 자동 검색 안 됨

- **해결**: host 네트워크 모드 사용
- compose.yml에서 `network_mode: host` 설정

### 3. 높은 메모리 사용

```yaml
# configuration.yaml
recorder:
  purge_keep_days: 3  # 데이터 보관 기간 단축
  commit_interval: 30  # 커밋 간격 증가

logger:
  default: warning  # 로그 레벨 조정
```

### 4. 느린 성능

- **CPU**: 최소 2코어 이상 할당
- **메모리**: 4GB 이상 권장
- **스토리지**: SSD 사용 권장
- **데이터베이스**: PostgreSQL 사용

## 통합 예제

### Zigbee2MQTT 연동

```yaml
# compose.yml에 추가
  zigbee2mqtt:
    image: koenkk/zigbee2mqtt:latest
    restart: unless-stopped
    volumes:
      - ./zigbee2mqtt:/app/data
      - /run/udev:/run/udev:ro
    devices:
      - /dev/ttyUSB0:/dev/ttyUSB0
    environment:
      - TZ=Asia/Seoul
    networks:
      - homeassistant
```

Home Assistant에서:
- Settings → Devices & Services → Add Integration → MQTT
- 자동으로 Zigbee 디바이스 인식

### InfluxDB + Grafana 모니터링

```yaml
# compose.yml에 추가
  influxdb:
    image: influxdb:2.7-alpine
    restart: unless-stopped
    ports:
      - "8086:8086"
    volumes:
      - ./influxdb:/var/lib/influxdb2
    networks:
      - homeassistant

  grafana:
    image: grafana/grafana:latest
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - ./grafana:/var/lib/grafana
    networks:
      - homeassistant
```

## 참고 자료

### 공식 문서
- [Home Assistant 공식 사이트](https://www.home-assistant.io/)
- [설치 가이드](https://www.home-assistant.io/installation/)
- [Docker 설치 문서](https://www.home-assistant.io/installation/linux#docker-compose)
- [통합 목록](https://www.home-assistant.io/integrations/)

### Docker 관련
- [공식 Docker 이미지](https://hub.docker.com/r/homeassistant/home-assistant)
- [Docker 제약사항](https://www.home-assistant.io/installation/linux#docker-compose)

### 커뮤니티
- [Home Assistant 커뮤니티](https://community.home-assistant.io/)
- [한국 사용자 그룹](https://cafe.naver.com/koreassistant)
- [Reddit](https://www.reddit.com/r/homeassistant/)

### 관련 프로젝트
- **Node-RED**: 자동화 플로우 도구
- **Zigbee2MQTT**: Zigbee 브리지
- **ESPHome**: DIY IoT 펌웨어
- **Mosquitto**: MQTT 브로커

## 결론

### ❌ Docker Container 모드를 사용하지 말아야 하는 경우:
- Add-on을 사용하고 싶은 경우
- 간단한 설치와 유지보수를 원하는 경우
- 초보자
- 프로덕션 환경

### ✅ Docker Container 모드를 고려할 수 있는 경우:
- 이미 복잡한 Docker 인프라가 있는 경우
- Add-on 없이 수동 통합을 선호하는 경우
- 테스트/개발 목적
- Docker 전문가

### 🎯 최종 권장사항:

**Home Assistant OS**를 사용하세요. 이것이 공식 권장 방법이며, 가장 안정적이고 기능이 완전합니다.

- **Raspberry Pi 4/5**: 가장 인기 있는 선택
- **x86-64 미니PC**: 성능이 필요한 경우
- **가상 머신**: 기존 서버 활용

Docker Container 모드는 **학습 및 참조 목적으로만** 사용하세요.
