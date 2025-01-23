#!/usr/bin/env bash
set -ex
ufw default allow outgoing
ufw default deny incoming

## STANDARD PORTS
for arg in 22 80 443 7871 45001 "64000:64321/tcp"; do
  ufw allow $arg
done


ln -sf "$(realpath ./config/ufw/after.rules)" /etc/ufw/after.rules
chown root:root /etc/ufw/after.rules

sleep 1
ufw enable