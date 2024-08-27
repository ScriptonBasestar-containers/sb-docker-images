REPO=scriptonbasestar/sb-flarum
VERSION=3.0.11

setup:
	git clone https://github.com/flarum/flarum --depth 1 app
	docker run --rm -it -v ./app:/var/www composer composer install

build:
	docker compose build --no-cache

run:
	docker compose up

clean:
	docker rm -f $(docker ps -qa)
	docker rmi $(docker images -q)
