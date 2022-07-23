#!/usr/bin/env bash

set -ex
create_passwd=0
mkdir -p /etc/nginx
if test -f /etc/nginx/htpasswd; then
    echo CREATING PASSWORD FILE
    read -p "Password file exists. Recreate? y/n: " -n 1 -r
    echo
    if [[ "$REPLY" =~ [Yy] ]]; then
        rm /etc/nginx/htpasswd
        create_passwd=1
    fi
else
    create_passwd=1
fi

if test $create_passwd != 0; then
    htpasswd -c -B /etc/nginx/htpasswd gr
fi
