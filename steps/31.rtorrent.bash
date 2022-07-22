#!/usr/bin/env bash

set -ex

echo COPYING RTORRENTRC
mkdir -p /etc/rtorrent
ln -sf "$(realpath ./config/rtorrent.rc)" /etc/rtorrent/rtorrent.rc
chown -R rtorrent:torrenting /etc/rtorrent

echo CREATING SOME FOLDERS
mkdir -p /var/rtorrent/{logs,session}
chown -R rtorrent:torrenting /var/rtorrent

echo LINKING SERVICE FILE
service_path=/etc/systemd/system/rtorrent.service

ln -sf "$(realpath ./config/rtorrent.service)" "$service_path"
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
systemctl enable rtorrent.service
