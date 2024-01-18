#!/usr/bin/env bash

set -ex
systemctl stop sabnzbd.service || true
sudo apt-get install sabnzbdplus
mkdir -p /opt/sabnzbd /etc/sabnzbd/scripts /var/log/sabnzbd /etc/sabnzbd

git clone https://github.com/sabnzbd/sabnzbd.git . || true
cd /opt/sabnzbd

python3.9 -m pip install --upgrade -r requirements.txt
# parse out the username from the sabnzbd.ini file if it exists:
if [ ! -f /root/usenet.env ]; then
  # Emit error
  echo "!! /root/usenet.env not found !!"
  read -p "Enter your usenet username: " usenet_username
  read -p "Enter your usenet password: " usenet_password
  echo "
  username=$usenet_username
  password=$usenet_password
  " > /root/usenet.env
  chmod 600 /root/usenet.env
fi

source /root/usenet.env
echo "Using credentials: $usenet_username:$usenet_password"
ln -sf "$(realpath /opt/perdido/config/sabnzbd/sabnzbd.service)" /lib/systemd/system/
cp -f "$(realpath /opt/perdido/config/sabnzbd/sabnzbd.ini)" /etc/sabnzbd/sabnzbd.ini
sed -i "s/>>USERNAME<</$usenet_username/mig" /etc/sabnzbd/sabnzbd.ini
sed -i "s/>>PASSWORD<</$usenet_password/mig" /etc/sabnzbd/sabnzbd.ini
rm -rf /etc/sabnzbd/scripts
cp -rf "$(realpath /opt/perdido/config/sabnzbd/scripts)" /etc/sabnzbd/scripts
chown -R rtorrent:torrenting /opt/sabnzbd /etc/sabnzbd /var/log/sabnzbd
chmod +x /etc/sabnzbd/scripts/*
systemctl daemon-reload

systemctl restart sabnzbd.service
