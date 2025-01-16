set -ex
apt-get install  python3-dev python3-pip python3-setuptools unrar unzip

systemctl stop bazarr.service || true
ln -sf "$(realpath ./config/arr/bazarr.service)" /etc/systemd/system/
mkdir -p /tmp/bazarr_install
cd /tmp/bazarr_install
rm -rf bazarr.zip bazarr /opt/bazarr
wget https://github.com/morpheus65535/bazarr/releases/latest/download/bazarr.zip

unzip bazarr.zip -d /opt/bazarr
cd /opt/bazarr
python3.10 -m pip install -r requirements.txt
chown -R search:torrenting /opt/bazarr
systemctl daemon-reload
systemctl enable bazarr.service
systemctl start bazarr.service