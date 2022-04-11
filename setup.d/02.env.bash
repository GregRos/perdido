#!/usr/bin/env bash
echo --- ENVIRONMENT STUFF ---
exec > >(trap "" INT TERM; sed 's/^/[ENV] /')
set -ex

sed -i /etc/ssh/ssh_config 's/PermitRootLogin yes/PermitRootLogin no/im'

echo --- DONE ---

