#!/usr/bin/env bash
set -ex
ufw default allow outgoing
ufw default deny incoming
for arg in ssh http https 45001/tcp 45001/udp 21/tcp 7567/tcp "64000:64321/tcp"; do
  ufw allow $arg
done
sleep 1
ufw enable


