#!/bin/bash

docker run \
-e HOSTNAME=local-mysql \
-e MYSQL_ROOT_PASSWORD=qwer1234 \
-e MYSQL_USER=test \
-e MYSQL_PASSWORD=qwer1234 \
-p 3306:3306 \
-d mysql




docker run -it mysql -P 3306 \
-e HOSTNAME=local-mysql \
-e MYSQL_ROOT_PASSWORD=qwer1234 \
-e MYSQL_USER=test \
-e MYSQL_PASSWORD=qwer1234


docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"'

docker run --name some-mysql -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:tag