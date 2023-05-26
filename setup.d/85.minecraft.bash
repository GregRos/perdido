set -ex

echo DOING THE DOCKER COMPOSE
config=$PWD/config/minecraft
cd ./config/minecraft
docker-compose down || true
docker-compose up -d
sleep 5
cp $config/{server.properties,whitelist.json} /opt/minecraft/
docker restart minecraft
until [ "`docker inspect -f {{.State.Health.Status}} minecraft`"=="healthy" ]; do
    sleep 0.1;
done;
ufw allow 25565
