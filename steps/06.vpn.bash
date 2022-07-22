#!/usr/bin/env bash
set -ex

# I decided not to bother with this for now. It works, but uploading is shit without
# port forwarding of some kind. I'll set it up if needed.

#
## This sets up a IPSec/IKEv2 VPN that works via a specific interface
#
## GUIDE ProtonVPN
## https://protonvpn.com/support/linux-ikev2-protonvpn/
#
## SPEC LEGACY ipsec.conf
## https://wiki.strongswan.org/projects/strongswan/wiki/ConnSection
#
## MIGRATION to swanctl.conf
## https://wiki.strongswan.org/projects/strongswan/wiki/Fromipsecconf
#
## SPEC swanctl.conf
## https://docs.strongswan.org/docs/5.9/swanctl/swanctlConf.html
#
## GUIDE Route-based IKEv2 VPN
## https://docs.strongswan.org/docs/5.9/features/routeBasedVpn.html#_xfrm_interfaces_on_linux
#
#apt-get install -y strongswan libstrongswan-extra-plugins libcharon-extra-plugins strongswan-swanctl
#systemctl restart strongswan-starter.service
#ip link add proton1 type xfrm dev lo if_id 42
#if [[ "$?" == "0" ]]; then
#  echo "200 proton1" > /etc/iproute2/rt_tables.d/proton1
#  ip rule add from 10.1.33.119 table proton1 prio 1
#  ip route add default dev proton1 table proton1
#fi
#
#sleep 1
#./scripts/btvpn stop || true
#my_vpn=$(realpath "./config/vpn")
#
#cp -f "$my_vpn/charon.conf" /etc/strongswan.d/charon.conf
#mkdir -p /etc/swanctl/x509ca/
#cp -f ./data/protonvpn.der /etc/swanctl/x509ca/
#cp -f "$my_vpn/swanctl/proton.conf" /etc/swanctl/conf.d/
#
#read -p "Set VPN secret (none to skip): " -r
#echo
#if [[ -n "$REPLY" ]]; then
#  cp -f "$my_vpn/swanctl/proton.secrets.conf" /etc/swanctl/conf.d/
#  sed -i s/%SECRET%/$REPLY/ /etc/swanctl/conf.d/proton.secrets.conf
#fi
#chmod 700 /etc/swanctl/conf.d/proton.secrets.conf
#chmod 744 /etc/swanctl/conf.d/proton.conf
#chmod 744  /etc/swanctl/x509ca/protonvpn.der
## techncially this uses the deprecated ipsec tool but it doesn't matter
## the important part is that it sets up the charon daemon
#systemctl enable strongswan-starter.service
#swanctl --reload-settings
#swanctl --load-all
#./scripts/btvpn start

