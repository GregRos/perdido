#!/usr/bin/env bash
set -ex
return 0
echo INSTALLING DEPENDENCIES
apt-get install -y bison  dh-autoreconf \
        doxygen flex gawk git iputils-ping libcurl4-gnutls-dev libexpat1-dev\
        libgeoip-dev liblmdb-dev libpcre3-dev libpcre++-dev libssl-dev libtool\
        libxml2 libxml2-dev libyajl-dev locales lua5.3-dev pkg-config wget zlib1g-dev

echo DIR SETUP
start_dir="$PWD"
mkdir -p /etc/nginx/modsec

mkdir -p ~/ccmod
cd ~/ccmod

echo CLONING MODSECURITY
rm -rf ModSecurity
git clone https://github.com/SpiderLabs/ModSecurity
cd ModSecurity
git checkout v3/master
git submodule init
git submodule update

echo COPYING AND MODIFYING SOME CONFIG FILES
cp ./unicode.mapping /etc/nginx/modsec/
cp -f ./config/modsecurity/*.conf /etc/nginx/modsec/

echo BUILDING MODSECURITY
sh build.sh
./configure
make
make install

cd ..
echo CLONE NGINX CONNECTOR
git clone https://github.com/SpiderLabs/ModSecurity-nginx

echo GET NGINX SOURCE
wget http://nginx.org/download/nginx-1.18.0.tar.gz
tar -zxvf nginx-1.18.0.tar.gz

echo BUILD NGINX WITH CONNECTOR
cd nginx-1.18.0
./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
make modules

echo COPY CONNECTOR MODULE
cp objs/ngx_http_modsecurity_module.so /usr/share/nginx/modules/
cd ..

echo CLONE OWASP RULES
wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v3.2.0.tar.gz
tar -zxvf v3.2.0.tar.gz

echo MOVE OWASP CONFIGS
mv owasp-modsecurity-crs-3.2.0 owasp-modsecurity-crs
mv owasp-modsecurity-crs/crs-setup.conf.example owasp-modsecurity-crs/crs-setup.conf
mv owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example  owasp-modsecurity-crs/rules/REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf
mv owasp-modsecurity-crs /usr/local/

# restart nginx
echo RESTART NGINX
nginx -t && nginx -s reload

echo TEST BANNED USER AGENT
result="$(curl -s -o /dev/null -w "%{http_code}" -H "User-Agent: Nikto" https://perdido.bond)"

if [[ "$result" != "403" ]]; then
  echo EXPECTED 403 DUE TO BLOCK
  exit 5
fi
