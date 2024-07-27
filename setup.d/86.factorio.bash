set -ex
cd /opt/perdido
source ./secrets/factorio.bash
config=/opt/perdido/config/factorio
cd $config
groupadd -g 845 factorio || true
useradd -u 845 -g 845 -s /bin/bash -m factorio || true
echo BUILDING THE DOCKER IMAGE
docker build \
  --build-arg USERNAME=$FACTORIO_USERNAME \
  --build-arg TOKEN=$FACTORIO_TOKEN \
  -t my-factorio .
echo DOING THE DOCKER COMPOSE
docker compose down || true
docker compose up -d
sleep 5
rm -f /etc/cron.d/backup-factorio || true
cp "$(realpath ./backup.cronjob)" /etc/cron.d/backup-factorio
chown root:root /etc/cron.d/backup-factorio

until [ "`docker inspect -f {{.State.Running}} factorio`"=="true" ]; do
    sleep 0.1;
done;
ufw allow 34197
