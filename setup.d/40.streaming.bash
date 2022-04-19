#!/bin/bash

echo --- JELLYFIN ---
exec > >(trap "" INT TERM; sed 's/^/[JELLYFIN] /')
set -ex

systemctl stop jellyfin.service || true
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | sudo tee /etc/apt/sources.list.d/jellyfin.list

apt-get update
apt-get install jellyfin -y

rm -rf /etc/jellyfin /etc/default/jellyfin
mkdir -p /etc/jellyfin/config /var/jellyfin/data/data
jellyfin_root=$(realpath ./config/jellyfin)
ln -sf "$jellyfin_root/default" /etc/jellyfin
cp -f "$jellyfin_root"/config/* /etc/jellyfin/config
cp -f ./data/jellyfin/*.db /var/jellyfin/data/data


ln -sf "$(realpath ./config/jellyfin.service)" /lib/systemd/system/
chown -R jellyfin:torrenting /etc/jellyfin /var/jellyfin

systemctl daemon-reload
systemctl enable jellyfin.service
systemctl start jellyfin.service

echo --- DONE ---
