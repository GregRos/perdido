#!/usr/bin/env bash
echo --- ENVIRONMENT ---
exec > >(trap "" INT TERM; sed 's/^/[02 ENV] /')
set -ex
timedatectl set-timezone Asia/Jerusalem
ufw default allow outgoing
ufw default deny incoming
for arg in ssh http https 45001/tcp 45001/udp 21/tcp "64000:64321/tcp"; do
  ufw allow $arg
done
sleep 1
ufw enable
echo --- DONE ---

