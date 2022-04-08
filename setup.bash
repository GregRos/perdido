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
  if ! bash "$file"; then
    echo Error executing $file
    exit 3
  fi
done

echo --- ALL DONE ---
