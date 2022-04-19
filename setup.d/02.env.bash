#!/usr/bin/env bash
echo --- ENVIRONMENT STUFF ---
exec > >(trap "" INT TERM; sed 's/^/[ENV] /')
set -ex

sed -i /etc/ssh/ssh_config 's/PermitRootLogin yes/PermitRootLogin no/im'
ufe default allow outgoing
ufw default deny incoming
for arg in ssh http https 45001/tcp 21/tcp "64000:64321/tcp"; do
  ufw allow $arg
done
sleep 1
ufw enable
echo --- DONE ---

