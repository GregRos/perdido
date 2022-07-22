#!/usr/bin/env bash
echo --- DOCKER ---
exec > >(trap "" INT TERM; sed 's/^/[03 DOCKER] /')
set -ex
mkdir -p /etc/apt/keyrings
if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo --- DONE ---

