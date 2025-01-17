set -ex
cd ./config/watchtower

docker-compose down
source ./secrets/watchtower.bash
cd ./config/watchtower

docker-compose up -d