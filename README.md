# sb-docker-images

도커 이미지 및 도커 컴포즈 테스트용
개발/테스트 이미지 생성용

라이센스는 전체적으로는 MIT지향이지만 다른고스이 이미지를 사용하는 경우 그짝을따름(GPL, AGPL등)

## List

- nextcloud
- squid
- jenkins-agent
- auth,security
  - https://github.com/freeipa/freeipa
  - keycloak
  - authelia
  - ory kratos
  - cas
- wiki
  - gollum
  - mediawiki
  - wikijs
- forum
  - discourse
  - misago
  - flaskbb
  - nodebb
- cms
  - https://github.com/pyrocms/pyrocms
  - joomla
  - drupal
  - wordpress
  - gnuboard
  - djangocms
- static, blog
  - ghost
  - jekyll
  - hugo
  - https://github.com/hexojs/hexo
  - gatsby
- sns, timeline
  - mastodon

## Deprecated, Archived 이거나 마찬가지
- xe3
- 

## REF
https://github.com/docker/build-push-action/issues/561
https://products.containerize.com
https://axbom.com/fediverse/

## Legacy
### docker에서 letsencrypt 적용할 때 쓰던것들
- https://github.com/nginx-proxy/docker-gen
- https://github.com/nginx-proxy/nginx-proxy
- https://github.com/jwilder/docker-letsencrypt-nginx-proxy-companion

## TODO
- 주기적으로 삭제하기
  https://rtyley.github.io/bfg-repo-cleaner/
