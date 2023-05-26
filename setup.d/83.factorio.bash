set -ex

echo DOWNLOADING HEADLESS SERVER
curl -L -o https://factorio.com/get-download/stable/headless/linux64 factorio_headless.tar.xz
tar xf factorio_headless.tar.xf
mv factorio /opt/factorio

echo INSTALLING SERVICE

rm /lib/systemd/system/factorio.service || true
ln -sf "$(realpath ./config/factorio/factorio.service)" /lib/systemd/system/

echo LINKING CONFIG

echo STARTING SERVICE
systemctl daemon-reload
systemctl enable log-viewer
systemctl start log-viewer

