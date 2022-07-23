#!/bin/bash

set -ex

echo INSTALLING FILEBROWSER
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

echo CREATING CONFIGURATION
mkdir -p /etc/filebrowser
mkdir -p /var/filebrowser


fb_config_src="$(realpath ./config/filebrowser)"
fb_config_dest="/etc/filebrowser"

rm -f "$fb_config_src/filebrowser.yaml" "/data/filebrowser.db" || true
ln -sf "$fb_config_src/filebrowser.yaml" "$fb_config_dest"
chown -R filebrowser:filebrowser $fb_config_dest /var/filebrowser

ln -sf "$fb_config_src/filebrowser.service" "/etc/systemd/system/"

systemctl daemon-reload
systemctl enable filebrowser
systemctl start filebrowser
nginx -t && nginx -s reload

