#!/usr/bin/env bash
echo --- SWEEPER ---
exec > >(trap "" INT TERM; sed 's/^/[SWEEPER] /')
set -ex

git clone https://github.com/GregRos/sweeper.git /opt/sweep
ln -sf "$(realpath ./config/sweep)" /usr/bin/
sweep -h

echo --- DONE ---

