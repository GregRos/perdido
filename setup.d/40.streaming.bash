#!/bin/bash

set -ex

echo STOPPING SERVICE IF ANY
systemctl stop jellyfin.service || true

echo REGISTERING KEY AND INSTALLING
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
apt-get update
apt-get install jellyfin -y

echo DELETING OLD SETTINGS
rm -rf /etc/jellyfin /etc/default/jellyfin

echo APPLYING DEFAULT SETTINGS
mkdir -p /etc/jellyfin/config /var/jellyfin/data/data
jellyfin_root=$(realpath ./config/jellyfin)
ln -sf "$jellyfin_root/default" /etc/jellyfin
cp -rf "$jellyfin_root"/config/* /etc/jellyfin/config
cp -rf ./data/jellyfin/*.db /var/jellyfin/data/data

echo ADDING SERVICE
ln -sf "$(realpath ./config/jellyfin.service)" /lib/systemd/system/

echo FIXING PERMISSIONS
chown -R jellyfin:torrenting /etc/jellyfin /var/jellyfin
cp "$(realpath ./config/jellyfin/restart.cronjob)" /etc/cron.d/restart-jellyfin
chown root:root /etc/cron.d/restart-jellyfin
echo RESTARTING SERVICE
systemctl daemon-reload
systemctl enable jellyfin.service
systemctl start jellyfin.service


