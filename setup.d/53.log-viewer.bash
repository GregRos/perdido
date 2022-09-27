#!/usr/bin/env bash
set -ex

echo DOWNLOADING LOG-VIEWER 1.0.3
curl -L https://github.com/sevdokimov/log-viewer/releases/download/v.1.0.3/log-viewer-1.0.3.zip -o /tmp/log-viewer103.zip

echo UNPACKING TO /opt/log-viewer
rm -rf /opt/log-viewer
unzip -o /tmp/log-viewer103.zip -d /opt/log-viewer
mv /opt/log-viewer/log-viewer-*/* /opt/log-viewer/
rm -rf /opt/log-viewer/log-viewer-*/

echo INSTALLING SERVICE
rm /lib/systemd/system/log-viewer.service || true
ln -sf "$(realpath ./config/log-viewer/log-viewer.service)" /lib/systemd/system/

echo LINKING CONFIG
ln -sf "$(realpath ./config/log-viewer/log-viewer.hocon)" /opt/log-viewer/config.conf

echo STARTING SERVICE
systemctl daemon-reload
systemctl enable log-viewer
systemctl start log-viewer


