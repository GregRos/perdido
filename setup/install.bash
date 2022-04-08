#!/bin/bash


echo INSTALLING FILEBOT


echo Setting up use structure
groupadd torrent
useradd -m gr
useradd -m an
# rtorrent default group should be 'torrent'.
useradd -g torrent -m rtorrent

for user in gr an; do
    usermod -a -G torrent "$user"
done



## Setup SSH keys for gr
SSH=/home/gr/.ssh
mkdir -p $SSH
chmod 0700 $SSH
cat gr.pub >> $SSH/authorized_keys
chown -R gr:gr $SSH

## Customize gr
chsh -u gr -s /usr/bin/fish
sudo -u gr -c 'fish gr.fish'

# Setup /data directory tree
mkdir -p /data/{downs/bt/{done,going},{anime,audiobooks,books,games,movies,not-porn,other,series,soft,trash}}




# Software Setup

# Drive Setup

# RAID 0
# PARITION / 500GB
# PARITION /home 500GB
# PARTITION /data 5TB

# USERS
# bt
# mediaserver
