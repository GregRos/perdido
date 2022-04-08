#!/usr/bin/env bash

echo Setting up use structure
groupadd torrent
useradd -m gr
useradd -m an
# rtorrent default group should be 'torrent'.
useradd -g torrent -m rtorrent

for user in gr an; do
    usermod -a -G torrent "$user"
done

"
# Anna & Greg Definitions

gr ALL=(ALL) NOPASSWD: ALL
an ALL=(ALL) NOPASSWD: ALL

" >> /etc/sudoers.d/angr
