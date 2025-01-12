#!/usr/bin/env bash
set -ex
ufw default allow outgoing
ufw default deny incoming
ln -sf "$(realpath ./config/ufw/after.rules)" /etc/ufw/after.rules
chown root:root /etc/ufw/after.rules