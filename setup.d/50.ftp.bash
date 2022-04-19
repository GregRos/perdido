#!/bin/bash

echo --- VSFTPD ---
exec > >(trap "" INT TERM; sed 's/^/[VSFTPD] /')
set -ex

apt-get install -y vsftpd

mkdir -p /etc/vsftpd

ln -sf "$(realpath ./config/vsftpd/vsftpd.conf)" /etc/vsftpd.conf
ln -sf "$(realpath ./config/vsftpd/user_list)" /etc/vsftpd

echo --- DONE ---
