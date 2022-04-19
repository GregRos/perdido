#!/bin/bash

echo --- VSFTPD ---
exec > >(trap "" INT TERM; sed 's/^/[VSFTPD] /')
set -ex

apt-get install -y vsftpd

rm -rf /etc/vsfptd /etc/vsftpd.conf

mkdir -p /etc/vsftpd

ln -sf "$(realpath ./config/vsftpd/vsftpd.conf)" /etc/vsftpd.conf
ln -sf "$(realpath ./config/vsftpd/user_list)" /etc/vsftpd
ln -sf "$(realpath ./config/fail2ban/vsftpd.jail.conf)" /etc/fail2ban/jail.d
ln -sf "$(realpath ./config/fail2ban/vsfptd.filter.conf)" /etc/fail2ban/filter.d
systemctl restart jail2ban.service
systemctl daemon-reload
systemctl restart vsftpd.service
systemctl enable vsftpd.service
echo --- DONE ---
