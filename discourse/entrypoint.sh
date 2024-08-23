#!/bin/bash

echo 'entrypoint entry.sh'
bundle exec rake db:migrate
bin/rails assets:precompile
# bundle exec rake db:seed
