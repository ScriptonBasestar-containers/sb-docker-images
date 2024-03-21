#!/bin/sh

# wait for mysql ready
sleep 15s;

envsubst < .xe_install_config-tmpl.yml > .xe_install_config.yml
# php -r "copy('http://start.xpressengine.io/download/installer', 'installer');"
# php installer install --config=.xe_install_config.yml --no-interact --install-dir=/var/www/html
php artisan xe:install --config=.xe_install_config.yml --no-interaction
# apache2-foreground