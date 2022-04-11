#!/usr/bin/env bash
echo --- BASIC PACKAGES ---
exec > >(trap "" INT TERM; sed 's/^/[FILEBOT] /')
set -ex
curl -fsSL https://deb.nodesource.com/setup_16.x | bash
apt-key adv --fetch-keys "https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub"
echo "deb [arch=all] https://get.filebot.net/deb/ universal main" | sudo tee /etc/apt/sources.list.d/filebot.list
apt-get update && apt-get upgrade -y
apt-get install -y \
  curl wget git gpg screen byobu sudo apt-transport-https tree  \
  iperf3 fish certbot speedtest-cli gcc make g++ automake \
  libcurl4-gnutls-dev pkg-config nodejs default-jre mediainfo \
  p7zip-full unrar dirmngr rtorrent \
  php php-geoip php7.4-cli php7.4-json php7.4-curl php7.4-cgi php7.4-mbstring php7.4-fpm \
  ffmpeg sqlite3 python fail2ban
apt-get --no-install-recommends install filebot
