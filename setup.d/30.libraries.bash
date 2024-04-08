#!/usr/bin/env bash

set -ex

echo CREATING DATA FOLDER STRUCTURE
mkdir -p /data/{syncthing,foundryvtt,{downloads,shares,api}/{done,going},{library,search-library}/{movies,anime,shows,books,other,programs,trash}}
chown -R rtorrent:torrenting /data
chmod 770 /data




