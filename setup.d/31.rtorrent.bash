#!/usr/bin/env bash
set -ex

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
exec 2> >(trap "" INT TERM; sed 's/^/[RTORRENT ERR] /' >&2)

echo INSTALLING RTORRENT
apt-get install -y rtorrent

echo COPYING RTORRENTRC
mkdir -p /etc/rtorrent
cp ./config/rtorrent.rc /etc/rtorrent/rtorrent.rc
chown -R rtorrent:torrenting /etc/rtorrent

echo CREATING SOME FOLDERS
mkdir -p /var/rtorrent/{log,session}
chown -R rtorrent:torrenting /var/rtorrent

echo COPYING SERVICE FILE
service_path=/etc/systemd/system/rtorrent.service
cp ./config/rtorrent.service "$service_path"
# Restrict permissions to root
chmod 700 "$service_path"

echo CONFIGURING AND LAUNCHING SERVICE
systemctl daemon-reload
systemctl start rtorrent.service
systemctl status rtorrent.service
systemctl enable rtorrent.service


