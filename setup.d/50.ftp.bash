#!/bin/bash

echo --- VSFTPD ---
exec > >(trap "" INT TERM; sed 's/^/[JELLYFIN] /')
set -ex

apt-get install -y vsftpd

mkdir -p /etc/vsftpd

ln -sf "$(realpath ./config/vsftpd/vsftpd.conf)" /etc/vsftpd.conf
ln -sf "$(realpath ./config/vsftpd/user_list)" /etc/vsftp

echo --- DONE ---
