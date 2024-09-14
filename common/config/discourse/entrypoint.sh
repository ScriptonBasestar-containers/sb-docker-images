#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /var/www/discourse/tmp/pids/server.pid

# launcher 뒤져버려라고

cd /var/www/discourse
bin/rake db:migrate

yarn
bin/rake yarn:install

bundle exec yarn

bin/rake assets:precompile

bin/ember-cli

# bin/rake admin:create
#git config --global --add safe.directory /var/www/discourse
