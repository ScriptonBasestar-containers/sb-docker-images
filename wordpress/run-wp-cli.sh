#!/bin/bash

## plugins
wp plugin install user-switching --activate

### keycloak
wp plugin install wp-oauth-server --activate
wp option update wpoauth_client_id 'your_keycloak_client_id'
wp option update wpoauth_client_secret 'your_keycloak_client_secret'
wp option update wpoauth_server_url 'https://your-keycloak-domain/auth/realms/your-realm/protocol/openid-connect/token'

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
wp plugin install wp-rocket --activate

## themes
wp theme install twentysixteen --activate

## users
wp user create admin_user admin@example.com --role=administrator --user_pass="your_secure_password"