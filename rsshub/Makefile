date_YYYYMMDD=$(shell date +%Y%m%d)

prepare:
	git clone --depth 1 https://github.com/DIYgod/RSSHub.git
	corepack enable pnpm

setup:
	cd RSSHub
	pnpm i
	pnpm dev

build:
	# docker compose build
	docker build RSSHub/ -t rsshub:latest
	docker tag rsshub:latest ScriptonBasestar/rsshub:latest
	docker tag rsshub:latest ScriptonBasestar/rsshub:${date_YYYYMMDD}

push:
	docker push 

start:
	docker compose up
