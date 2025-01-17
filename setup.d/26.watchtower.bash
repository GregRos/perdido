set -ex
source ./secrets/watchtower.bash
cd ./config/watchtower

docker-compose up -d