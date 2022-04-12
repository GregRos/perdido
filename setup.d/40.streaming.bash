#!/bin/bash

echo --- JELLYFIN ---
exec > >(trap "" INT TERM; sed 's/^/[JELLYFIN] /')
set -ex


wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
apt-get update -y
apt-get install jellyfin -y

systemctl enable jellyfin.service
systemctl start jellyfin.service



# Program directories
JELLYFIN_DATA_DIR="/var/lib/jellyfin"
JELLYFIN_CONFIG_DIR="/etc/jellyfin"
JELLYFIN_LOG_DIR="/var/log/jellyfin"
JELLYFIN_CACHE_DIR="/var/cache/jellyfin"
