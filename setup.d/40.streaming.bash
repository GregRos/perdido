#!/bin/bash

echo --- JELLYFIN ---
exec > >(trap "" INT TERM; sed 's/^/[JELLYFIN] /')
set -ex

systemctl stop jellyfin.service || true
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
rm -rf /etc/jellyfin /etc/default/jellyfin
mkdir -p /etc/jellyfin
ln -sf "$(realpath ./config/jellyfin/default)" /etc/jellyfin/
ln -sf "$(realpath ./config/jellyfin/config)" /etc/jellyfin/
apt-get update -y
apt-get install jellyfin -y
systemctl enable jellyfin.service
systemctl start jellyfin.service
