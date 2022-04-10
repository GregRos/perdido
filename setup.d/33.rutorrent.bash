#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

mkdir -p /var/rutorrent/profiles
chown -R flood:flood /var/rutorrent
cd /var/www/perdido.bond

git clone https://github.com/Novik/ruTorrent.git rutorrent

ln -sf ./config/rutorrent/config.php /var/www/perdido.bond/rutorrent/
chown -R flood:flood rutorrent/
chmod -R 770 rutorrent/

echo --- DONE ---

