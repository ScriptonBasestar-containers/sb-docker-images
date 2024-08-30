REPO=scriptonbasestar/sb-flarum
VERSION=3.0.11

setup:
<<<<<<< HEAD
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
=======
	git clone https://github.com/flarum/flarum --depth 1 flarum-app
	git clone https://github.com/flarumite/flarum-docker --depth 1 flarum-docker
	# docker run --rm -it -v ./flarum-app:/var/www composer composer install

build:
	# docker compose -f dc-nginx.yml build --no-cache
	docker compose -f dc-apache.yml build --no-cache
>>>>>>> dd1a21c (nextcloud)

run:
	docker compose -f dc-apache.yml

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)
