# sb-docker-squid

## 주의

기본설치에는 아래 설정이 빠져있지만 이 도커 컨테이너에는 추가
(내부 네트워크 접속을 허용)

```bash
http_access allow localnet
```


## Usage 우사기?

볼륨디렉토리
* 설정파일: /etc/squid/conf.d
* 캐시디렉토리: /var/spool/squid

실행 명령

```bash
docker run --rm -d -v vol_cache:/var/spool/squid -v vol_conf:/etc/squid/conf.d -p 3128:3128 scriptonbasestar/sb-docker-squid
```

설정은 'sample.conf'를 참고


## Test

```bash
docker build . -t squid-test
docker run --rm -it -p 3128:3128 squid-test
```
