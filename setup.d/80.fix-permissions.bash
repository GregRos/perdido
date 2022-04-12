#!/usr/bin/env bash

echo --- FIXING PERMISSIONS ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

echo CHWON ALL TO NGINX
chown -R nginx:nginx /etc/nginx /usr/local/owasp-modsecurity-crs /usr/share/nginx
chown -R nginx:nginx /var/www
chown -R nginx:torrenting /var/www/perdido.bond/rutorrent

echo CHOWN ALL TO RTORRENT
chown -R rtorrent:torrenting /var/rtorrent /etc/rtorrent /data

echo --- DONE ---
