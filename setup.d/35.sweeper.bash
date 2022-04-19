#!/usr/bin/env bash
echo --- SWEEPER ---
exec > >(trap "" INT TERM; sed 's/^/[SWEEPER] /')
set -ex

rm -rf /opt/sweeper
git clone https://github.com/GregRos/sweeper.git /opt/sweeper
ln -sf "$(realpath ./config/sweeper)" /usr/bin/
chown -R gr:gr /opt/sweeper
sweeper -h

echo --- DONE ---

