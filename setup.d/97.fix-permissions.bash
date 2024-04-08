#!/usr/bin/env bash
set -ex

echo CHWON ALL TO NGINX
chown -R nginx:nginx /etc/nginx /usr/share/nginx
chown -R nginx:nginx /var/www
chown -R search:search /var/lib/prowlarr
chown -R nginx:torrenting /var/www/perdido.bond/rutorrent
chown -R search:search /opt/{sonarr,radarr,prowlarr,jackett} || true
chown -R syncthing:syncthing /opt/syncthing{,-discovery}
chown -R search:torrenting /data/search-library
echo CHOWN ALL CERTS TO NGINX

bash ./_cert-permissions.bash
chmod 775 /data
echo CHOWN ALL TO RTORRENT
shopt -s extglob
chown -R rtorrent:torrenting /var/rtorrent /etc/rtorrent
chown rtorrent:torrenting /data
chown -R nginx:web /data/gregros.dev
chmod -R 770 /data/gregros.dev

read -p "chwon /data/* too? CANT ABORT, TAKES AGES. [y/N]" -n 1 -r
if [[ "$REPLY" =~ [Yy] ]]; then
  chown -R rtorrent:torrenting /data/{api,downloads,library,shares}
  chown -R syncthing:syncthing /data/syncthing
  chown -R jellyfin:torrenting /etc/jellyfin /var/jellyfin
  chown -R syncthing:syncthing /etc/{syncthing,syncthing-discovery}
fi



