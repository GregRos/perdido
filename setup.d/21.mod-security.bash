#!/usr/bin/env bash
echo --- SETTING UP MOD_SECURITY ---
# TODO
# See https://techexpert.tips/nginx/nginx-modsecurity-installation/
exec > >(trap "" INT TERM; sed 's/^/[WEB] /')
set -ex
