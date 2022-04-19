#!/bin/bash

echo --- VSFTPD ---
exec > >(trap "" INT TERM; sed 's/^/[VSFTPD] /')
set -ex

apt-get install -y vsftpd

rm -rf /etc/vsfptd /etc/vsftpd.conf

mkdir -p /etc/vsftpd

cp -f "$(realpath ./config/vsftpd/vsftpd.conf)" /etc/vsftpd.conf
cp -f "$(realpath ./config/vsftpd/user_list)" /etc/vsftpd

systemctl daemon-reload
systemctl restart vsftpd.service
systemctl enable vsftpd.service
echo --- DONE ---
