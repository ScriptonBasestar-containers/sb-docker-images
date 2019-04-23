# Bitcoin

테스트 모드 2가지
Testnet : 공개 테스트 네트워크.
Regtest : 로컬 테스트 환경

docker build . -t sb-bitcoin-node
docker run -it --rm sb-bitcoin-node bash

# 미트코인은 100블록 생성전엔 송금이 불가. 100개 생성.
docker run -it --rm sb-bitcoin-node bitcoin-cli -regtest generate 101

# 현재 블록 수 확인
bitcoin-cli -regtest getblockcount
# 계좌생성
bitcoin-cli -regtest getnewaddress testuser1
~~ {계좌번호} 생성
# 잔고확인
bitcoin-cli -regtest getbalance
~~ 채굴보상으로 받은 코인표시됨. 아이디 명시 안했으니 지갑 주인의 
bitcoin-cli -regtest getbalance testuser1
~~ test1의 잔고 표시됨 아직아무것도 안했으니 0원
# 송금
bitcoin-cli -regtest sendtoaddress {계좌번호}
~~ 채굴자 지갑에서 돈 나감
# 확인
bitcoin-cli -regtest listunspent
