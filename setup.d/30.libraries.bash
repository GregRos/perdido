#!/usr/bin/env bash

set -ex

echo CREATING DATA FOLDER STRUCTURE
mkdir -p /data/{downloads/{done,going},library/{movies,anime,shows,books,other,programs,trash}}
chown -R rtorrent:torrenting /data
chmod 770 /data




