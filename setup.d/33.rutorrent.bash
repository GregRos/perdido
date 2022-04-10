#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex
ln -sf "$(realpath "./config/rutorrent/config.php")" /var/www/perdido.bond/rutorrent/

mkdir -p /var/rutorrent/profiles
chown -R flood:flood /var/rutorrent
cd /var/www/perdido.bond
rm -rf rutorrent
git clone https://github.com/Novik/ruTorrent.git rutorrent

chown -R nginx:nginx rutorrent/
chmod -R 777 rutorrent/

echo --- DONE ---

