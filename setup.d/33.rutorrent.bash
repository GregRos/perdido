#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

mkdir -p /var/rutorrent/profiles/torrents
chown -R nginx:torrenting /var/rutorrent
www_rutorent=/var/www/perdido.bond/rutorrent
rm -rf $www_rutorent
git clone https://github.com/Novik/ruTorrent.git $www_rutorent
rm -rf /tmp/rutorrent-themes
mkdir -p /tmp/rutorrent-themes
git clone https://github.com/artyuum/3rd-party-ruTorrent-Themes /tmp/rutorrent-themes
mv /tmp/rutorrent-themes/*/ $www_rutorent/plugins/theme/themes/
ln -sf "$(realpath "./config/rutorrent/config.php")" $www_rutorent/conf/
ln -sf "$(realpath "./config/rutorrent/www.conf")" /etc/php/7.4/fpm/pool.d/

echo --- DONE ---

