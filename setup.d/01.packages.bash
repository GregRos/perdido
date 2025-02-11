#!/usr/bin/env bash
set -ex

apt-get install -y curl wget git gpg screen byobu sudo apt-transport-https tree htop jq rsync
apt-key adv --fetch-keys "https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub"
echo "deb [arch=all] https://get.filebot.net/deb/ universal main" | sudo tee /etc/apt/sources.list.d/filebot.list
apt-get update && apt-get upgrade -y
apt-get install -y \
  shc snapd \
  iperf3 fish certbot speedtest-cli gcc make g++ automake \
  pkg-config default-jre mediainfo apache2-utils \
  p7zip-full unrar dirmngr rtorrent \
  php php-geoip php7.4-cli php7.4-json php7.4-curl php7.4-cgi php7.4-mbstring php7.4-fpm sox \
  ffmpeg sqlite3 python fail2ban \
  libtool libfuzzy-dev ssdeep gettext liblua5.3-dev libpcre3 libpcre3-dev libxml2 libxml2-dev libyajl-dev doxygen libcurl4 libgeoip-dev libssl-dev zlib1g-dev libxslt-dev liblmdb-dev libpcre++-dev libgd-dev \
  software-properties-common ufw python3-pip unzip \
  libmono-cil-dev mono-devel easy-rsa

curl https://bootstrap.pypa.io/pip/2.7/get-pip.py | python2.7
