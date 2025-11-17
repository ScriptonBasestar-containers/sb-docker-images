#!/bin/bash

wp core install \
  --url=http://localhost:8100 \
  --title=My\ WordPress\ Site \
  --admin_user=a01 \
  --admin_password=passw0rd \
  --admin_email=a01@a.com

## plugins
wp plugin install user-switching --activate

wp plugin install miniorange-login-with-eve-online-google-facebook --activate
wp plugin install social-rocket --activate

### keycloak
# wp plugin install wp-oauth-server --activate
# wp option update wpoauth_client_id 'your_keycloak_client_id'
# wp option update wpoauth_client_secret 'your_keycloak_client_secret'
# wp option update wpoauth_server_url 'https://your-keycloak-domain/auth/realms/your-realm/protocol/openid-connect/token'

### forum
# bbpress, buddypress, wpforo, asgaros, simple:press, discussion board
wp plugin install bbpress --activate

### board
# wpdiscuz, wpforo

### blogs
# define('WP_ALLOW_MULTISITE', true);
wp core multisite-install --title="My Network" --admin_user="admin" --admin_password="your_secure_password" --admin_email="" --url="http://example.com" --base="/"

### cache
# wp-rocket, w3-total-cache, wp-super-cache, wp-fastest-cache, wp-optimize
# wp plugin install wp-redis --activate

## themes
wp theme install twentysixteen --activate

## users
wp user create admin1 a01@a.com --role=administrator --user_pass="passw0rd"
wp user create admin2 a02@a.com --role=administrator --user_pass="passw0rd"
wp user create user1 u01@a.com --role=user --user_pass="passw0rd"
wp user create user2 u02@a.com --role=user --user_pass="passw0rd"
wp user create user3 u03@a.com --role=user --user_pass="passw0rd"
