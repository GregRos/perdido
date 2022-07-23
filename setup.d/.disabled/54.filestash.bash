##!/bin/bash
# I decided not to bother with this. Filestash looks nice but it has some missing functionality I need.

set -ex
echo INSTALLING FILESTASH
mkdir filestash && cd filestash
curl -O https://downloads.filestash.app/latest/docker-compose.yml
docker-compose up -d


