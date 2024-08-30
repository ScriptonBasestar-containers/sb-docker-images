REPO=scriptonbasestar/sb-flarum
VERSION=3.0.11

setup:
	# git clone https://github.com/flarum/flarum --depth 1 app
	# docker run --rm -it -v ./app:/app composer composer install

teardown:
	rm -rf app
	docker compose down -v

build:
	docker compose build --no-cache
	# docker compose run php flrum migrate
	# docker compose run php flarum cache:clear
	# flarum vendor:install
	# flarum admin:generate

run:
	docker compose up

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)
