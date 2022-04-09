#!/usr/bin/env bash
echo --- SETTING UP WEB REVERSE PROXY ---

exec > >(trap "" INT TERM; sed 's/^/[WEB] /')
set -ex
apt-get install -y certbot nginx python3-certbot-nginx apache2-utils

if ! curl localhost; then
  >&2 echo nginx seems to be broken
  exit 3
fi

echo CREATING PASSWORD FILE
rm /etc/nginx/htpasswd
htpasswd -c -B /etc/nginx/htpasswd gr

echo SETTING UP NGINX CONFIG
sed -i 's/user .*$/user nginx;/im' /etc/nginx/nginx.conf
rm -rf /etc/nginx/conf.d/
mkdir -p /etc/nginx/conf.d
cp -f ./config/nginx/*.conf /etc/nginx/conf.d/

echo GENERATING CERTIFICATE
certbot --nginx -d perdido.bond

echo RELOADING
unlink /etc/nginx/sites-enabled/default || true
nginx -t && nginx -s reload

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
cp -f config/renew.cronjob /etc/cron.d/
