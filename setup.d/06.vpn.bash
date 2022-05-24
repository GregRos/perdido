#!/usr/bin/env bash
echo --- VPN ---
exec > >(trap "" INT TERM; sed 's/^/[06 VPN] /')
set -ex

# This sets up a IPSec/IKEv2 VPN that works via a specific interface

# GUIDE ProtonVPN
# https://protonvpn.com/support/linux-ikev2-protonvpn/

# SPEC LEGACY ipsec.conf
# https://wiki.strongswan.org/projects/strongswan/wiki/ConnSection

# MIGRATION to swanctl.conf
# https://wiki.strongswan.org/projects/strongswan/wiki/Fromipsecconf

# SPEC swanctl.conf
# https://docs.strongswan.org/docs/5.9/swanctl/swanctlConf.html

# GUIDE Route-based IKEv2 VPN
# https://docs.strongswan.org/docs/5.9/features/routeBasedVpn.html#_xfrm_interfaces_on_linux

apt-get install -y strongswan libstrongswan-extra-plugins libcharon-extra-plugins strongswan-swanctl
./scripts/btvpn stop
my_vpn=$(realpath "./config/vpn")

ln -sf "$my_vpn/charon.conf" /etc/strongswan.d/charon.conf
mkdir -p /etc/swanctl/x509ca/
cp -f ./data/protonvpn.der /etc/swanctl/x509ca/
ln -sf "$my_vpn/swanctl/proton.conf" /etc/swanctl/conf.d/

read -p "Set VPN secret (none to skip): " -r
echo
if [[ -n "$REPLY" ]]; then
  cp -f "$my_vpn/swanctl/proton.secrets.conf" /etc/swanctl/conf.d/
  sed -i /%SECRET%/$REPLY/s /etc/swanctl/conf.d/proton.secrets.conf
fi
chmod 700 /etc/swanctl/conf.d/proton.secrets.conf
chmod 744 /etc/swanctl/conf.d/proton.conf
chmod 744  /etc/swanctl/x509ca/protonvpn.der
# techncially this uses the deprecated ipsec tool but it doesn't matter
# the important part is that it sets up the charon daemon
systemctl enable strongswan-starter.service
systemctl restart strongswan-starter.service
swanctl --reload-settings
swanctl --load-all
./scripts/btvpn start
