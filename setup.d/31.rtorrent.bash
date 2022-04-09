#!/usr/bin/env bash

echo --- RTORRENT ---
exec > >(trap "" INT TERM; sed 's/^/[RTORRENT] /')
set -ex

echo INSTALLING RTORRENT
apt-get install -y rtorrent

echo COPYING RTORRENTRC
mkdir -p /etc/rtorrent
cp -f ./config/rtorrent.rc /etc/rtorrent/rtorrent.rc
chown -R rtorrent:torrenting /etc/rtorrent

echo CREATING SOME FOLDERS
mkdir -p /var/rtorrent/{logs,session}
chown -R rtorrent:torrenting /var/rtorrent

echo COPYING SERVICE FILE
service_path=/etc/systemd/system/rtorrent.service
cp -f ./config/rtorrent.service "$service_path"
# Restrict permissions to root
chmod 700 "$service_path"

echo CONFIGURING AND LAUNCHING SERVICE
systemctl stop rtorrent.service || true
systemctl daemon-reload
systemctl start rtorrent.service

echo WAITING TO CHECK RTORRENT SERVICE...
sleep 5
if ! systemctl status rtorrent.service; then
  echo FAILED TO START
  exit 3
fi

