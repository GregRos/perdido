#!/usr/bin/env bash

echo --- USER STRUCTURE ---
exec > >(trap "" INT TERM; sed 's/^/[USERS] /')
exec 2> >(trap "" INT TERM; sed 's/^/[USERS] /' >&2)

torrenting_group=torrenting
rpc_group=rpcing
echo ADDING GROUP
groupadd $torrenting_group
groupadd $rpc_group

echo CREATING USERS
useradd -m gr
useradd -m an
useradd -m nginx
useradd -g $torrenting_group -m rtorrent
echo ADDING TO GROUPS
for user in gr an; do
    usermod -a -G $torrenting_group "$user"
    usermod -a -G "$rpc_group" "$user"
done
for user in nginx rtorrent; do
  usermod -a -G "$rpc_group" "$user"
done

echo ADDING TO SUDOERS
"
# Anna & Greg Definitions

gr ALL=(ALL) NOPASSWD: ALL
an ALL=(ALL) NOPASSWD: ALL

" > /etc/sudoers.d/angr

echo --- DONE --
