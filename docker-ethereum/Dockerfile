FROM ubuntu:16.04

WORKDIR /app

# geth 소스 코드 다운로드
RUN git clone -b release/1.3.6 https://github.com/ethereum/go-ethereum.git /app
# go 환경 설치
RUN apt-get install -y build-essential libqmp3-dev golang

WORKDIR /app
# geth 빌드
RUN make -C go-ethereum geth
#빌드 성공 확인
RUN ./go-ethereum/build/bin/geth version
# 복사
RUN cp ./go-ethereum/build/bin/geth /usr/bin/

#테스트넷 실행
ENTRYPOINT geth ---networkid "123" --dadadir "/app" --olympic console

