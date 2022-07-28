#!/usr/bin/env bash
set -ex
rm /etc/motd
ln -sf "$(realpath config/motd)" /etc/motd
chmod 664 /etc/motd config/motd
timedatectl set-timezone Asia/Jerusalem
usermod --shell /usr/bin/fish root
fish -c "echo First run for root"
bash ./shell/install.bash
