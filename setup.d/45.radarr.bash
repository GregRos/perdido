#!/bin/bash

set -ex
systemctl stop radarr.service || true
wget --content-disposition 'http://radarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64'
tar -xvzf Radarr*.linux*.tar.gz
rm Radarr*.linux*.tar.gz
rm -rf /opt/radarr
mv Radarr /opt/radarr
ln -sf "$(realpath ./config/arr/radarr.service)" /etc/systemd/system/
systemctl stop radarr.service || true
systemctl daemon-reload
systemctl start radarr.service


