#!/bin/bash

# cli alpine 82
# cli-8.3 alpine 82
# wordpress;6-php8.3-apache debian 33
chown -R www-data:www-data /var/www
find /var/www/ -type d -exec chmod 755 {} \;
find /var/www/ -type f -exec chmod 644 {} \;
