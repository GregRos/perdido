set -ex

echo SETTING UP CD

rm -f /bin/minecraft-redeploy || true
echo "#!/bin/bash
sudo -u docker /bin/bash /opt/perdido/shell/minecraft-redeploy
" > /bin/minecraft-redeploy

chown minecraft-modpack:minecraft-modpack /bin/minecraft-redeploy
chmod 750 /bin/minecraft-redeploy

echo '
  %minecraft-modpack ALL=(docker) NOPASSWD: /bin/bash /opt/perdido/shell/minecraft-redeploy
' | sudo tee /etc/sudoers.d/minecraft


config=$PWD/config/minecraft
cd ./config/minecraft
echo BUILDING THE DOCKER IMAGE

docker build -t my-minecraft .

echo SETTING UP BACKUP CRONJOBS
rm -f /etc/cron.d/backup-minecraft || true
cp "$(realpath ./backup.cronjob)" /etc/cron.d/backup-minecraft
chown root:root /etc/cron.d/backup-minecraft

echo RUNNING REDEPLOY
minecraft-redeploy

echo OPENING PORTS
ufw allow 25565





