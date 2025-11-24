#!/bin/sh

APPNAME=${APPNAME:=app}

if [ -z "$TWITCH_ENDPOINT" ] && [ -z "$TWITCH_CODE" ]
then
  echo 'TWITCH_ENDPOINT, TWITCH_CODE is essential'
  exit 0
fi

if [ -z "$YOUTUBE_ENDPOINT" ] && [ -z "$YOUTUBE_CODE" ]
then
  echo 'YOUTUBE_ENDPOINT, YOUTUBE_CODE is essential'
  exit 0
fi


# TODO sed rtmp.conf
HOST_IP=$(/sbin/ip route|awk '/default/ { print $3 }')

sed -i "s/{{APPNAME}}/$APPNAME/" /etc/nginx/module.d/10-rtmp.conf

sed -i "s/{{HOST_IP}}/$HOST_IP/" /etc/nginx/module.d/10-rtmp.conf

sed -i "s@{{TWITCH_ENDPOINT}}@$TWITCH_ENDPOINT@" /etc/nginx/module.d/10-rtmp.conf
sed -i "s@{{TWITCH_CODE}}@$TWITCH_CODE@" /etc/nginx/module.d/10-rtmp.conf
sed -i "s@{{YOUTUBE_ENDPOINT}}@$YOUTUBE_ENDPOINT@" /etc/nginx/module.d/10-rtmp.conf
sed -i "s@{{YOUTUBE_CODE}}@$YOUTUBE_CODE@" /etc/nginx/module.d/10-rtmp.conf

echo "$@"
exec "$@"
