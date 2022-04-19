#!/usr/bin/env bash
echo --- SWEEPER ---
exec > >(trap "" INT TERM; sed 's/^/[35 SWEEPER] /')
set -ex

echo DELETING OLD CODE
rm -rf /opt/sweeper

echo INSTALLING
git clone https://github.com/GregRos/sweeper.git /opt/sweeper
ln -sf /opt/sweeper/sweeper /usr/bin/

echo FIXING PERMISSIONS
chown -R gr:torrenting /opt/sweeper
chown -R rtorrent:torrenting /var/sweeper

runuser -u rtorrent -- pip3 install patool
echo RUNNING TEST
sweeper -h

echo --- DONE ---

