#!/usr/bin/env bash

set -ex
apt-get install -y --no-install-recommends certbot
# Puts certificate in /etc/letsencrypt/live
# can be skipped if cert is okay
domains=(
  perdido.bond gregros.dev
  $(echo {discovery,files,stream,jellyfin,rutorrent,logs,movies,shows,jackett,prowlarr}.perdido.bond)
  xyz.gregros.dev
)
read -p "Generate new certificate?  [all/yes/No]" -n 1 -r
firstReply=$REPLY
if [[ "$firstReply" =~ [YyAa] ]]; then
  systemctl stop nginx || true
  for domain in ${domains[*]}; do
    cont=1
    if ! [[ "$firstReply" =~ [Aa] ]]; then
      read -p "Generate new cert for $domain? [Yes/no/stop]" -n 1 -r
      if [[ "$REPLY" =~ [Ss] ]]; then
        echo "Bye."
        exit 0
      fi
      if [[ "$REPLY" =~ [Nn] ]]; then
        unset cont
      fi
    fi
    if [[ -n $cont ]]; then
      certbot certonly --standalone --preferred-challenges http -d $domain
    fi
  done
fi

wait


echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
rm -f /etc/cron.d/renew-certificates || true
cp "$(realpath ./config/nginx/renew.cronjob)" /etc/cron.d/renew-certificates
chown root:root /etc/cron.d/renew-certificates
chown root:cert_group /etc/letsencrypt{,**/*,*}
chmod 750 /etc/letsencrypt{,**/*,*}
