#!/bin/bash

set -ex
systemctl stop sonarr.service || true
wget https://download.sonarr.tv/v3/main/3.0.10.1567/Sonarr.main.3.0.10.1567.linux.tar.gz
tar -xvzf Sonarr.main.3.0.10.1567.linux.tar.gz
rm Sonarr.main.3.0.10.1567.linux.tar.gz
rm -rf /opt/sonarr
mv Sonarr /opt/sonarr/
chmod +x /opt/sonarr/Sonarr.exe
ln -sf "$(realpath ./config/arr/sonarr.service)" /etc/systemd/system/
systemctl stop sonarr.service || true
systemctl daemon-reload
systemctl start sonarr.service
