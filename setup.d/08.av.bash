#!/usr/bin/env bash
echo --- ANTI-VIRUS ---
exec > >(trap "" INT TERM; sed 's/^/[08 ANTI-VIRUS] /')
set -ex

apt-get install -y clamav clamav-daemon
gpasswd -M clamav torrenting
systemctl enable clamav-daemon
systemctl start clamav-daemon
