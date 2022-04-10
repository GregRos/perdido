#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

mkdir -p /var/www/perdido.bond/rutorrent
cd /var/www/perdido.bond/rutorrent

git clone https://github.com/Novik/ruTorrent.git rutorrent

chown -R flood:flood rutorrent/
chmod -R 770 rutorrent/

echo --- DONE ---

