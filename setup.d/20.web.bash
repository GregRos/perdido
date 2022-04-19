#!/usr/bin/env bash
echo --- SET UP WEB ---

exec > >(
    trap "" INT TERM
    sed 's/^/[20 WEB] /'
)
set -ex
apt-get install -y certbot nginx-core nginx-common nginx nginx-full python3-certbot-nginx apache2-utils

echo REGENERATING CERTIFICATE
systemctl stop nginx || true
# Puts certificate in /etc/letsencrypt/live
# can be skipped if cert is okay
certbot certonly --standalone --preferred-challenges http -d perdido.bond

my_nginx=$(realpath "./config/nginx")
local_nginx=/etc/nginx
local_www=/var/www/perdido.bond
unlink $local_nginx/sites-enabled/default || true
systemctl daemon-reload
systemctl restart nginx
nginx -t && nginx -s reload
if ! curl localhost; then
    echo >&2 nginx seems to be broken
    exit 3
fi

create_passwd=0
echo CREATING PASSWORD FILE
if test -f $local_nginx/htpasswd; then
    read -p "Password file exists. Recreate? y/n: " -n 1 -r
    echo
    if [[ "$REPLY" =~ [Yy] ]]; then
        rm $local_nginx/htpasswd
        create_passwd=1
    fi
else
    create_passwd=1
fi

if test $create_passwd != 0; then
    htpasswd -c -B $local_nginx/htpasswd gr
fi

echo SETTING UP PERMISSIONS

echo LINKING STATIC CONTENT
rm -rf ${local_www:?} || true
mkdir -p $local_www
cp -rf $my_nginx/www/* $local_www
chown -R nginx:nginx "$local_www"

echo SETTING UP NGINX CONFIG
sed -i 's/user .*$/user nginx;/im' $local_nginx/nginx.conf
rm -rf "${local_nginx:?}"/{fragments,conf.d}
mkdir -p "$local_nginx"/{fragments,conf.d}
ln -sf "$my_nginx"/conf/*.conf $local_nginx/conf.d/
ln -sf $my_nginx/fragments/*.conf $local_nginx/fragments/
ln -sf $my_nginx/nginx.service /lib/systemd/system/
ln -sf "$my_nginx/ssl-dhparams.certbot.pem" $local_nginx

echo RELOADING NGINX
nginx -t && nginx -s reload

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
ln -sf "$my_nginx"/renew.cronjob /etc/cron.d
