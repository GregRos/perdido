#!/usr/bin/env bash
set -ex

echo CHWON ALL TO NGINX
chown -R nginx:nginx /etc/nginx /usr/local/owasp-modsecurity-crs /usr/share/nginx
chown -R nginx:nginx /var/www
chown -R search:search /var/lib/prowlarr
chown -R nginx:torrenting /var/www/perdido.bond/rutorrent
chown -R search:search /opt/sonarr || true
chown -R search:search /opt/radarr || true
echo CHOWN ALL CERTS TO NGINX

for cur_cert in /etc/letsencrypt/live/{*.,}{perdido.bond,gregros.dev}; do
  chown -R nginx:cert_group $cur_cert;
  chown -R nginx:cert_group "$(realpath $cur_cert)"
done
for cur_cert in /etc/letsencrypt/archive/{*.,}{perdido.bond,gregros.dev}; do
  chown -R nginx:cert_group $cur_cert;
  chown -R nginx:cert_group "$(realpath $cur_cert)"
done

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



