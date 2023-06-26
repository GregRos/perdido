set -ex

echo SETTING UP CD
rm -f /bin/minecraft-sync || true
echo "#!/bin/bash
sudo -u minecraft-modpack /bin/bash /opt/perdido/shell/minecraft-sync
" > /bin/minecraft-sync

rm -f /bin/minecraft-redeploy || true
echo "#!/bin/bash
sudo -u docker /bin/bash /opt/perdido/shell/minecraft-redeploy
" > /bin/minecraft-redeploy

rm -f /bin/minecraft-update || true
echo "#!/bin/bash
minecraft-sync
minecraft-redeploy
" > /bin/minecraft-update
for command in minecraft-sync minecraft-redeploy minecraft-update; do
  chown minecraft-modpack:minecraft-modpack /bin/$command
  chmod 750 /bin/$command
done
echo '
  %minecraft-modpack ALL=(minecraft-modpack) NOPASSWD: /bin/bash /opt/perdido/shell/minecraft-sync
  %minecraft-modpack ALL=(docker) NOPASSWD: /bin/bash /opt/perdido/shell/minecraft-redeploy
' | sudo tee /etc/sudoers.d/minecraft


echo SETTING UP CONTAINERS
config=$PWD/config/minecraft
cd ./config/minecraft
echo BUILDING THE DOCKER IMAGE
docker build -t my-minecraft .

echo SETTING UP BACKUP CRONJOBS
rm -f /etc/cron.d/backup-minecraft || true
cp "$(realpath ./backup.cronjob)" /etc/cron.d/backup-minecraft
chown root:root /etc/cron.d/backup-minecraft

echo PUBLISHING MODPACK
rm -f /data/gregros.dev/xyz/{minecraft-perdido-modpack,minecraft/perdido-modpack} || true
mkdir -p /data/gregros.dev/xyz/minecraft
ln -sf /opt/minecraft-perdido-modpack /data/gregros.dev/xyz/minecraft/perdido-modpack

echo RUNNING SYNC AND DEPLOY
minecraft-sync
minecraft-redeploy

echo OPENING PORTS
ufw allow 25565





