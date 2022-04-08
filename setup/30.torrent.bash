#!/usr/bin/env bash

echo --- TORRENTS --
exec > >(trap "" INT TERM; sed 's/^/[TORRENTS] /')
exec 2> >(trap "" INT TERM; sed 's/^/[TORRENTS ERR] /' >&2)

echo CREATING DATA FOLDER STRUCTURE
mkdir -p /data/{downs/bt/{done,going},{anime,audiobooks,books,games,movies,not-porn,other,series,soft,trash}}

echo --- DONE ---



