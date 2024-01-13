#!/usr/bin/env bash

set -ex
systemctl stop sabnzbd.service || true
sudo apt-get install sabnzbdplus
mkdir -p /opt/sabnzbd /etc/sabnzbd/scripts /var/log/sabnzbd /etc/sabnzbd

git clone https://github.com/sabnzbd/sabnzbd.git . || true
cd /opt/sabnzbd

python3.9 -m pip install --upgrade -r requirements.txt

ln -sf "$(realpath /opt/perdido/config/sabnzbd/sabnzbd.service)" /lib/systemd/system/
cp -f "$(realpath /opt/perdido/config/sabnzbd/sabnzbd.ini)" /etc/sabnzbd/sabnzbd.ini
rm -rf /etc/sabnzbd/scripts
cp -rf "$(realpath /opt/perdido/config/sabnzbd/scripts)" /etc/sabnzbd/scripts
chown -R rtorrent:torrenting /opt/sabnzbd /etc/sabnzbd /var/log/sabnzbd
chmod +x /etc/sabnzbd/scripts/*
systemctl daemon-reload

systemctl restart sabnzbd.service
