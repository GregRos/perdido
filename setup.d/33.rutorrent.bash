#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

mkdir -p /var/rutorrent/profiles
chown -R nginx:nginx /var/rutorrent
rm -rf /var/www/perdido.bond/rutorrent
git clone https://github.com/Novik/ruTorrent.git /var/www/perdido.bond/rutorrent
ln -sf "$(realpath "./config/rutorrent/config.php")" /var/www/perdido.bond/rutorrent/

chown -R nginx:nginx rutorrent/
chmod -R 777 rutorrent/

echo --- DONE ---

