#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

mkdir -p /var/rutorrent/profiles/torrents
chown -R nginx:torrenting /var/rutorrent
www_rutorent=/var/www/perdido.bond/rutorrent
rm -rf $www_rutorent
git clone https://github.com/Novik/ruTorrent.git $www_rutorent
ln -sf "$(realpath "./config/rutorrent/config.php")" $www_rutorent/conf/
ln -sf "$(realpath "./config/rutorrent/www.conf")" /etc/php/7.4/fpm/pool.d/
chown -R nginx:nginx $www_rutorent/
chmod -R 777 $www_rutorent/

echo --- DONE ---

