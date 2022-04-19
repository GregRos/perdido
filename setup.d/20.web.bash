#!/usr/bin/env bash
echo --- SET UP WEB ---

exec > >(trap "" INT TERM; sed 's/^/[20 WEB] /')
set -ex
apt-get install -y certbot nginx-core nginx-common nginx nginx-full python3-certbot-nginx apache2-utils
my_nginx=$(realpath "./config/nginx")
local_nginx=/etc/nginx
local_www=/var/www/perdido.bond
unlink $local_nginx/sites-enabled/default || true
if ! curl localhost; then
  >&2 echo nginx seems to be broken
  exit 3
fi

echo CREATING PASSWORD FILE
if test -f $local_nginx/htpasswd; then
  read -p "Password file exists. Recreate? y/n: " -n 1 -r
  echo
  if [[ "$REPLY" =~ [Yy] ]]; then
      rm $local_nginx/htpasswd
      htpasswd -c -B $local_nginx/htpasswd gr
  fi
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

echo REGENERATING CERTIFICATE
# Puts certificate in /etc/letsencrypt/live
# can be skipped if cert is okay
certbot certonly --nginx -d perdido.bond

echo RELOADING NGINX
nginx -t && nginx -s reload

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
ln -sf "$my_nginx"/renew.cronjob /etc/cron.d
