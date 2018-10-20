#!/bin/bash

docker build -t mysql-test .
docker run -d -p 3306 --name mysql-test mysql-test 

# docker exec -it mysql-test bash
