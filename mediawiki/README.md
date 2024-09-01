# MediaWIKI

no m1 aarch64 support

install composer
https://stackoverflow.com/questions/51443557/how-to-install-php-composer-inside-a-docker-container

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

install mwcli
https://github.com/samwilson/mwcli

git clone https://github.com/samwilson/mwcli
cd mwcli
composer install --no-dev
export PATH=$PATH:$(pwd)/bin

## REF
https://github.com/ubc/mediawiki-docker
