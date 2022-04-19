#!/usr/bin/env bash
echo --- ENVIRONMENT ---
exec > >(trap "" INT TERM; sed 's/^/[02 ENV] /')
set -ex

ufw default allow outgoing
ufw default deny incoming
for arg in ssh http https 45001/tcp 21/tcp "64000:64321/tcp"; do
  ufw allow $arg
done
sleep 1
ufw enable
echo --- DONE ---

