#!/bin/bash

set -ex
systemctl stop radarr.service || true
wget --content-disposition 'http://prowlarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'
tar -xvzf Prowlarr*.linux*.tar.gz
rm Prowlarr*.linux*.tar.gz
rm -rf /opt/prowlarr
mv Prowlarr /opt/prowlarr
ln -sf "$(realpath ./config/arr/prowlarr.service)" /etc/systemd/system/
mkdir -p /var/lib/prowlarr

systemctl stop prowlarr.service || true
systemctl daemon-reload
systemctl start prowlarr.service

