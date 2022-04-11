#!/usr/bin/env bash
echo SKIPPING FLOOD
exit 0

echo --- FLOOD ---
exec > >(trap "" INT TERM; sed 's/^/[FLOOD] /')
set -ex

echo INSTALLING FLOOD
npm install --global flood

echo CONFIGURING FOLDER
mkdir -p /var/flood
chown -R flood:flood /var/flood

echo LINKING SERVICE
service_path=/etc/systemd/system/flood.service
ln -sf "$(realpath ./config/flood.service)" "$service_path"
chmod 700 "$service_path"

echo LAUNCHING AND CONFIGURING SERVICE
systemctl stop flood.service || true
systemctl daemon-reload
systemctl start flood.service

echo WAITING TO CHECK FLOOD SERVICE...
sleep 5
if ! systemctl status flood.service || ! curl -L http://localhost:9001; then
  echo FAILED TO START
  exit 3
fi
systemctl enable flood.service



