#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive

# core:
apt-get install -y --no-install-recommends \
    byobu tree htop jq rsync p7zip-full unrar unzip \
    nano iftop iotop nethogs speedtest-cli 

cargo install bandwhich dua-cli