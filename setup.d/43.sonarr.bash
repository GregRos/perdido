#!/bin/bash

set -ex

systemctl stop sonarr.service || true
ln -sf "$(realpath ./config/arr/sonarr.service)" /etc/systemd/system/
tmpdir=/tmp/install_sonarr
mkdir -p $tmpdir
cd $tmpdir
rm -rf Sonarr.tar.gz Sonarr
wget "https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64" -O Sonarr.tar.gz
tar -xvzf  Sonarr.tar.gz
rm -rf /opt/sonarr
mv Sonarr /opt/sonarr/
chmod +x /opt/sonarr/Sonarr

systemctl stop sonarr.service || true
systemctl daemon-reload
systemctl start sonarr.service
