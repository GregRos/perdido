#!/usr/bin/env bash
echo --- SETTING UP WEB REVERSE PROXY ---

exec > >(trap "" INT TERM; sed 's/^/[WEB] /')
set -ex
apt-get install -y certbot nginx python3-certbot-nginx apache2-utils
my_nginx=$(realpath "./config/nginx")
local_nginx=/etc/nginx
local_www=/var/www/perdido.bond
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

echo LINKING STATIC CONTENT
rm -rf ${local_www:?}/ || true
mkdir -p $local_www
ln -s "$my_nginx"/www $local_www

echo SETTING UP NGINX CONFIG
sed -i 's/user .*$/user nginx;/im' $local_nginx/nginx.conf
rm -rf "${local_nginx:?}"/{fragments,conf.d}
mkdir -p "$local_nginx"/{fragments,conf.d}
ln -s "$my_nginx"/conf/*.conf $local_nginx/conf.d/
ln -s $my_nginx/fragments/*.conf $local_nginx/fragments/


echo GENERATING CERTIFICATE
# Puts certificate in /etc/letsencrypt/live
# can be skipped if cert is okay
certbot certonly --nginx -d perdido.bond

echo RELOADING
unlink $local_nginx/sites-enabled/default || true
nginx -t && nginx -s reload

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
ln -sf "$my_nginx"/renew.cronjob /etc/cron.d
