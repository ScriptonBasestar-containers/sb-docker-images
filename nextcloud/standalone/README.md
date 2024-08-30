# Nextcloud Standalone 인스톨 테st

도커에서 소스코드를 다운로드 받아서 실행시켜보기

## setup

1. git clone https://github.com/nextcloud/server.git
2. docker-compose.yml
```yml
services:
  postgres:
    
```

## REF
- https://github.com/nextcloud/docker/issues/2226
```
Though I'm thinking maybe we should nudge people towards simply using the Auto configuration via hooks support (#2231) since all config.php values can be set via occ config:system:set whereas NC_* doesn't support any parameters with . in them nor any array values (which are both big limitations). It's also not documented and thus not well supported upstream.
```
