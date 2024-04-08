set -ex

dest=syncthing
dest_disco=syncthing-discovery
sv=v1.22.1
sv_disco=v1.18.6
version=syncthing-linux-amd64-$sv
version_disco=stdiscosrv-linux-amd64-$sv_disco

# RUN ONCE ONLY:
# echo "fs.inotify.max_user_watches=204800" | sudo tee -a /etc/sysctl.conf

ufw allow 22000
systemctl stop $dest || true
systemctl stop $dest_disco || true
rm -rf /tmp/{$version,$version_disco}.tar.gz

if [ -f /tmp/$version.tar.gz ]; then
    echo "Already downloaded $version.tar.gz"
else
    wget https://github.com/syncthing/syncthing/releases/download/$sv/$version.tar.gz -O /tmp/$version.tar.gz
    wget https://github.com/syncthing/discosrv/releases/download/$sv_disco/$version_disco.tar.gz -O /tmp/$version_disco.tar.gz
fi

rm -rf /opt/{$dest,$dest_disco}
tar --directory /tmp/ --extract --file /tmp/$version.tar.gz
tar --directory /tmp/ --extract --file /tmp/$version_disco.tar.gz

mv /tmp/$version /opt/$dest
mv /tmp/$version_disco /opt/$dest_disco

cfg=$(realpath ./config/syncthing)
ln -sf "$cfg/$dest.service" /etc/systemd/system/
ln -sf "$cfg/$dest_disco.service" /etc/systemd/system/
mkdir -p /etc/{$dest,$dest_disco}
chown -R syncthing:syncthing /etc/{$dest,$dest_disco} /opt/{$dest,$dest_disco}
chmod -R 770 /etc/{$dest,$dest_disco} /opt/{$dest,$dest_disco}

read -p "Overwrite syncthing config.xml? y/n: " -n 1 -r
echo
if [[ "$REPLY" =~ [Yy] ]]; then
    cp -f $cfg/config.xml /etc/syncthing/config.xml
fi

systemctl daemon-reload

systemctl enable $dest
systemctl start $dest

systemctl enable $dest_disco
systemctl start $dest_disco
