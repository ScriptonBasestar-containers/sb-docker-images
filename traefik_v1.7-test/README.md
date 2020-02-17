# Traefik

## Test1(Success)
https://sysadmins.co.za/traefik-and-portainer-on-docker-swarm-with-letsencrypt/

dig A test.polypia.net +short
sudo apt install apache2-utils -y
htpasswd -c htpasswd admin

export DOMAIN=polypia.net
export EMAIL=your@email-domain.com


docker stack deploy -c test1-1traefik.yml proxy
docker stack deploy -c test1-2portaigner.yml port

curl -H Host:traefik.polypia.net localhost
curl -H Host:portainer.polypia.net localhost
curl -H Host:wordpress.polypia.net localhost

## Test2



## Service Test

```
docker network create --driver=overlay traefik-public

curl -H Host:whoami0.traefik http://192.168.11.111
curl -H Host:whoami1.traefik http://192.168.11.111
```
