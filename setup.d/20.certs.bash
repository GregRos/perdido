#!/usr/bin/env bash

set -ex
apt-get install -y --no-install-recommends certbot
# Puts certificate in /etc/letsencrypt/live
# can be skipped if cert is okay
domains=(
  perdido.bond gregros.dev parjs.org
  $(echo {discovery,files,stream,sabnzbd,jellyfin,rutorrent,logs,torrents,movies,shows,jackett,prowlarr}.perdido.bond)
  $(echo {xyz,safr,world.safr,game.safr}.gregros.dev)
  $(echo gregros.me)
)
read -p "Generate new certificate?  [all/yes/No]" -n 1 -r
firstReply=$REPLY
stopped_nginx=false
if [[ "$firstReply" =~ [YyAa] ]]; then
  stopped_nginx=$(systemctl stop nginx && echo true || echo false)
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

echo ADDING CERTIFICATE RENEW CRONJOB
mkdir -p /etc/cron.d
rm -f /etc/cron.d/renew-certificates || true
cp "$(realpath ./config/nginx/renew.cronjob)" /etc/cron.d/renew-certificates
chown root:root /etc/cron.d/renew-certificates
bash ./_cert-permissions.bash
if [[ "$stopped_nginx" == "true" ]]; then
  systemctl start nginx
fi
