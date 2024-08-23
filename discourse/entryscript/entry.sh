#!/bin/bash

echo 'entrypoint entry.sh'
bundle exec rake db:migrate
# bundle exec rake db:seed
