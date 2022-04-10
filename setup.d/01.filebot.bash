#!/usr/bin/env bash
echo --- FILEBOT ---
exec > >(trap "" INT TERM; sed 's/^/[FILEBOT] /')
set -ex

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

