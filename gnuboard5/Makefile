CONTAINER_NAME=gnuboard5

setup:
	@echo "Setting up"
	git clone https://github.com/gnuboard/gnuboard5.git --depth 1 app



build:
	@echo "Building Debian"
	#docker build -f Image.debian.dockerfile -t gnuboard6 .
	docker compose build --no-cache

run:
	@echo "Running Debian"
	# define('G5_DOMAIN', 'http://localhost:8080');
#	sed -i 's/define('G5_DOMAIN', '');/define('G5_DOMAIN', 'http:\/\/localhost:8000');/g' app/config.php
	# linux
	#sed -i "s|define('G5_DOMAIN', '');|define('G5_DOMAIN', 'http://localhost:8080');|" app/config.php
	# mac
	sed -i '' "s|define('G5_DOMAIN', '');|define('G5_DOMAIN', 'http://localhost:8080');|" app/config.php
	docker compose up
