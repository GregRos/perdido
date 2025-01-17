set -ex

echo "DOWNING SCRUTINY"
cd ./config/scrutiny
docker-compose down || true

docker-compose up -d