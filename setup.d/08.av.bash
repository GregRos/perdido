#!/usr/bin/env bash
set -ex

apt-get install -y clamav clamav-daemon
gpasswd -M clamav torrenting
systemctl enable clamav-daemon
systemctl start clamav-daemon
