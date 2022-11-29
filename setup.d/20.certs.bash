#!/usr/bin/env bash

set -ex
apt-get install -y --no-install-recommends certbot
# Puts certificate in /etc/letsencrypt/live
# can be skipped if cert is okay
read -p "Generate new certificate? [y/N]" -n 1 -r
if [[ "$REPLY" =~ [Yy] ]]; then
  systemctl stop nginx || true
  for domain in perdido.bond discovery.perdido.bond files.perdido.bond stream.perdido.bond jellyfin.perdido.bond rutorrent.perdido.bond logs.perdido.bond; do
    certbot certonly --standalone --preferred-challenges http -d $domain
  done
fi


echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
ln -sf "$(realpath ./config/nginx/renew.cronjob)" /etc/cron.d

chown root:cert_group /etc/letsencrypt{,**/*,*}
chmod 750 /etc/letsencrypt{,**/*,*}
