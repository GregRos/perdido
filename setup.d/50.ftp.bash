#!/bin/bash

echo --- VSFTPD ---
exec > >(trap "" INT TERM; sed 's/^/[VSFTPD] /')
set -ex

echo INSTALLING PACKAGES
apt-get install -y vsftpd

echo REMOVING OLD SETTINGS
rm -rf /etc/vsftpd /etc/vsftpd.conf /etc/fail2ban/jail.d/vsftpd.jail.conf /etc/fail2ban/filter.d/vsftpd.conf

echo INSTALLING SETTINGS: FTP, FAIL2BAN
mkdir -p /etc/vsftpd
cp -f "$(realpath ./config/vsftpd/vsftpd.conf)" /etc/vsftpd.conf
cp -f "$(realpath ./config/vsftpd/user_list)" /etc/vsftpd
cp -f "$(realpath ./config/fail2ban/vsftpd.jail.conf)" /etc/fail2ban/jail.d
cp -f "$(realpath ./config/fail2ban/vsftpd.filter.conf)" /etc/fail2ban/filter.d/vsftpd.conf

echo RESTARTING SERVICES
systemctl restart fail2ban.service
systemctl daemon-reload
systemctl restart vsftpd.service
systemctl enable vsftpd.service
echo --- DONE ---
