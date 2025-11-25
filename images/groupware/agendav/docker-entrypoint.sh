#!/bin/sh
set -e

# Generate settings.php if it doesn't exist
SETTINGS_FILE="/var/www/agendav/web/config/settings.php"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Creating settings.php from environment variables..."
    cat > "$SETTINGS_FILE" << EOF
<?php
// AgenDAV settings - auto-generated
\$app['site.title'] = '${AGENDAV_TITLE:-AgenDAV}';
\$app['site.logo'] = '${AGENDAV_LOGO:-img/agendav_100transp.png}';
\$app['site.footer'] = '${AGENDAV_FOOTER:-AgenDAV}';

// Database
\$app['db.options'] = [
    'dbname' => '${DB_DATABASE:-agendav}',
    'user' => '${DB_USERNAME:-agendav}',
    'password' => '${DB_PASSWORD:-agendav_password}',
    'host' => '${DB_HOST:-db}',
    'driver' => 'pdo_mysql',
];

// CalDAV server
\$app['caldav.baseurl'] = '${CALDAV_URL:-http://localhost:5232/}';
\$app['caldav.authmethod'] = '${CALDAV_AUTH_METHOD:-basic}';

// Timezone
\$app['defaults.timezone'] = '${AGENDAV_TIMEZONE:-UTC}';

// Language
\$app['defaults.language'] = '${AGENDAV_LANGUAGE:-en}';

// Log level
\$app['log.level'] = '${AGENDAV_LOG_LEVEL:-WARNING}';

// Session settings
\$app['encryption.key'] = '${AGENDAV_ENCRYPTION_KEY:-CHANGE_ME_PLEASE}';
EOF
    chown www-data:www-data "$SETTINGS_FILE"
fi

# Initialize database if needed
if [ "${AGENDAV_INIT_DB:-false}" = "true" ]; then
    echo "Initializing database..."
    cd /var/www/agendav
    php bin/agendavcli dbupdate
fi

exec "$@"
