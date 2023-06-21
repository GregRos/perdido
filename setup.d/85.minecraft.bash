set -ex

config=$PWD/config/minecraft
cd ./config/minecraft
echo BUILDING THE DOCKER IMAGE
docker build -t my-minecraft .
echo DOING THE DOCKER COMPOSE
docker-compose down || true
docker-compose up -d
sleep 5
rm -f /etc/cron.d/backup-minecraft || true
cp "$(realpath ./backup.cronjob)" /etc/cron.d/backup-minecraft
chown root:root /etc/cron.d/backup-minecraft
until [ "`docker inspect -f {{.State.Health.Status}} minecraft`"=="healthy" ]; do
    sleep 0.1;
done;
ufw allow 25565
