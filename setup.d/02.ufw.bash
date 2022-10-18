#!/usr/bin/env bash
set -ex
ufw default allow outgoing
ufw default deny incoming
