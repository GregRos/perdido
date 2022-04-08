#!/bin/bash
echo --- BASIC PACKAGES ---
exec > >(trap "" INT TERM; sed 's/^/[BASICS] /')
exec 2> >(trap "" INT TERM; sed 's/^/[BASICS::ERROR] /' >&2)

apt-get update && apt-get upgrade -y
apt-get install -y \
  curl wget git gpg screen byobu sudo apt-transport-https  \
  iperf3 fish certbot speedtest-cli

echo --- DONE ---
