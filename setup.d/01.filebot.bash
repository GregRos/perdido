#!/usr/bin/env bash
echo --- FILEBOT ---
exec > >(trap "" INT TERM; sed 's/^/[FILEBOT] /')
set -ex

echo SETTING UP KEYS AND STUFF
apt-get install --install-recommends dirmngr
apt-key adv --fetch-keys "https://raw.githubusercontent.com/filebot/plugins/master/gpg/maintainer.pub"
echo "deb [arch=all] https://get.filebot.net/deb/ universal main" | sudo tee /etc/apt/sources.list.d/filebot.list

echo INSTALL PACKAGES
apt-get update
apt-get install -y default-jre mediainfo p7zip-full unrar
apt-get install -y filebot

echo PRINT FILEBOT VERSION
filebot -version

echo DECRYPT AND APPLY LICENSE
read -p "Activate filebot now? y/n: " -n 1 -r
echo
if [[ "$REPLY" =~ [Yy] ]]; then
  gpg --output filebot-lic.psm --decrypt ./data/filebot-lic.psm.gpg
  filebot --license filebot-lic.psm
fi

echo FILEBOT SYSINFO
filebot -script fn:sysinfo

echo --- DONE ---

