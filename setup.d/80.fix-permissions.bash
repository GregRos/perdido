#!/usr/bin/env bash
set -ex

echo CHWON ALL TO NGINX
chown -R nginx:nginx /etc/nginx /usr/local/owasp-modsecurity-crs /usr/share/nginx
chown -R nginx:nginx /var/www
chown -R nginx:torrenting /var/www/perdido.bond/rutorrent

echo CHOWN ALL CERTS TO NGINX

for cur_cert in /etc/letsencrypt/live/*.perdido.bond/*.pem; do
  chown -R nginx:nginx $cur_cert;
  chown -R nginx:nginx "$(realpath $cur_cert)"
done

echo CHOWN ALL TO RTORRENT
chown -R rtorrent:torrenting /var/rtorrent /etc/rtorrent /data
chown -R jellyfin:torrenting /etc/jellyfin /var/jellyfin


