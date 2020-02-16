# Traefik

## Test1(Success)

dig A test.polypia.net +short
sudo apt install apache2-utils -y
htpasswd -c htpasswd admin

export DOMAIN=polypia.net
export EMAIL=your@email-domain.com

curl -H Host:portainer.polypia.net localhost


## Test2



## Service Test

```
docker network create --driver=overlay traefik-public

curl -H Host:whoami0.traefik http://192.168.11.111
curl -H Host:whoami1.traefik http://192.168.11.111
```
