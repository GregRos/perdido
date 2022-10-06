#!/usr/bin/env bash

set -ex

echo CREATING GROUPS
torrenting_group=torrenting
rpc_group=rpcing
cert_group=cert_group
for group in $torrenting_group $rpc_group $cert_group; do
  getent group $group || groupadd $group
done

echo CREATING USERS
for user in gr an nginx filebrowser arr jellyfin iperf; do
  getent passwd $user || useradd -m $user
done
getent passwd rtorrent || useradd -g $torrenting_group -m rtorrent
echo ADDING TO GROUPS
gpasswd -M gr,an,nginx,jellyfin,filebrowser,clamav $torrenting_group
gpasswd -M nginx,rtorrent,gr,an $rpc_group
gpasswd -M nginx $cert_group
echo ADDING TO SUDOERS
echo "
# Anna & Greg Definitions

gr ALL=(ALL) NOPASSWD: ALL
an ALL=(ALL) NOPASSWD: ALL

" > /etc/sudoers.d/angr

read -p "Disable SSH login for root account? y/n: " -n 1 -r
echo
if [[ "$REPLY" =~ [Yy] ]]; then
    sed -i 's/PermitRootLogin yes$/PermitRootLogin no/mi' /etc/ssh/sshd_config
fi


