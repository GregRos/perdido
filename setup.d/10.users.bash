#!/usr/bin/env bash

echo --- USER STRUCTURE ---
exec > >(trap "" INT TERM; sed 's/^/[USERS] /')
set -ex

echo CREATING GROUPS
torrenting_group=torrenting
rpc_group=rpcing
for group in $torrenting_group $rpc_group; do
  getent group $group || groupadd $group
done

echo CREATING USERS
for user in gr an nginx flood arr; do
  getent passwd $user || useradd -m $user
done
getent passwd rtorrent || useradd -g $torrenting_group -m rtorrent
echo ADDING TO GROUPS
gpasswd -M gr,an $torrenting_group
gpasswd -M nginx,rtorrent,gr,an,flood $rpc_group

echo ADDING TO SUDOERS
echo "
# Anna & Greg Definitions

gr ALL=(ALL) NOPASSWD: ALL
an ALL=(ALL) NOPASSWD: ALL

" > /etc/sudoers.d/angr

echo --- DONE ---
