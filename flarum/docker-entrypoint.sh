#!/bin/bash

echo 'entry >>>>>>>>>> start'

# php flarum cache:clear
# php flarum migrate
# php flarum assets:publish

# php flarum install --defaults \
#   --title="$FLARUM_TITLE" \
#   --url="$FLARUM_URL" \
#   --admin-user="$FLARUM_ADMIN_USER" \
#   --admin-password="$FLARUM_ADMIN_PASSWORD" \
#   --admin-email="$FLARUM_ADMIN_EMAIL" \
#   --db-host="$FLARUM_DB_HOST" \
#   --db-name="$FLARUM_DB_NAME" \
#   --db-user="$FLARUM_DB_USER" \
#   --db-password="$FLARUM_DB_PASSWORD" \
#   --db-prefix="${FLARUM_DB_PREFIX:-}"

# php flarum install -f /flarum-config.json
php flarum install -f /flarum-config.yaml

php flarum extension:enable flarum-tags
php flarum extension:enable flarum-sticky
php flarum extension:enable flarum-pwa
php flarum extension:enable flarum-approval
php flarum extension:enable flarum-suspend
php flarum extension:enable flarum-lock
php flarum extension:enable flarum-mentions
php flarum extension:enable flarum-statistics
php flarum extension:enable flarum-bbcode
php flarum extension:enable flarum-emoji
php flarum extension:enable fof-best-answer

php flarum extension:enable \
    flarum-tags \
    flarum-sticky \
    flarum-pwa \
    flarum-approval \
    flarum-suspend \
    flarum-lock \
    flarum-mentions \
    flarum-statistics \
    flarum-bbcode \
    flarum-emoji 
echo 'entry <<<<<<<<<< success'
