#!/usr/bin/env bash

echo --- TORRENTS --
exec > >(trap "" INT TERM; sed 's/^/[30 LIBRARY STRUCTURE] /')
set -ex

echo CREATING DATA FOLDER STRUCTURE
mkdir -p /data/{downloads/{done,going},library/{movies,anime,shows,books,games,other,programs,trash}}
chown -R rtorrent:torrenting /data
echo --- DONE ---



