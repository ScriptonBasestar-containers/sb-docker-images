#!/bin/bash

echo 'entry >>>>>>>>>> start'

php flarum cache:clear
php flarum migrate
php flarum assets:publish

php flarum install --defaults \
  --title="Your Forum Title" \
  --url="http://your-forum-url.com" \
  --admin-user="admin" \
  --admin-password="yourpassword" \
  --admin-email="admin@example.com" \
  --db-host="localhost" \
  --db-name="flarum" \
  --db-user="flarum_user" \
  --db-password="flarum_password" \
  --db-prefix="flarum_"

flarum install -f ./flarum-config.json
echo 'entry <<<<<<<<<< success'
