#!/usr/bin/env bash

echo --- SETTING UP WEB REVERSE PROXY ---
exec > >(trap "" INT TERM; sed 's/^/[WEB] /')
exec 2> >(trap "" INT TERM; sed 's/^/[WEB ERR] /' >&2)

apt-get install -y certbot nginx python-certbot-nginx

if ! curl localhost; then
  >&2 echo nginx seems to be broken
fi

sed -i 's/user .*$/user nginx;/im' /etc/nginx/nginx.conf
cp ./config/nginx/* /etc/nginx/conf.d/

unlink /etc/nginx/sites-enabled/default


