#!/bin/bash
echo --- BASIC PACKAGES ---

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
apt-get install -y \
  curl wget git gpg screen byobu sudo apt-transport-https  \
  iperf3 fish certbot speedtest-cli

echo Starting file execution
for file in ./setup.d/*.bash; do
  # guaranteed to be alphabetical, which is why we do the above...
  bash "$file"
done

echo --- ALL DONE ---
