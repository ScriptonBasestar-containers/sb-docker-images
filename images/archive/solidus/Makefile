
setup:
	@echo "Setup Solidus"
	git clone https://github.com/solidusio/solidus.git
	cd solidus && git checkout v4.3

build:
	cd solidus && docker compose build --no-cache

run:
	cd solidus && docker compose up -d
