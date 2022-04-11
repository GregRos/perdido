#!/usr/bin/env bash

echo --- FIXING PERMISSIONS ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

echo CHWON ALL TO NGINX
chown -R nginx:nginx /etc/nginx /usr/local/owasp-modsecurity-crs /usr/share/nginx

echo CHOWN ALL TO RTORRENT
chown -R rtorrent:torrenting /var/rtorrent /etc/rtorrent /data

echo --- DONE ---
