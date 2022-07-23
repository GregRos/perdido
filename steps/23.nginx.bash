#!/usr/bin/env bash

set -ex
my_nginx=$(realpath "./config/nginx")
mkdir -p /etc/nginx{,www,fragments,conf.d}
local_nginx=/etc/nginx
local_www=/var/www/perdido.bond
unlink $local_nginx/sites-enabled/default || true


echo SETTING UP PERMISSIONS

echo LINKING STATIC CONTENT
mkdir -p $local_www
ln -sf $my_nginx/www/* $local_www
chown -R nginx:nginx "$local_www"

echo SETTING UP NGINX CONFIG
sed -i 's/user .*$/user nginx;/im' $local_nginx/nginx.conf
rm -rf "${local_nginx:?}"/{fragments,conf.d}
mkdir -p "$local_nginx"/{fragments,conf.d}

ln -sf "$my_nginx"/conf/*.conf $local_nginx/conf.d/
ln -sf $my_nginx/fragments/*.conf $local_nginx/fragments/
cp -f $my_nginx/secret.conf $local_nginx/fragments/secret.conf;
random_token="$(od -vAn -N4 -tu4 < /dev/urandom | md5sum | cut -f1 -d' ')"
sed -i "s/>>RANDOM<</$random_token/mig" $local_nginx/fragments/secret.conf
ln -sf $my_nginx/nginx.service /lib/systemd/system/
ln -sf "$my_nginx/ssl-dhparams.certbot.pem" $local_nginx

echo RELOADING NGINX
apt-get install -y --no-install-recommends nginx-core nginx-common nginx nginx-full python3-certbot-nginx apache2-utils

systemctl daemon-reload
systemctl restart nginx
nginx -t && nginx -s reload
if ! curl localhost; then
    echo >&2 nginx seems to be broken
    exit 3
fi

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
ln -sf "$my_nginx"/renew.cronjob /etc/cron.d
