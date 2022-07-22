#!/bin/bash

set -ex

echo INSTALLING FILESTASH
mkdir filestash && cd filestash
curl -O https://downloads.filestash.app/latest/docker-compose.yml
docker-compose up -d


