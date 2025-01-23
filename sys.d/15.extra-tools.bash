#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive

apt-get install -y --no-install-recommends \    
    exa zoxide bat fzf bpytop

cargo install  sd tre-command 