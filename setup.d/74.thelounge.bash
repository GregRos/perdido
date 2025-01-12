set -ex

(cd ./config/thelounge; docker-compose down) || true
mkdir -p /data/thelounge
(cd ./config/thelounge; docker-compose up -d)