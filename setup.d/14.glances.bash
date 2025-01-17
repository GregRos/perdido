set -ex

echo "DOWNING GLANCES"
cd ./config/glances
docker-compose down || true

docker-compose up -d