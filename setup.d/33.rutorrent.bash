#!/usr/bin/env bash

set -ex

echo CREATING SOME DIRS
mkdir -p /var/rutorrent/profiles/torrents
chown -R nginx:torrenting /var/rutorrent

echo CLONING RUTORRENT AND SETTING UP WWW
www_rutorent=/var/www/perdido.bond/rutorrent
rm -rf $www_rutorent
git clone https://github.com/Novik/ruTorrent.git $www_rutorent

echo SETTING UP THEMES
rm -rf /tmp/rutorrent-themes
mkdir -p /tmp/rutorrent-themes
git clone https://github.com/artyuum/3rd-party-ruTorrent-Themes /tmp/rutorrent-themes
mv /tmp/rutorrent-themes/*/ $www_rutorent/plugins/theme/themes/

echo LINKING CONFIG FILES
ln -sf "$(realpath "./config/rutorrent/config.php")" $www_rutorent/conf/
ln -sf "$(realpath "./config/rutorrent/www.conf")" /etc/php/7.4/fpm/pool.d/
rm -rf $www_rutorent/plugins/_cloudflare

echo FIXING PERMISSIONS
chown -R nginx:torrenting $www_rutorent


