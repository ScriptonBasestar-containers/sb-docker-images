# sb-rtmp-proxy-docker

여러개 서비스 동시 스트리밍할 때 사용하는 이미지

## 사용법

### 사용포트

rtmp 표준 포트
Port 1935

방화벽을 사용하는 경우 열어놔야함

### 스트리밍 앱

obs 등등의 앱에서 `rtmp://localhost/app` 주소 등록 코드나 별도 정보는 필요없음

### 도커 설치

* windows + hyperv : https://docs.docker.com/docker-for-windows/install/
* windows + virtualbox : https://docs.docker.com/toolbox/toolbox_install_windows/
* mac + virtualbox : https://docs.docker.com/docker-for-mac/install/
* linux : 하는사람들은 알아서 잘 하지 않을까 싶지만  https://docs.docker.com/install/linux/docker-ce/ubuntu/

### 명령행 실행

* TWITCH YOUTUBE 다 입력하지 않으면 오류
* 현재 alpine만 테스트

```bash
docker run --rm \
-e TWITCH_ENDPOINT=live-sel.twitch.tv/app \
-e TWITCH_CODE=xxxx \
-e YOUTUBE_ENDPOINT=a.rtmp.youtube.com/live2 \
-e YOUTUBE_CODE=xxxx \
-p 1905:1905 \
scriptonbasestar/sb-rtmp-proxy-nginx:alpine
```

다른 방법으로

`docker run --rm -v $(pwd)/10-rtmp.conf:/etc/nginx/module.d/10-rtmp.conf scriptonbasestar/sb-rtmp-proxy-nginx:alpine`

## 참고

* https://github.com/arut/nginx-rtmp-module
* https://stream.twitch.tv/ingests/
* https://support.google.com/youtube/answer/2474026?hl=en
