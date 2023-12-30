#!/usr/bin/env bash

set -ex
# Define the source and target paths for settings.json
SOURCE_PATH="$(realpath ./config/transmission)"
TARGET_PATH="/var/lib/transmission-daemon"  # This path may vary

# Install Transmission
apt-get install transmission-daemon -y --no-install-recommends

# Stop Transmission daemon to safely modify the settings
systemctl stop transmission-daemon || true

# Copy the settings.json file to the appropriate location
rm -f "$TARGET_PATH/settings.json"
cp -f "$SOURCE_PATH/settings.json" "$TARGET_PATH/"
cp -f "$SOURCE_PATH/on_complete.bash" "$TARGET_PATH/"
chmod +x "$TARGET_PATH/on_complete.bash"
chown -R rtorrent:torrenting "$TARGET_PATH"
# Change ownership of the copied file to the Transmission user
chmod 755 ./config/transmission/on_complete.bash
rm -rf /lib/systemd/system/transmission-daemon.service
ln -sf "$(realpath ./config/transmission/transmission-daemon.service)" /lib/systemd/system/
mkdir -p /var/log/transmission
chown rtorrent:torrenting /var/log/transmission
# Prompt the user for a password

# Start Transmission daemon again
systemctl daemon-reload
systemctl start transmission-daemon
ufw allow 45002
