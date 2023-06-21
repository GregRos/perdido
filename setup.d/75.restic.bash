#!/usr/bin/env bash
set -ex

echo INSTALLING RESTIC BACKUP SOFTWARE
wget https://github.com/restic/restic/releases/download/v0.15.2/restic_0.15.2_linux_386.bz2
bzip2 -d restic_0.15.2_linux_386.bz2
mv restic_0.15.2_linux_386 /opt/restic
chmod +x /opt/restic
sudo rm -f /usr/bin/restic || true
sudo ln -sf "$(realpath shell/restic)" /usr/bin/restic
chmod +x /usr/bin/restic
# The restic launcher is a wrapper that sets restic environment variables
restic init || true
