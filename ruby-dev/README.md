# Ruby on Rails 개발환경

호스트에서 에디터로 편집하고 도커환경에서 구동가능한 이미지

ruby, rails, node

docker-compose는 샘플

## Usage

* 도커 이미지 안에서 /app 경로를 개발경로로 사용
* Gemfile을 해당 프로젝트의 파일로교체
* archmagece/ruby-dev:2.5.3은 적절히 교체 또는 그냥 사용.

### 도커 이미지 실행

실행
```bash
$ docker run -ti -p 3000:3000 -v "[로컬 개발경로]:/app" -v gempath:/usr/local/bundle --link mysql:mysql archmagece/ruby-dev:2.5.3 bash
```

도커 실행 후 커맨드라인
```bash
$ mkdir /tmp/rails
$ rm -rf /app/tmp
$ ln -s /tmp/rails /app/tmp
```

의존성 다운로드 및 서버 실행
```bash
bundle install
#rails server -e development -b 0.0.0.0 -p 8000 --pid /tmp/rails/server.pid
rails server -e development -b 0.0.0.0 -p 3000
```
