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
if test -f /etc/nginx/htpasswd; then
  read -p "Password file exists. Leave or recreate?" -n 1 -r
  echo
  if [[ "$REPLY" =~ [Yy] ]]; then
      rm /etc/nginx/htpasswd
      htpasswd -c -B /etc/nginx/htpasswd gr
  fi
fi


echo SETTING UP NGINX STATIC CONTENT
mkdir -p /var/www/

echo SETTING UP NGINX CONFIG
sed -i 's/user .*$/user nginx;/im' /etc/nginx/nginx.conf
rm -rf /etc/nginx/conf.d/
mkdir -p /etc/nginx/{conf.d,fragments}
cp -f ./config/nginx/conf/*.conf /etc/nginx/conf.d/
cp -f ./config/nginx/fragments/*.conf /etc/nginx/fragments/
rm -rf /var/www/perdido.bond/ || true
mkdir -p /var/www/perdido.bond
cp ./config/nginx/www/* /var/www/perdido.bond/

echo GENERATING CERTIFICATE
# Puts certificate in /etc/letsencrypt/live
certbot --nginx -d perdido.bond

echo RELOADING
unlink /etc/nginx/sites-enabled/default || true
nginx -t && nginx -s reload

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
cp -f config/renew.cronjob /etc/cron.d/
