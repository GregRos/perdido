sudo apt-get -yy install samba

rm -rf /etc/samba/smb.conf
ln -sf "$(realpath ./config/samba/smb.conf)" "/etc/samba/smb.conf"
ufw allow 443
systemctl restart smbd
