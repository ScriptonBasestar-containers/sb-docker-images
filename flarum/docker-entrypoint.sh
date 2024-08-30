#!/bin/bash

echo 'entry >>>>>>>>>> start'

php flarum cache:clear
php flarum migrate
php flarum assets:publish

echo 'entry <<<<<<<<<< success'
