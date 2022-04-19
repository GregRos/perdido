#!/usr/bin/env bash
echo --- SWEEPER ---
exec > >(trap "" INT TERM; sed 's/^/[SWEEPER] /')
set -ex

rm -rf /opt/sweeper
git clone https://github.com/GregRos/sweeper.git /opt/sweeper
ln -sf "$(realpath ./config/sweep)" /usr/bin/
sweeper -h

echo --- DONE ---

