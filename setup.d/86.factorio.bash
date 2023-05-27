set -ex

echo DOING THE DOCKER COMPOSE
config=$PWD/config/factorio
cd $config
docker-compose down || true
docker-compose up -d
sleep 5
cp $config/*.json /opt/factorio/config/
docker restart factorio
until [ "`docker inspect -f {{.State.Running}} factorio`"=="true" ]; do
    sleep 0.1;
done;
ufw allow 34197
