#!/usr/bin/env bash
echo --- SETTING UP WEB REVERSE PROXY ---

exec > >(trap "" INT TERM; sed 's/^/[WEB] /')
set -ex
apt-get install -y certbot nginx python3-certbot-nginx

if ! curl localhost; then
  >&2 echo nginx seems to be broken
fi

sed -i 's/user .*$/user nginx;/im' /etc/nginx/nginx.conf
rm -rf /etc/nginx/conf.d/
mkdir -p /etc/nginx/conf.d
cp -f ./config/nginx/*.conf /etc/nginx/conf.d/
certbot --nginx -d perdido.bond

unlink /etc/nginx/sites-enabled/default || true
nginx -t && nginx -s reload
mkdir -p /etc/cron.d
cp -f config/renew.cronjob /etc/cron.d/
